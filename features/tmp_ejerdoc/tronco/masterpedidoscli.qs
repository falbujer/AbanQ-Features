
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
	var util:FLUtil = new FLUtil();
	var fecha:String;
	if (curPedido.action() == "pedidoscli") {
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
	
	var codDir:Number = util.sqlSelect("dirclientes", "id", "codcliente = '" + curPedido.valueBuffer("codcliente") + "' AND domenvio = 'true'");
		
	with (this.iface.curAlbaran) {
		setValueBuffer("codserie", curPedido.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("irpf", curPedido.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codagente", curPedido.valueBuffer("codagente"));
		setValueBuffer("porcomision", curPedido.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curPedido.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curPedido.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curPedido.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curPedido.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curPedido.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curPedido.valueBuffer("nombrecliente"));
		if(!codDir){
			setValueBuffer("coddir", curPedido.valueBuffer("coddir"));
			setValueBuffer("direccion", curPedido.valueBuffer("direccion"));
			setValueBuffer("codpostal", curPedido.valueBuffer("codpostal"));
			setValueBuffer("ciudad", curPedido.valueBuffer("ciudad"));
			setValueBuffer("provincia", curPedido.valueBuffer("provincia"));
			setValueBuffer("apartado", curPedido.valueBuffer("apartado"));
			setValueBuffer("codpais", curPedido.valueBuffer("codpais"));
		}
		else {
			setValueBuffer("coddir", codDir);
			setValueBuffer("direccion", util.sqlSelect("dirclientes","direccion","id = " + codDir));
			setValueBuffer("codpostal", util.sqlSelect("dirclientes","codpostal","id = " + codDir));
			setValueBuffer("ciudad", util.sqlSelect("dirclientes","ciudad","id = " + codDir));
			setValueBuffer("provincia", util.sqlSelect("dirclientes","provincia","id = " + codDir));
			setValueBuffer("apartado", util.sqlSelect("dirclientes","apartado","id = " + codDir));
			setValueBuffer("codpais", util.sqlSelect("dirclientes","codpais","id = " + codDir));
		}
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
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
	var retorno:Number;
	var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranescli");
	var numeroAlbaran:Number = flfacturac.iface.pub_siguienteNumero(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), "nalbarancli");
	if (!numeroAlbaran)
		return false;
	
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
				
	with(curAlbaran) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("numero", numeroAlbaran);
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
	}
	if (!curAlbaran.commitBuffer())
		return false;

	var idAlbaran:Number = curAlbaran.valueBuffer("idalbaran");
	var qryPedidos:FLSqlQuery = new FLSqlQuery();
	qryPedidos.setTablesList("pedidoscli");
	qryPedidos.setSelect("idpedido");
	qryPedidos.setFrom("pedidoscli");
	qryPedidos.setWhere(where);

	if (!qryPedidos.exec())
		return false;

	var idPedido:String;
	while (qryPedidos.next()) {
		idPedido = qryPedidos.value(0);
		if (!this.iface.copiaLineas(idPedido, idAlbaran))
			return false;
	}
		
	curAlbaran.select("idalbaran = " + idAlbaran);
	if (curAlbaran.first()) {
		with(curAlbaran) {
			setModeAccess(Edit);
			refreshBuffer();
			setValueBuffer("neto", formalbaranescli.iface.pub_commonCalculateField("neto", curAlbaran));
			setValueBuffer("totaliva", formalbaranescli.iface.pub_commonCalculateField("totaliva", curAlbaran));
			setValueBuffer("totalirpf", formalbaranescli.iface.pub_commonCalculateField("totalirpf", curAlbaran));
			setValueBuffer("totalrecargo", formalbaranescli.iface.pub_commonCalculateField("totalrecargo", curAlbaran));
			setValueBuffer("total", formalbaranescli.iface.pub_commonCalculateField("total", curAlbaran));
			setValueBuffer("totaleuros", formalbaranescli.iface.pub_commonCalculateField("totaleuros", curAlbaran));
			setValueBuffer("codigo", formalbaranescli.iface.pub_commonCalculateField("codigo", curAlbaran));
		}
		if (curAlbaran.commitBuffer() == true)
		retorno = idAlbaran;
	}
	if(!this.iface.actualizarDatosPedido(where, idAlbaran))
		return false;
	
return retorno;
}

//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
