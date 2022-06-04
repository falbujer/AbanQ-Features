
/** @class_declaration mailFacturac */
/////////////////////////////////////////////////////////////////
//// MAILFACTURAC //////////////////////////////////////////////////
class mailFacturac extends oficial {
	function mailFacturac( context ) { oficial ( context ); }
    function init() { this.ctx.mailFacturac_init(); }
    function enviarDoc() { this.ctx.mailFacturac_enviarDoc(); }
}
//// MAILFACTURAC //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition mailFacturac */
/////////////////////////////////////////////////////////////////
//// MAILFACTURAC //////////////////////////////////////////////////

function mailFacturac_init()
{
	this.iface.__init();
	connect(this.child("toolButtonEnviar"), "clicked()", this, "iface.enviarDoc");
}

function mailFacturac_enviarDoc()
{
	formRecordcomunicacionescli.iface.pub_enviarDoc(this.cursor(), true);
}

//// MAILFACTURAC //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////