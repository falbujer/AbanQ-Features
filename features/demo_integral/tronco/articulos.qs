
/** @class_declaration demo */
/////////////////////////////////////////////////////////////////
//// DEMO INTEGRAL //////////////////////////////////////////////
class demo extends fluxecPro {
    function demo( context ) { fluxecPro ( context ); }
    function init() {
		return this.ctx.demo_init();
	}
}
//// DEMO INTEGRAL //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition demo */
//// DEMO INTEGRAL //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
function demo_init()
{
	this.iface.__init();
	
	var cursor:FLSqlCursor = this.cursor();
	
	if (sys.isLoadedModule("flcolagedo")) {
		var datosGD:Array;
		datosGD["txtRaiz"] = cursor.valueBuffer("referencia") + ": " + cursor.valueBuffer("descripcion");
		datosGD["tipoRaiz"] = "articulos";
		datosGD["idRaiz"] = cursor.valueBuffer("referencia");
		flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
	} else {
		this.child("tbwDocumentos").setTabEnabled("gestiondoc", false);
	}
}
//// DEMO INTEGRAL //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
