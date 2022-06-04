
/** @class_declaration ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
class ivaGeneral extends oficial {
    function ivaGeneral( context ) { oficial ( context ); }
	function init() { this.ctx.ivaGeneral_init(); }
	function bufferChanged(fN:String) {
		return this.ctx.ivaGeneral_bufferChanged(fN);
	}
}
//// IVA_GENERAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
function ivaGeneral_init()
{
	this.iface.__init();
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	var serie:String = cursor.valueBuffer("codserie");
	var siniva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
	if(siniva){
		this.child("fdbCodImpuesto").setDisabled(true);
		this.child("fdbIva").setDisabled(true);
		cursor.setValueBuffer("codimpuesto","");
		cursor.setValueBuffer("iva",0);
	}
}

function ivaGeneral_bufferChanged(fN:String)
{
	switch (fN) {
		case "codimpuesto":{
			this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			break;
		}
		default: this.iface.__bufferChanged(fN);
	}
}
//// IVA_GENERAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
