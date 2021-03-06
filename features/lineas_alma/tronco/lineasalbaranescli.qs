
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC?N POR L?NEA //////////////////////////////////////////
class lineasAlma extends oficial {
    function lineasAlma( context ) { oficial ( context ); }
    function init() { 
		return this.ctx.lineasAlma_init(); 
	}
}
//// ALMAC?N POR L?NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMAC?N POR L?NEA //////////////////////////////////////////
function lineasAlma_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.modeAccess() == cursor.Insert) {
		var codAlmacen:String = cursor.cursorRelation().valueBuffer("codalmacen");
		this.child("fdbCodAlmacen").setValue(codAlmacen);
	}
}

//// ALMAC?N POR L?NEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
