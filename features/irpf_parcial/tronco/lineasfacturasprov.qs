
/** @class_declaration irpfParcial */
/////////////////////////////////////////////////////////////////
//// IRPF_PARCIAL ///////////////////////////////////////////////
class irpfParcial extends oficial {
    function irpfParcial( context ) { oficial ( context ); }
    function init() { 
	return this.ctx.irpfParcial_init(); 
    }
}
//// IRPF_PARCIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition irpfParcial */
/////////////////////////////////////////////////////////////////
//// IRPF_PARCIAL //////////////////////////////////////////////
function irpfParcial_init()
{
	this.child("fdbIRPF").close();
	this.iface.__init();
}

//// IRPF_PARCIAL //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////