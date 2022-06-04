
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
	var numSerie:String;
	function funNumSerie( context ) { oficial( context ); } 	
	function init() { return this.ctx.funNumSerie_init(); }
	function bufferChanged(fN:String) { return this.ctx.funNumSerie_bufferChanged(fN); }
	function controlCantidad(cantidadAuno:Boolean) { return this.ctx.funNumSerie_controlCantidad(cantidadAuno); }
	function validateForm() { return this.ctx.funNumSerie_validateForm(); }
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////

function funNumSerie_init()
{
	this.iface.__init();
	
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Edit) {
		this.iface.controlCantidad(true);
		this.child("fdbNumSerie").setDisabled(true);
		this.child("fdbReferencia").setDisabled(true);
	}

	this.iface.numSerie = cursor.valueBuffer("numserie");
}

function funNumSerie_bufferChanged(fN:String)
{
	switch (fN) {
		case "referencia":
			this.iface.controlCantidad(true);
		break;
	}
	
	return this.iface.__bufferChanged(fN);
}

function funNumSerie_controlCantidad(cantidadAuno:Boolean)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + cursor.valueBuffer("referencia") + "'")) {
		if (cantidadAuno) 
			cursor.setValueBuffer("cantidad", 1);
		this.child("fdbCantidad").setDisabled(true);
		this.child("fdbNumSerie").setDisabled(false);
	}
	else {
		this.child("fdbCantidad").setDisabled(false);
		this.child("fdbNumSerie").setDisabled(true);
	}
}

/** \D Controla que el n�mero de serie no est� duplicado, s�lamente cuando no ha cambiado en la
edici�n
*/
function funNumSerie_validateForm():Boolean
{
	if (!this.iface.__validateForm()) return false;

	var cursor:FLSqlCursor = this.cursor();
	if (this.iface.numSerie == cursor.valueBuffer("numserie")) return true;

	switch(cursor.modeAccess()) {
		
		case cursor.Insert:
		case cursor.Edit:
			var util:FLUtil = new FLUtil;
			if (util.sqlSelect("numerosserie", "numserie", "referencia = '" + cursor.valueBuffer("referencia") + "' AND numserie = '" + cursor.valueBuffer("numserie") + "'")) {
				MessageBox.warning(util.translate("scripts", "Este n�mero de serie ya existe para el art�culo ") + cursor.valueBuffer("referencia"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
			break;
	}
	return true;
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
