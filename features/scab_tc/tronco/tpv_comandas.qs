
/** @class_declaration scabTC */
/////////////////////////////////////////////////////////////////
//// SCAB TALLAS Y COLORES //////////////////////////////////////
class scabTC extends scab {
    function scabTC( context ) { scab ( context ); }
    function cargarArrayStocks():Array {
		return this.ctx.scabTC_cargarArrayStocks();
	}
// 	function controlStockCabecera():Boolean {
// 		return this.ctx.scabTC_controlStockCabecera();
// 	}
}
//// SCAB TALLAS Y COLORES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scabTC */
/////////////////////////////////////////////////////////////////
//// SCAB TALLAS Y COLORES //////////////////////////////////////
function scabTC_cargarArrayStocks():Array
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var arrayStocks:Array = [];

	var qryStocks:FLSqlQuery = new FLSqlQuery;
	qryStocks.setTablesList("tpv_comandas,tpv_lineascomanda,tpv_puntosventa");
	qryStocks.setSelect("pv.codalmacen, ld.referencia, ld.barcode, SUM(ld.cantidad)");
	qryStocks.setFrom("tpv_comandas d INNER JOIN tpv_lineascomanda ld ON d.idtpv_comanda = ld.idtpv_comanda INNER JOIN tpv_puntosventa pv ON d.codtpv_puntoventa = pv.codtpv_puntoventa");
	qryStocks.setWhere("d.idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda") + " AND ld.referencia IS NOT NULL GROUP BY pv.codalmacen, ld.referencia, ld.barcode");
	qryStocks.setForwardOnly(true);
	if (!qryStocks.exec()) {
		return false;
	}
	var i:Number = 0;
	var barcode:String;
	while (qryStocks.next()) {
		barcode = qryStocks.value("ld.barcode");
		arrayStocks[i] = [];
		arrayStocks[i]["articulo"] = [];
		arrayStocks[i]["articulo"]["referencia"] = qryStocks.value("ld.referencia");
		arrayStocks[i]["articulo"]["barcode"] = (barcode && barcode != "" ? barcode : false);
		arrayStocks[i]["codalmacen"] = qryStocks.value("pv.codalmacen");
		arrayStocks[i]["cantidad"] = qryStocks.value("SUM(ld.cantidad)");
		i++;
	}
	
	return arrayStocks;
}

// function scabTC_controlStockCabecera():Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 	
// 	var arrayActual:Array = this.iface.cargarArrayStocks();
// 	if (!arrayActual) {
// 		MessageBox.warning(util.translate("scripts", "Error al cargar los datos de stock"), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 
// 	var arrayAfectados:Array = flfactalma.iface.pub_arraySocksAfectados(this.iface.arrayStocks_, arrayActual);
// 	if (!arrayAfectados) {
// 		return false;
// 	}
// 	for (var i:Number = 0; i < arrayAfectados.length; i++) {
// 		if (!flfactalma.iface.pub_actualizarStockFisico(arrayAfectados[i]["articulo"], arrayAfectados[i]["codalmacen"], "cantidadtpv")) {
// 			return false;
// 		}
// 	}
// 
// 	return true;
// }
//// SCAB TALLAS Y COLORES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

