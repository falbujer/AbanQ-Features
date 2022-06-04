/***************************************************************************
                 lotes.qs  -  description
                             -------------------
    begin                : lun sep 26 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
/////////////////////////////////////////////////////////////////
//// OFICIAL ////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna ( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function calcularTotal() {
		return this.ctx.oficial_calcularTotal();
	}
	function articuloCaduca():Boolean {
		return this.ctx.oficial_articuloCaduca();
	}
}
//// OFICIAL ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

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
/** \C Los lotes son creados al generarse el primer movimiento asociado. En el formulario, el usuario seleccionar� el --codlote-- y la --caducidad--. El campo --enalmacen-- se calcular� como la suma de entradas menos salidas m�s regularizaciones.

El --codlote-- debe corresponder a un lote asociado al mismo tipo de art�culo (referencia) que el establecido en la l�nea del documento origen, si lo hay.

La  --caducidad-- ser�, por defecto, la fecha actual m�s el per�odo de consumo preferente establecido para el art�culo del lote.

A la hora de dar de alta un movimiento de salida, asociado a una l�nea de albar�n o factura de cliente, se mostrar�n �nicamente como candidatos los lotes del art�culo seleccionado que todav�a tienen un stock positivo. Por defecto aparecer� el lote con menor fecha de caducidad.
*/
function interna_init()
{
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tdbMoviLote").cursor(), "bufferCommited()", this, "iface.calcularTotal");
	
	var cursor:FLSqlCursor = this.cursor();
	this.child("fdbReferencia").setFilter("porlotes = true");
	if (cursor.modeAccess() == cursor.Insert) {
		var formAbierto:Object = formRecordmovilote.child("fdbCodLote");
		if (formAbierto) {
			var cR:FLSqlCursor = formRecordmovilote.cursor().cursorRelation();
			this.child("fdbReferencia").setValue(cR.valueBuffer("referencia"));
			this.child("fdbReferencia").setDisabled(true);
		}
	} else {
		var util:FLUtil = new FLUtil();
		if (util.sqlSelect("movilote", "codlote", "codlote = '" + this.cursor().valueBuffer("codlote") + "'"))
			this.child("fdbReferencia").setDisabled(true);
		else
			this.child("fdbReferencia").setDisabled(false);
	}
	
	if(cursor.action() == "insertarlotes")
		this.child("gbxMovimientod").close();
	
	this.child("tdbVentas").cursor().setMainFilter("cantidad < 0");
	this.child("tdbCompras").cursor().setMainFilter("cantidad >= 0");
	this.iface.articuloCaduca();

	return;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
/////////////////////////////////////////////////////////////////
//// OFICIAL //////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	switch(fN) {
		case "referencia": {
			if (this.iface.articuloCaduca()) {
				var caducidad:Date = new Date();
				var diasConsumo:Number = util.sqlSelect("articulos", "diasconsumo", "referencia = '" + cursor.valueBuffer("referencia") + "'");
				if (!diasConsumo)
					diasConsumo = 0;
				caducidad = util.addDays(caducidad, diasConsumo);
				cursor.setValueBuffer("caducidad", caducidad)
			}
			break;
		}
	}

	return;
}

/** \D Comprueba si un art�culo caduca (si el n�mero de d�as de consumo es nulo o cero
\end */
function oficial_articuloCaduca():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var caduca:Boolean;
	var diasConsumo:Number = util.sqlSelect("articulos", "diasconsumo", "referencia = '" + cursor.valueBuffer("referencia") + "'");
	if (!diasConsumo) {
		cursor.setValueBuffer("caducidad", "");
		caduca = false;
	} else {
		caduca = true
	}
	return caduca;
}

function oficial_calcularTotal()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var total:Number = util.sqlSelect("movilote", "SUM(cantidad)", "codlote = '" + cursor.valueBuffer("codlote") + "'");
	if (!total)
		total = 0;
	this.child("fdbEnAlmacen").setValue(total);
}
//// OFICIAL //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////