
/** @class_declaration scabTC */
/////////////////////////////////////////////////////////////////
//// SCAB TALLAS Y COLORES //////////////////////////////////////
class scabTC extends scab {
	function scabTC( context ) { scab ( context ); }
	function dameWhereStock(cursor, campoAlmacen, campoFecha, fechaMax) {
		return this.ctx.scabTC_dameWhereStock(cursor, campoAlmacen, campoFecha, fechaMax);
	}
	function commonCalculateField(fN, cursor, oParam) {
		return this.ctx.scabTC_commonCalculateField(fN, cursor, oParam);
	}
}
//// SCAB TALLAS Y COLORES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scabTC */
/////////////////////////////////////////////////////////////////
//// SCAB TALLAS Y COLORES //////////////////////////////////////
function scabTC_dameWhereStock(cursor, campoAlmacen, campoFecha, fechaMax)
{
	if (!campoFecha) {
		campoFecha = "d.fecha";
	}
	var barcode = cursor.valueBuffer("barcode");
	var fUltReg;
	if (fechaMax) {
		fUltReg = AQUtil.sqlSelect("lineasregstocks", "fecha", "idstock = " + cursor.valueBuffer("idstock") + " AND fecha <= '" + fechaMax + "' ORDER BY fecha DESC, hora DESC");
	} else {
		fUltReg = cursor.isNull("fechaultreg") ? false : cursor.valueBuffer("fechaultreg");
	}
	var whereStock;
	if (barcode && barcode != "") {
		whereStock = campoAlmacen + " = '" + cursor.valueBuffer("codalmacen") + "' AND ld.barcode = '" + cursor.valueBuffer("barcode") + "'";
	} else {
		whereStock = campoAlmacen + " = '" + cursor.valueBuffer("codalmacen") + "' AND ld.referencia = '" + cursor.valueBuffer("referencia") + "'";
	}
	if (fUltReg) {
		whereStock += " AND ((" + campoFecha + " > '" + fUltReg + "') OR (" + campoFecha + " = '" + fUltReg + "' AND d.hora > '" + fUltReg.toString().right(8) + "'))";
	}
	if (fechaMax) {
		whereStock += " AND " + campoFecha + " < '" + fechaMax + "'"
	}
	return whereStock;
}

function scabTC_commonCalculateField(fN, cursor, oParam)
{
	var _i = this.iface;
	var util:FLUtil = new FLUtil;
	var valor:String;
	switch (fN) {
		case "reservada": {
			var idPedido = oParam ? oParam.idPedido : false;
			var codAlmacen = cursor.valueBuffer("codalmacen");
			var referencia = cursor.valueBuffer("referencia");
			var barcode:String = cursor.valueBuffer("barcode");
			var where:String;
			if (barcode && barcode != "") {
				where = "p.codalmacen = '" + codAlmacen + "' AND lp.barcode = '" + barcode + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)";
			} else {
				where = "p.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + referencia + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)";
			}
			if (idPedido && idPedido != "") {
				where += " AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ")";
			} else {
				where += " AND p.servido IN ('No', 'Parcial')";
			}
			valor = util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", where, "lineaspedidoscli,pedidoscli");
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "pterecibir": {
			var idPedido = oParam ? oParam.idPedido : false;
			var codAlmacen = cursor.valueBuffer("codalmacen");
			var referencia = cursor.valueBuffer("referencia");
			var codAlmacen:String = cursor.valueBuffer("codalmacen");
			var referencia:String = cursor.valueBuffer("referencia");
			var barcode:String = cursor.valueBuffer("barcode");
			var where:String;
			if (barcode && barcode != "") {
				where = "p.codalmacen = '" + codAlmacen + "' AND lp.barcode = '" + barcode + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)";
			} else {
				where = "p.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + referencia + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)";
			}
			if (idPedido && idPedido != "") {
				where += " AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ")";
			} else {
				where += " AND p.servido IN ('No', 'Parcial')";
			}
			valor = util.sqlSelect("lineaspedidosprov lp INNER JOIN pedidosprov p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", where, "lineaspedidosprov,pedidosprov");
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor, oParam);
		}
	}
	return valor;	
}
//// SCAB TALLAS Y COLORES //////////////////////////////////////
/////////////////////////////////////////////////////////////////
