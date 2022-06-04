
/** @class_declaration traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
class traducciones extends oficial {
    function traducciones( context ) { oficial ( context ); }
    function init() { 
		return this.ctx.traducciones_init(); 
	}
    function traducirFormaPago() { 
		return this.ctx.traducciones_traducirFormaPago(); 
	}
}
//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
function traducciones_init()
{
	connect(this.child("pbnTraducir"), "clicked()", this, "iface.traducirFormaPago");
}

function traducciones_traducirFormaPago()
{
	return flfactppal.iface.pub_traducir("formaspago", "descripcion", this.cursor().valueBuffer("codpago"));
}
