
/** @class_declaration compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACI�N DE RECIBOS ////////////////////////////////////
class compRecibos extends oficial {
	var tdbRecords:Object;
    function compRecibos( context ) { oficial ( context ); }
	function init() {
		return this.ctx.compRecibos_init();
	}
	function romperCompensacion() {
		return this.ctx.compRecibos_romperCompensacion();
	}
	function marcarEmitidos(idRecibo:String, idReciboComp:String):Boolean {
		return this.ctx.compRecibos_marcarEmitidos(idRecibo, idReciboComp);
	}
}
//// COMPENSACI�N DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACI�N DE RECIBOS ////////////////////////////////////
function compRecibos_init()
{
	this.iface.__init();
	
	this.iface.tdbRecords = this.child("tableDBRecords");
	connect(this.child("tbnRomperCompensacion"), "clicked()", this, "iface.romperCompensacion");
}

/** \C Rompe la compensaci�n del recibo seleccionado, si la hay
\end */
function compRecibos_romperCompensacion()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	var idRecibo:String = cursor.valueBuffer("idrecibo");
	var idReciboComp:String = cursor.valueBuffer("idrecibocomp");
	if (!idReciboComp || parseFloat(idReciboComp) == 0) {
		MessageBox.information(util.translate("scripts", "El recibo seleccionado no est� compensado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var res:Number = MessageBox.information(util.translate("scripts", "Va a romper la compensaci�n del recibo seleccioado"), MessageBox.Ok, MessageBox.Cancel);
	if (res != MessageBox.Ok)
		return;
		
	cursor.transaction(false);
	try {
		if (this.iface.marcarEmitidos(idRecibo, idReciboComp))
			cursor.commit();
		else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al romper la compensaci�n:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbRecords.refresh();
}

/** \D Marca como emitidos dos recibos Compensados
@param	idRecibo: primer recibo
@param	idReciboComp: segundo recibo
@return	true si la actualizaci�n tiene �xito, false en caso contrario
\end */
function compRecibos_marcarEmitidos(idRecibo:String, idReciboComp:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var estado:String;
	var tipo:String;
	tipo = util.sqlSelect("pagosdevolcli", "tipo", "idrecibo = " + idRecibo + " ORDER BY idpagodevol DESC");
	if (tipo == "Devoluci�n") {
		estado = "Devuelto";
	} else {
		estado = "Emitido";
	}
	if (!util.sqlUpdate("reciboscli", "estado,idrecibocomp", estado + ",NULL", "idrecibo = " + idRecibo))
		return false;
	

	tipo = util.sqlSelect("pagosdevolcli", "tipo", "idrecibo = " + idReciboComp + " ORDER BY idpagodevol DESC");
	if (tipo == "Devoluci�n") {
		estado = "Devuelto";
	} else {
		estado = "Emitido";
	}
	if (!util.sqlUpdate("reciboscli", "estado,idrecibocomp", estado + ",NULL", "idrecibo = " + idReciboComp))
		return false;
	return true;
}
//// COMPENSACI�N DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
