
/** @class_declaration ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA_INCLUIDO ///////////////////////////////////////////////
class ivaIncluido extends oficial {
    function ivaIncluido( context ) { oficial ( context ); }
	function init() {
		return this.ctx.ivaIncluido_init();
	}
}
//// IVA_INCLUIDO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA_INCLUIDO //////////////////////////////////////////////
function ivaIncluido_init()
{
	this.iface.__init();
	formRecordlineaspedidoscli.iface.pub_habilitarPorIvaIncluido(form);
}

//// IVA_INCLUIDO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
