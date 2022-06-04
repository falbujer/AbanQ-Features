
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
	qryStocks.setTablesList("facturasprov,lineasfacturasprov");
	qryStocks.setSelect("lf.referencia, lf.barcode, SUM(lf.cantidad)");
	qryStocks.setFrom("facturasprov f INNER JOIN lineasfacturasprov lf ON f.idfactura = lf.idfactura");
	qryStocks.setWhere("f.idfactura = " + cursor.valueBuffer("idfactura") + " AND lf.referencia IS NOT NULL GROUP BY f.codalmacen, lf.referencia, lf.barcode");
	qryStocks.setForwardOnly(true);
	if (!qryStocks.exec()) {
		return false;
	}
	var i:Number = 0;
	var barcode:String;
	while (qryStocks.next()) {
		barcode = qryStocks.value("lf.barcode");
		arrayStocks[i] = [];
		arrayStocks[i]["articulo"] = [];
		arrayStocks[i]["articulo"]["referencia"] = qryStocks.value("lf.referencia");
		arrayStocks[i]["articulo"]["barcode"] = (barcode && barcode != "" ? barcode : false);
		arrayStocks[i]["codalmacen"] = cursor.valueBuffer("codalmacen");
		arrayStocks[i]["cantidad"] = qryStocks.value("SUM(lf.cantidad)");
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
// 		if (!flfactalma.iface.pub_actualizarStockFisico(arrayAfectados[i]["articulo"], arrayAfectados[i]["codalmacen"], "cantidadfp")) {
// 			return false;
// 		}
// 	}
// 
// 	return true;
// }
//// SCAB TALLAS Y COLORES //////////////////////////////////////
/////////////////////////////////////////////////////////////////
