/***************************************************************************
                 ejemploartcomplejos.qs  -  description
                             -------------------
    begin                : vie ene 25 2012
    copyright            : (C) 2012 by InfoSiAL S.L.
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
	function calculateField(fN:String) { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); } 
	function commonCalculateField(fN, cursor) {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
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
  function pub_commonCalculateField(fN, cursor) {
		return this.commonCalculateField(fN, cursor);
	}
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
	var _i = this.iface;
	var cursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
}

function interna_calculateField(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	var valor;
	switch (fN) {
		default: {
			valor = _i.commonCalculateField(fN, cursor);
		}
	}
			
	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN, cursor)
{
	var _i = this.iface;
	var valor;
	var v = cursor.valueBuffer;
	switch (fN) {
		case "descripcion": {
			valor = v("cantidad1") + " " + v("descripcion1") + " + " + v("cantidad2") + " " + v("descripcion2");
			break;
		}
		case "precio": {
			var valor1 = parseFloat(AQUtil.sqlSelect("articulos", "pvp", "referencia = '" + v("referencia1") + "'")) * v("cantidad1");
			var valor2 = parseFloat(AQUtil.sqlSelect("articulos", "pvp", "referencia = '" + v("referencia2") + "'")) * v("cantidad2");
			valor1 = isNaN(valor1) ? 0 : valor1;
			valor2 = isNaN(valor2) ? 0 : valor2;
			valor = parseFloat(valor1) + parseFloat(valor2);
			break;
		}
		default: {
		}
	}
			
	return valor;
}

function oficial_bufferChanged(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	switch (fN) {
		case "referencia1":
		case "referencia2":
		case "cantidad1":
		case "cantidad2": {
			sys.setObjText(this, "fdbPrecio", _i.calculateField("precio"));
			sys.setObjText(this, "fdbDescripcion", _i.calculateField("descripcion"));
			break;
		}
		default: {
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////