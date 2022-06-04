
/** @class_declaration tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
class tmpEjerDoc extends oficial {
    function tmpEjerDoc( context ) { oficial ( context ); }
	function datosDocFacturacion(fecha:String, codEjercicio:String):Array {
		return this.ctx.tmpEjerDoc_datosDocFacturacion(fecha, codEjercicio);
	}
	function generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean {
		return this.ctx.tmpEjerDoc_generarAsientoFacturaProv(curFactura);
	}
	function generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.tmpEjerDoc_generarAsientoFacturaCli(curFactura);
	}
	function regenerarAsiento(curFactura:FLSqlCursor, valoresDefecto:Array):Array {
		return this.ctx.tmpEjerDoc_regenerarAsiento(curFactura, valoresDefecto);
	}
}
//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
class pubEjerDoc extends ifaceCtx {
    function pubEjerDoc( context ) { ifaceCtx ( context ); }
	function pub_datosDocFacturacion(fecha:String, codEjercicio:String):Array {
		return this.datosDocFacturacion(fecha, codEjercicio);
	}
}
//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
/** \D Si la fecha no está dentro del ejercicio, propone al usuario la selección de uno nuevo
@param	fecha: Fecha del documento
@param	codEjercicio: Ejercicio del documento
@return	Devuelve un array con los siguientes datos:
ok:	Indica si la función terminó correctamente (true) o con error (false)
modificaciones: Indica si se ha modificado algún valor (fecha o ejercicio)
fecha: Nuevo valor para la fecha modificada
codEjercicio: Nuevo valor para el ejercicio modificado
\end */
function tmpEjerDoc_datosDocFacturacion(fecha:String, codEjercicio:String):Array
{
	var res:Array = [];
	res["ok"] = true;
	res["modificaciones"] = false;
	
	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "' AND '" + fecha + "' BETWEEN fechainicio AND fechafin"))
		return res;
		
	var label:String = util.translate("scripts", "Los datos actuales de fecha y ejercicio del documento a generar no son coherentes:") + "\n" + util.translate("scripts", "Fecha: ") + util.dateAMDtoDMA(fecha) + "\n" + util.translate("scripts", "Ejercicio: ") + codEjercicio + "\n" + util.translate("scripts", "Escoja un ejercicio que contenga la fecha establecida o cambie el valor de la fecha");
	var f:Object = new FLFormSearchDB("fechaejercicio");
	var cursor:FLSqlCursor = f.cursor();
	
	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	cursor.setValueBuffer("fecha", fecha);
	cursor.setValueBuffer("codejercicio", codEjercicio);
	cursor.setValueBuffer("label", label);
	
	var acpt:String = f.exec("codejercicio");
	if (!acpt) {
		res["ok"] = false;
		return res;
	}
	res["modificaciones"] = true;
	res["fecha"] = cursor.valueBuffer("fecha");
	res["codEjercicio"] = cursor.valueBuffer("codejercicio");
	
	if (res.codEjercicio != flfactppal.iface.pub_ejercicioActual()) {
		MessageBox.information(util.translate("scripts", "Ha seleccionado un ejercicio distinto del actual.\nPara visualizar los documentos generados debe cambiar el ejercicio actual en la ventana\nde empresa y volver a abrir el formulario maestro correspondiente a los documentos generados"), MessageBox.Ok, MessageBox.NoButton);
	}
	
	return res;
}

/** \U Genera o regenera el asiento correspondiente a una factura de proveedor
@param	curFactura: Cursor con los datos de la factura
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
/** \C El concepto de los asientos de factura de proveedor será 'Su factura ' + número de proveedor asociado a la factura. Si el número de proveedor no se especifica, el concepto será 'Su factura ' + código de factura.
\end */
function tmpEjerDoc_generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean
{
	if (curFactura.modeAccess() != curFactura.Insert && curFactura.modeAccess() != curFactura.Edit)
		return true;

	var util:FLUtil = new FLUtil();
	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = curFactura.valueBuffer("codejercicio");
	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	datosAsiento = this.iface.regenerarAsiento(curFactura, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	var numProveedor:String = curFactura.valueBuffer("numproveedor");
	var concepto:String;
	if (!numProveedor || numProveedor == "")
		concepto = util.translate("scripts", "Su factura ") + curFactura.valueBuffer("codigo");
	else
		concepto = util.translate("scripts", "Su factura ") + numProveedor;
	concepto += " - " + curFactura.valueBuffer("nombre");

	var ctaProveedor:Array = this.iface.datosCtaProveedor(curFactura, valoresDefecto);
	if (ctaProveedor.error != 0)
		return false;

	if (!this.iface.generarPartidasProveedor(curFactura, datosAsiento.idasiento, valoresDefecto, ctaProveedor, concepto))
		return false;

	if (!this.iface.generarPartidasIVAProv(curFactura, datosAsiento.idasiento, valoresDefecto, ctaProveedor, concepto))
		return false;

	if (!this.iface.generarPartidasCompra(curFactura, datosAsiento.idasiento, valoresDefecto, concepto))
		return false;
	
	curFactura.setValueBuffer("idasiento", datosAsiento.idasiento);
		
	if (curFactura.valueBuffer("deabono") == true)
		if (!this.iface.asientoFacturaAbonoProv(curFactura, valoresDefecto))
			return false;

	
	return true;
}

/** \U Genera o regenera el asiento correspondiente a una factura de cliente
@param	curFactura: Cursor con los datos de la factura
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function tmpEjerDoc_generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean
{
	if (curFactura.modeAccess() != curFactura.Insert && curFactura.modeAccess() != curFactura.Edit)
		return true;

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = curFactura.valueBuffer("codejercicio");
	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	datosAsiento = this.iface.regenerarAsiento(curFactura, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	var ctaCliente = this.iface.datosCtaCliente(curFactura, valoresDefecto);
	if (ctaCliente.error != 0)
		return false;

	if (!this.iface.generarPartidasCliente(curFactura, datosAsiento.idasiento, valoresDefecto, ctaCliente))
		return false;

	if (!this.iface.generarPartidasIRPF(curFactura, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasIVACli(curFactura, datosAsiento.idasiento, valoresDefecto, ctaCliente))
		return false;

	if (!this.iface.generarPartidasVenta(curFactura, datosAsiento.idasiento, valoresDefecto))
		return false;
    
	curFactura.setValueBuffer("idasiento", datosAsiento.idasiento);
	
	if (curFactura.valueBuffer("deabono") == true)
		if (!this.iface.asientoFacturaAbonoCli(curFactura, valoresDefecto))
			return false;

	return true;
}

/** \D Genera o regenera el registro en la tabla de asientos correspondiente a la factura. Si el asiento ya estaba creado borra sus partidas asociadas.
@param	curFactura: Cursor posicionado en el registro de factura
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	array con los siguientes datos:
asiento.idasiento: Id del asiento
asiento.numero: numero del asiento
asiento.fecha: fecha del asiento
asiento.error: indicador booleano de que ha habido un error en la función
\end */
function tmpEjerDoc_regenerarAsiento(curFactura:FLSqlCursor, valoresDefecto:Array):Array
{
	var util:FLUtil = new FLUtil;
	var asiento:Array = [];
	var idAsiento:Number = curFactura.valueBuffer("idasiento");
	if (curFactura.isNull("idasiento")) {
		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
		var numAsiento:Number = util.sqlSelect("co_asientos", "MAX(numero)",  "codejercicio = '" + valoresDefecto.codejercicio + "'");
		numAsiento++;
		with (curAsiento) {
			setModeAccess(curAsiento.Insert);
			refreshBuffer();
			setValueBuffer("numero", numAsiento);
			setValueBuffer("fecha", curFactura.valueBuffer("fecha"));
			setValueBuffer("codejercicio", valoresDefecto.codejercicio);
		}
		if (!curAsiento.commitBuffer()) {
			asiento.error = true;
			return asiento;
		}
		asiento.idasiento = curAsiento.valueBuffer("idasiento");
		asiento.numero = curAsiento.valueBuffer("numero");
		asiento.fecha = curAsiento.valueBuffer("fecha");
		curAsiento.select("idasiento = " + asiento.idasiento);
		curAsiento.first();
		curAsiento.setUnLock("editable", false);
	} else {
		if (!this.iface.asientoBorrable(idAsiento)) {
			asiento.error = true;
			return asiento;
		}

		if (curFactura.valueBuffer("fecha") != curFactura.valueBufferCopy("fecha")) {
			var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
			curAsiento.select("idasiento = " + idAsiento);
			if (!curAsiento.first()) {
				asiento.error = true;
				return asiento;
			}
			curAsiento.setUnLock("editable", true);

			curAsiento.select("idasiento = " + idAsiento);
			if (!curAsiento.first()) {
				asiento.error = true;
				return asiento;
			}
			curAsiento.setModeAccess(curAsiento.Edit);
			curAsiento.refreshBuffer();
			curAsiento.setValueBuffer("fecha", curFactura.valueBuffer("fecha"));

			if (!curAsiento.commitBuffer()) {
				asiento.error = true;
				return asiento;
			}
			curAsiento.select("idasiento = " + idAsiento);
			if (!curAsiento.first()) {
				asiento.error = true;
				return asiento;
			}
			curAsiento.setUnLock("editable", false);
		}

		asiento = flfactppal.iface.pub_ejecutarQry("co_asientos", "idasiento,numero,fecha",
				"idasiento = '" + idAsiento + "'");
		var curPartidas = new FLSqlCursor("co_partidas");
		curPartidas.select("idasiento = " + idAsiento);
		while (curPartidas.next()) {
			curPartidas.setModeAccess(curPartidas.Del);
			curPartidas.refreshBuffer();
			if (!curPartidas.commitBuffer()) {
				asiento.error = true;
				return asiento;
			}
		}
	}

	asiento.error = false;
	return asiento;
}

//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////