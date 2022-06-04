
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC�N POR L�NEA //////////////////////////////////////////
class lineasAlma extends oficial {
    function lineasAlma( context ) { oficial ( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.lineasAlma_datosLineaFactura(curLineaAlbaran);
	}
}
//// ALMAC�N POR L�NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC�N POR L�NEA //////////////////////////////////////////
function lineasAlma_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran)) {
		return false;
	}

	with (this.iface.curLineaFactura) {
		setValueBuffer("codalmacen", curLineaAlbaran.valueBuffer("codalmacen"));
	}
	
	return true;
}

//// ALMAC�N POR L�NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
