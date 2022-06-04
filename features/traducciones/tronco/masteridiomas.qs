/***************************************************************************
                 masteridiomas.qs  -  description
                             -------------------
    begin                : lun abr 11 2011
    copyright            : (C) 2011 by InfoSiAL S.L.
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
	function interna( context ) {
		this.ctx = context;
	}
	function init() {
		this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var xmlMultilalg_; // Doc XML que contiene el fichero multilang de traduccions
	var codIsoPrevio_; // C�digo de idioma previamente tratado
	var cacheMessages_; // Array con los mensajes de un contexto
	var aCaracteres_; // Array con la correspondencia entre caracteres y su referencia de entidad (Latin 1) http://www.htmlquick.com/es/reference/character-entity-reference.html

	function oficial( context ) { interna( context ); } 
	function tbnTraducirModulos_clicked() {
		return this.ctx.oficial_tbnTraducirModulos_clicked();
	}
	function traducirModulo(idModulo) {
		return this.ctx.oficial_traducirModulo(idModulo);
	}
	function incluirMensajes(contenido, codIso) {
		return this.ctx.oficial_incluirMensajes(contenido, codIso);
	}
	function procesarTexto(texto) {
		return this.ctx.oficial_procesarTexto(texto);
	}
	function cargaMensajesContexto(eContext) {
		return this.ctx.oficial_cargaMensajesContexto(eContext);
	}
	function dameNodoMessage(eContext, texto) {
		return this.ctx.oficial_dameNodoMessage(eContext, texto);
	}
	function buscaNodoContexto(codIso) {
		return this.ctx.oficial_buscaNodoContexto(codIso);
	}
	function dameNodoContexto(codIsoCompleto) {
		return this.ctx.oficial_dameNodoContexto(codIsoCompleto);
	}
	function cargaCaracteres() {
		return this.ctx.oficial_cargaCaracteres();
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
	this.iface.cargaCaracteres();
	connect(this.child("tbnTraducirModulos"), "clicked()", this, "iface.tbnTraducirModulos_clicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnTraducirModulos_clicked()
{
	var util = new FLUtil;
	var res = MessageBox.warning(util.translate("scripts", "Va a actualizar los ficheros de traducci�n multilang asociados a todos los m�dulos.\n�Est� seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}
	var qryMods = new FLSqlQuery;
	qryMods.setTablesList("flmodules,flareas");
	qryMods.setSelect("m.idmodulo, m.descripcion, a.descripcion");
	qryMods.setFrom("flmodules m INNER JOIN flareas a ON m.idarea = a.idarea");
	qryMods.setWhere("m.bloqueo = true");
	qryMods.setForwardOnly(true);
	if (!qryMods.exec()) {
		return false;
	}
	var idModulo, modulo, area;
	util.createProgressDialog(util.translate("scripts", "Actualizando multilang en m�dulos..."), qryMods.size());
	var paso = 0;
	while (qryMods.next()) {
		util.setProgress(++paso);
		idModulo = qryMods.value("m.idmodulo");
		modulo = qryMods.value("m.descripcion");
		area = qryMods.value("a.descripcion");
		if (!this.iface.traducirModulo(idModulo)) {
			util.destroyProgressDialog();
			MessageBox.warning(util.translate("scripts", "Error al traducir el m�dulo %1 de %2").arg(modulo).arg(area), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	util.destroyProgressDialog();
	MessageBox.warning(util.translate("scripts", "Los ficheros multilang se han actualizado correctamente "), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_traducirModulo(idModulo)
{
debug("Modulo " + idModulo);
	var util = new FLUtil;
	
	var qryIdiomas = new FLSqlQuery;
	qryIdiomas.setTablesList("idiomas");
	qryIdiomas.setSelect("codidioma, codiso");
	qryIdiomas.setFrom("idiomas");
	qryIdiomas.setWhere("1 = 1");
	qryIdiomas.setForwardOnly(true);
	if (!qryIdiomas.exec()) {
		return false;
	}
	
	var codIdioma, codIso, nombre, fileMultilang;
	nombre = idModulo + ".multilang.ts";
	fileMultilang = util.sqlSelect("flfiles", "contenido", "idmodulo = '" + idModulo + "' AND nombre = '" + nombre + "'");
//debug("fileMultilang " + fileMultilang);
	if (this.iface.xmlMultilalg_) {
		delete this.iface.xmlMultilalg_;
	}
	this.iface.xmlMultilalg_ = new FLDomDocument;
	if (!this.iface.xmlMultilalg_.setContent(fileMultilang ? fileMultilang : "<!DOCTYPE TS><TS/>")) {
		debug("Fallo setcontent");
		return false;
	}
debug(qryIdiomas.size());
	this.iface.codIsoPrevio_ = false;
	while (qryIdiomas.next()) {
//	var cursor = this.cursor();
		codIdioma = qryIdiomas.value("codidioma");
		codIso = qryIdiomas.value("codiso");
		if (!codIso || codIso == "") {
			MessageBox.warning(util.translate("scripts", "Debe establecer el c�digo ISO del idioma %1").arg(codIdioma), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	
		var qryFile = new FLSqlQuery;
		qryFile.setTablesList("flfiles");
		qryFile.setSelect("nombre, contenido");
		qryFile.setFrom("flfiles");
		qryFile.setWhere("idmodulo = '" + idModulo + "' AND UPPER(nombre) LIKE '%.KUT'");
		qryFile.setForwardOnly(true);
		if (!qryFile.exec()) {
			return false; 
		}
		var contenido;
		if (qryFile.size() == 0) {
			return true;
		}
		while (qryFile.next()) {
			contenido = qryFile.value("contenido");
			if (!this.iface.incluirMensajes(contenido, codIso)) {
				return false;
			}
		}
	}
	
	debug(this.iface.xmlMultilalg_.toString(4));
	File.write("/home/arodriguez/tmp/tmp/" + nombre, this.iface.xmlMultilalg_.toString(4));
	var curFileMultilang = new FLSqlCursor("flfiles");
	curFileMultilang.select("nombre = '" + nombre + "'");
	if (curFileMultilang.first()) {
		curFileMultilang.setModeAccess(curFileMultilang.Edit);
		curFileMultilang.refreshBuffer();
	} else {
		curFileMultilang.setModeAccess(curFileMultilang.Insert);
		curFileMultilang.refreshBuffer();
		curFileMultilang.setValueBuffer("idmodulo", idModulo);
		curFileMultilang.setValueBuffer("nombre", nombre);
	}
	contenido = this.iface.xmlMultilalg_.toString(4);
	var sha = util.sha1(contenido);
	curFileMultilang.setValueBuffer("contenido", contenido);
	curFileMultilang.setValueBuffer("sha", sha);
	if (!curFileMultilang.commitBuffer()) {
		return false;
	}
	
	return true;
}

function oficial_incluirMensajes(contenido, codIso)
{
	var eRaiz = this.iface.xmlMultilalg_.namedItem("TS");
	if (!eRaiz) {
		return false;
	}
	var eContext = this.iface.buscaNodoContexto(codIso);
	if (!eContext) {
		return false;
	}
	if (codIso != this.iface.codIsoPrevio_) {
		if (!this.iface.cargaMensajesContexto(eContext)) {
			return false;
		}
		this.iface.codIsoPrevio_ = codIso;
	}
	var xmlSource = new FLDomDocument;
	var lista;
	if (!xmlSource.setContent(contenido)) {
		return false;
	}
	lista = xmlSource.elementsByTagName("Label");
	if (!lista) {
		return true;
	}
	var eLabel, texto, eMensaje, existe;
	for (var i = 0; i < lista.length(); i++) {
		eLabel = lista.item(i).toElement();
		texto = eLabel.attribute("Text");
		texto = this.iface.procesarTexto(texto);
		try {
			existe = this.iface.cacheMessages_[texto];
		} catch (e) {
			existe = false;
		}
// 		if (this.iface.existeEnContexto(eContext, texto)) {
// 			continue;
// 		}
		eMensaje = this.iface.dameNodoMessage(eContext, texto)
		if (!eMensaje) {
			return false;
		}
	}
	return true;
}

function oficial_procesarTexto(texto)
{
	var util = new FLUtil;
	texto = util.utf8(texto);
//	for (var i = 0; i < this.iface.aCaracteres_.length; i++) {
//		while (texto.find(this.iface.aCaracteres_[i][0]) >= 0) {
//			texto = texto.replace(this.iface.aCaracteres_[i][0], this.iface.aCaracteres_[i][1]);
//		}
//	}
	return texto;
}

function oficial_cargaMensajesContexto(eContext)
{
	this.iface.cacheMessages_ = [];
	var lista = eContext.elementsByTagName("message");
	if (!lista) {
		return true;
	}
	var eMessage, eSource;
	for (var i = 0; i < lista.length(); i++) {
		eMessage = lista.item(i);
		eSource = eMessage.namedItem("source");
		if (!eSource) {
			return false;
		}
		this.iface.cacheMessages_[eSource.firstChild().nodeValue()] = true;
	}

	return true;
}

function oficial_dameNodoMessage(eContext, texto)
{
	var eMensaje = this.iface.xmlMultilalg_.createElement("message");
	eMensaje.setAttribute("encoding", "UTF-8");
	eContext.appendChild(eMensaje);
	var eSource = this.iface.xmlMultilalg_.createElement("source");
	eMensaje.appendChild(eSource);
	var tTexto = this.iface.xmlMultilalg_.createTextNode(texto);
	eSource.appendChild(tTexto);
	var eTranslation = this.iface.xmlMultilalg_.createElement("translation");
	eMensaje.appendChild(eTranslation);
	eTranslation.setAttribute("type", "unfinished");
	return eMensaje;	
}

function oficial_buscaNodoContexto(codIso)
{
	var codIsoCompleto = codIso.toUpperCase() + "_MULTILANG";
	var eContext, nodoName;
	var lista = this.iface.xmlMultilalg_.namedItem("TS").toElement().elementsByTagName("context");
	if (!lista) {
		eContext = this.iface.dameNodoContexto(codIsoCompleto);
		return eContext;
	}
	for (var i = 0; i < lista.length(); i++) {
		eContext = lista.item(i).toElement();
		nodoName = eContext.namedItem("name");
		if (!nodoName) {
			return false;
		}
		var nombreContexto = nodoName.firstChild().nodeValue();
		if (nombreContexto && nombreContexto.toUpperCase() == codIsoCompleto) {
			return eContext;
		}
	}
	eContext = this.iface.dameNodoContexto(codIsoCompleto);
	return eContext;
}

function oficial_dameNodoContexto(codIsoCompleto)
{
	debug("codIsoCompleto " + codIsoCompleto);
	var eContext = this.iface.xmlMultilalg_.createElement("context");
	this.iface.xmlMultilalg_.namedItem("TS").appendChild(eContext);
	var eName = this.iface.xmlMultilalg_.createElement("name");
	eContext.appendChild(eName);
	var tName = this.iface.xmlMultilalg_.createTextNode(codIsoCompleto);
	eName.appendChild(tName);
	return eContext;	
}

function oficial_cargaCaracteres()
{
	this.iface.aCaracteres_ = [["�", "&#xa1;"],
["�", "&#xa2;"],
["�", "&#xa3;"],
["?", "&#xa4;"],
["�", "&#xa5;"],
["?", "&#xa6;"],
["�", "&#xa7;"],
["?", "&#xa8;"],
["�", "&#xa9;"],
["�", "&#xaa;"],
["�", "&#xab;"],
["�", "&#xac;"],
["�", "&#xad;"],
["�", "&#xae;"],
["�", "&#xaf;"],
["�", "&#xb0;"],
["�", "&#xb1;"],
["�", "&#xb2;"],
["�", "&#xb3;"],
["?", "&#xb4;"],
["�", "&#xb5;"],
["�", "&#xb6;"],
["�", "&#xb7;"],
["?", "&#xb8;"],
["�", "&#xb9;"],
["�", "&#xba;"],
["�", "&#xbb;"],
["?", "&#xbc;"],
["?", "&#xbd;"],
["?", "&#xbe;"],
["�", "&#xbf;"],
["�", "&#xc0;"],
["�", "&#xc1;"],
["�", "&#xc2;"],
["�", "&#xc3;"],
["�", "&#xc4;"],
["�", "&#xc5;"],
["�", "&#xc6;"],
["�", "&#xc7;"],
["�", "&#xc8;"],
["�", "&#xc9;"],
["�", "&#xca;"],
["�", "&#xcb;"],
["�", "&#xcc;"],
["�", "&#xcd;"],
["�", "&#xce;"],
["�", "&#xcf;"],
["�", "&#xd0;"],
["�", "&#xd1;"],
["�", "&#xd2;"],
["�", "&#xd3;"],
["�", "&#xd4;"],
["�", "&#xd5;"],
["�", "&#xd6;"],
["�", "&#xd7;"],
["�", "&#xd8;"],
["�", "&#xd9;"],
["�", "&#xda;"],
["�", "&#xdb;"],
["�", "&#xdc;"],
["�", "&#xdd;"],
["�", "&#xde;"],
["�", "&#xdf;"],
["�", "&#xe0;"],
["�", "&#xe1;"],
["�", "&#xe2;"],
["�", "&#xe3;"],
["�", "&#xe4;"],
["�", "&#xe5;"],
["�", "&#xe6;"],
["�", "&#xe7;"],
["�", "&#xe8;"],
["�", "&#xe9;"],
["�", "&#xea;"],
["�", "&#xeb;"],
["�", "&#xec;"],
["�", "&#xed;"],
["�", "&#xee;"],
["�", "&#xef;"],
["�", "&#xf0;"],
["�", "&#xf1;"],
["�", "&#xf2;"],
["�", "&#xf3;"],
["�", "&#xf4;"],
["�", "&#xf5;"],
["�", "&#xf6;"],
["�", "&#xf7;"],
["�", "&#xf8;"],
["�", "&#xf9;"],
["�", "&#xfa;"],
["�", "&#xfb;"],
["�", "&#xfc;"],
["�", "&#xfd;"],
["�", "&#xfe;"],
["�", "&#xff;"]]
}

//function oficial_dameNodoContexto(codIsoCompleto)
//{
//	var eContext = this.iface.xmlMultilalg_.createElement("context");
//	this.iface.xmlMultilalg_.appendChild(eContext);
//	var eName= this.iface.xmlMultilalg_.createElement("name");
//	eContext.appendChild(eName);
//	eContext.firstChild().setNodeValue(codIsoCompleto);
//	return eContext;	
//}

// function oficial_existeEnContexto(eContext, texto)
// {
// 	
// }
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
