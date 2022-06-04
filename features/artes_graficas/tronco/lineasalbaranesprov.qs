
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GR�FICAS /////////////////////////////////////////////
class artesG extends prod {
    function artesG( context ) { prod ( context ); }
	function init() {
		return this.ctx.artesG_init();
	}
}
//// ARTES GR�FICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GR�FICAS /////////////////////////////////////////////
function artesG_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			formRecordlineaspedidosprov.iface.pub_obtenerFamilia("sin familia");
			break;
		}
		case cursor.Edit: {
			formRecordlineaspedidosprov.iface.pub_obtenerFamilia(cursor.valueBuffer("referencia"));
			break;
		}
	}
	formRecordlineaspedidosprov.iface.pub_habilitacionesFamilia(this);
	formRecordlineaspedidosprov.iface.pub_establecerAliasPapel(this);
}
//// ARTES GR�FICAS /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
