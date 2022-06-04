
/** @class_declaration scabTC */
/////////////////////////////////////////////////////////////////
//// SCAB TALLAS Y COLORES //////////////////////////////////////
class scabTC extends scab {
	function scabTC( context ) { scab ( context ); }
	function actualizarStockReservado(aArticulo:Array, codAlmacen:String, idPedido:String):Boolean {
		return this.ctx.scabTC_actualizarStockReservado(aArticulo, codAlmacen, idPedido);
	}
	function actualizarStockPteRecibir(aArticulo:Array, codAlmacen:String, idPedido:String):Boolean {
		return this.ctx.scabTC_actualizarStockPteRecibir(aArticulo, codAlmacen, idPedido);
	}
	function actualizarStockFisico(aArticulo:Array, codAlmacen:String, campo:String):Boolean {
		return this.ctx.scabTC_actualizarStockFisico(aArticulo, codAlmacen, campo);
	}
	function dameIdStock(aArticulo:Array, codAlmacen:String):String {
		return this.ctx.scabTC_dameIdStock(aArticulo, codAlmacen);
	}
	function arraySocksAfectados(arrayInicial:Array, arrayFinal:Array):Array {
		return this.ctx.scabTC_arraySocksAfectados(arrayInicial, arrayFinal);
	}
	function compararArrayStock(a:Array, b:Array):Number {
		return this.ctx.scabTC_compararArrayStock(a, b);
	}
	function controlStockFisico(curLinea:FLSqlCursor, codAlmacen:String, campo:String):Boolean {
		return this.ctx.scabTC_controlStockFisico(curLinea, codAlmacen, campo);
	}
}
//// SCAB TALLAS Y COLORES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubScabTC */
/////////////////////////////////////////////////////////////////
//// PUB SCAB ///////////////////////////////////////////////////
class pubScabTC extends pubScab {
	function pubScabTC ( context ) { pubScab( context ); }
}
//// PUB SCAB ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scabTC */
/////////////////////////////////////////////////////////////////
//// SCAB TALLAS Y COLORES //////////////////////////////////////
function scabTC_dameIdStock(aArticulo:Array, codAlmacen:String):String
{
	var util:FLUtil = new FLUtil;
	var idStock:String = false;
	var referencia:String = ""
	
	if("referencia" in aArticulo)
		referencia = aArticulo["referencia"];
	else
		return false;
	
	var barcode:String = "";
	if("barcode" in aArticulo)
		barcode = aArticulo["barcode"];
	
	
	if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia + "'")) {
		return true;
	}
	
	if (barcode && barcode != "") {
		idStock = util.sqlSelect("stocks", "idstock", "barcode = '" + barcode + "' AND codalmacen = '" + codAlmacen + "'");
	} else {
		idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
	}
	if ( !idStock ) {
		idStock = this.iface.crearStock( codAlmacen, aArticulo );
	}
	return idStock;
}


function scabTC_actualizarStockReservado(aArticulo:Array, codAlmacen:String, idPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idStock:String = this.iface.dameIdStock(aArticulo, codAlmacen);
	if (!idStock) {
		return false;
	}

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	
	var oS = formRecordregstocks.iface.pub_dameParamStock();
	oS.idPedido = idPedido
	var stockFisico:Number;
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("reservada", formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock, oS));
	curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	if (!curStock.commitBuffer()) {
		return false;
	}
	
	return true;
}

function scabTC_actualizarStockPteRecibir(aArticulo:Array, codAlmacen:String, idPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idStock:String = this.iface.dameIdStock(aArticulo, codAlmacen);
	if (!idStock) {
		return false;
	}

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	var oS = formRecordregstocks.iface.pub_dameParamStock();
	oS.idPedido = idPedido
	var stockFisico:Number;
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("pterecibir", formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock, oS));
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}

function scabTC_actualizarStockFisico(aArticulo:Array, codAlmacen:String, campo:String):Boolean
{
// debug("scabTC_actualizarStockFisico " + aArticulo["referencia"] + " " + aArticulo["barcode"] + " " + codAlmacen + " " + campo);
	var util:FLUtil = new FLUtil;
	
	var idStock:String = this.iface.dameIdStock(aArticulo, codAlmacen);
	if (!idStock) {
		return false;
	}
	var referencia:String = ""
	if("referencia" in aArticulo)
		referencia = aArticulo["referencia"];
	else
		return false;
	
	var barcode:String = "";
	if("barcode" in aArticulo)
		barcode = aArticulo["barcode"];

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	var stockFisico:Number;
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer(campo, formRecordregstocks.iface.pub_commonCalculateField(campo, curStock));
	
	stockFisico = formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock);
	if (stockFisico < 0) {
		if (!util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'")) {
			MessageBox.warning( util.translate("scripts", "El artículo %1 no permite ventas sin stock. Este movimiento dejaría el stock de %2 - %3 con un valor de %4.\n").arg(referencia).arg(barcode).arg(codAlmacen).arg(stockFisico), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	curStock.setValueBuffer("cantidad", stockFisico);
	curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}


function scabTC_arraySocksAfectados(arrayInicial:Array, arrayFinal:Array):Array
{
	var arrayAfectados:Array = [];
	var iAA:Number = 0;
	var iAI:Number = 0;
	var iAF:Number = 0;
	var longAI:Number = arrayInicial.length;
	var longAF:Number = arrayFinal.length;

debug("ARRAY INICIAL");
for (var i:Number = 0; i < arrayInicial.length; i++) {
	debug(" " + arrayInicial[i]["articulo"]["referencia"] + "-" + arrayInicial[i]["articulo"]["barcode"] + "-" + arrayInicial[i]["codalmacen"]);
}
debug("ARRAY FINAL");
for (var i:Number = 0; i < arrayFinal.length; i++) {
	debug(" " + arrayFinal[i]["articulo"]["referencia"] + "-" + arrayFinal[i]["articulo"]["barcode"] + "-" + arrayFinal[i]["codalmacen"]);
}

	arrayInicial.sort(this.iface.compararArrayStock);
	arrayFinal.sort(this.iface.compararArrayStock);
	
debug("ARRAY INICIAL ORDENADO");
for (var i:Number = 0; i < arrayInicial.length; i++) {
	debug(" " + arrayInicial[i]["articulo"]["referencia"] + "-" + arrayInicial[i]["articulo"]["barcode"] + "-" + arrayInicial[i]["codalmacen"]);
}
debug("ARRAY FINAL ORDENADO");
for (var i:Number = 0; i < arrayFinal.length; i++) {
	debug(" " + arrayFinal[i]["articulo"]["referencia"] + "-" + arrayFinal[i]["articulo"]["barcode"] + "-" + arrayFinal[i]["codalmacen"]);
}

	var comparacion:Number;
	while (iAI < longAI || iAF < longAF) {
		if (iAI < longAI && iAF < longAF) {
			comparacion = this.iface.compararArrayStock(arrayInicial[iAI], arrayFinal[iAF]);
		} else if (iAF < longAF) {
			comparacion = 1;
		} else if (iAI < longAI) {
			comparacion = -1;
		}
		switch (comparacion) {
			case 1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["articulo"] = [];
				arrayAfectados[iAA]["articulo"]["referencia"] = arrayFinal[iAF]["articulo"]["referencia"];
				arrayAfectados[iAA]["articulo"]["barcode"] = arrayFinal[iAF]["articulo"]["barcode"];
				arrayAfectados[iAA]["codalmacen"] = arrayFinal[iAF]["codalmacen"];
				iAF++;
				iAA++;
				break;
			}
			case -1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["articulo"] = [];
				arrayAfectados[iAA]["articulo"]["referencia"] = arrayInicial[iAI]["articulo"]["referencia"];
				arrayAfectados[iAA]["articulo"]["barcode"] = arrayInicial[iAI]["articulo"]["barcode"];
				arrayAfectados[iAA]["codalmacen"] = arrayInicial[iAI]["codalmacen"];
				iAI++;
				iAA++;
				break;
			}
			case 0: {
				if (arrayInicial[iAI]["cantidad"] != arrayFinal[iAF]["cantidad"]) {
					arrayAfectados[iAA] = [];
					arrayAfectados[iAA]["articulo"] = [];
					arrayAfectados[iAA]["articulo"]["referencia"] = arrayFinal[iAI]["articulo"]["referencia"];
					arrayAfectados[iAA]["articulo"]["barcode"] = arrayFinal[iAI]["articulo"]["barcode"];
					arrayAfectados[iAA]["codalmacen"] = arrayFinal[iAI]["codalmacen"];
					iAA++;
				}
				iAI++;
				iAF++;
				break;
			}
		}
	}
	return arrayAfectados;
}

function scabTC_compararArrayStock(a:Array, b:Array):Number
{
	var resultado:Number = 0;
	if (a["codalmacen"] > b["codalmacen"]) {
		resultado = 1;
	} else if (a["codalmacen"] < b["codalmacen"]) {
		resultado = -1;
	} else if (a["codalmacen"] == b["codalmacen"]) {
		if (a["articulo"]["referencia"] > b["articulo"]["referencia"]) {
			resultado = 1;
		} else if (a["articulo"]["referencia"] < b["articulo"]["referencia"]) {
			resultado = -1;
		} else if (a["articulo"]["referencia"] == b["articulo"]["referencia"]) {
			if (a["articulo"]["barcode"] > b["articulo"]["barcode"])  {
				resultado = 1;
			} else if (a["articulo"]["barcode"] < b["articulo"]["barcode"])  {
				resultado = -1;
			}
		}
	}
	return resultado;
}

function scabTC_controlStockFisico(curLinea:FLSqlCursor, codAlmacen:String, campo:String):Boolean
{
debug("scabTC_controlStockFisico");
	var util:FLUtil = new FLUtil;
	
	var referencia:String = curLinea.valueBuffer("referencia");
	if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'")) {
		return true;
	}
	var aArticulo:Array = [];
	aArticulo["referencia"] = referencia;
	aArticulo["barcode"] = curLinea.valueBuffer("barcode");
	if ((aArticulo["referencia"] && aArticulo["referencia"] != "") || (aArticulo["barcode"] && aArticulo["barcode"] != "")) {
		if (!this.iface.actualizarStockFisico(aArticulo, codAlmacen, campo)) {
			return false;
		}
	}
	
	var aArticuloPrevio:Array = [];
	aArticuloPrevio["referencia"] = curLinea.valueBufferCopy("referencia");
	aArticuloPrevio["barcode"] = curLinea.valueBufferCopy("barcode");
	if ((aArticuloPrevio["referencia"] && aArticuloPrevio["referencia"] != "" && aArticuloPrevio["referencia"] != aArticulo["referencia"]) || (aArticuloPrevio["barcode"] && aArticuloPrevio["barcode"] != "" && aArticuloPrevio["barcode"] != aArticulo["barcode"])) {
		if (!this.iface.actualizarStockFisico(aArticuloPrevio, codAlmacen, campo)) {
			return false;
		}
	}
 
	return true;
}
//// SCAB TALLAS Y COLORES //////////////////////////////////////
/////////////////////////////////////////////////////////////////
