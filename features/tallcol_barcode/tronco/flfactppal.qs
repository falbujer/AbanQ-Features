
/** @class_declaration tcbarcode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class tcbarcode extends oficial {
	function tcbarcode( context ) { oficial ( context ); }
	function extension(nE) {
		return this.ctx.tcbarcode_extension(nE);
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tcbarcode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function tcbarcode_extension(nE)
{
	var _i = this.iface;
	if (nE == "tallcol_barcode") {
		return true;
	}
	return _i.__extension(nE);
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
