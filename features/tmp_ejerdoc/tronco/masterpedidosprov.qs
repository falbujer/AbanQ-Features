
/** @class_declaration tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
class tmpEjerDoc extends oficial {
    function tmpEjerDoc( context ) { oficial ( context ); }
	function datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.tmpEjerDoc_datosAlbaran(curPedido, where, datosAgrupacion);
	}
	function generarAlbaran(where:String, cursor:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.ctx.tmpEjerDoc_generarAlbaran(where, cursor, datosAgrupacion);
	}
}
//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
/** \D Informa los datos de un albarán a partir de los de uno o varios pedidos
@param	curPedido: Cursor que contiene los datos a incluir en el albarán
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function tmpEjerDoc_datosAlbaran(curPedido:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean
{
	var fecha:String;
	if (curPedido.action() == "pedidosprov") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPedido.valueBuffer("fecha");
			
	var codEjercicio:String = curPedido.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio);
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}

	with (this.iface.curAlbaran) {
		setValueBuffer("codproveedor", curPedido.valueBuffer("codproveedor"));
		setValueBuffer("nombre", curPedido.valueBuffer("nombre"));
		setValueBuffer("cifnif", curPedido.valueBuffer("cifnif"));
		setValueBuffer("coddivisa", curPedido.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
		setValueBuffer("codpago", curPedido.valueBuffer("codpago"));
		setValueBuffer("codalmacen", curPedido.valueBuffer("codalmacen"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codserie", curPedido.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
		setValueBuffer("irpf", curPedido.valueBuffer("irpf"));
	}
	
	return true;
}

/** \D 
Genera el albarán asociado a uno o más pedidos
@param where: Sentencia where para la consulta de búsqueda de los pedidos a agrupar
@param cursor: Cursor con los datos principales que se copiarán del pedido al albarán
@return Identificador del albarán generado. FALSE si hay error
\end */
function tmpEjerDoc_generarAlbaran(where:String, cursor:FLSqlCursor, datosAgrupacion:Array):Number
{
	var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranesprov");
	var idPedido:Number = cursor.valueBuffer("idpedido");
	var numeroPedido:Number = cursor.valueBuffer("numero");
	var numeroAlbaran:Number = flfacturac.iface.pub_siguienteNumero(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), "nalbaranprov");
	if (!numeroAlbaran)
		return false;

	var fecha:String;
	if (cursor.action() == "pedidosprov") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = cursor.valueBuffer("fecha");
	
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio);
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}

	with(curAlbaran) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("numero", numeroAlbaran);
			setValueBuffer("codproveedor", cursor.valueBuffer("codproveedor"));
			setValueBuffer("nombre", cursor.valueBuffer("nombre"));
			setValueBuffer("cifnif", cursor.valueBuffer("cifnif"));
			setValueBuffer("coddivisa", cursor.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", cursor.valueBuffer("tasaconv"));
			setValueBuffer("recfinanciero", cursor.valueBuffer("recfinanciero"));
			setValueBuffer("codpago", cursor.valueBuffer("codpago"));
			setValueBuffer("codalmacen", cursor.valueBuffer("codalmacen"));
			setValueBuffer("fecha", fecha);
			setValueBuffer("codserie", cursor.valueBuffer("codserie"));
			setValueBuffer("codejercicio", codEjercicio);
			setValueBuffer("tasaconv", cursor.valueBuffer("tasaconv"));
			setValueBuffer("recfinanciero", cursor.valueBuffer("recfinanciero"));
	}
	if (!curAlbaran.commitBuffer())
			return false;
			
	var idAlbaran:Number = curAlbaran.valueBuffer("idalbaran");
	var codAlmacen:String = curAlbaran.valueBuffer("codalmacen");

	var curPedidos:FLSqlCursor = new FLSqlCursor("pedidosprov");
	curPedidos.select(where);
	while (curPedidos.next()) {
		curPedidos.setModeAccess(curPedidos.Edit);
		curPedidos.refreshBuffer();
		idPedido = curPedidos.valueBuffer("idpedido");
		if (!this.iface.copiaLineas(idPedido, idAlbaran, codAlmacen))
			return false;
		curPedidos.setValueBuffer("servido", "Sí");
		curPedidos.setValueBuffer("editable", false);
		if (!curPedidos.commitBuffer())
			return false;
	}

	curAlbaran.select("idalbaran = " + idAlbaran);
	if (curAlbaran.first()) {
		with(curAlbaran) {
			setModeAccess(Edit);
			refreshBuffer();
			setValueBuffer("neto", formalbaranesprov.iface.pub_commonCalculateField("neto", curAlbaran));
			setValueBuffer("totaliva", formalbaranesprov.iface.pub_commonCalculateField("totaliva", curAlbaran));
			setValueBuffer("totalrecargo", formalbaranesprov.iface.pub_commonCalculateField("totalrecargo", curAlbaran));
			setValueBuffer("total", formalbaranesprov.iface.pub_commonCalculateField("total", curAlbaran));
			setValueBuffer("totaleuros", formalbaranesprov.iface.pub_commonCalculateField("totaleuros", curAlbaran));
			setValueBuffer("codigo", formalbaranesprov.iface.pub_commonCalculateField("codigo", curAlbaran));
		}
		if (!curAlbaran.commitBuffer())
			return false;
	}

	return idAlbaran;
}

//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
