
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
function ivaGeneral_init() {
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconectar");

	if (cursor.modeAccess() == cursor.Insert)
		this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));

	this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
	
	if (sys.isLoadedModule("flcontppal")) {
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", 
				"codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.bloqueoSubcuenta = false;
		this.iface.posActualPuntoSubcuenta = -1;
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	} else
		this.child("gbxContabilidad").enabled = false;
}

function ivaGeneral_bufferChanged(fN:String)
{
		var cursor:FLSqlCursor = this.cursor();
		var util:FLUtil = new FLUtil();
		
		switch(fN) {
			case "referencia":{
				this.iface.bloqueoSubcuenta = true;
				this.child("fdbCodSubcuenta").setValue(this.iface.calculateField("codsubcuenta"));
				this.iface.bloqueoSubcuenta = false;
				formRecordlineaspedidosprov.iface.pub_commonBufferChanged(fN, form);
				break;
			}
			default:
				this.iface.__bufferChanged(fN);
		}
}
//// IVA_GENERAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
