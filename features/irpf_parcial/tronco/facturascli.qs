
/** @class_declaration irpfParcial */
/////////////////////////////////////////////////////////////////
//// IRPF_PARCIAL //////////////////////////////////////////////////
class irpfParcial extends oficial 
{
    function irpfParcial( context ) { oficial ( context ); }
	function calcularTotales() {
		return this.ctx.irpfParcial_calcularTotales();
	}
}
//// IRPF_PARCIAL //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition irpfParcial */
/////////////////////////////////////////////////////////////////
//// IRPF_PARCIAL //////////////////////////////////////////////////

function irpfParcial_calcularTotales()
{
	this.iface.__calcularTotales();
	this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
}

//// IRPF_PARCIAL //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

