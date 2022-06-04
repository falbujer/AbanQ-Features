
/** @class_declaration distEjer */
/////////////////////////////////////////////////////////////////
//// DISTIBUCI�N EJERCICIOS /////////////////////////////////////
class distEjer extends oficial {
	function distEjer( context ) { oficial ( context ); }
	function datosLineaAlbaran(curLineaPedido) {
		return this.ctx.distEjer_datosLineaAlbaran(curLineaPedido);
	}
}
//// DISTIBUCI�N EJERCICIOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCI�N EJERCICIOS ////////////////////////////////////
function distEjer_datosLineaAlbaran(curLineaPedido)
{
  var _i = this.iface;
	
	var oCantidad = _i.dameCantidadLineaAlbaran(curLineaPedido);
	if (!oCantidad) {
		return false;
	}

	_i.curLineaAlbaran.setValueBuffer("canfactura", oCantidad.cantidad);
  if (!_i.__datosLineaAlbaran(curLineaPedido)) {
    return false;
  }

  return true;
}
//// DISTRIBUCI�N EJERCICIOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
