
/** @class_declaration rasientos */
/////////////////////////////////////////////////////////////////
//// RASIENTOS //////////////////////////////////////////////////
class rasientos extends oficial {
    function rasientos( context ) { oficial ( context ); }
	function init() {
		this.ctx.rasientos_init();
	}
	function tbnRegenerar_clicked() {
		return this.ctx.rasientos_tbnRegenerar_clicked();
	}
	function regenerar():Boolean {
		return this.ctx.rasientos_regenerar();
	}
	function pagosdevolcli(curPD:FLSqlCursor):Boolean {
		return this.ctx.rasientos_pagosdevolcli(curPD);
	}
	function pagosdevolprov(curPD:FLSqlCursor):Boolean {
		return this.ctx.rasientos_pagosdevolprov(curPD);
	}
}
//// RASIENTOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rasientos */
//////////////////////////////////////////////////////////////////
//// RASIENTOS ///////////////////////////////////////////////////
function rasientos_init() {
	this.iface.__init();
	connect(this.child("tbnRegenerar"), "clicked()", this, "iface.tbnRegenerar_clicked()");
}

function rasientos_tbnRegenerar_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var res:Number = MessageBox.warning(util.translate("scripts", "¿Está seguro de querer regenerar los asientos automáticos?"), MessageBox.Yes, MessageBox.No);
		
	if (res != MessageBox.Yes)
		return;
	
	cursor.transaction(false);
	try {
		if (this.iface.regenerar())
			cursor.commit();
		else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la regeneración:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
}

function rasientos_regenerar():Boolean
{
	var util:FLUtil = new FLUtil();
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var progress:Number;
	
	var curFacturasProv:FLSqlCursor = new FLSqlCursor("facturasprov");
	curFacturasProv.select("codejercicio = '" + codEjercicio + "'");
	util.createProgressDialog(util.translate("scripts", "Regenerando facturas de proveedor"), curFacturasProv.size());
	
	progress = 0;
	while (curFacturasProv.next()) {
		util.setProgress(progress++);
		curFacturasProv.setModeAccess(curFacturasProv.Browse);
		curFacturasProv.refreshBuffer();
		if (curFacturasProv.valueBuffer("nogenerarasiento"))
			continue;
		if (!flfacturac.iface.generarAsientoFacturaProv(curFacturasProv)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	
	progress = 0;
	var curFacturasCli:FLSqlCursor = new FLSqlCursor("facturascli");
	curFacturasCli.select("codejercicio = '" + codEjercicio + "'");
	util.createProgressDialog(util.translate("scripts", "Regenerando facturas de cliente"), curFacturasCli.size());
	while (curFacturasCli.next()) {
		util.setProgress(progress++);
		curFacturasCli.setModeAccess(curFacturasProv.Browse);
		curFacturasCli.refreshBuffer();
		if (curFacturasCli.valueBuffer("nogenerarasiento"))
			continue;
		if (!flfacturac.iface.generarAsientoFacturaCli(curFacturasCli)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	
	progress = 0;
	var curPDCLi:FLSqlCursor = new FLSqlCursor("pagosdevolcli");
	var qryPDCli:FLSqlQuery = new FLSqlQuery;
	qryPDCli.setTablesList("co_asientos,pagosdevolcli");
	qryPDCli.setSelect("idpagodevol");
	qryPDCli.setFrom("co_asientos a inner join pagosdevolcli p on a.idasiento = p.idasiento");
	qryPDCli.setWhere("a.codejercicio = '" + codEjercicio + "'");
	if (!qryPDCli.exec())
		return false;
		
	util.createProgressDialog(util.translate("scripts", "Regenerando pagos de cliente"), qryPDCli.size());
	while (qryPDCli.next()) {
		util.setProgress(progress++);
		curPDCLi.select("idpagodevol = " + qryPDCli.value(0));
		while (curPDCLi.next()) {
			curPDCLi.setModeAccess(curPDCLi.Browse);
			curPDCLi.refreshBuffer();
			if (curPDCLi.valueBuffer("nogenerarasiento"))
				continue;
			if (!this.iface.pagosdevolcli(curPDCLi)) {
				util.destroyProgressDialog();
				return false;
			}
		}
	}
	util.destroyProgressDialog();
	
	progress = 0;
	var curPDProv:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
	if (!curPDProv.select("1=1"))
		return true;
	var qryPDProv:FLSqlQuery = new FLSqlQuery;
	qryPDProv.setTablesList("co_asientos,pagosdevolprov");
	qryPDProv.setSelect("idpagodevol");
	qryPDProv.setFrom("co_asientos a inner join pagosdevolprov p on a.idasiento = p.idasiento");
	qryPDProv.setWhere("a.codejercicio = '" + codEjercicio + "'");
	if (!qryPDProv.exec())
		return false;
		
	util.createProgressDialog(util.translate("scripts", "Regenerando pagos de proveedor"), qryPDProv.size());
	while (qryPDProv.next()) {
		util.setProgress(progress++);
		curPDProv.select("idpagodevol = " + qryPDCli.value(0));
		while (curPDProv.next()) {
			curPDProv.setModeAccess(curPDProv.Browse);
			curPDProv.refreshBuffer();
			if (curPDProv.valueBuffer("nogenerarasiento"))
				continue;
			if (!this.iface.pagosdevolprov(curPDProv)) {
				util.destroyProgressDialog();
				return false;
			}
		}
	}
	util.destroyProgressDialog();
	return true;
}

function rasientos_pagosdevolcli(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flcontppal") || curPD.valueBuffer("nogenerarasiento") || !util.sqlSelect("empresa", "contintegrada", "1 = 1")) {
		return true;
	}
	
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	
	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	
	datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	var ctaDebe:Array = [];
	var ctaHaber:Array = [];
	if (curPD.valueBuffer("tipo") == "Pago") {
	/** \C La cuenta del haber del asiento de pago será la misma cuenta de tipo CLIENT que se usó para realizar el asiento de la correspondiente factura
	\end */
		var idAsientoFactura:Number = util.sqlSelect("reciboscli r INNER JOIN facturascli f" +
			" ON r.idfactura = f.idfactura", "f.idasiento",
			"r.idrecibo = " + curPD.valueBuffer("idrecibo"),
			"facturascli,reciboscli");

		ctaHaber.codsubcuenta = util.sqlSelect("co_partidas p" +
			" INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta" +
			" INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta",
			"s.codsubcuenta",
			"p.idasiento = " + idAsientoFactura + " AND c.idcuentaesp = 'CLIENT'",
			"co_partidas,co_subcuentas,co_cuentas");

		if (!ctaHaber.codsubcuenta) {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado la subcuenta de cliente del asiento contable correspondiente a la factura a pagar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}

		ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
		if (!ctaHaber.idsubcuenta) {
			MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaHaber.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder realizar el pago debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}

		ctaDebe.idsubcuenta = curPD.valueBuffer("idsubcuenta");
		ctaDebe.codsubcuenta = curPD.valueBuffer("codsubcuenta");

		var debe:Number = 0;
		var haber:Number = 0;
		var debeME:Number = 0;
		var haberME:Number = 0;
		var tasaconvDebe:Number = 1;
		var tasaconvHaber:Number = 1;
		var diferenciaCambio:Number = 0;
		var recibo:Array = flfactppal.iface.pub_ejecutarQry("reciboscli", "coddivisa,importe,importeeuros,idfactura,codigo,nombrecliente", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (recibo.result != 1)
			return false;

		if (valoresDefecto.coddivisa == recibo.coddivisa) {
			debe = recibo.importe;
			debeME = 0;
			haber = debe;
			haberMe = 0;
		} else {
			tasaconvDebe = curPD.valueBuffer("tasaconv");
			tasaconvHaber = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");
			debe = parseFloat(recibo.importe) * parseFloat(tasaconvDebe);
			debeME = parseFloat(recibo.importe);
			haber = parseFloat(recibo.importeeuros);
			haberME = parseFloat(recibo.importe);
			diferenciaCambio = debe - haber;
			if (util.buildNumber(diferenciaCambio, "f", 2) == "0.00" || util.buildNumber(diferenciaCambio, "f", 2) == "-0.00") {
				diferenciaCambio = 0;
				debe = haber;
			}
		}
		
		var esAbono:Boolean = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");
		
		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with(curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo " + recibo.codigo + " - " + recibo.nombrecliente);
			setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
			setValueBuffer("idasiento", datosAsiento.idasiento);
			if (esAbono) {
				setValueBuffer("debe", 0);
				setValueBuffer("haber", debe * -1);
			} else {
				setValueBuffer("debe", debe);
				setValueBuffer("haber", 0);
			}
			setValueBuffer("coddivisa", recibo.coddivisa);
			setValueBuffer("tasaconv", tasaconvDebe);
			setValueBuffer("debeME", debeME);
			setValueBuffer("haberME", 0);
		}
		if (!curPartida.commitBuffer())
			return false;

		with(curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo " + recibo.codigo + " - " + recibo.nombrecliente);
			setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
			setValueBuffer("idasiento", datosAsiento.idasiento);
			if (esAbono) {
				setValueBuffer("debe", haber * -1);
				setValueBuffer("haber", 0);
			} else {
				setValueBuffer("debe", 0);
				setValueBuffer("haber", haber);
			}
			setValueBuffer("coddivisa", recibo.coddivisa);
			setValueBuffer("tasaconv", tasaconvHaber);
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
		}
		if (!curPartida.commitBuffer())
				return false;

		/** \C En el caso de que la divisa sea extranjera y la tasa de cambio haya variado desde el momento de la emisión de la factura, la diferencia se imputará a la correspondiente cuenta de diferencias de cambio.
			\end */
		if (diferenciaCambio != 0) {
			var ctaDifCambio:Array = [];
			var debeDifCambio:Number = 0;
			var haberDifCambio:Number = 0;
			if (diferenciaCambio > 0) {
				ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMPOS", valoresDefecto.codejercicio);
				if (ctaDifCambio.error != 0)
					return false;
				debeDifCambio = 0;
				haberDifCambio = diferenciaCambio;
			} else {
				ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMNEG", valoresDefecto.codejercicio);
				if (ctaDifCambio.error != 0)
					return false;
				diferenciaCambio = 0 - diferenciaCambio;
				debeDifCambio = diferenciaCambio;
				haberDifCambio = 0;
			}

			with(curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo " + recibo.codigo + " - " + recibo.nombrecliente);
				setValueBuffer("idsubcuenta", ctaDifCambio.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaDifCambio.codsubcuenta);
				setValueBuffer("idasiento", datosAsiento.idasiento);
				setValueBuffer("debe", debeDifCambio);
				setValueBuffer("haber", haberDifCambio);
				setValueBuffer("coddivisa", valoresDefecto.coddivisa);
				setValueBuffer("tasaconv", 1);
				setValueBuffer("debeME", 0);
				setValueBuffer("haberME", 0);
			}
			if (!curPartida.commitBuffer())
				return false;
		}
	} else {
		/** \D En el caso de dar una devolución, las subcuentas del asiento contable serán las inversas al asiento contable correspondiente al último pago
		\end */
		var idAsientoPago:Number = util.sqlSelect("pagosdevolcli", "idasiento", "idrecibo = " + curPD.valueBuffer("idrecibo") + " AND  tipo = 'Pago' ORDER BY fecha DESC");
		var codRecibo:String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (flfactteso.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, curPD.valueBuffer("tipo") + " recibo " + codRecibo, valoresDefecto.codejercicio) == false)
			return false;
	}

	return true;
}

function rasientos_pagosdevolprov(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	
	if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit)
		return true;

	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	var ctaDebe:Array = [];
	var ctaHaber:Array = [];
	if (curPD.valueBuffer("tipo") == "Pago") {
	/** \C La cuenta del debe del asiento de pago será la misma cuenta de tipo PROVEE que se usó para realizar el asiento de la correspondiente factura
	\end */
		var idAsientoFactura:Number = util.sqlSelect("recibosprov r INNER JOIN facturasprov f" + " ON r.idfactura = f.idfactura", "f.idasiento", "r.idrecibo = " + curPD.valueBuffer("idrecibo"), "facturasprov,recibosprov");
				
		ctaDebe.codsubcuenta = util.sqlSelect("co_partidas p" + " INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta" + " INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta", "s.codsubcuenta", "p.idasiento = " + idAsientoFactura + " AND c.idcuentaesp = 'PROVEE'", "co_partidas,co_subcuentas,co_cuentas");

		if (!ctaDebe.codsubcuenta) {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado la subcuenta de proveedor del asiento contable correspondiente a la factura a pagar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}

		ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta +  "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
		if (!ctaDebe.idsubcuenta) {
			MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaHaber.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder realizar el pago debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}

		ctaHaber.idsubcuenta = curPD.valueBuffer("idsubcuenta");
		ctaHaber.codsubcuenta = curPD.valueBuffer("codsubcuenta");

		var debe:Number = 0;
		var haber:Number = 0;
		var debeME:Number = 0;
		var haberME:Number = 0;
		var tasaconvDebe:Number = 1;
		var tasaconvHaber:Number = 1;
		var diferenciaCambio:Number = 0;
		var recibo:Array = flfactppal.iface.pub_ejecutarQry("recibosprov", "coddivisa,importe,importeeuros,idfactura,codigo,nombreproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (recibo.result != 1)
			return false;
		
		if (valoresDefecto.coddivisa == recibo.coddivisa) {
			debe = recibo.importe;
			debeME = 0;
			haber = debe;
			haberMe = 0;
		} else {
			tasaconvHaber = curPD.valueBuffer("tasaconv");
			tasaconvDebe = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");
			debe = parseFloat(recibo.importeeuros);
			debeME = parseFloat(recibo.importe);
			haber = parseFloat(recibo.importe) * parseFloat(tasaconvHaber);
			haberME = parseFloat(recibo.importe);
			diferenciaCambio = debe - haber;
			if (util.buildNumber(diferenciaCambio, "f", 2) == "0.00" || util.buildNumber(diferenciaCambio, "f", 2) == "-0.00") {
				diferenciaCambio = 0;
				debe = haber;
			}
		}

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with(curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo prov. " + recibo.codigo + " - " + recibo.nombreproveedor);
			setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
			setValueBuffer("idasiento", datosAsiento.idasiento);
			setValueBuffer("debe", debe);
			setValueBuffer("haber", 0);
			setValueBuffer("coddivisa", recibo.coddivisa);
			setValueBuffer("tasaconv", tasaconvDebe);
			setValueBuffer("debeME", debeME);
			setValueBuffer("haberME", 0);
		}
		if (!curPartida.commitBuffer())
			return false;

		with(curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo prov. " + recibo.codigo + " - " + recibo.nombreproveedor);
			setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
			setValueBuffer("idasiento", datosAsiento.idasiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("coddivisa", recibo.coddivisa);
			setValueBuffer("tasaconv", tasaconvHaber);
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
		}
		if (!curPartida.commitBuffer())
			return false;

		/** \C En el caso de que la divisa sea extranjera y la tasa de cambio haya variado desde el momento de la emisión de la factura, la diferencia se imputará a la correspondiente cuenta de diferencias de cambio.
			\end */
		if (diferenciaCambio != 0) {
			var ctaDifCambio:Array = [];
			var debeDifCambio:Number = 0;
			var haberDifCambio:Number = 0;
			if (diferenciaCambio > 0) {
				ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMPOS", valoresDefecto.codejercicio);
				if (ctaDifCambio.error != 0)
					return false;
				debeDifCambio = 0;
				haberDifCambio = diferenciaCambio;
			} else {
				ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMNEG", valoresDefecto.codejercicio);
				if (ctaDifCambio.error != 0)
					return false;
				diferenciaCambio = 0 - diferenciaCambio;
				debeDifCambio = diferenciaCambio;
				haberDifCambio = 0;
			}

			with(curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("concepto", curPD.valueBuffer("tipo") + " reciboprov " + recibo.codigo + " - " + recibo.nombreproveedor);
				setValueBuffer("idsubcuenta", ctaDifCambio.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaDifCambio.codsubcuenta);
				setValueBuffer("idasiento", datosAsiento.idasiento);
				setValueBuffer("debe", debeDifCambio);
				setValueBuffer("haber", haberDifCambio);
				setValueBuffer("coddivisa", valoresDefecto.coddivisa);
				setValueBuffer("tasaconv", 1);
				setValueBuffer("debeME", 0);
				setValueBuffer("haberME", 0);
			}
			if (!curPartida.commitBuffer())
				return false;
		}
	} else {
		/** \D En el caso de dar una devolución, las subcuentas del asiento contable serán las inversas al asiento contable correspondiente al último pago
		\end */
		var idAsientoPago:Number = util.sqlSelect("pagosdevolprov", "idasiento", "idrecibo = " + curPD.valueBuffer("idrecibo") + " AND  tipo = 'Pago' ORDER BY fecha DESC");
		var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (flfactteso.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, curPD.valueBuffer("tipo") + " recibo " + codRecibo, valoresDefecto.codejercicio) == false)
			return false;
	}

	return true;
}


//// RASIENTOS ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
