
/** @class_declaration pagaresMultipago */
/////////////////////////////////////////////////////////////////
//// PAGARES MULTIPAGO  /////////////////////////////////////////
class pagaresMultipago extends oficial {

	function pagaresMultipago( context ) { oficial ( context ); }
  function init() {
		this.ctx.pagaresMultipago_init();
	}
}

//// PAGARES MULTIPAGO  /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagaresMultipago */
/////////////////////////////////////////////////////////////////
//// PAGARES MULTIPAGO //////////////////////////////////////////

function pagaresMultipago_init()
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	_i.__init();
	this.child("pbnAnularPagare").close();
}

//// PAGARES MULTIPAGO //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
