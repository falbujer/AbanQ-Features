
/** @class_declaration pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
class pagareProv extends proveed {
    function pagareProv( context ) { proveed ( context ); }
	function generarAsientoPagoDevolProv(curPD:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_generarAsientoPagoDevolProv(curPD);
	}
	function beforeCommit_pagaresprov(curPagare:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_beforeCommit_pagaresprov(curPagare);
	}
	function beforeCommit_pagospagareprov(curPD:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_beforeCommit_pagospagareprov(curPD);
	}
	function afterCommit_pagospagareprov(curPD:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_afterCommit_pagospagareprov(curPD);
	}
	function generarPartidasBancoPagProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, pagare:Array):Boolean {
		return this.ctx.pagareProv_generarPartidasBancoPagProv(curPD, valoresDefecto, datosAsiento, pagare);
	}
	function generarPartidasPtePagProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, pagare:Array):Boolean {
		return this.ctx.pagareProv_generarPartidasPtePagProv(curPD, valoresDefecto, datosAsiento, pagare);
	}
	function generarAsientoPagoPagareProv(curPD:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_generarAsientoPagoPagareProv(curPD);
	}
	function cambiaUltimoPagoPagProv(idPagare:String, idPagoDevol:String, unlock:Boolean):Boolean {
		return this.ctx.pagareProv_cambiaUltimoPagoPagProv(idPagare, idPagoDevol, unlock);
	}
	function comprobarFechasPagares(curPagare:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_comprobarFechasPagares(curPagare);
	}
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
function pagareProv_generarAsientoPagoDevolProv(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit)
		return true;
	
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curPD.valueBuffer("fecha"), codEjercicio, "pagosdevolprov");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		curPD.setValueBuffer("fecha", datosDoc.fecha);
	}
	
	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	
	datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	if (curPD.valueBuffer("tipo") == "Pago") {
		var recibo:Array = flfactppal.iface.pub_ejecutarQry("recibosprov", "coddivisa,importe,importeeuros,idfactura,codigo,nombreproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (recibo.result != 1)
			return false;
	
		if (!this.iface.generarPartidasProv(curPD, valoresDefecto, datosAsiento, recibo))
			return false;
	
		if (!this.iface.generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo))
			return false;

		if (!this.iface.generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo))
			return false;
	} else if (curPD.valueBuffer("tipo") == "Pagar�") {
		var recibo:Array = flfactppal.iface.pub_ejecutarQry("recibosprov", "coddivisa,importe,importeeuros,idfactura,codigo,nombreproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (recibo.result != 1)
			return false;
	
		if (!this.iface.generarPartidasProv(curPD, valoresDefecto, datosAsiento, recibo))
			return false;
	
		if (!this.iface.generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo))
			return false;

		if (!this.iface.generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo))
			return false;
	} else if (curPD.valueBuffer("tipo") == "Pag.Anulado") {
		/** \D En el caso de anular un pago con pagar�, las subcuentas del asiento contable ser�n las inversas al asiento contable correspondiente al �ltimo pago con pagar�
		\end */
		var idAsientoPago:Number = util.sqlSelect("pagosdevolprov", "idasiento", "idrecibo = " + curPD.valueBuffer("idrecibo") + " AND  tipo = 'Pagar�' ORDER BY fecha DESC");
		var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (this.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, curPD.valueBuffer("tipo") + " recibo " + codRecibo, valoresDefecto.codejercicio) == false)
			return false;
	} else {
		/** \D En el caso de dar una devoluci�n, las subcuentas del asiento contable ser�n las inversas al asiento contable correspondiente al �ltimo pago
		\end */
		var idAsientoPago:Number = util.sqlSelect("pagosdevolprov", "idasiento", "idrecibo = " + curPD.valueBuffer("idrecibo") + " AND  tipo = 'Pago' ORDER BY fecha DESC");
		var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (this.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, curPD.valueBuffer("tipo") + " recibo " + codRecibo, valoresDefecto.codejercicio) == false)
			return false;
	}

	if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
		return false;

	curPD.setValueBuffer("idasiento", datosAsiento.idasiento);

	return true;
}

function pagareProv_beforeCommit_pagaresprov(curPagare:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	switch (curPagare.modeAccess()) {
		/** \C El pagar� puede borrarse si todos los recibos asociados pueden ser excluidos
		\end */
		case curPagare.Del: {
			if (curPagare.valueBuffer("estado") != "Emitido") {
				MessageBox.warning(util.translate("scripts", "No puede borrar un pagar� en estado %1.\nSi realmente quiere borrarlo debe eliminar los pagos y devoluciones").arg(curPagare.valueBuffer("estado")), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			var idPagare:Number = curPagare.valueBuffer("idpagare");
			var qryRecibos:FLSqlQuery = new FLSqlQuery;
			qryRecibos.setTablesList("pagosdevolprov");
			qryRecibos.setSelect("DISTINCT(idrecibo)");
			qryRecibos.setFrom("pagosdevolprov");
			qryRecibos.setWhere("idpagare = " + idPagare);
			qryRecibos.setForwardOnly(true);
			if (!qryRecibos.exec())
				return false;
			while (qryRecibos.next()) {
				if (!formRecordpagaresprov.iface.pub_excluirReciboPagare(qryRecibos.value(0), idPagare))
					return false;
			}
		}
		case curPagare.Insert:
		case curPagare.Edit: {
			if (!this.iface.comprobarFechasPagares(curPagare))
				return false;

			if (curPagare.valueBuffer("numero") == "") {
				MessageBox.warning(util.translate("scripts", "El pagar� debe tener un n�mero establecido"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			if (util.sqlSelect("pagaresprov", "idpagare", "numero = '" + curPagare.valueBuffer("numero") + "' AND idpagare <> " + curPagare.valueBuffer("idpagare"))) {
				MessageBox.warning(util.translate("scripts", "Ya existe un pagar� con el n�mero %1").arg(curPagare.valueBuffer("numero")), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	}
	return true;
}

function pagareProv_beforeCommit_pagospagareprov(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if (sys.isLoadedModule("flcontppal") && !curPD.valueBuffer("nogenerarasiento") && util.sqlSelect("empresa", "contintegrada", "1 = 1")) {
		if (!this.iface.generarAsientoPagoPagareProv(curPD))
			return false;
	}
	
	return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devoluci�n
\end */
function pagareProv_afterCommit_pagospagareprov(curPD:FLSqlCursor):Boolean
{
	var idPagare:String = curPD.valueBuffer("idpagare");
	
	/** \C Se cambia el pago anterior al actual para que s�lo el �ltimo sea editable
	\end */
	switch (curPD.modeAccess()) {
		case curPD.Insert:
		case curPD.Edit: {
			if (!this.iface.cambiaUltimoPagoPagProv(idPagare, curPD.valueBuffer("idpagodevol"), false))
			return false;
			break;
		}
		case curPD.Del: {
			if (!this.iface.cambiaUltimoPagoPagProv(idPagare, curPD.valueBuffer("idpagodevol"), true))
			return false;
			break;
		}
	}
		
	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flcontppal") == false || util.sqlSelect("empresa", "contintegrada", "1 = 1") == false)
		return true;
		
	if (curPD.modeAccess() == curPD.Del) {
		if (curPD.isNull("idasiento"))
			return true;

		var idAsiento:Number = curPD.valueBuffer("idasiento");
		if (flfacturac.iface.pub_asientoBorrable(idAsiento) == false)
			return false;

		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
		curAsiento.select("idasiento = " + idAsiento);
		if (curAsiento.first()) {
			curAsiento.setUnLock("editable", true);
			curAsiento.setModeAccess(curAsiento.Del);
			curAsiento.refreshBuffer();
			if (!curAsiento.commitBuffer())
				return false;
		}
	}
	return true;
}

function pagareProv_generarAsientoPagoPagareProv(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit)
		return true;
	
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curPD.valueBuffer("fecha"), codEjercicio, "pagosdevolprov");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		curPD.setValueBuffer("fecha", datosDoc.fecha);
	}
	
	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	
	datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	if (curPD.valueBuffer("tipo") == "Pago") {
		var pagare:Array = flfactppal.iface.pub_ejecutarQry("pagaresprov", "numero,total,nombreproveedor,coddivisa,codsubcuentap", "idpagare = " + curPD.valueBuffer("idpagare"));
		if (pagare.result != 1)
			return false;
	
		if (!this.iface.generarPartidasPtePagProv(curPD, valoresDefecto, datosAsiento, pagare))
			return false;
	
		if (!this.iface.generarPartidasBancoPagProv(curPD, valoresDefecto, datosAsiento, pagare))
			return false;

	} else {
		/** \D En el caso de dar una devoluci�n, las subcuentas del asiento contable ser�n las inversas al asiento contable correspondiente al �ltimo pago
		\end */
		var idAsientoPago:Number = util.sqlSelect("pagospagareprov", "idasiento", "idpagare = " + curPD.valueBuffer("idpagare") + " AND  tipo = 'Pago' ORDER BY fecha DESC");
		var numPagare:String = util.sqlSelect("pagaresprov", "numero", "idpagare = " + curPD.valueBuffer("idpagare"));
		if (this.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, curPD.valueBuffer("tipo") + " pagare " + numPagare, valoresDefecto.codejercicio) == false)
			return false;
	}

	if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
		return false;

	curPD.setValueBuffer("idasiento", datosAsiento.idasiento);

	return true;
}

function pagareProv_generarPartidasBancoPagProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, pagare:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaHaber:Array = [];
	
	ctaHaber.codsubcuenta = curPD.valueBuffer("codsubcuenta");
	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
		
	var haber:Number = 0;
	var haberME:Number = 0;
	
	haber = pagare.total;
	haberMe = 0;
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", curPD.valueBuffer("tipo") + " pagar� prov. " + pagare.numero + " - " + pagare.nombreproveedor);
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("coddivisa", pagare.coddivisa);
		setValueBuffer("tasaconv", 1);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la partida correspondiente a la subcuenta de efectos pendientes de pago
@param	curPD: Cursor del pago o devoluci�n
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@param	pagare: Array con los datos del pagar� asociado al pago
@return	true si la generaci�n es correcta, false en caso contrario
\end */
function pagareProv_generarPartidasPtePagProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, pagare:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaDebe:Array = [];
	
	ctaDebe.codsubcuenta = pagare.codsubcuentap;
	ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaDebe.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var debe:Number = 0;
	var debeME:Number = 0;
	var tasaconvDebe:Number = 1;

	debe = util.sqlSelect("pagosdevolprov pd INNER JOIN co_partidas p ON pd.idasiento = p.idasiento", "SUM(haber - debe)", "pd.idpagare = " + curPD.valueBuffer("idpagare") + " AND p.codsubcuenta = '" + pagare.codsubcuentap + "'", "pagosdevolprov,co_subcuentas");
	debeME = 0;

	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");
	if (parseFloat(debe) != parseFloat(pagare.total)) {
		MessageBox.warning(util.translate("script", "Error: La suma de pagos de los recibos en el pagar� (%1)\nno coincide con el total del pagar� (%2)").arg(util.roundFieldValue(debe, "co_partidas", "debe")).arg(util.roundFieldValue(pagare.total, "co_partidas", "debe")), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
 
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", curPD.valueBuffer("tipo") + " pagar� prov. " + pagare.numero + " - " + pagare.nombreproveedor);
		setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("coddivisa", pagare.coddivisa);
		setValueBuffer("tasaconv", tasaconvDebe);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}


/** \D Cambia la el estado del �ltimo pago anterior al especificado, de forma que se mantenga como �nico pago editable el �ltimo de todos
@param	idPagare: Identificador del pagar� al que pertenecen los pagos tratados
@param	idPagoDevol: Identificador del pago que ha cambiado
@param	unlock: Indicador de si el �ltim pago debe ser editable o no
@return	true si la verificaci�n del estado es correcta, false en caso contrario
\end */
function pagareProv_cambiaUltimoPagoPagProv(idPagare:String, idPagoDevol:String, unlock:Boolean):Boolean
{
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagospagareprov");
	curPagosDevol.select("idpagare = " + idPagare + " AND idpagodevol <> " + idPagoDevol + " ORDER BY fecha, idpagodevol");
	if (curPagosDevol.last())
		curPagosDevol.setUnLock("editable", unlock);
	
	return true;
}

function pagareProv_comprobarFechasPagares(curPagare:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	if (util.daysTo(curPagare.valueBuffer("fecha"), curPagare.valueBuffer("fechav")) < 0) {
		MessageBox.warning(util.translate("scripts", "La fecha de emisi�n debe ser menor o igual a la fecha de vencimiento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
