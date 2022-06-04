/***************************************************************************
                      premed_medidas.qs  -  description
                             -------------------
    begin                : vie jun 15 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }

	function actualizarFdbTotal() {
		this.ctx.oficial_actualizarFdbTotal();
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

function interna_init() {
	connect( this.child( "fdbUds" ).editor(), "textChanged(QString)", this, "iface.actualizarFdbTotal()" );
	connect( this.child( "fdbLargo" ).editor(), "textChanged(QString)", this, "iface.actualizarFdbTotal()" );
	connect( this.child( "fdbAncho" ).editor(), "textChanged(QString)", this, "iface.actualizarFdbTotal()" );
	connect( this.child( "fdbAlto" ).editor(), "textChanged(QString)", this, "iface.actualizarFdbTotal()" );
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_actualizarFdbTotal() {
	var util:FLUtil = new FLUtil();
	var uds:Number = parseFloat( !this.child( "fdbUds" ).editor().text.isEmpty() ? this.child( "fdbUds" ).editor().text : 0 );
	var largo:Number = parseFloat( !this.child( "fdbLargo" ).editor().text.isEmpty() ? this.child( "fdbLargo" ).editor().text : 0 );
	var ancho:Number = parseFloat( !this.child( "fdbAncho" ).editor().text.isEmpty() ? this.child( "fdbAncho" ).editor().text : 0 );
	var alto:Number = parseFloat( !this.child( "fdbAlto" ).editor().text.isEmpty() ? this.child( "fdbAlto" ).editor().text : 0 );
	var total:Number = ( uds ? uds : 1  ) * ( largo ? largo : 1 ) * ( ancho ? ancho : 1 ) * ( alto ? alto : 1 );

	this.child( "fdbTotal" ).editor().text = util.buildNumber( total, "f", 2 );
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////