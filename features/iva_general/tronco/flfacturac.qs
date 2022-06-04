
/** @class_declaration ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
class ivaGeneral extends oficial {
	function ivaGeneral( context ) { oficial ( context ); }
	function generarPartidasIVAProv(curFactura:FLSqlCursor,idAsiento:Number,valoresDefecto:Array,ctaProveedor:Array, concepto:String):Boolean {
		return this.ctx.ivaGeneral_generarPartidasIVAProv(curFactura, idAsiento, valoresDefecto, ctaProveedor, concepto);
	}
	function generarPartidasIVACli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaCliente:Array):Boolean {
		return this.ctx.ivaGeneral_generarPartidasIVACli(curFactura, idAsiento, valoresDefecto, ctaCliente);
	}
}
//// IVA_GENERAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de IVA y de recargo de equivalencia, si la factura lo tiene
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	ctaCliente: Array con los datos de la contrapartida
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function ivaGeneral_generarPartidasIVACli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaCliente:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var totalIva:Number = parseFloat(curFactura.valueBuffer("totaliva"));
	var totalRecargo:Number = parseFloat(curFactura.valueBuffer("totalrecargo"));
	var codImpuesto:String = curFactura.valueBuffer("codImpuesto");
	if (totalIva == 0)
		return true;
	
	var haber:Number = 0;
	var haberME:Number = 0;
	var ctaIvaRep:Array = this.iface.datosCtaIVA("IVAREP", valoresDefecto.codejercicio, codImpuesto);
	if (ctaIvaRep.error != 0)
		return false;

	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	if (monedaSistema) {
		haber = totalIva;
		haberME = 0;
	} else {
		haber = parseFloat(totalIva * parseFloat(curFactura.valueBuffer("tasaconv")));
		haberME = totalIva;
	}

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
		setValueBuffer("idsubcuenta", ctaIvaRep.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaIvaRep.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);		
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
		setValueBuffer("baseimponible", curFactura.valueBuffer("neto"));
		setValueBuffer("iva", util.sqlSelect("impuestos","iva","codimpuesto = '" + codImpuesto + "'"));
		setValueBuffer("recargo", util.sqlSelect("impuestos","recargo","codimpuesto = '" + codImpuesto + "'"));
		setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
		setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
		setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
		setValueBuffer("tipodocumento", "Factura de cliente");
		setValueBuffer("documento", curFactura.valueBuffer("codigo"));
		setValueBuffer("factura", curFactura.valueBuffer("numero"));
		setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
	}
	if (!curPartida.commitBuffer())
		return false;

	if (monedaSistema) {
		haber = totalRecargo;
		haberME = 0;
	} else {
		haber = parseFloat(totalRecargo) * parseFloat(curFactura.valueBuffer("tasaconv"));
		haberME = totalRecargo;
	}
	if (parseFloat(haber) != 0) {
		var ctaRecargo = this.iface.datosCtaIVA("IVAACR", valoresDefecto.codejercicio, codImpuesto);
		if (ctaRecargo.error != 0)
			return false;
		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
			setValueBuffer("idsubcuenta", ctaRecargo.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaRecargo.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
		}
		if (!curPartida.commitBuffer())
			return false;
		}

	return true;
}

/** \D Genera la parte del asiento de factura de proveedor correspondiente a la subcuenta de IVA y de recargo de equivalencia, si la factura lo tiene
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	ctaProveedor: Array con los datos de la contrapartida
@param	concepto: Concepto de la partida
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function ivaGeneral_generarPartidasIVAProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaProveedor:Array, concepto:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var totalIva:Number = parseFloat(curFactura.valueBuffer("totaliva"));
	var totalRecargo:Number = parseFloat(curFactura.valueBuffer("totalrecargo"));
	var codImpuesto:String = curFactura.valueBuffer("codImpuesto");
	if (totalIva == 0)
		return true;

	var debe:Number = 0;
	var debeME:Number = 0;
	var ctaIvaSop:Array = this.iface.datosCtaIVA("IVASOP", valoresDefecto.codejercicio, codImpuesto);
	if (ctaIvaSop.error != 0)
		return false;

	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	if (monedaSistema) {
		debe = totalIva;
		debeME = 0;
	} else {
		debe = parseFloat(totalIva) * parseFloat(curFactura.valueBuffer("tasaconv"));
		debeME = totalIva;
	}

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", concepto);
		setValueBuffer("idsubcuenta", ctaIvaSop.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaIvaSop.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("baseimponible", curFactura.valueBuffer("neto"));
		setValueBuffer("iva", util.sqlSelect("impuestos","iva","codimpuesto = '" + codImpuesto + "'"));
		setValueBuffer("recargo", util.sqlSelect("impuestos","recargo","codimpuesto = '" + codImpuesto + "'"));
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
		setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
		setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
		setValueBuffer("tipodocumento", "Factura de proveedor");
		setValueBuffer("documento", curFactura.valueBuffer("codigo"));
		setValueBuffer("factura", curFactura.valueBuffer("numero"));
		setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
	}
	if (!curPartida.commitBuffer())
		return false;
	
	if (monedaSistema) {
		debe = totalRecargo;
		debeME = 0;
	} else {
		debe = parseFloat(totalRecargo) * parseFloat(curFactura.valueBuffer("tasaconv"));
		debeME = totalRecargo;
	}
	
	if (parseFloat(debe) != 0) {
		var ctaRecargo:Array = this.iface.datosCtaIVA("IVADEU", valoresDefecto.codejercicio, codImpuesto);
		if (ctaRecargo.error != 0)
			return false;
		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", concepto);
			setValueBuffer("idsubcuenta", ctaRecargo.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaRecargo.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", debe);
			setValueBuffer("haber", 0);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("debeME", debeME);
			setValueBuffer("haberME", 0);
		}
		if (!curPartida.commitBuffer())
			return false;
	}
	return true;
}
//// IVA_GENERAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
