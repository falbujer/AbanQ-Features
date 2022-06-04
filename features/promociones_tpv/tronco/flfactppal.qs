
/** @class_declaration promocionesTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
class promocionesTpv extends oficial {
	function promocionesTpv( context ) { oficial ( context ); }
	function extension(nE) {
		return this.ctx.promocionesTpv_extension(nE);
	}
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition promocionesTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
function promocionesTpv_extension(nE)
{
	var _i = this.iface;
	if (nE == "promociones_tpv") {
		return true;
	}
	return _i.__extension(nE);
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
