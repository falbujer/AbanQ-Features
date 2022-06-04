
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GR�FICAS /////////////////////////////////////////////
class artesG extends prod {
    function artesG( context ) { prod ( context ); }
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.artesG_datosLineaAlbaran(curLineaPedido);
	}
}
//// ARTES GR�FICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GR�FICAS /////////////////////////////////////////////
function artesG_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;

	with (this.iface.curLineaAlbaran) {
		setValueBuffer("udpapel", curLineaPedido.valueBuffer("udpapel"));
		setValueBuffer("cantidadaux", curLineaPedido.valueBuffer("cantidadaux"));
		setValueBuffer("unidades", curLineaPedido.valueBuffer("unidades"));
		setValueBuffer("pvppliego", curLineaPedido.valueBuffer("pvppliego"));
	}
	return true;
}
//// ARTES GR�FICAS /////////////////////////////////////////////
//////////////////////////////////////////////////////////////
