/***************************************************************************
                      premed_proyectos.qs  -  description
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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var conectado:Boolean;
	var tdbCapitulos;
	var tdbPartidas;
	var tdbDescom;
	var tdbMediPar;
	var tdbMediDes;
	var tedOut;
	var stepsImport:Number;

	function oficial( context ) { interna( context ); }

	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function actualizarFdbCapitulo() {
		this.ctx.oficial_actualizarFdbCapitulo();
	}
	function actualizarFdbPartida() {
		this.ctx.oficial_actualizarFdbPartida();
	}
	function actualizarFdbDescom() {
		this.ctx.oficial_actualizarFdbDescom();
	}
	function actualizarLblMediPar() {
		this.ctx.oficial_actualizarLblMediPar();
	}
	function actualizarLblMediDes() {
		this.ctx.oficial_actualizarLblMediDes();
	}
	function actualizarProyecto( codP:String ) {
		this.ctx.oficial_actualizarProyecto( codP );
	}
	function actualizarFdbCoste() {
		this.ctx.oficial_actualizarFdbCoste();
	}
	function actualizarCostes() {
		this.ctx.oficial_actualizarCostes();
	}
	function agregarComponentesPartida( idP:Number ) {
		this.ctx.oficial_agregarComponentesPartida( idP );
	}
	function actualizarTedOutSimple() {
		this.ctx.oficial_actualizarTedOutSimple();
	}
	function actualizarTedOutDescomp() {
		this.ctx.oficial_actualizarTedOutDescomp();
	}
	function actualizarTedOutMediciones() {
		this.ctx.oficial_actualizarTedOutMediciones();
	}
	function actualizarTedOutElementos() {
		this.ctx.oficial_actualizarTedOutElementos();
	}
	function obtenerHtmlSimple():String {
		return this.ctx.oficial_obtenerHtmlSimple();
	}
	function obtenerHtmlDescomp():String {
		return this.ctx.oficial_obtenerHtmlDescomp();
	}
	function obtenerHtmlMediciones():String {
		return this.ctx.oficial_obtenerHtmlMediciones();
	}
	function obtenerHtmlElementos():String {
		return this.ctx.oficial_obtenerHtmlElementos();
	}
	function imprimirTedOut() {
		this.ctx.oficial_imprimirTedOut();
	}
	function importarPresupuesto() {
		this.ctx.oficial_importarPresupuesto();
	}
	function importarCapitulos() {
		this.ctx.oficial_importarCapitulos();
	}
	function importarPartidas( cod:String, idC:Number ) {
		this.ctx.oficial_importarPartidas( cod, idC );
	}
	function importarDescomp( cod:String, idP:Number ) {
		this.ctx.oficial_importarDescomp( cod, idP );
	}
	function conectar() {
		this.ctx.oficial_conectar();
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
	this.iface.conectado = false;
	this.iface.tdbCapitulos = this.child( "tdbCapitulos" );
	this.iface.tdbPartidas = this.child( "tdbPartidas" );
	this.iface.tdbDescom = this.child( "tdbDescom" );
	this.iface.tdbMediPar = this.child( "tdbMediPar" );
	this.iface.tdbMediDes = this.child( "tdbMediDes" );
	this.iface.tedOut = this.child( "tedOut" );

	this.iface.tdbCapitulos.show();
	this.iface.tdbPartidas.show();
	this.iface.tdbDescom.show();
	this.iface.tdbMediPar.show();
	this.iface.tdbMediDes.show();

	this.iface.actualizarFdbCoste();

	this.iface.conectar();

	this.child( "pbMediDes" ).setOn( false );
}

function interna_calculateField( fN:String ):String {
	return formpresupuestoscli.iface.pub_commonCalculateField( fN, this.cursor() );
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_actualizarFdbCapitulo() {
	var idC:Number;

	if ( this.iface.tdbCapitulos.cursor().isValid() ) {
		idC = this.iface.tdbCapitulos.cursor().valueBuffer( "idcapitulo" );
		this.child( "fdbCapitulo" ).editor().text = idC.toString();
	} else
		this.child( "fdbCapitulo" ).editor().text = "";

	this.iface.tdbPartidas.refresh();
}

function oficial_actualizarFdbPartida() {
	var idP:Number;

	if ( this.iface.tdbPartidas.cursor().isValid() ) {
		idP = this.iface.tdbPartidas.cursor().valueBuffer( "idpartida" );
		this.child( "fdbPartida" ).editor().text = idP.toString();
	} else
		this.child( "fdbPartida" ).editor().text = "";

	this.iface.tdbDescom.refresh();
	this.iface.tdbMediPar.refresh();
	this.iface.actualizarLblMediPar();
}

function oficial_actualizarFdbDescom() {
	var idD:Number;

	if ( this.iface.tdbDescom.cursor().isValid() ) {
		idD = this.iface.tdbDescom.cursor().valueBuffer( "iddescomp" );
		this.child( "fdbDescom" ).editor().text = idD.toString();
	} else
		this.child( "fdbDescom" ).editor().text = "";

	this.iface.tdbMediDes.refresh();
	this.iface.actualizarLblMediDes();
}

function oficial_actualizarLblMediPar() {
	if ( !this.iface.tdbPartidas.cursor().isValid() ) {
		this.child( "lblMediPar" ).text = "0";
		return;
	}

	var util:FLUtil = new FLUtil();
	var idP:Number = this.iface.tdbPartidas.cursor().valueBuffer( "idpartida" );
	var where:String = "idpartida = " + idP;
	var total:Number = parseFloat( util.sqlSelect( "premed_medipar", "SUM(total)", where ) );

	this.child( "lblMediPar" ).text = util.buildNumber( total, "f", 2 );
}

function oficial_actualizarLblMediDes() {
	if ( !this.iface.tdbDescom.cursor().isValid() ) {
		this.child( "lblMediDes" ).text = "0";
		return;
	}

	var util:FLUtil = new FLUtil();
	var idD:Number = this.iface.tdbDescom.cursor().valueBuffer( "iddescomp" );
	var where:String = "iddescomp = " + idD;
	var total:Number = parseFloat( util.sqlSelect( "premed_medides", "SUM(total)", where ) );

	this.child( "lblMediDes" ).text = util.buildNumber( total, "f", 2 );
}

function oficial_bufferChanged( fN:String ) {
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "codcliente": {
			this.child("fdbCodDir").setValue("0");
			this.child("fdbCodDir").setValue(this.iface.calculateField("coddir"));
			break;
		}
	}
}

function oficial_actualizarFdbCoste( ) {
	var util:FLUtil = new FLUtil();
	var where:String = "codproyecto = '" + this.child( "fdbCodProyecto" ).editor().text + "'";
	var totalCapitulos:Number = parseFloat( util.sqlSelect( "premed_procapitulos", "SUM(coste)", where ) );

	this.child( "fdbCoste" ).editor().text = util.buildNumber( totalCapitulos, "f", 2 );
}

function oficial_actualizarCostes() {
	if ( this.iface.tdbDescom.cursor().isValid() ) {
		var idD:Number = this.iface.tdbDescom.cursor().valueBuffer( "iddescomp" );
		formRecordpremed_prodescomposicion.iface.pub_actualizarDescomp( idD );
		this.iface.tdbDescom.refresh();
	}

	if ( !this.iface.tdbDescom.cursor().size() ) {
		if ( this.iface.tdbPartidas.cursor().isValid() ) {
			var idP:Number = this.iface.tdbPartidas.cursor().valueBuffer( "idpartida" );
			this.iface.agregarComponentesPartida( idP );
		}
	}

	if ( this.iface.tdbPartidas.cursor().isValid() ) {
		var idP:Number = this.iface.tdbPartidas.cursor().valueBuffer( "idpartida" );
		formRecordpremed_propartidas.iface.pub_actualizarPartida( idP );
		this.iface.tdbPartidas.refresh();
	}

	if ( this.iface.tdbCapitulos.cursor().isValid() ) {
		var idC:Number = this.iface.tdbCapitulos.cursor().valueBuffer( "idcapitulo" );
		formRecordpremed_procapitulos.iface.pub_actualizarCapitulo( idC );
		this.iface.tdbCapitulos.refresh();
		this.iface.actualizarFdbCoste();
	}

	this.iface.actualizarLblMediPar();
	this.iface.actualizarLblMediDes();
}

function oficial_agregarComponentesPartida( idP:Number ) {
	var util:FLUtil = new FLUtil();
	var codPartida = util.sqlSelect( "premed_propartidas", "codpropartida", "idpartida = " + idP );

	if ( codPartida == undefined || !codPartida )
		return;

	if ( codPartida.isEmpty() )
		return;

	var qry:FLSqlQuery = new FLSqlQuery();

	qry.setTablesList( "premed_descomposicion" );
	qry.setSelect( "referencia,cantidad,codunidad,resumen,precio,descripcion,tipo,coste");
	qry.setFrom( "premed_descomposicion" );
	qry.setWhere( "codpartida = '" + codPartida + "'" );

	try { qry.setForwardOnly( true ); } catch (e) {}

	if (!qry.exec())
		return;

	var cur:FLSqlCursor = new FLSqlCursor( "premed_prodescomposicion" );

	while( qry.next() ) {
		cur.setModeAccess( cur.Insert );
		cur.refreshBuffer();
		cur.setValueBuffer( "idpartida", idP );
		cur.setValueBuffer( "referencia", qry.value( 0 ) );
		cur.setValueBuffer( "cantidad", qry.value( 1 ) );
		cur.setValueBuffer( "codunidad", qry.value( 2 ) );
		cur.setValueBuffer( "resumen", qry.value( 3 ) );
		cur.setValueBuffer( "precio", qry.value( 4 ) );
		cur.setValueBuffer( "descripcion", qry.value( 5 ) );
		cur.setValueBuffer( "tipo", qry.value( 6 ) );
		cur.setValueBuffer( "coste", qry.value( 7 ) );
		cur.commitBuffer();
	}
}

function oficial_actualizarTedOutSimple() {
	var html:String = this.iface.obtenerHtmlSimple();

	this.iface.tedOut.clear();
	this.iface.tedOut.append( html );
}

function oficial_actualizarTedOutDescomp() {
	var html:String = this.iface.obtenerHtmlDescomp();

	this.iface.tedOut.clear();
	this.iface.tedOut.append( html );
}

function oficial_actualizarTedOutMediciones() {
	var html:String = this.iface.obtenerHtmlMediciones();

	this.iface.tedOut.clear();
	this.iface.tedOut.append( html );
}

function oficial_actualizarTedOutElementos() {
	var html:String = this.iface.obtenerHtmlElementos();

	this.iface.tedOut.clear();
	this.iface.tedOut.append( html );
}

function oficial_obtenerHtmlSimple():String {
	var util:FLUtil = new FLUtil();
	var html:String;
	var codProyecto:String = this.child( "fdbCodProyecto" ).editor().text;
	var steps:Number = 0;

	html = "<h4>SERVICIOS Y APLICACIONES INEL</h4>";
	html += "<h4>PRESUPUESTO " + codProyecto + "</h4>";

	var curC:FLSqlCursor = new FLSqlCursor( "premed_procapitulos" );
	var curP:FLSqlCursor = new FLSqlCursor( "premed_propartidas" );
	var contadorC:Number = 0;
	var contadorP:Number = 0;

	curC.select( "codproyecto = '" + codProyecto + "'" );

	util.createProgressDialog( "Generando Presupuesto", curC.size() );

	while ( curC.next() ) {

		++contadorC;

		html += "<hr color=\"#000000\">";

		html += "<table border=\"1\" cellpadding=\"2\" cellspacing=\"2\" width=\"100%\">";
		html += "<tr>";
		html += "<td>Capítulo " + contadorC.toString() + "  ( " + curC.valueBuffer( "codcapitulo" ) + " ) </td>";
		html += "<td align=\"center\">" + curC.valueBuffer( "resumen" ) + "</td>";
		html += "<td align=\"right\">" + util.buildNumber( curC.valueBuffer( "coste" ), "f", 2 ) + "</td>";
		html += "</tr>";
		html += "</table>";

		curP.select( "idcapitulo = " + curC.valueBuffer( "idcapitulo" ) );

		html += "<table border=\"0\" cellpadding=\"4\" cellspacing=\"4\" width=\"90%\">";
		html += "<tr>";
		html += "<th></th>";
		html += "<th></th>";
		html += "<th align=\"center\">Medición</th>";
		html += "<th align=\"center\">Prec/ud</th>";
		html += "<th align=\"center\">Importe</th>";
		html += "</tr>";

		while( curP.next() ) {

			++contadorP;

			html += "<tr>";
			html += "<td valign=\"top\" align=\"right\">" + contadorC.toString() + "." + contadorP.toString() + "</td>";
			html += "<td valign=\"top\" align=\"left\">" + curP.valueBuffer( "codunidad" ) + " " + curP.valueBuffer( "codpropartida" ) + "<br>" + curP.valueBuffer( "resumen" ) + "<br>" + curP.valueBuffer( "descripcion" ) + "</td>";
			html += "<td valign=\"bottom\" align=\"right\">" + util.buildNumber( curP.valueBuffer( "cantidad" ), "f", 3 ) + "</td>";
			html += "<td valign=\"bottom\" align=\"right\">" + util.buildNumber( curP.valueBuffer( "precio" ), "f", 2 ) + "</td>";
			html += "<td valign=\"bottom\" align=\"right\">" + util.buildNumber( curP.valueBuffer( "coste" ), "f", 2 ) + "</td>";
			html += "</tr>";
		}

		util.setProgress( ++steps );
		util.setLabelText( "Presupuesto Capítulo " + contadorC.toString() + "  ( " + curC.valueBuffer( "codcapitulo" ) + " )" );

		html += "</table>";

		html += "<table border=\"1\" cellpadding=\"2\" cellspacing=\"2\" width=\"100%\">";
		html += "<tr>";
		html += "<td width=\"67%\">Capítulo " + contadorC.toString() + "  ( " + curC.valueBuffer( "codcapitulo" ) + " ) </td>";
		html += "<td align=\"right\">" + util.buildNumber( curC.valueBuffer( "coste" ), "f", 2 ) + "</td>";
		html += "</tr>";
		html += "</table>";

		html += "<hr color=\"#000000\"><br><br>";

		contadorP = 0;
	}

	util.destroyProgressDialog();

	html += "<h4>RESUMEN DE PRESUPUESTO</h4>";
	html += "<hr color=\"#000000\">";

	curC.select( "codproyecto = '" + codProyecto + "'" );
	contadorC = 0;

	util.createProgressDialog( "Generando Resumen de Presupuesto", curC.size() );
	steps = 0;

	while ( curC.next() ) {

		++contadorC;

		html += "<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\" width=\"100%\">";
		html += "<tr>";
		html += "<td align=\"right\">" + contadorC.toString() +  " : </td>";
		html += "<td align=\"left\" width=\"90%\">" + curC.valueBuffer( "resumen" ) + "</td>";
		html += "<td align=\"right\">" + util.buildNumber( curC.valueBuffer( "coste" ), "f", 2 ) + "</td>";
		html += "</tr>";
		html += "</table>";

		curP.select( "idcapitulo = " + curC.valueBuffer( "idcapitulo" ) );

		html += "<center><table border=\"0\" cellpadding=\"2\" cellspacing=\"2\" width=\"80%\">";

		while ( curP.next() ) {

			++contadorP;

			html += "<tr>";
			html += "<td align=\"right\">" + contadorC.toString() + "." + contadorP.toString() + " : </td>";
			html += "<td align=\"left\" width=\"80%\">" + curP.valueBuffer( "resumen" ) + "</td>";
			html += "<td valign=\"bottom\" align=\"right\">" + util.buildNumber( curP.valueBuffer( "coste" ), "f", 2 ) + "</td>";
			html += "</tr>";
		}

		util.setProgress( ++steps );
		util.setLabelText( "Resumen Capítulo " + contadorC.toString() + "  ( " + curC.valueBuffer( "codcapitulo" ) + " )" );

		html += "</table></center>";

		contadorP = 0;
	}

	html += "<hr color=\"#000000\">";

	html += "<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\" width=\"100%\">";
	html += "<tr>";
	html += "<td align=\"left\"><b>TOTAL PRESUPUESTO</b></td>";
	html += "<td align=\"right\"><b>" + util.buildNumber( this.cursor().valueBuffer( "coste" ), "f", 2 ) + "</b></td>";
	html += "</tr>";
	html += "</table>";

	html += "<hr color=\"#000000\">";

	util.destroyProgressDialog();

	return html;
}

function oficial_obtenerHtmlDescomp():String {
	var util:FLUtil = new FLUtil();
	var html:String;
	var codProyecto:String = this.child( "fdbCodProyecto" ).editor().text;
	var steps:Number = 0;

	html = "<h4>SERVICIOS Y APLICACIONES INEL</h4>";
	html += "<h4>CUADRO DE PRECIOS DESCOMPUESTOS</h4>";

	var curC:FLSqlCursor = new FLSqlCursor( "premed_procapitulos" );
	var curP:FLSqlCursor = new FLSqlCursor( "premed_propartidas" );
	var curD:FLSqlCursor = new FLSqlCursor( "premed_prodescomposicion" );

	var contadorC:Number = 0;
	var contadorP:Number = 0;

	curC.select( "codproyecto = '" + codProyecto + "'" );

	html += "<hr color=\"#000000\">";

	while ( curC.next() ) {

		++contadorC;

		steps = 0;

		curP.select( "idcapitulo = " + curC.valueBuffer( "idcapitulo" ) );

		util.createProgressDialog( "Generando Cuadro de Precios Descompuestos", curP.size() );

		while ( curP.next() ) {

			++contadorP;

			html += "<hr color=\"#000000\">";

			html += "<table border=\"1\" cellpadding=\"2\" cellspacing=\"2\" width=\"100%\">";
			html += "<tr>";
			html += "<td>" + contadorC.toString() + "." + contadorP.toString() + "</td>";
			html += "<td width=\"90%\">" + curP.valueBuffer( "codunidad" ) + " " + curP.valueBuffer( "codpropartida" ) + " " + curP.valueBuffer( "resumen" ) + " " + curP.valueBuffer( "descripcion" ) + "</td>";
			html += "</tr>";
			html += "</table>";

			curD.select( "idpartida = " + curP.valueBuffer( "idpartida" ) );

			html += "<center><table border=\"0\" cellpadding=\"4\" cellspacing=\"4\" width=\"80%\">";

			while ( curD.next() ) {

				html += "<tr>";
				html += "<td>" + curD.valueBuffer( "referencia" ) + "</td>";
				html += "<td>" + curD.valueBuffer( "resumen" ) + "</td>";
				html += "<td align=\"right\">" + util.buildNumber( curD.valueBuffer( "cantidad" ), "f", 3 ) + "</td>";
				html += "<td>" + curD.valueBuffer( "codunidad" ) + "</td>";
				html += "<td align=\"right\">" + util.buildNumber( curD.valueBuffer( "precio" ), "f", 2 ) + "</td>";
				html += "<td align=\"right\">" + util.buildNumber( curD.valueBuffer( "coste" ), "f", 2 ) + "</td>";
				html += "</tr>";

			}

			util.setProgress( ++steps );
			util.setLabelText( "Partida " + curP.valueBuffer( "codpropartida" ) );

			html += "<tr>";
			html += "<td></td>";
			html += "<td></td>";
			html += "<td></td>";
			html += "<td></td>";
			html += "<td align=\"right\">TOTAL : </td>";
			html += "<td align=\"right\"><b>" + util.buildNumber( curP.valueBuffer( "precio" ), "f", 2 ) + "</b></td>";
			html += "</tr>";

			html += "</table></center><br><br>";
		}

		contadorP = 0;
	}

	html += "<hr color=\"#000000\"><br><br>";

	util.destroyProgressDialog();

	return html;
}

function oficial_obtenerHtmlMediciones():String {
	var util:FLUtil = new FLUtil();
	var html:String;
	var codProyecto:String = this.child( "fdbCodProyecto" ).editor().text;
	var steps:Number = 0;

	html = "<h4>SERVICIOS Y APLICACIONES INEL</h4>";
	html += "<h4>MEDICIONES</h4>";

	var curC:FLSqlCursor = new FLSqlCursor( "premed_procapitulos" );
	var curP:FLSqlCursor = new FLSqlCursor( "premed_propartidas" );
	var curM:FLSqlCursor = new FLSqlCursor( "premed_medipar" );

	var contadorC:Number = 0;
	var contadorP:Number = 0;

	var uds:Number;
	var largo:Number;
	var ancho:Number;
	var alto:Number;

	curC.select( "codproyecto = '" + codProyecto + "'" );

	html += "<hr color=\"#000000\">";

	while ( curC.next() ) {

		++contadorC;

		steps = 0;

		curP.select( "idcapitulo = " + curC.valueBuffer( "idcapitulo" ) );

		util.createProgressDialog( "Generando Cuadro de Mediciones", curP.size() );

		while ( curP.next() ) {

			++contadorP;

			html += "<hr color=\"#000000\">";

			html += "<table border=\"1\" cellpadding=\"2\" cellspacing=\"2\" width=\"100%\">";
			html += "<tr>";
			html += "<td>" + contadorC.toString() + "." + contadorP.toString() + "</td>";
			html += "<td width=\"90%\">" + curP.valueBuffer( "codunidad" ) + " " + curP.valueBuffer( "codpropartida" ) + " " + curP.valueBuffer( "resumen" ) + " " + curP.valueBuffer( "descripcion" ) + "</td>";
			html += "</tr>";
			html += "</table>";

			curM.select( "idpartida = " + curP.valueBuffer( "idpartida" ) );

			html += "<center><table border=\"0\" cellpadding=\"4\" cellspacing=\"4\" width=\"80%\">";
			html += "<tr>";
			html += "<th></th>";
			html += "<th align=\"right\">Uds.</th>";
			html += "<th align=\"right\">Largo</th>";
			html += "<th align=\"right\">Ancho</th>";
			html += "<th align=\"right\">Alto</th>";
			html += "<th align=\"right\">Parcial</th>";
			html += "</tr>";

			while ( curM.next() ) {

				uds = parseFloat( curM.valueBuffer( "uds" ) );
				largo = parseFloat( curM.valueBuffer( "largo" ) );
				ancho = parseFloat( curM.valueBuffer( "ancho" ) );
				alto = parseFloat( curM.valueBuffer( "alto" ) );

				html += "<tr>";
				html += "<td>" + curM.valueBuffer( "comentario" ) + "</td>";
				html += "<td align=\"right\">" + ( uds ? util.buildNumber( uds, "f", 2 ) : "" ) + "</td>";
				html += "<td align=\"right\">" + ( largo ? util.buildNumber( largo, "f", 2 ) : "" ) + "</td>";
				html += "<td align=\"right\">" + ( ancho ? util.buildNumber( ancho, "f", 2 ) : "" ) + "</td>";
				html += "<td align=\"right\">" + ( alto ? util.buildNumber( alto, "f", 2 ) : "" ) + "</td>";
				html += "<td align=\"right\">" + util.buildNumber( curM.valueBuffer( "total" ), "f", 2 ) + "</td>";
				html += "</tr>";

			}

			util.setProgress( ++steps );
			util.setLabelText( "Partida " + curP.valueBuffer( "codpropartida" ) );

			html += "<tr>";
			html += "<td></td>";
			html += "<td></td>";
			html += "<td></td>";
			html += "<td></td>";
			html += "<td align=\"right\">TOTAL : </td>";
			html += "<td align=\"right\"><b>" + util.buildNumber( curP.valueBuffer( "cantidad" ), "f", 2 ) + "</b></td>";
			html += "</tr>";

			html += "</table></center><br><br>";
		}

		contadorP = 0;
	}

	html += "<hr color=\"#000000\"><br><br>";

	util.destroyProgressDialog();

	return html;
}

function oficial_obtenerHtmlElementos() {
	var util:FLUtil = new FLUtil();
	var html:String;
	var codProyecto:String = this.child( "fdbCodProyecto" ).editor().text;
	var cantidad:Number;
	var precio:Number;
	var descripcion:String;
	var steps:Number = 0;

	html = "<h4>SERVICIOS Y APLICACIONES INEL</h4>";
	html += "<h4>LISTA DE ELEMENTOS</h4>";

	var qry:FLSqlQuery = new FLSqlQuery();

	qry.setTablesList( "premed_proyectos,premed_procapitulos,premed_propartidas,premed_prodescomposicion" );
	qry.setSelect( "des.referencia,des.codunidad,des.resumen,des.descripcion,des.precio,SUM(des.cantidad)");
	qry.setFrom( "premed_proyectos pro inner join premed_procapitulos cap on pro.codproyecto = cap.codproyecto inner join premed_propartidas par on cap.idcapitulo = par.idcapitulo inner join premed_prodescomposicion des on par.idpartida = des.idpartida" );
	qry.setWhere( "pro.codproyecto = '" + codProyecto + "' group by des.referencia,des.resumen,des.descripcion,des.precio,des.codunidad" );

	try { qry.setForwardOnly( true ); } catch (e) {}

	if (!qry.exec())
		return;

	util.createProgressDialog( "Generando Lista de Elementos", qry.size() );

	html += "<hr color=\"#000000\"><br><br>";

	while ( qry.next() ) {

		util.setProgress( ++steps );
		util.setLabelText( "Elemento " + qry.value( 0 ) );

		html += "<center><table border=\"0\" cellpadding=\"2\" cellspacing=\"2\" width=\"90%\">";
		html += "<tr>";
		html += "<td>" + qry.value( 0 ) + "</td>";
		html += "<td align=\"center\" width=\"75%\">" + qry.value( 2 ) + "</td>";
		html += "<td align=\"right\">( " + qry.value( 1 ) + " )</td>";
		html += "<td align=\"right\">" + util.buildNumber( qry.value( 4 ), "f", 2 ) + "</td>";
		html += "</tr>";

		descripcion = qry.value( 3 );

		if ( !descripcion.isEmpty() ) {
			html += "<tr>";
			html += "<td></td>";
			html += "<td align=\"justify\" colspan=\"2\">" + descripcion + "</td>";
			html += "<td></td>";
			html += "</tr>";
		}

		html += "</table></center>";

		html += "<center><table border=\"0\" cellpadding=\"4\" cellspacing=\"4\" width=\"80%\">";
		html += "<tr>";
		html += "<th align=\"right\">Cant. en Presupuesto</th>";
		html += "<th align=\"right\">Precio</th>";
		html += "<th align=\"right\">Total en Presupuesto</th>";
		html += "</tr>";

		cantidad = parseFloat( qry.value(5) );
		precio = parseFloat( qry.value(4) );

		html += "<tr>";
		html += "<td align=\"right\">" + util.buildNumber( cantidad, "f", 2 ) + "</td>";
		html += "<td align=\"right\">" + util.buildNumber( precio, "f", 2 ) + "</td>";
		html += "<td align=\"right\">" + util.buildNumber( cantidad * precio, "f", 2 ) + "</td>";
		html += "</tr>";
		html += "</table></center>";

		html += "<hr color=\"#000000\"><br><br>";
	}

	util.destroyProgressDialog();

	return html;
}

function oficial_imprimirTedOut() {
	if ( this.iface.tedOut.text.isEmpty() )
		return;

	sys.printTextEdit( this.iface.tedOut );
}

function oficial_importarPresupuesto() {
	var util:FLUtil = new FLUtil();
	var curTempC:FLSqlCursor = new FLSqlCursor( "premed_tempc" );
	var curTempD:FLSqlCursor = new FLSqlCursor( "premed_tempd" );
	var totalSteps:Number;

	this.iface.stepsImport = 0;

	curTempC.select();
	curTempD.select();
	totalSteps = ( curTempC.size() + curTempD.size() ) / 2;

	util.createProgressDialog( "Importando Presupuesto", totalSteps );
	util.setProgress( this.iface.stepsImport++ );

	this.iface.importarCapitulos();

	util.setProgress( totalSteps );
	util.destroyProgressDialog();

	this.iface.tdbCapitulos.refresh();
	this.iface.tdbPartidas.refresh();
	this.iface.tdbDescom.refresh();
	this.iface.actualizarLblMediPar();
	this.iface.actualizarLblMediDes();
	this.iface.actualizarFdbCoste();
}

function oficial_importarCapitulos() {
	var util:FLUtil = new FLUtil();
	var curTempC:FLSqlCursor = new FLSqlCursor( "premed_tempc" );
	var cur:FLSqlCursor = new FLSqlCursor( "premed_procapitulos" );
	var codProyecto:String = this.child( "fdbCodProyecto" ).editor().text;
	var cod:String;
	var idC:Number;

	curTempC.select( "tipoc = 3" );

	while ( curTempC.next() ) {

		if ( !curTempC.isNull( "codigo" ) ) {
			cod = curTempC.valueBuffer( "codigo" );

			if ( !cod.isEmpty() ) {
				util.setLabelText( "Importando Capítulo : " + cod );

				cur.setModeAccess( cur.Insert );
				cur.refreshBuffer();

				idC = cur.valueBuffer( "idcapitulo" );

				cur.setValueBuffer( "codproyecto", codProyecto );
				cur.setValueBuffer( "codcapitulo", cod );
				cur.setValueBuffer( "resumen", curTempC.valueBuffer( "resumen" ) );
				cur.setValueBuffer( "descripcion", curTempC.valueBuffer( "descripcion" ) );
				if ( cur.commitBuffer() ) {
					this.iface.importarPartidas( cod, idC );
					formRecordpremed_procapitulos.iface.pub_actualizarCapitulo( idC );
				}
			}
		}

	}
}

function oficial_importarPartidas( cod:String, idC:Number ) {
	var util:FLUtil = new FLUtil();
	var cur:FLSqlCursor = new FLSqlCursor( "premed_propartidas" );
	var codP:String;
	var idP:Number;
	var qry:FLSqlQuery = new FLSqlQuery();

	qry.setTablesList( "premed_tempc,premed_tempd" );
	qry.setSelect( "c.codigo,d.cantidad,c.codunidad,c.resumen,c.precio,c.descripcion");
	qry.setFrom( "premed_tempd d inner join premed_tempc c on d.codhijo = c.codigo" );
	qry.setWhere( "d.codpadre = '" + cod + "'" );

	try { qry.setForwardOnly( true ); } catch ( e ) {}

	if ( !qry.exec() )
		return;

	while ( qry.next() ) {

		codP = qry.value( 0 );

		if ( !codP.isEmpty() ) {
				util.setLabelText( "Importando Partida : " + codP );

				cur.setModeAccess( cur.Insert );
				cur.refreshBuffer();

				idP = cur.valueBuffer( "idpartida" );

				cur.setValueBuffer( "idcapitulo", idC );
				cur.setValueBuffer( "codpropartida", codP );
				cur.setValueBuffer( "cantidad", qry.value( 1 ) );
				cur.setValueBuffer( "codunidad", qry.value( 2 ) );
				cur.setValueBuffer( "resumen", qry.value( 3 ) );
				cur.setValueBuffer( "precio", qry.value( 4 ) );
				cur.setValueBuffer( "descripcion", qry.value( 5 ) );
				if ( cur.commitBuffer() ) {
					this.iface.importarDescomp( codP, idP );
					formRecordpremed_propartidas.iface.pub_actualizarPartida( idP );
				}
		}
	}
}

function oficial_importarDescomp( cod:String, idP:Number ) {
	var util:FLUtil = new FLUtil();
	var cur:FLSqlCursor = new FLSqlCursor( "premed_prodescomposicion" );
	var codD:String;
	var idD:Number;
	var qry:FLSqlQuery = new FLSqlQuery();

	qry.setTablesList( "premed_tempc,premed_tempd" );
	qry.setSelect( "c.codigo,d.cantidad,c.codunidad,c.resumen,c.precio,c.descripcion");
	qry.setFrom( "premed_tempd d inner join premed_tempc c on d.codhijo = c.codigo" );
	qry.setWhere( "d.codpadre = '" + cod + "' and c.codigo<>'%'" );

	try { qry.setForwardOnly( true ); } catch ( e ) {}

	if ( !qry.exec() )
		return;

	while ( qry.next() ) {

		codD = qry.value( 0 );

		if ( !codD.isEmpty() ) {
				util.setLabelText( "Importando Descomposicion : " + codD );

				cur.setModeAccess( cur.Insert );
				cur.refreshBuffer();

				idD = cur.valueBuffer( "iddescomp" );

				cur.setValueBuffer( "idpartida", idP );
				cur.setValueBuffer( "referencia", codD );
				cur.setValueBuffer( "cantidad", qry.value( 1 ) );
				cur.setValueBuffer( "codunidad", qry.value( 2 ) );
				cur.setValueBuffer( "resumen", qry.value( 3 ) );
				cur.setValueBuffer( "precio", qry.value( 4 ) );
				cur.setValueBuffer( "descripcion", qry.value( 5 ) );
				cur.commitBuffer();
		}

		util.setProgress( this.iface.stepsImport++ );
		formRecordpremed_prodescomposicion.iface.pub_actualizarDescomp( idD );

	}
}

function oficial_conectar() {
	if ( !this.iface.conectado ) {
		connect( this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged" );

		connect( this.iface.tdbCapitulos.cursor(), "newBuffer()", this, "iface.actualizarFdbCapitulo()" );
		connect( this.iface.tdbPartidas.cursor(), "newBuffer()", this, "iface.actualizarFdbPartida()" );
		connect( this.iface.tdbDescom.cursor(), "newBuffer()", this, "iface.actualizarFdbDescom()" );

		connect( this.iface.tdbCapitulos.cursor(), "bufferCommited()", this, "iface.actualizarCostes()" );
		connect( this.iface.tdbPartidas.cursor(), "bufferCommited()", this, "iface.actualizarCostes()" );
		connect( this.iface.tdbDescom.cursor(), "bufferCommited()", this, "iface.actualizarCostes()" );
		connect( this.iface.tdbMediPar.cursor(), "bufferCommited()", this, "iface.actualizarCostes()" );
		connect( this.iface.tdbMediDes.cursor(), "bufferCommited()", this, "iface.actualizarCostes()" );

		connect( this.child( "pbSimple" ), "clicked()", this, "iface.actualizarTedOutSimple()");
		connect( this.child( "pbDescomp" ), "clicked()", this, "iface.actualizarTedOutDescomp()");
		connect( this.child( "pbMediciones" ), "clicked()", this, "iface.actualizarTedOutMediciones()");
		connect( this.child( "pbElementos" ), "clicked()", this, "iface.actualizarTedOutElementos()");
		connect( this.child( "pbImprimir" ), "clicked()", this, "iface.imprimirTedOut()");
		connect( this.child( "pbImportar" ), "clicked()", this, "iface.importarPresupuesto()");

		this.iface.conectado = true;
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////