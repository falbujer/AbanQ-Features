
/** @class_declaration prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCI?N /////////////////////////////////////////////////
class prod extends oficial {
	var pbnEditLote:Object;
    function prod( context ) { oficial ( context ); }
	function init() {
		return this.ctx.prod_init();
	}
	function editarLote() {
		return this.ctx.prod_editarLote();
	}
}
//// PRODUCCI?N /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PROD ///////////////////////////////////////////////////////
/** \C Una vez establecida, no podr? modificarse la referencia de los art?culos y si el art?culo es por lotes tampoco podr? modificarse la cantidad.
\end */
function prod_init()
{
	this.iface.__init();

	this.iface.pbnEditLote = this.child("pbnEditLote");
	connect(this.iface.pbnEditLote, "clicked()", this, "iface.editarLote()");

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Edit: {
			//this.child("fdbReferencia").setDisabled(true);
			if (util.sqlSelect("articulos", "tipostock", "referencia = '" + cursor.valueBuffer("referencia") + "'") == "Lotes") {
				
				this.child("fdbCantidad").setDisabled(true);
			}
		}
	}
	this.child("tdbMoviStock").cursor().setMainFilter("idlineapr = " + cursor.valueBuffer("idlinea"));
	this.child("tdbMoviStock").refresh();
	this.child("tdbLotesStock").cursor().setMainFilter("codlote IN (SELECT codlote FROM movistock WHERE idlineapr = " + cursor.valueBuffer("idlinea") + ")");
	this.child("tdbLotesStock").refresh();
}

function prod_editarLote()
{
	var codLote = this.child("tdbLotesStock").cursor().valueBuffer("codlote");
	debug("codLote " + codLote);
	if(!codLote || codLote == "") {
		return false;
	}

	this.child("tdbLotesStock").cursor().editRecord();
}
//// PROD ///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
