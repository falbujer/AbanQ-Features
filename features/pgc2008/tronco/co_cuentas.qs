
/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial 
{
    function pgc2008( context ) { oficial ( context ); }
	function init() { this.ctx.pgc2008_init(); }
}
//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////

function pgc2008_init()
{
	//MessageBox.information("pita!2");
	this.iface.__init();
	
	var util:FLUtil = new FLUtil();
	if (util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + this.cursor().valueBuffer("codejercicio") + "'") == "08")
		this.child("fdbCodBalance").setDisabled(true);

}

//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
