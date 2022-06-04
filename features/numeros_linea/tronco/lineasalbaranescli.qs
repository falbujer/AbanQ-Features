
/** @class_declaration numLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS DE L�NEA ///////////////////////////////////////////
class numLinea extends oficial {
    function numLinea( context ) { oficial ( context ); }
	function init() {
		return this.ctx.numLinea_init();
	}
}
//// NUMEROS DE L�NEA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numLinea */
/////////////////////////////////////////////////////////////////
//// N�MEROS DE L�NEA ///////////////////////////////////////////
function numLinea_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbNumLinea").setValue(this.iface.calculateField("numlinea"));
			break;
		}
	}
}
//// N�MEROS DE L�NEA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////