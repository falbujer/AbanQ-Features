
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GR�FICAS /////////////////////////////////////////////
class artesG extends articuloscomp {
    function artesG( context ) { articuloscomp ( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.artesG_datosLineaFactura(curLineaAlbaran);
	}
}
//// ARTES GR�FICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GR�FICAS /////////////////////////////////////////////
function artesG_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;

	with (this.iface.curLineaFactura) {
		setValueBuffer("udpapel", curLineaAlbaran.valueBuffer("udpapel"));
		setValueBuffer("cantidadaux", curLineaAlbaran.valueBuffer("cantidadaux"));
		setValueBuffer("unidades", curLineaAlbaran.valueBuffer("unidades"));
		setValueBuffer("pvppliego", curLineaAlbaran.valueBuffer("pvppliego"));
	}
	return true;
}
//// ARTES GR�FICAS /////////////////////////////////////////////
//////////////////////////////////////////////////////////////
