
/** @class_declaration incoterms */
/////////////////////////////////////////////////////////////////
//// INCOTERMS //////////////////////////////////////////////////
class incoterms extends oficial {
    function incoterms( context ) { oficial ( context ); }
    function datosFactura(curAlbaran, where, datosAgrupacion) {
		return this.ctx.incoterms_datosFactura(curAlbaran, where, datosAgrupacion);
	}
}
//// INCOTERMS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition incoterms */
/////////////////////////////////////////////////////////////////
//// INCOTERMS //////////////////////////////////////////////////
function incoterms_datosFactura(curAlbaran, where, datosAgrupacion)
{
	if (!this.iface.__datosFactura(curAlbaran, where, datosAgrupacion)) {
		return false;
	}
	with (this.iface.curFactura) {
		setValueBuffer("incoterm", curAlbaran.valueBuffer("incoterm"));
	}
	
	return true;
}
//// INCOTERMS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
