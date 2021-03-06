
/** @class_declaration tarifasFact */
//////////////////////////////////////////////////////////////////
//// tarifasFact //////////////////////////////////////////////////////
class tarifasFact extends oficial {
    function tarifasFact( context ) { oficial( context ); }
	function datosPedido(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.tarifasFact_datosPedido(curPresupuesto);
	}
}
//// tarifasFact //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tarifasFact */
/////////////////////////////////////////////////////////////////
//// tarifasFact /////////////////////////////////////////////////////

function tarifasFact_datosPedido(curPresupuesto:FLSqlCursor):Boolean
{
	if (!this.iface.__datosPedido(curPresupuesto))
		return false;
		
	with (this.iface.curPedido) {
		setValueBuffer("codtarifa", curPresupuesto.valueBuffer("codtarifa"));
	}
	
	return true;
}

//// tarifasFact /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
