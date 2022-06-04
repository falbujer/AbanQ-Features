
/** @class_declaration tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
class tmpEjerDoc extends oficial {
    function tmpEjerDoc( context ) { oficial ( context ); }
	function datosPedido(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.tmpEjerDoc_datosPedido(curPresupuesto);
	}
	function generarPedido(cursor:FLSqlCursor):Number {
		return this.ctx.tmpEjerDoc_generarPedido(cursor);
	}
}
//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
/** \D Informa los datos de un pedido a partir de los de un presupuesto
@param	curPresupuesto: Cursor que contiene los datos a incluir en el pedido
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function tmpEjerDoc_datosPedido(curPresupuesto:FLSqlCursor):Boolean
{
	var fecha:String;
	if (curPresupuesto.action() == "pedidoscli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPresupuesto.valueBuffer("fecha");
	
	var codEjercicio:String = curPresupuesto.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio);
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}
	
	with (this.iface.curPedido) {
		setValueBuffer("codserie", curPresupuesto.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("irpf", curPresupuesto.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codagente", curPresupuesto.valueBuffer("codagente"));
		setValueBuffer("porcomision", curPresupuesto.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curPresupuesto.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curPresupuesto.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curPresupuesto.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPresupuesto.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curPresupuesto.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curPresupuesto.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curPresupuesto.valueBuffer("nombrecliente"));
		setValueBuffer("coddir", curPresupuesto.valueBuffer("coddir"));
		setValueBuffer("direccion", curPresupuesto.valueBuffer("direccion"));
		setValueBuffer("codpostal", curPresupuesto.valueBuffer("codpostal"));
		setValueBuffer("ciudad", curPresupuesto.valueBuffer("ciudad"));
		setValueBuffer("provincia", curPresupuesto.valueBuffer("provincia"));
		setValueBuffer("apartado", curPresupuesto.valueBuffer("apartado"));
		setValueBuffer("codpais", curPresupuesto.valueBuffer("codpais"));
		setValueBuffer("recfinanciero", curPresupuesto.valueBuffer("recfinanciero"));
	}
	
	return true;
}

/** \D
Genera el pedido asociado a un presupuesto
@param cursor: Cursor con los datos principales que se copiarán del presupuesto al pedido
@return True: Copia realizada con éxito, False: Error
\end */
function tmpEjerDoc_generarPedido(cursor:FLSqlCursor):Number
{
	var retorno:Number;
	var where:String = "idpresupuesto = " + cursor.valueBuffer("idpresupuesto");
	var curPedido:FLSqlCursor = new FLSqlCursor("pedidoscli");
	var idPresupuesto:Number = cursor.valueBuffer("idpresupuesto");

	var fecha:String;
	if (cursor.action() == "pedidoscli") {
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
	
	var numeroPedido:Number = flfacturac.iface.pub_siguienteNumero(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), "npedidocli");
	if (!numeroPedido)
		return false;
		
	with(curPedido) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("numero", numeroPedido);
		setValueBuffer("codserie", cursor.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("irpf", cursor.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codagente", cursor.valueBuffer("codagente"));
		setValueBuffer("porcomision", cursor.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", cursor.valueBuffer("codalmacen"));
		setValueBuffer("codpago", cursor.valueBuffer("codpago"));
		setValueBuffer("coddivisa", cursor.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", cursor.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", cursor.valueBuffer("codcliente"));
		setValueBuffer("cifnif", cursor.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", cursor.valueBuffer("nombrecliente"));
		setValueBuffer("coddir", cursor.valueBuffer("coddir"));
		setValueBuffer("direccion", cursor.valueBuffer("direccion"));
		setValueBuffer("codpostal", cursor.valueBuffer("codpostal"));
		setValueBuffer("ciudad", cursor.valueBuffer("ciudad"));
		setValueBuffer("provincia", cursor.valueBuffer("provincia"));
		setValueBuffer("apartado", cursor.valueBuffer("apartado"));
		setValueBuffer("codpais", cursor.valueBuffer("codpais"));
		setValueBuffer("recfinanciero", cursor.valueBuffer("recfinanciero"));
		setValueBuffer("idpresupuesto", idPresupuesto);
	}
	if (!curPedido.commitBuffer())
		return false;
		
	var idPedido:Number = curPedido.valueBuffer("idpedido");
	var curPresupuestos:FLSqlCursor = new FLSqlCursor("presupuestoscli");
	curPresupuestos.select(where);
	while (curPresupuestos.next()) {
		curPresupuestos.setModeAccess(curPresupuestos.Edit);
		curPresupuestos.refreshBuffer();
		idPresupuesto = curPresupuestos.valueBuffer("idpresupuesto");
		if (!this.iface.copiaLineas(idPresupuesto, idPedido))
			return;
		curPresupuestos.setValueBuffer("editable", false);
		curPresupuestos.commitBuffer();
	}

	curPedido.select("idpedido = " + idPedido);
	if (curPedido.first()) {
		with(curPedido) {
			setModeAccess(Edit);
			refreshBuffer();
			setValueBuffer("neto", formpedidoscli.iface.pub_commonCalculateField("neto", curPedido));
			setValueBuffer("totaliva", formpedidoscli.iface.pub_commonCalculateField("totaliva", curPedido));
			setValueBuffer("totalirpf", formpedidoscli.iface.pub_commonCalculateField("totalirpf", curPedido));
			setValueBuffer("totalrecargo", formpedidoscli.iface.pub_commonCalculateField("totalrecargo", curPedido));
			setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", curPedido));
			setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", curPedido));
			setValueBuffer("codigo", formpedidoscli.iface.pub_commonCalculateField("codigo", curPedido));
		}
		if (curPedido.commitBuffer() == true)
			retorno = idPedido;
	}

	return retorno;
}

//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
