/***************************************************************************
                      premed_propartidas.qs  -  description
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

	function actualizarFdbCoste() {
		this.ctx.oficial_actualizarFdbCoste();
	}
	function actualizarPartida( idP:Number ) {
		this.ctx.oficial_actualizarPartida( idP );
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

	function pub_actualizarPartida( idP:Number ) {
		this.actualizarPartida( idP );
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

function interna_init() {
	connect( this.child( "fdbCantidad" ).editor(), "textChanged(QString)", this, "iface.actualizarFdbCoste()" );
	connect( this.child( "fdbPrecio" ).editor(), "textChanged(QString)", this, "iface.actualizarFdbCoste()" );

	var util:FLUtil = new FLUtil();
	var where:String = "idpartida = " +  this.cursor().valueBuffer( "idpartida" );

	if ( util.sqlSelect( "premed_medipar", "COUNT(*)", where ) )
		this.child( "fdbCantidad" ).setDisabled( true );

}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_actualizarFdbCoste() {
	var util:FLUtil = new FLUtil();
	var cantidad:Number = parseFloat( !this.child( "fdbCantidad" ).editor().text.isEmpty() ? this.child( "fdbCantidad" ).editor().text : 0 );
	var precio:Number = parseFloat( !this.child( "fdbPrecio" ).editor().text.isEmpty() ? this.child( "fdbPrecio" ).editor().text : 0 );
	var coste:Number = cantidad * precio;

	this.child( "fdbCoste" ).editor().text = util.buildNumber( coste, "f", 2 );
}

function oficial_actualizarPartida( idP:Number ) {
	var util:FLUtil = new FLUtil();
	var where:String = "idpartida = " + idP;
	var precioDescomp:Number = parseFloat( util.sqlSelect( "premed_prodescomposicion", "SUM(coste)", where ) );
	var precio:Number = parseFloat( util.roundFieldValue( precioDescomp, "premed_propartidas", "precio" ) );
	var cantidadMedicion:Number = 0;
	var cantidad:Number = 0;
	var coste:Number = 0;
	var cur:FLSqlCursor = new FLSqlCursor( "premed_propartidas" );
	var idC:Number;

	cur.select( where );
	if ( cur.next() ) {
		cur.setModeAccess( cur.Edit );
		cur.refreshBuffer();

		if ( util.sqlSelect( "premed_medipar", "COUNT(*)", where ) ) {
			cantidadMedicion = parseFloat( util.sqlSelect( "premed_medipar", "SUM(total)", where ) );
			cantidad = parseFloat( util.roundFieldValue( cantidadMedicion, "premed_propartidas", "cantidad" ) );
			cur.setValueBuffer( "cantidad", cantidad );
		 } else
			cantidad = parseFloat( cur.valueBuffer( "cantidad" ) );

		idC = cur.valueBuffer( "idcapitulo" );
		coste = parseFloat( util.roundFieldValue( cantidad * precio, "premed_propartidas", "coste" ) );

		cur.setValueBuffer( "precio", precio );
		cur.setValueBuffer( "coste", coste );
		cur.commitBuffer();
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////