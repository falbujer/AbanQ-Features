
/** @class_declaration ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
class ivaGeneral extends oficial {
    function ivaGeneral( context ) { oficial ( context ); }
	function init() { this.ctx.ivaGeneral_init(); }
	function bufferChanged(fN:String) {
		return this.ctx.ivaGeneral_bufferChanged(fN);
	}
	function actualizarLineasIva(idFactura:Number):Boolean {
		return this.ctx.ivaGeneral_actualizarLineasIva(idFactura);
	}
	function inicializarControles() {
		return this.ctx.ivaGeneral_inicializarControles();
	}
	function calcularTotales() {
		return this.ctx.ivaGeneral_calcularTotales();
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
			this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
			this.child("lblComision").setText(this.iface.calculateField("lblComision"));
			this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			this.iface.verificarHabilitaciones();
			break;
		}
		default: this.iface.__bufferChanged(fN);
	}
}

function ivaGeneral_actualizarLineasIva(idFactura:Number):Boolean
{	debug("ivaGeneral_actualizarLineasIvaClientes");
		return true;
}

function ivaGeneral_inicializarControles()
{
		var util:FLUtil = new FLUtil();
		if (!sys.isLoadedModule("flcontppal")
				|| !util.sqlSelect("empresa", "contintegrada", "1 = 1"))
				this.child("tbwFactura").setTabEnabled("contabilidad", false);

		this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
		this.child("lblComision").setText(this.iface.calculateField("lblComision"));
		this.child("tdbPartidas").setReadOnly(true);
		this.iface.verificarHabilitaciones();
}

function ivaGeneral_calcularTotales()
{
		this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
    	this.child("lblComision").setText(this.iface.calculateField("lblComision"));
		this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
		this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
		this.iface.verificarHabilitaciones();
}
//// IVA_GENERAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
