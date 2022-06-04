
/** @class_declaration distEjer */
/////////////////////////////////////////////////////////////////
//// DISTIBUCI�N EJERCICIOS /////////////////////////////////////
class distEjer extends oficial {
	function distEjer( context ) { oficial ( context ); }
	function commonCalculateField(fN, cursor) {
		return this.ctx.distEjer_commonCalculateField(fN, cursor);
	}
}
//// DISTIBUCI�N EJERCICIOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCI�N EJERCICIOS ////////////////////////////////////

function distEjer_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
	var valor;
	switch (fN) {
		case "canfactura": {
			valor = cursor.valueBuffer("cantidad") - cursor.valueBuffer("candistribuida");
      break;
    }
		case "pvpsindto": {
			if(cursor.table() == "lineasalbaranescli"){
				valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("canfactura"));
				valor = AQUtil.roundFieldValue(valor, "lineaspedidoscli", "pvpsindto");
			}
			else{
				valor = _i.__commonCalculateField(fN, cursor);
			}
      break;
    }
		default: {
			valor = _i.__commonCalculateField(fN, cursor);
		}
	}
	return valor;
}
//// DISTRIBUCI�N EJERCICIOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
