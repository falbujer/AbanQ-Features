
/** @class_declaration distEjer */
/////////////////////////////////////////////////////////////////
//// DISTIBUCI�N EJERCICIOS /////////////////////////////////////
class distEjer extends oficial {
	function distEjer( context ) { oficial ( context ); }
	function bufferChanged(fN) {
		return this.ctx.distEjer_bufferChanged(fN);
	}
}
//// DISTIBUCI�N EJERCICIOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCI�N EJERCICIOS ////////////////////////////////////
function distEjer_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
		case "cantidad": {
			sys.setObjText(this, "fdbCanFactura", _i.calculateField("canfactura"));
      _i.__bufferChanged(fN);
      break;
    }
		default: {
			_i.__bufferChanged(fN);
		}
	}
}

//// DISTRIBUCI�N EJERCICIOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
