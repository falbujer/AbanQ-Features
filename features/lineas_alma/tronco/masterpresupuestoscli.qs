
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC�N POR L�NEA //////////////////////////////////////////
class lineasAlma extends oficial {
    function lineasAlma( context ) { oficial ( context ); }
	function datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.lineasAlma_datosLineaPedido(curLineaPresupuesto);
	}
}
//// ALMAC�N POR L�NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC�N POR L�NEA //////////////////////////////////////////
function lineasAlma_datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaPedido(curLineaPresupuesto)) {
		return false;
	}

	with (this.iface.curLineaPedido) {
		setValueBuffer("codalmacen", curLineaPresupuesto.valueBuffer("codalmacen"));
	}
	return true;
}

//// ALMAC�N POR L�NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
