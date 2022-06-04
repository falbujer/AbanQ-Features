
/** @class_declaration documentosPdf */
/////////////////////////////////////////////////////////////////
//// DOCUMENTOSPDF //////////////////////////////////////////////////
class documentosPdf extends oficial {
    function documentosPdf( context ) { oficial ( context ); }
	function init() {
		return this.ctx.documentosPdf_init();
	}
	function generarPDF() {
		return this.ctx.documentosPdf_generarPDF();
	}
}
//// DOCUMENTOSPDF //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition documentosPdf */
/////////////////////////////////////////////////////////////////
//// DOCUMENTOSPDF //////////////////////////////////////////////////

function documentosPdf_init() 
{
	connect(this.child("pbnGenerarPDF"), "clicked()", this, "iface.generarPDF");
	this.iface.__init();
}

function documentosPdf_generarPDF() {
	var util:FLUtil = new FLUtil;
	var destino:String = util.sqlSelect("proveedores", "email", "codproveedor = '" + this.cursor().valueBuffer("codproveedor") + "'");
	formalbaranescli.iface.pub_generarPDF(this.cursor(), "Factura", "i_facturasprov", "i_facturasprov", destino);
}

//// DOCUMENTOSPDF //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
