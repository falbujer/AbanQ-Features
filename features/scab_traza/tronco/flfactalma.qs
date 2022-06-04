
/** @class_declaration scabTraza */
/////////////////////////////////////////////////////////////////
//// SCAB_TRAZA //////////////////////////////////////////////////////
class scabTraza extends scab {
	function scabTraza( context ) { scab ( context ); }
	function controlCantidadLote(curMoviLote:FLSqlCursor):Boolean {
		return this.ctx.scabTraza_controlCantidadLote(curMoviLote);
	}
	function controlStockLote(curMoviLote:FLSqlCursor):Boolean {
		return this.ctx.scabTraza_controlStockLote(curMoviLote);
	}
	function arrayLotesAfectados(arrayInicial:Array, arrayFinal:Array):Array {
		return this.ctx.scabTraza_arrayLotesAfectados(arrayInicial, arrayFinal);
	}
	function compararArrayLote(a:Array, b:Array):Number {
		return this.ctx.scabTraza_compararArrayLote(a, b);
	}
}
//// SCAB_TRAZA //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubScabTraza */
/////////////////////////////////////////////////////////////////
//// PUB SCAB TRAZA /////////////////////////////////////////////
class pubScabTraza extends pubScab {
	function pubScabTraza ( context ) { pubScab ( context ); }
	function pub_arrayLotesAfectados(arrayInicial:Array, arrayFinal:Array):Array {
		return this.arrayLotesAfectados(arrayInicial, arrayFinal);
	}
	function pub_actualizarStockFisico(referencia:String, codAlmacen:String, campo:String):Boolean {
		return this.actualizarStockFisico(referencia, codAlmacen, campo);
	}
}
//// PUB SCAB TRAZA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scabTraza */
/////////////////////////////////////////////////////////////////
//// SCAB_TRAZA /////////////////////////////////////////////////
function scabTraza_controlCantidadLote(curMoviLote:FLSqlCursor):Boolean
{
	var curRelation:FLSqlCursor = curMoviLote.cursorRelation();
	if (!curRelation) {
		return this.iface.__controlCantidadLote(curMoviLote);
	}
	var tablaRel:String = curRelation.table();
	switch (tablaRel) {
		case "lineasalbaranescli":
		case "lineasalbaranesprov":
		case "lineasfacturascli":
		case "lineasfacturasprov": {
			return true;
		}
		default: {
			return this.iface.__controlCantidadLote(curMoviLote);
		}
	}
	
	return true;
}

function scabTraza_controlStockLote(curMoviLote:FLSqlCursor):Boolean
{
	var curRelation:FLSqlCursor = curMoviLote.cursorRelation();
	if (!curRelation) {
		return this.iface.__controlStockLote(curMoviLote);
	}
	var tablaRel:String = curRelation.table();
	switch (tablaRel) {
		case "lineasalbaranescli":
		case "lineasalbaranesprov":
		case "lineasfacturascli":
		case "lineasfacturasprov": {
			return true;
		}
		default: {
			return this.iface.__controlStockLote(curMoviLote);
		}
	}
	return true;
}

function scabTraza_arrayLotesAfectados(arrayInicial:Array, arrayFinal:Array):Array
{
	var arrayAfectados:Array = [];
	var iAA:Number = 0;
	var iAI:Number = 0;
	var iAF:Number = 0;
	var longAI:Number = arrayInicial.length;
	var longAF:Number = arrayFinal.length;

/*debug("ARRAY INICIAL");
for (var i:Number = 0; i < arrayInicial.length; i++) {
	debug(" " + arrayInicial[i]["codlote"]);
}
debug("ARRAY FINAL");
for (var i:Number = 0; i < arrayFinal.length; i++) {
	debug(" " + arrayFinal[i]["codlote"]);
}
*/
	arrayInicial.sort(this.iface.compararArrayLote);
	arrayFinal.sort(this.iface.compararArrayLote);
	
/*debug("ARRAY INICIAL ORDENADO");
for (var i:Number = 0; i < arrayInicial.length; i++) {
	debug(" " + arrayInicial[i]["codlote"]);
}
debug("ARRAY FINAL ORDENADO");
for (var i:Number = 0; i < arrayFinal.length; i++) {
	debug(" " + arrayFinal[i]["codlote"]);
}*/
	var comparacion:Number;
	while (iAI < longAI || iAF < longAF) {
		if (iAI < longAI && iAF < longAF) {
			comparacion = this.iface.compararArrayLote(arrayInicial[iAI], arrayFinal[iAF]);
		} else if (iAF < longAF) {
			comparacion = 1;
		} else if (iAI < longAI) {
			comparacion = -1;
		}
		switch (comparacion) {
			case 1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["codlote"] = arrayFinal[iAF]["codlote"];
				iAF++;
				iAA++;
				break;
			}
			case -1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["codlote"] = arrayInicial[iAI]["codlote"];
				iAI++;
				iAA++;
				break;
			}
			case 0: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["codlote"] = arrayFinal[iAF]["codlote"];
				iAI++;
				iAF++;
				iAA++;
				break;
			}
		}
	}
	return arrayAfectados;
}

function scabTraza_compararArrayLote(a:Array, b:Array):Number
{
	var resultado:Number = 0;
	if (a["codlote"] > b["codlote"]) {
		resultado = 1;
	} else if (a["codlote"] < b["codlote"]) {
		resultado = -1;
	}
	return resultado;
}

//// SCAB_TRAZA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
