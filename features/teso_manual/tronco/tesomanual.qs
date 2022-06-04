/***************************************************************************
                 tesomanual.qs  -  description
                             -------------------
    begin                : lun may 29 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function cambiarEstado() {
		return this.ctx.oficial_cambiarEstado();
	}
	function obtenerEstado(idRecibo:String):String {
		return this.ctx.oficial_obtenerEstado(idRecibo);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tdbPagosTesoManual").cursor(), "cursorUpdated()", this, "iface.cambiarEstado");
	
	this.child("fdbTexto").setValue(this.iface.calculateField("texto"));

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
		this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + this.child("fdbCodDivisa").value() + "'"));
	}

	this.iface.bufferChanged("codcuenta");
	this.iface.cambiarEstado();
}

/** \C
La fecha de vencimiento debe ser siempre igual o posterior a la fecha de emisión del recibo.
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (util.daysTo(cursor.valueBuffer("fecha"), cursor.valueBuffer("fechav")) < 0) {
		MessageBox.warning(util.translate("scripts", "La fecha de vencimiento debe ser siempre igual o posterior\na la fecha de emisión del recibo."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "estado": {
			valor = this.iface.obtenerEstado(cursor.valueBuffer("idrecibo"));
			break;
		}
		case "texto": {
			var importe:Number = parseFloat(cursor.valueBuffer("importe"));
			var moneda:String = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
			valor = util.enLetraMoneda(importe, moneda);
			break;
		}
		case "importeeuros": {
			var importe:Number = parseFloat(cursor.valueBuffer("importe"));
			var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
			valor = importe * tasaConv;
			valor = parseFloat(util.roundFieldValue(valor, "tesomanual", "importeeuros"));
			break;
		}
		case "codigo": {
			valor = flfacturac.iface.pub_construirCodigo(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"));
			break;
		}
	}

	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	switch (fN) {
		case "importe": {
			this.child("fdbTexto").setValue(this.iface.calculateField("texto"));
			this.child("fdbImporteEuros").setValue(this.iface.calculateField("importeeuros"));
			break;
		}
		case "tasaconv": {
			this.child("fdbImporteEuros").setValue(this.iface.calculateField("importeeuros"));
			break;
		}
	}
}

/** \D
Cambia el valor del estado del recibo entre Emitido, Cobrado y Devuelto
\end */
function oficial_cambiarEstado()
{
	var estado:String = this.iface.calculateField("estado");
	this.child("fdbEstado").setValue(estado);
	if ( estado != "Emitido" ) {
		this.child("fdbImporte").setDisabled(true);
		this.child("fdbCodDivisa").setDisabled(true);
	} else {
		this.child("fdbImporte").setDisabled(false);
		this.child("fdbCodDivisa").setDisabled(false);
	}
}

/** \D
Calcula el estado en función de los pagos y devoluciones asociados a un recibo
@param	idRecibo: Identificador del recibo cuyo estado se desea calcular
@return	Estado del recibo
\end */
function oficial_obtenerEstado(idRecibo:String):String
{
	var valor:String = "Emitido";
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagostesomanual");
	curPagosDevol.select("idrecibo = " + idRecibo + " ORDER BY fecha DESC, idpagodevol DESC");
	if (curPagosDevol.first()) {
		curPagosDevol.setModeAccess(curPagosDevol.Browse);
		curPagosDevol.refreshBuffer();
		if (curPagosDevol.valueBuffer("tipo") == "Pago")
			valor = "Pagado";
		else
			valor = "Devuelto";
	}
	return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////