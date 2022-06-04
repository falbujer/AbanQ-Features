
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC�N POR L�NEA //////////////////////////////////////////
class lineasAlma extends oficial {
    function lineasAlma( context ) { oficial ( context ); }
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.lineasAlma_datosLineaAlbaran(curLineaPedido);
	}
}
//// ALMAC�N POR L�NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC�N POR L�NEA //////////////////////////////////////////
function lineasAlma_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaAlbaran(curLineaPedido)) {
		return false;
	}	

	with (this.iface.curLineaAlbaran) {
		setValueBuffer("codalmacen", curLineaPedido.valueBuffer("codalmacen"));
	}
	return true;
}

//// ALMAC�N POR L�NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
