
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC�N POR L�NEA //////////////////////////////////////////
class lineasAlma extends scab {
    function lineasAlma( context ) { scab ( context ); }
	function cargarArrayStocks():Boolean {
		return this.ctx.lineasAlma_cargarArrayStocks();
	}
}
//// ALMAC�N POR L�NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC�N POR L�NEA //////////////////////////////////////////
function lineasAlma_cargarArrayStocks():Array
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var arrayStocks:Array = [];

	var qryStocks:FLSqlQuery = new FLSqlQuery;
	qryStocks.setTablesList("lineasalbaranescli");
	qryStocks.setSelect("codalmacen, referencia, SUM(cantidad)");
	qryStocks.setFrom("lineasalbaranescli");
	qryStocks.setWhere("idalbaran = " + cursor.valueBuffer("idalbaran") + " GROUP BY codalmacen, referencia");
	qryStocks.setForwardOnly(true);
	if (!qryStocks.exec()) {
		return false;
	}
	var i:Number = 0;
	while (qryStocks.next()) {
		arrayStocks[i] = [];
		arrayStocks[i]["articulo"] = [];
		arrayStocks[i]["articulo"]["referencia"] =  qryStocks.value("referencia");
		arrayStocks[i]["codalmacen"] = qryStocks.value("codalmacen");
		arrayStocks[i]["cantidad"] = qryStocks.value("SUM(cantidad)");
		i++;
	}
	return arrayStocks;
}

//// ALMAC�N POR L�NEA //////////////////////////////////////////
////////////////////////////////////////////////////////////////
