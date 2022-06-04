
/** @class_declaration tesoMan */
/////////////////////////////////////////////////////////////////
//// TESORERIA MANUAL ///////////////////////////////////////////
class tesoMan extends oficial {
    function tesoMan( context ) { oficial ( context ); }
	function incluirRecibos(curCriterios:FLSqlCursor, tipo:String):Boolean {
		return this.ctx.tesoMan_incluirRecibos(curCriterios, tipo);
	}
	function incluirRecibosManual(curCriterios:FLSqlCursor, tipo:String):Boolean {
		return this.ctx.tesoMan_incluirRecibosManual(curCriterios, tipo);
	}
}
//// TESORERIA MANUAL ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tesoMan */
/////////////////////////////////////////////////////////////////
//// TESORERIA MANUAL ///////////////////////////////////////////
/** \D 
Busca e incluye en la tabla temporal aquellos recibos de cliente o proveedor que cumplen los criterios de búsqueda impuestos
@param	curCriterios: Cursor con el resto de criterios de búsqueda
@param	tipo: Indicador de si se debe buscar recibos de cliente (valor CLI) o proveedor (valor PROV)
@return	true si la búsqueda se realizó correctamente, false en caso contrario
*/
function tesoMan_incluirRecibos(curCriterios:FLSqlCursor, tipo:String):Boolean
{
	if (!this.iface.__incluirRecibos(curCriterios, tipo)) {
		return false;
	}

	if (!this.iface.incluirRecibosManual(curCriterios, tipo)) {
		return false;
	}

	return true;
}

function tesoMan_incluirRecibosManual(curCriterios:FLSqlCursor, tipo:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var codCuentaCri:String = curCriterios.valueBuffer("codcuenta");
	var codEjercicio:String = curCriterios.valueBuffer("codejercicio");
	
	var intervalo:Array = [];
	
	if (curCriterios.valueBuffer("codintervalo")) {
		intervalo = flfactppal.iface.pub_calcularIntervalo(curCriterios.valueBuffer("codintervalo"));
		curCriterios.setValueBuffer("fechavtodesde", intervalo.desde);
		curCriterios.setValueBuffer("fechavtohasta", intervalo.hasta);
	}
	
	var fechas:String = "";
	if (!curCriterios.isNull("fechavtodesde") != "") {
		fechas += " AND r.fechav >= '" + curCriterios.valueBuffer("fechavtodesde") + "'";
	if (!curCriterios.isNull("fechavtohasta") != "" )
		fechas += " AND r.fechav <= '" + curCriterios.valueBuffer("fechavtohasta") + "'";
	}
	
	var where:String = "1 = 1 " + fechas;
	if (codEjercicio && codEjercicio != "")
		where += " AND r.codejercicio = '" + codEjercicio + "'";
	where += " AND r.codejercicio LIKE '2%'";
debug(where);	
	if (tipo == "CLI")
		where += " AND estado <> 'Pagado' AND tipo = 'Ingreso'";
	else {
		var hoy:Date = new Date;
		where += " AND r.fechav >= '" + hoy.toString() + "' AND tipo = 'Pago'";
	}

	var qryRecibosCli:FLSqlQuery = new FLSqlQuery();
	qryRecibosCli.setTablesList("tesomanual");
	qryRecibosCli.setSelect("r.fechav, r.fecha, r.codigo, r.importe, r.codcuentapago, r.concepto");
	qryRecibosCli.setFrom("tesomanual r");
	
	qryRecibosCli.setWhere(where);
	if (!qryRecibosCli.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var curVtoTemp:FLSqlCursor = new FLSqlCursor("i_vencimientos_buffer");
	var importe:Number, cobro:Number, pago:Number;
	var codCuenta:String, desCuenta:String, concepto:String;
	var codSubcuenta:String = "";
	debug(qryRecibosCli.sql());
	while (qryRecibosCli.next()) {
		importe = parseFloat(qryRecibosCli.value("r.importe"));
		codCuenta = qryRecibosCli.value("r.codcuentapago");
		concepto = qryRecibosCli.value("r.concepto");

		if (codCuentaCri && codCuentaCri != "" && codCuentaCri != codCuenta)
			continue;

		if (codCuenta && codCuenta != "") {
			var qryCuentas:FLSqlQuery = new FLSqlQuery();
			qryCuentas.setTablesList("cuentasbanco");
			qryCuentas.setSelect("descripcion, codsubcuenta");
			qryCuentas.setFrom("cuentasbanco");
			qryCuentas.setWhere("codcuenta = '" + codCuenta + "'");
			qryCuentas.exec();
			qryCuentas.first();
			desCuenta = qryCuentas.value(0);
			codSubcuenta = qryCuentas.value(1);
		} else {
			desCuenta = util.translate("scripts", "Caja");
			if (this.iface.contActiva) 
				codSubcuenta = this.iface.codSubcuentaCaja;
			else
				codSubcuenta = "";
		}
		
		if (tipo == "CLI") {
			cobro = importe;
			pago = 0;
		} else {
			cobro = 0;
			pago = importe;
		}
		
		curVtoTemp.setModeAccess(curVtoTemp.Insert);
		curVtoTemp.refreshBuffer();
		curVtoTemp.setValueBuffer("idimpresion", this.iface.idImpresion);
		curVtoTemp.setValueBuffer("fechavto", qryRecibosCli.value("r.fechav"));
		curVtoTemp.setValueBuffer("fechaemision", qryRecibosCli.value("r.fecha"));
		curVtoTemp.setValueBuffer("codsujeto", "");
		curVtoTemp.setValueBuffer("codrecibo", qryRecibosCli.value("r.codigo"));
		curVtoTemp.setValueBuffer("codcuenta", codCuenta);
		curVtoTemp.setValueBuffer("descuenta", desCuenta);
		curVtoTemp.setValueBuffer("codsubcuenta", codSubcuenta);
		curVtoTemp.setValueBuffer("concepto",  concepto);
		curVtoTemp.setValueBuffer("nombresujeto", "");
		curVtoTemp.setValueBuffer("cobros", cobro);
		curVtoTemp.setValueBuffer("pagos", pago);

		curVtoTemp.setValueBuffer("saldo", this.iface.saldo);
		
		if (!curVtoTemp.commitBuffer()) {
			MessageBox.critical(util.translate("scripts", "Falló la creación de tabla temporal"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}
//// TESORERIA MANUAL ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
