
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
	function funNumSerie( context ) { oficial( context ); } 	
	function init() { return this.ctx.funNumSerie_init(); }
	function validateForm():Boolean { return this.ctx.funNumSerie_validateForm(); }
	function bufferChanged(fN:String) { return this.ctx.funNumSerie_bufferChanged(fN); }
	function controlCantidad(cantidadAuno:Boolean) { return this.ctx.funNumSerie_controlCantidad(cantidadAuno); }
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
	if (cursor.modeAccess() == cursor.Edit)
		this.iface.controlCantidad(true);
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

function funNumSerie_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();

	if (this.cursor().valueBuffer("numserie")) {
	
		// Si es factura de abono se permite s�lo la devoluci�n
		if (this.cursor().cursorRelation().valueBuffer("deabono")) {
			if (// Si existe el n�mero de serie no vendido
				util.sqlSelect("numerosserie", "id", 
					"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
					" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
					" AND vendido = false")
				// Salvo que sea otra l�nea de esta misma factura
				|| util.sqlSelect("lineasfacturascli", "idlinea", 
					"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
					" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
					" AND idfactura = '" +	this.cursor().valueBuffer("idfactura") + "'" +
					" AND idlinea <> " + this.cursor().valueBuffer("idlinea")))
			{
				MessageBox.warning(util.translate("scripts", "En facturas de abono s�lo pueden incluirse n�meros de serie previamente vendidos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}
		
		else {
			if (// Si existe un n�mero de serie que no es de esta factura
				util.sqlSelect("numerosserie", "id", 
					"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
					" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
					" AND idfacturaventa <> " + this.cursor().valueBuffer("idfactura") +
					" AND vendido = 'true'")
				// Salvo que sea otra l�nea de esta misma factura
				|| util.sqlSelect("lineasfacturascli", "idlinea", 
					"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
					" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
					" AND idfactura = '" +	this.cursor().valueBuffer("idfactura") + "'" +
					" AND idlinea <> " + this.cursor().valueBuffer("idlinea")))
			{
				MessageBox.warning(util.translate("scripts", "Este n�mero de serie corresponde a un art�culo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}
	}
	
	return this.iface.__validateForm();
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
