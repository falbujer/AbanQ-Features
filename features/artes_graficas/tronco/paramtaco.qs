/***************************************************************************
                 paramtaco.qs  -  description
                             -------------------
    begin                : vie dic 03 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
	function init() {
		return this.ctx.interna_init();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var xmlParam_:FLDomDocument;
	var xmlPrecortes_:FLDomDocument;
	var xmlPrecorteActual_:FLDomNode;
	var xmlTPOs_:FLDomDocument;
	var xmlTPOActual_:FLDomNode;
	var xmlTPMSs_:FLDomDocument;
	var xmlTPMSActual_:FLDomNode;
    
// 	var curCantidades_:FLSqlCursor;
	var curColores_:FLSqlCursor;
	var cantidad:Number;
    function oficial( context ) { interna( context ); }
	function cargarDatos() {
		return this.ctx.oficial_cargarDatos();
	}
// 	function cargarDiseno(eDiseno:FLDomElement):Boolean {
// 		return this.ctx.oficial_cargarDiseno(eDiseno);
// 	}
// 	function cargarAreaT(eAreaT:FLDomElement):Boolean {
// 		return this.ctx.oficial_cargarAreaT(eAreaT);
// 	}
// 	function cargarSangria(eSangria:FLDomElement):Boolean {
// 		return this.ctx.oficial_cargarSangria(eSangria);
// 	}
	function habilitarPorSangria() {
		return this.ctx.oficial_habilitarPorSangria();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function tbnPrecorte_clicked() {
		return this.ctx.oficial_tbnPrecorte_clicked();
	}
	function cargarPrecortes():Boolean {
		return this.ctx.oficial_cargarPrecortes();
	}
	function tbnTPO_clicked() {
		return this.ctx.oficial_tbnTPO_clicked();
	}
	function cargarTPOs():Boolean {
		return this.ctx.oficial_cargarTPOs();
	}
	function tbnTPMS_clicked() {
		return this.ctx.oficial_tbnTPMS_clicked();
	}
	function cargarTPMSs():Boolean {
		return this.ctx.oficial_cargarTPMSs();
	}
	function tbnBorrarPrecorte_clicked() {
		return this.ctx.oficial_tbnBorrarPrecorte_clicked();
	}
	function tbnBorrarTPO_clicked() {
		return this.ctx.oficial_tbnBorrarTPO_clicked();
	}
	function tbnBorrarTPMS_clicked() {
		return this.ctx.oficial_tbnBorrarTPMS_clicked();
	}
	function mostrarPrecorte() {
		return this.ctx.oficial_mostrarPrecorte();
	}
	function mostrarTPO() {
		return this.ctx.oficial_mostrarTPO();
	}
	function mostrarTPMS() {
		return this.ctx.oficial_mostrarTPMS();
	}
	function guardarDatos(cursor:FLSqlCursor):FLDomDocument {
		return this.ctx.oficial_guardarDatos(cursor);
	}
	function guardarDiseno(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarDiseno(nodoParam, cursor);
	}
	function guardarSangrias(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarSangrias(nodoParam, cursor);
	}
	function guardarPapel(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarPapel(nodoParam, cursor);
	}
	function guardarPliegoImpresion(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarPliegoImpresion(nodoParam, cursor);
	}
	function guardarTrabajosPliego(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarTrabajosPliego(nodoParam, cursor);
	}
	function guardarImpresora(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarImpresora(nodoParam, cursor);
	}
	function guardarEstiloImpresion(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarEstiloImpresion(nodoParam, cursor);
	}
	function guardarOtros(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarOtros(nodoParam, cursor);
	}
	function guardarColor(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarColor(nodoParam, cursor);
	}
	function guardarCantidad(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarCantidad(nodoParam, cursor);
	}
	function guardarMaculas(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_guardarMaculas(nodoParam, cursor);
	}
	function crearNodoHijo(nodoPadre:FLDomNode, nombreHijo):FLDomNode {
		return this.ctx.oficial_crearNodoHijo(nodoPadre, nombreHijo);
	}
	function validarDatos(xmlProceso:FLDomNode):Boolean {
		return this.ctx.oficial_validarDatos(xmlProceso);
	}
	function datosImpresoraGral():Array {
		return this.ctx.oficial_datosImpresoraGral();
	}
	function cambiarColor() {
		return this.ctx.oficial_cambiarColor();
	}
	function tbnMasPI_clicked() {
		return this.ctx.oficial_tbnMasPI_clicked();
	}
	function tbnMasPIMS_clicked() {
		return this.ctx.oficial_tbnMasPIMS_clicked();
	}
	function tbnColores_clicked() {
		return this.ctx.oficial_tbnColores_clicked();
	}
	function tbnCantidades_clicked() {
		return this.ctx.oficial_tbnCantidades_clicked();
	}
	function habilitarBotonColor() {
		return this.ctx.oficial_habilitarBotonColor();
	}
	function habilitarPorReferencia() {
		return this.ctx.oficial_habilitarPorReferencia();
	}
	function crearRegistroColor(cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_crearRegistroColor(cursor);
	}
	function ponerPinza():Boolean {
		return this.ctx.oficial_ponerPinza();
	}
	function habilitarMaculas():Boolean {
		return this.ctx.oficial_habilitarMaculas();
	}
	function habilitarEnvio():Boolean {
		return this.ctx.oficial_habilitarEnvio();
	}
	function comprobarRegistroEnvio():Boolean {
		return this.ctx.oficial_comprobarRegistroEnvio();
	}
	function crearRegistroEnvio(cursor:FLSqlCursor, desdeForm:Boolean):Boolean {
		return this.ctx.oficial_crearRegistroEnvio(cursor, desdeForm);
	}
	function establecerFiltroPliego() {
		return this.ctx.oficial_establecerFiltroPliego();
	}
	function habilitarPorTipoTaco() {
		return this.ctx.oficial_habilitarPorTipoTaco();
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
	function pub_guardarDatos(cursor:FLSqlCursor):FLDomDocument {
		return this.guardarDatos(cursor);
	}
	function pub_crearRegistroColor(cursor:FLSqlCursor):Boolean {
		return this.crearRegistroColor(cursor);
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.xmlPrecortes_ = false;
	this.iface.xmlTPOs_ = false;
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("chkSangriasInd"), "clicked()", this, "iface.habilitarPorSangria");
	connect(this.child("tbnPrecorte"), "clicked()", this, "iface.tbnPrecorte_clicked");
	connect(this.child("tbnTPO"), "clicked()", this, "iface.tbnTPO_clicked");
	connect(this.child("tbnTPMS"), "clicked()", this, "iface.tbnTPMS_clicked");
	connect(this.child("tbnBorrarPrecorte"), "clicked()", this, "iface.tbnBorrarPrecorte_clicked");
	connect(this.child("tbnBorrarTPO"), "clicked()", this, "iface.tbnBorrarTPO_clicked");
	connect(this.child("tbnBorrarTPMS"), "clicked()", this, "iface.tbnBorrarTPMS_clicked");
	
	connect(this.child("tbnMasPI"), "clicked()", this, "iface.tbnMasPI_clicked");
	connect(this.child("tbnMasPIMS"), "clicked()", this, "iface.tbnMasPIMS_clicked");
	connect(this.child("tbnColores"), "clicked()", this, "iface.tbnColores_clicked");

	this.child("fdbIdImpresora").setFilter("tipoag = 'Impresora'");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
debug("Insert");
			var idProducto:String = formRecordlineaspresupuestoscli.iface.idProductoSel_;
			if (!idProducto) {
				MessageBox.warning(util.translate("scripts", "No tiene ning�n producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
				this.close();
			}
			if (util.sqlSelect("paramtaco", "id", "idproducto = " + idProducto)) {
				MessageBox.warning(util.translate("scrpts", "Ya hay un registro de par�metros para el producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
				this.close();
			}
			cursor.setValueBuffer("idproducto", idProducto);
			this.iface.cambiarColor();
			break;
		}
		case cursor.Edit: {
debug("Edit");
			this.iface.cargarDatos();
			if (!util.sqlSelect("paramcolor", "id", "idparamtaco = " + cursor.valueBuffer("id"))) {
				this.iface.cambiarColor();
			}
			break;
		}
	}
	
	this.iface.establecerFiltroPliego();
	this.iface.habilitarPorSangria();
	this.iface.habilitarPorTipoTaco();
	this.iface.habilitarBotonColor();
	this.iface.habilitarPorReferencia();
	this.iface.habilitarMaculas();
	this.iface.habilitarEnvio();
	
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "capas": {
			var capas:Number = 0;
			var refCapa:String;
			for (var i:Number = 0; i < 4; i++) {
				refCapa = cursor.valueBuffer("papel" + i.toString());
				if (refCapa && refCapa != "") {
					capas++;
				}
			}
			valor = capas;
			break;
		}
	}
	return valor;
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var xmlDocParam:FLDomDocument = this.iface.guardarDatos(cursor);
	if (!xmlDocParam) {
		return false;
	}

	if (!this.iface.comprobarRegistroEnvio()) {
		MessageBox.warning(util.translate("scripts", "Error al comprobar los datos de env�o"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
debug(xmlDocParam.toString());

	if (!this.iface.validarDatos(xmlDocParam.firstChild())) {
		return false;
	}

	cursor.setValueBuffer("xml", xmlDocParam.toString());

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnMasPI_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (!this.iface.xmlTPOActual_) {
		MessageBox.warning(util.translate("scripts", "No hay una distribuci�n seleccionada"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	var xmlDocParam:FLDomDocument = this.iface.guardarDatos(cursor);
	if (!xmlDocParam) {
		return false;
	}

	var idUsuario = sys.nameUser();
	if (!util.sqlDelete("parampliego", "idusuario = '" + idUsuario + "'")) {
		return false;
	}

	var parametros:String = xmlDocParam.toString(4);

	var f:Object = new FLFormSearchDB("parampliego");
	var curPP:FLSqlCursor = f.cursor();
	
	curPP.setModeAccess(curPP.Insert);
	curPP.refreshBuffer();
	curPP.setValueBuffer("idusuario", idUsuario);
	curPP.setValueBuffer("xml", parametros);
	curPP.setValueBuffer("altopi", cursor.valueBuffer("altopi"));
	curPP.setValueBuffer("anchopi", cursor.valueBuffer("anchopi"));

	f.setMainWidget();
	var xml:String = f.exec("xml");
}

function oficial_tbnMasPIMS_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (!this.iface.xmlTPMSActual_) {
		MessageBox.warning(util.translate("scripts", "No hay una distribuci�n seleccionada"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	var xmlDocParam:FLDomDocument = this.iface.guardarDatos(cursor);
	if (!xmlDocParam) {
		return false;
	}

	var idUsuario = sys.nameUser();
	if (!util.sqlDelete("parampliego", "idusuario = '" + idUsuario + "'")) {
		return false;
	}

	var parametros:String = xmlDocParam.toString(4);

	var f:Object = new FLFormSearchDB("parampliego");
	var curPP:FLSqlCursor = f.cursor();
	
	curPP.setModeAccess(curPP.Insert);
	curPP.refreshBuffer();
	curPP.setValueBuffer("idusuario", idUsuario);
	curPP.setValueBuffer("xml", parametros);
	curPP.setValueBuffer("altopi", cursor.valueBuffer("altopi"));
	curPP.setValueBuffer("anchopi", cursor.valueBuffer("anchopi"));

	f.setMainWidget();
	var xml:String = f.exec("xml");
}

function oficial_cargarDatos()
{
	var cursor:FLSqlCursor = this.cursor();
	var xmlParam:FLDomDocument = new FLDomDocument;
	if (!xmlParam.setContent(cursor.valueBuffer("xml"))) {
		return;
	}

	var xmlAux:FLDomNode;
	var xmlElemento:FLDomElement;
	var nodoParam:FLDomNode = xmlParam.firstChild();

	xmlElemento = nodoParam.namedItem("PliegoImpresionParam");
	if (xmlElemento && xmlElemento.toElement().attribute("Corte") != "") {
		this.iface.xmlPrecortes_ = new FLDomDocument;
		this.iface.xmlPrecortes_.setContent("<Precortes/>");
		this.iface.xmlPrecortes_.firstChild().appendChild(xmlElemento.cloneNode());
		this.iface.xmlPrecorteActual_ = this.iface.xmlPrecortes_.firstChild().firstChild();
		this.iface.mostrarPrecorte();
		this.child("tbnPrecorte").enabled = false;
	}

	xmlElemento = nodoParam.namedItem("TrabajosPliegoParam");
	if (xmlElemento) {
		if (xmlElemento.toElement().attribute("EjeSim") == "V" || xmlElemento.toElement().attribute("EjeSim") == "H") {
			this.iface.xmlTPMSs_ = new FLDomDocument;
			this.iface.xmlTPMSs_.setContent("<TrabajosPliegoVar/>");
			this.iface.xmlTPMSs_.firstChild().appendChild(xmlElemento.cloneNode());
			this.iface.xmlTPMSActual_ = this.iface.xmlTPMSs_.firstChild().firstChild();
			this.iface.mostrarTPMS();
			this.child("tbnTPMS").enabled = false;
		} else {
			this.iface.xmlTPOs_ = new FLDomDocument;
			this.iface.xmlTPOs_.setContent("<TrabajosPliegoVar/>");
			this.iface.xmlTPOs_.firstChild().appendChild(xmlElemento.cloneNode());
			this.iface.xmlTPOActual_ = this.iface.xmlTPOs_.firstChild().firstChild();
			this.iface.mostrarTPO();
			this.child("tbnTPO").enabled = false;
		}
	}
}

function oficial_cargarCantidades():Boolean
{
debug("oficial_cargarCantidades");
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var xmlParam:FLDomDocument = new FLDomDocument;
	if (!xmlParam.setContent(contenido)) {
		return;
	}
	var xmlAux:FLDomNode;
	var xmlElemento:FLDomElement;
	var nodoPaginas:FLDomNode = xmlParam.namedItem("PaginasParam");

	xmlElemento = nodoPaginas.toElement()
	if (xmlElemento) {
		this.child("fdbNumPaginas").setValue(xmlElemento.attribute("NumPaginas"));
		this.child("fdbNumCopias").setValue(xmlElemento.attribute("NumCopias"));
		this.child("fdbCanTaco").setValue(xmlElemento.attribute("CanTaco"));
// 		this.child("fdbJuegos").setValue((xmlElemento.attribute("Juegos") == true));
	}
	return true;
}

function oficial_cambiarColor()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var dosCaras:Boolean;
	var colores:String = cursor.valueBuffer("colores");
debug("Colores ");
	switch (colores) {
		case "1+1":
		case "4+4": {
			dosCaras = true;
			if (!this.iface.crearRegistroColor(cursor)) {
				return false;
			}
			break;
		}
		case "1+0":
		case "4+0": {
			dosCaras = false;
			if (!this.iface.crearRegistroColor(cursor)) {
				return false;
			}
			break;
		}
		case "Otros": {
			break;
		}
	}

	this.child("fdbDosCaras").setValue(dosCaras);
	this.iface.habilitarBotonColor();
}

function oficial_crearRegistroColor(cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var dosCaras:Boolean;
	var colores:String = cursor.valueBuffer("colores");
	var curColores:FLSqlCursor = new FLSqlCursor("paramcolor");
	switch (colores) {
		case "4+4": {
			dosCaras = true;
			if (!util.sqlDelete("paramcolor", "idparamtaco = " + cursor.valueBuffer("id"))) {
				return false;
			}

			curColores.setModeAccess(curColores.Insert);
			curColores.refreshBuffer();
			curColores.setValueBuffer("idparamtaco", cursor.valueBuffer("id"));
			curColores.setValueBuffer("coloresreg", true);
			curColores.setValueBuffer("doscaras", dosCaras);
			curColores.setValueBuffer("colorf1", "Cian");
			curColores.setValueBuffer("colorf2", "Magenta");
			curColores.setValueBuffer("colorf3", "Negro");
			curColores.setValueBuffer("colorf4", "Amarillo");
			curColores.setValueBuffer("colorv1", "Cian");
			curColores.setValueBuffer("colorv2", "Magenta");
			curColores.setValueBuffer("colorv3", "Negro");
			curColores.setValueBuffer("colorv4", "Amarillo");
			xml = formRecordparamcolor.iface.pub_xmlColores(curColores);
			if (!xml) {
				return false;
			}
			curColores.setValueBuffer("xml", xml);
			if (!curColores.commitBuffer()) {
				return false;
			}
			break;
		}
		case "4+0": {
			dosCaras = false;
			if (!util.sqlDelete("paramcolor", "idparamtaco = " + cursor.valueBuffer("id"))) {
				return false;
			}

			curColores.setModeAccess(curColores.Insert);
			curColores.refreshBuffer();
			curColores.setValueBuffer("idparamtaco", cursor.valueBuffer("id"));
			curColores.setValueBuffer("coloresreg", true);
			curColores.setValueBuffer("doscaras", dosCaras);
			curColores.setValueBuffer("colorf1", "Cian");
			curColores.setValueBuffer("colorf2", "Magenta");
			curColores.setValueBuffer("colorf3", "Negro");
			curColores.setValueBuffer("colorf4", "Amarillo");
			xml = formRecordparamcolor.iface.pub_xmlColores(curColores);
			if (!xml) {
				return false;
			}
			curColores.setValueBuffer("xml", xml);
			if (!curColores.commitBuffer()) {
				return false;
			}
			break;
		}
		case "1+1": {
			dosCaras = true;
			if (!util.sqlDelete("paramcolor", "idparamtaco = " + cursor.valueBuffer("id"))) {
				return false;
			}

			curColores.setModeAccess(curColores.Insert);
			curColores.refreshBuffer();
			curColores.setValueBuffer("idparamtaco", cursor.valueBuffer("id"));
			curColores.setValueBuffer("coloresreg", false);
			curColores.setValueBuffer("doscaras", dosCaras);
			curColores.setValueBuffer("colorf1", "Negro");
			curColores.setValueBuffer("colorv1", "Negro");
			xml = formRecordparamcolor.iface.pub_xmlColores(curColores);
			if (!xml) {
				return false;
			}
			curColores.setValueBuffer("xml", xml);
			if (!curColores.commitBuffer()) {
				return false;
			}
			break;
		}
		case "1+0": {
			dosCaras = false;
			if (!util.sqlDelete("paramcolor", "idparamtaco = " + cursor.valueBuffer("id"))) {
				return false;
			}

			curColores.setModeAccess(curColores.Insert);
			curColores.refreshBuffer();
			curColores.setValueBuffer("idparamtaco", cursor.valueBuffer("id"));
			curColores.setValueBuffer("coloresreg", false);
			curColores.setValueBuffer("doscaras", dosCaras);
			curColores.setValueBuffer("colorf1", "Negro");
			xml = formRecordparamcolor.iface.pub_xmlColores(curColores);
			if (!xml) {
				return false;
			}
			curColores.setValueBuffer("xml", xml);
			if (!curColores.commitBuffer()) {
				return false;
			}
			break;
		}
	}
	return true;
}

function oficial_habilitarBotonColor()
{
debug("oficial_habilitarBotonColor");
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var colores:String = cursor.valueBuffer("colores");
	switch (colores) {
		case "4+4":
		case "4+0":
		case "1+1":
		case "1+0": {
			this.child("tbnColores").enabled = false;
			this.child("lblOtrosColores").text = "";
			break;
		}
		default: {
			this.child("tbnColores").enabled = true;
			var otrosColores:String = "";
			var contenidoColor:String = util.sqlSelect("paramcolor", "xml", "idparamtaco = " + cursor.valueBuffer("id"));
			if (contenidoColor) {
				var xmlColor:FLDomDocument = new FLDomDocument;
				if (xmlColor.setContent(contenidoColor)) {
					otrosColores = xmlColor.firstChild().toElement().attribute("Valor");
				}
			}
			this.child("lblOtrosColores").text = otrosColores;
			break;
		}
	}
}

// function oficial_cargarDiseno(eDiseno:FLDomElement):Boolean
// {
// 	var valor:String = eDiseno.attribute("Valor");
// 	if (!valor || valor == "") {
// 		this.child("fdbDiseno").setValue(true);
// 		return true;
// 	} else {
// 		if (valor == "true") {
// 			this.child("fdbDiseno").setValue(true);
// 		} else {
// 			this.child("fdbDiseno").setValue(false);
// 		}
// 	}
// 
// 	var tiempoDiseno:Number = parseFloat(eDiseno.attribute("TiempoUsuario"));
// 	if (isNaN(tiempoDiseno)) {
// 		this.child("fdbTiempoDiseno").setValue("");
// 	} else {
// 		this.child("fdbTiempoDiseno").setValue(tiempoDiseno);
// 	}
// 	return true;
// }

// function oficial_cargarAreaT(eAreaT:FLDomElement):Boolean
// {
// 	var valor:String = eAreaT.attribute("Valor");
// 	if (!valor || valor == "") {
// 		this.child("fdbAnchoT").setValue("");
// 		this.child("fdbAltoT").setValue("");
// 		return true;
// 	}
// 	var dim:Array = valor.split("x");
// 	this.child("fdbAnchoT").setValue(dim[0]);
// 	this.child("fdbAltoT").setValue(dim[1]);
// 
// 	return true;
// }

// function oficial_cargarSangria(eSangria:FLDomElement):Boolean
// {
// 	var valor:String = eSangria.attribute("Arriba");
// 	var unicoValor:String = valor;
// 	var independientes:Boolean = false;
// 
// 	this.child("fdbSangriaSup").setValue(valor);
// 
// 	valor = eSangria.attribute("Abajo");
// 	if (independientes && unicoValor != valor) {
// 		independientes = true;
// 	}
// 	this.child("fdbSangriaInf").setValue(valor);
// 
// 	valor = eSangria.attribute("Izquierda");
// 	if (independientes && unicoValor != valor) {
// 		independientes = true;
// 	}
// 	this.child("fdbSangriaIzq").setValue(valor);
// 	
// 	valor = eSangria.attribute("Derecha");
// 	if (independientes && unicoValor != valor) {
// 		independientes = true;
// 	}
// 	this.child("fdbSangriaDer").setValue(valor);
// 
// 	if (independientes) {
// 		this.child("chkSangriasInd").checked = true;
// 	}
// 	this.iface.habilitarPorSangria();
// 	
// 	return true;
// }

function oficial_habilitarPorSangria()
{
	var cursor:FLSqlCursor = this.cursor();
	if (this.child("chkSangriasInd").checked == true) {
		this.child("fdbSangriaInf").setDisabled(false);
		this.child("fdbSangriaDer").setDisabled(false);
		this.child("fdbSangriaIzq").setDisabled(false);
		this.iface.bufferChanged("sangriasup");
	} else {
		this.child("fdbSangriaInf").setDisabled(true);
		this.child("fdbSangriaDer").setDisabled(true);
		this.child("fdbSangriaIzq").setDisabled(true);
	}
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "sangriasup": {
			if (this.child("chkSangriasInd").checked == false) {
				this.child("fdbSangriaInf").setValue(cursor.valueBuffer("sangriasup"));
				this.child("fdbSangriaDer").setValue(cursor.valueBuffer("sangriasup"));
				this.child("fdbSangriaIzq").setValue(cursor.valueBuffer("sangriasup"));
			}
			break;
		}
		case "tipotaco": {
			switch (cursor.valueBuffer("tipotaco")) {
				case "Juegos sueltos": {
					this.child("fdbCanTaco").setValue(1);
					break;
				}
			}
			this.iface.habilitarPorTipoTaco();
			break;
		}
		case "papel0": {
			this.child("fdbCapas").setValue(this.iface.calculateField("capas"));
			this.iface.tbnBorrarPrecorte_clicked();
			break;
		}
		case "papel1":
		case "papel2":
		case "papel3":
		case "papel4": {
			this.child("fdbCapas").setValue(this.iface.calculateField("capas"));
			break;
		}
		case "altot":
		case "anchot": {
			this.iface.tbnBorrarPrecorte_clicked();
			break;
		}
		case "estiloimpresion": {
			if (cursor.valueBuffer("estiloimpresion") == "TiraRetira") {
				this.iface.tbnBorrarTPO_clicked();
			}
			if (!this.iface.ponerPinza()) {
				return false;
			}
			break;
		}
		case "idimpresora": {
			if (!this.iface.ponerPinza()) {
				return false;
			}
debug("Pinza puesta");
			var idImpresora:String = cursor.valueBuffer("idimpresora");
			if (!idImpresora || idImpresora == "") {
				return;
			}
			var xmlImpresora:FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(idImpresora);
			if (!xmlImpresora) {
				return;
			}
			var datosImpresora:String = util.translate("scripts", "%1\n�rea m�x: %2\n�rea m�n: %3").arg(idImpresora).arg(xmlImpresora.toElement().attribute("AreaMax")).arg(xmlImpresora.toElement().attribute("AreaMin"));
			this.child("lblPliegoImpresion").text = datosImpresora;
			if (!flfacturac.iface.pub_validarPinzas(xmlProceso.firstChild())) {
				MessageBox.warning(util.translate("scripts", "La distribuci�n escogida no encaja en el pliego de impresi�n para la impresora y estilo de impresi�n escogidos"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
debug("Validando OK");
			break;
		}
		case "colores": {
			this.iface.cambiarColor();
			break;
		}
		case "codmarcapapel":
		case "codcalidad":
		case "gramaje": {
			this.iface.establecerFiltroPliego();
			break;
		}
		case "maculasmanual": {
			this.iface.habilitarMaculas();
			if (!cursor.valueBuffer("maculasmanual")) {
				this.child("fdbTotalMaculas").setValue("");
			}
			break;
		}
		case "ignorarenvio": {
			if (cursor.valueBuffer("ignorarenvio")) {
				this.iface.comprobarRegistroEnvio();
				this.child("tdbParamEnvio").refresh();
			}
			this.iface.habilitarEnvio();
			break;
		}
	}
}

function oficial_establecerFiltroPliego()
{
	var cursor:FLSqlCursor = this.cursor();
	var filtro:String = "codfamilia = 'PAPE'";
// 	var gramaje:String = cursor.valueBuffer("gramaje");
// 	if (gramaje && gramaje != "") {
// 		filtro += " AND gramaje = " + gramaje;
// 	}
// 	var codCalidad:String = cursor.valueBuffer("codcalidad");
// 	if (codCalidad && codCalidad != "") {
// 		filtro += " AND codcalidad = '" + codCalidad + "'";
// 	}
// 	var codMarcaPapel:String = cursor.valueBuffer("codmarcapapel");
// 	if (codMarcaPapel && codMarcaPapel != "") {
// 		filtro += " AND codmarcapapel = '" + codMarcaPapel + "'";
// 	}
	this.child("fdbPapel0").setFilter(filtro);
	this.child("fdbPapel1").setFilter(filtro);
	this.child("fdbPapel2").setFilter(filtro);
	this.child("fdbPapel3").setFilter(filtro);
	this.child("fdbPapel4").setFilter(filtro);
	this.child("fdbCarton").setFilter("codfamilia = 'PAPE'");
}

function oficial_habilitarMaculas()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (cursor.valueBuffer("maculasmanual")) {
		this.child("fdbTotalMaculas").setDisabled(false);
	} else {
		this.child("fdbTotalMaculas").setDisabled(true);
	}
}

function oficial_ponerPinza():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var xmlDocParam:FLDomDocument = this.iface.guardarDatos(cursor);
	if (!xmlDocParam) {
		return false;
	}
	var xmlProceso:FLDomDocument = new FLDomDocument();
	xmlProceso.setContent("<Proceso/>");
	xmlProceso.firstChild().appendChild(xmlDocParam.firstChild().cloneNode());
	if (!flfacturac.iface.pub_nodoXMLPinza(xmlProceso.firstChild())) {
		return false;
	}
	this.iface.mostrarTPO();
	this.iface.mostrarTPMS();
}

function oficial_tbnPrecorte_clicked()
{
debug(1);
	if (!this.iface.xmlPrecortes_) {
		if (!this.iface.cargarPrecortes())
			return;
		this.iface.xmlPrecorteActual_ = this.iface.xmlPrecortes_.firstChild().firstChild();
	} else {
		this.iface.xmlPrecorteActual_ = this.iface.xmlPrecorteActual_.nextSibling();
	}
	if (!this.iface.xmlPrecorteActual_)
		this.iface.xmlPrecorteActual_ = this.iface.xmlPrecortes_.firstChild().firstChild();

	this.iface.mostrarPrecorte();
	this.iface.tbnBorrarTPO_clicked();
	this.iface.tbnBorrarTPMS_clicked();
}

function oficial_cargarPrecortes():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var altoT:String = this.child("fdbAltoT").value();
	if (!altoT || altoT == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer el alto del trabajo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var anchoT:String = this.child("fdbAnchoT").value();
	if (!anchoT || anchoT == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer el ancho del trabajo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var areaTrabajo:String = anchoT + "x" + altoT;

	var refPapel:String = cursor.valueBuffer("papel0");
	if (!refPapel || refPapel == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer el pliego a utilizar"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var anchoP:String = util.sqlSelect("articulos", "anchopliego", "referencia = '" + refPapel + "'");
	var altoP:String = util.sqlSelect("articulos", "altopliego", "referencia = '" + refPapel + "'");
	var areaPliego:String = anchoP + "x" + altoP;

	var codImpresora:String = cursor.valueBuffer("idimpresora");
	if (codImpresora == "") {
		codImpresora = false;
	}

	var contenido:String = flfacturac.iface.pub_divisionesPliego(areaTrabajo, areaPliego, codImpresora);
	if (!contenido || contenido == "") {
		MessageBox.warning(util.translate("scripts", "No se han obtenido precortes para los datos introducidos"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	contenido = "<Precortes>" + contenido + "</Precortes>";
	this.iface.xmlPrecortes_ = new FLDomDocument;
	this.iface.xmlPrecortes_.setContent(contenido);

	return true;
}

function oficial_tbnBorrarPrecorte_clicked()
{
	delete this.iface.xmlPrecortes_;
	this.iface.xmlPrecortes_ = false;
	this.iface.xmlPrecorteActual_ = false;
	this.iface.mostrarPrecorte();
	
	this.iface.tbnBorrarTPO_clicked();
	this.iface.tbnBorrarTPMS_clicked();
	this.child("tbnPrecorte").enabled = true;
}

function oficial_tbnBorrarTPO_clicked()
{
	delete this.iface.xmlTPOs_;
	this.iface.xmlTPOs_= false;
	this.iface.xmlTPOActual_ = false;
	this.iface.mostrarTPO();
	this.child("tbnTPO").enabled = true;
}

function oficial_tbnBorrarTPMS_clicked()
{
	delete this.iface.xmlTPMSs_;
	this.iface.xmlTPMSs_= false;
	this.iface.xmlTPMSActual_ = false;
	this.iface.mostrarTPMS();
	this.child("tbnTPMS").enabled = true;
}

function oficial_mostrarPrecorte()
{
	var dimPliego:String = this.child("fdbAnchoP").value() + "x" + this.child("fdbAltoP").value();
	if (!this.iface.xmlPrecorteActual_) {
		this.child("fdbPrecorte").setValue("");
		this.child("fdbAltoPI").setValue("");
		this.child("fdbAnchoPI").setValue("");
	} else {
		var precorte:String = this.iface.xmlPrecorteActual_.toElement().attribute("Corte");
		this.child("fdbPrecorte").setValue(precorte);
		var dimPI:Array = this.iface.xmlPrecorteActual_.toElement().attribute("Valor").split("x");
		this.child("fdbAltoPI").setValue(dimPI[1]);
		this.child("fdbAnchoPI").setValue(dimPI[0]);
	}
	flfacturac.iface.pub_mostrarPrecorte(this.child( "lblDiagPrecorte" ), this.iface.xmlPrecorteActual_, dimPliego);
}


function oficial_tbnTPO_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("estiloimpresion") == "TiraRetira") {
		MessageBox.warning(util.translate("scripts", "Si el estilo es TiraRetira la distribuci�n debe ser sim�trica"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	if (!this.iface.xmlTPOs_) {
		if (!this.iface.cargarTPOs()) {
			return;
		}
		if (!this.iface.xmlTPOs_.firstChild().hasChildNodes()) {
			MessageBox.warning(util.translate("scripts", "No existen distribuciones para el las dimensiones de pliego y el precorte indicados"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		this.iface.xmlTPOActual_ = flfacturac.iface.pub_dameNodoXML(this.iface.xmlTPOs_.firstChild(), "TrabajosPliegoParam[@Optima=true]");
		if (!this.iface.xmlTPOActual_) {
			return;
		}
	} else {
		this.iface.xmlTPOActual_ = this.iface.xmlTPOActual_.nextSibling();
	}
	if (!this.iface.xmlTPOActual_) {
		this.iface.xmlTPOActual_= this.iface.xmlTPOs_.firstChild().firstChild();
	}

	this.iface.mostrarTPO();
}

function oficial_tbnTPMS_clicked()
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.xmlTPMSs_) {
		if (!this.iface.cargarTPMSs()) {
			return;
		}
		if (!this.iface.xmlTPMSs_.firstChild().hasChildNodes()) {
			MessageBox.warning(util.translate("scripts", "No existen distribuciones sim�tricas"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		this.iface.xmlTPMSActual_ = this.iface.xmlTPMSs_.firstChild().firstChild();
	} else {
		if (!this.iface.xmlTPMSActual_) {
			return;
		}
		this.iface.xmlTPMSActual_ = this.iface.xmlTPMSActual_.nextSibling();
	}
	if (!this.iface.xmlTPMSActual_) {
		this.iface.xmlTPMSActual_ = this.iface.xmlTPMSs_.firstChild().firstChild();
	}

	this.iface.mostrarTPMS();
}

function oficial_cargarTPOs():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var precorte:String = cursor.valueBuffer("precorte");
	if (!precorte || precorte == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer el precorte"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var xmlDocParam:FLDomDocument = this.iface.guardarDatos(cursor);
	if (!xmlDocParam) {
		return false;
	}

	var referencia:String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
	var xmlDocProceso:FLDomDocument = new FLDomDocument;
	xmlDocProceso.setContent("<Producto Ref=\"" + referencia + "\"><Proceso/></Producto>");
	var xmlProceso:FLDomNode = xmlDocProceso.firstChild().firstChild();
	xmlProceso.appendChild(xmlDocParam.firstChild());

	this.iface.xmlTPOs_ = new FLDomDocument;
	var nodoOT:FLDomNode = flfacturac.iface.trabajosXPliego(xmlProceso);
	if (!nodoOT) {
		return false;
	}

	this.iface.xmlTPOs_.appendChild(nodoOT.cloneNode());

	return true;
}

function oficial_cargarTPMSs():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var precorte:String = cursor.valueBuffer("precorte");
	if (!precorte || precorte == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer el precorte"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var xmlDocParam:FLDomDocument = this.iface.guardarDatos(cursor);
	if (!xmlDocParam) {
		return false;
	}

	var referencia:String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
	var xmlDocProceso:FLDomDocument = new FLDomDocument;
	xmlDocProceso.setContent("<Producto Ref=\"" + referencia + "\"><Proceso/></Producto>");
	var xmlProceso:FLDomNode = xmlDocProceso.firstChild().firstChild();
	xmlProceso.appendChild(xmlDocParam.firstChild());
debug(xmlDocProceso.toString(4));
	this.iface.xmlTPMSs_ = new FLDomDocument;
	var nodoOT:FLDomDocument = flfacturac.iface.trabajosXPliegoSim(xmlProceso);
	if (!nodoOT) {
		return false;
	}

	this.iface.xmlTPMSs_.appendChild(nodoOT.cloneNode());
	return true;
}


function oficial_mostrarTPO()
{
	var dimPI:String = this.child("fdbAnchoPI").value() + "x" + this.child("fdbAltoPI").value();

	if (!this.iface.xmlTPOActual_) {
		this.child("lblOptimo").text = "";
		flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagTPO"), false, dimPI, false);
		return;
	}
	
	var texto:String = "(" + this.iface.xmlTPOActual_.toElement().attribute("Eficiencia") + "%)";
	if (this.iface.xmlTPOActual_.toElement().attribute("Optima") == "true")
		texto += "*";
	this.child("lblOptimo").text = texto;
	
	var cursor:FLSqlCursor = this.cursor();
	var xmlDocParam:FLDomDocument = this.iface.guardarDatos(cursor);
	if (!xmlDocParam) {
		return false;
	}
	var xmlProceso:FLDomDocument = new FLDomDocument();
	xmlProceso.setContent("<Proceso/>");
	xmlProceso.firstChild().appendChild(xmlDocParam.firstChild().cloneNode());
	
	flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagTPO"), xmlProceso.firstChild(), dimPI, false);

	return true;
}

function oficial_mostrarTPMS()
{
	var dimPI:String = this.child("fdbAnchoPI").value() + "x" + this.child("fdbAltoPI").value();
	if (!this.iface.xmlTPMSActual_) {
		this.child("lblMejorSim").text = "";
		flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagTPMS"), false, dimPI, false);
		return;
	}

	var texto:String = "(" + this.iface.xmlTPMSActual_.toElement().attribute("Eficiencia") + "%)";
	if (this.iface.xmlTPMSActual_.toElement().attribute("Optima") == "true")
		texto += "*";
	if (this.iface.xmlTPMSActual_.toElement().attribute("EjeSim") == "H")
		texto += "(H)";
	if (this.iface.xmlTPMSActual_.toElement().attribute("EjeSim") == "V")
		texto += "(V)";
	this.child("lblMejorSim").text = texto;

	var cursor:FLSqlCursor = this.cursor();
	var xmlDocParam:FLDomDocument = this.iface.guardarDatos(cursor);
	if (!xmlDocParam) {
		return false;
	}
	var xmlProceso:FLDomDocument = new FLDomDocument();
	xmlProceso.setContent("<Proceso/>");
	xmlProceso.firstChild().appendChild(xmlDocParam.firstChild().cloneNode());
	
	flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagTPMS"), xmlProceso.firstChild(), dimPI, false);

	return true;
}

function oficial_guardarDatos(cursor:FLSqlCursor):FLDomDocument
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.xmlParam_) {
		this.iface.xmlParam_ = new FLDomDocument;
	}
	this.iface.xmlParam_.setContent("<Parametros/>");
	var nodoParam:FLDomNode = this.iface.xmlParam_.firstChild();
	var nodoAux:FLDomNode;
	
	var gramaje:String = cursor.valueBuffer("gramaje");
	if (!gramaje || gramaje == "" || gramaje == 0) {
		MessageBox.warning(util.translate("scripts", "Debe establecer el gramaje"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	nodoAux = this.iface.crearNodoHijo(nodoParam, "GramajeParam");
	nodoAux.toElement().setAttribute("Valor", gramaje);

	var codMarcaPapel:String = cursor.valueBuffer("codmarcapapel");
	if (!codMarcaPapel || codMarcaPapel == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer la marca de papel"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	nodoAux = this.iface.crearNodoHijo(nodoParam, "CodMarcaPapelParam");
	nodoAux.toElement().setAttribute("Valor", codMarcaPapel);

	var codCalidad:String = cursor.valueBuffer("codcalidad");
	if (!codCalidad || codCalidad == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer la calidad de papel"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	nodoAux = this.iface.crearNodoHijo(nodoParam, "CalidadParam");
	nodoAux.toElement().setAttribute("Valor", codCalidad);

	if (!this.iface.guardarDiseno(nodoParam, cursor)) {
		return false;
	}

	var areaTrabajo:String = cursor.valueBuffer("anchot") + "x" + cursor.valueBuffer("altot");
	if (!areaTrabajo || areaTrabajo.startsWith("x") || areaTrabajo.endsWith("x")) {
		MessageBox.warning(util.translate("scripts", "Debe establecer el �rea del trabajo"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	nodoAux = this.iface.crearNodoHijo(nodoParam, "AreaTrabajoParam");
	nodoAux.toElement().setAttribute("Valor", areaTrabajo);

	if (!this.iface.guardarSangrias(nodoParam, cursor)) {
		return false;
	}
	if (!this.iface.guardarPapel(nodoParam, cursor)) {
		return false;
	}
	if (!this.iface.guardarPliegoImpresion(nodoParam, cursor)) {
		return false;
	}
	if (!this.iface.guardarTrabajosPliego(nodoParam, cursor)) {
		return false;
	}
	if (!this.iface.guardarImpresora(nodoParam, cursor)) {
		return false;
	}
	if (!this.iface.guardarEstiloImpresion(nodoParam, cursor)) {
		return false;
	}
	if (!flfacturac.iface.pub_nodoXMLPinza(this.iface.xmlParam_)) {
		return false;
	}
	if (!this.iface.guardarColor(nodoParam, cursor)) {
		return false;
	}
	if (!this.iface.guardarCantidad(nodoParam, cursor)) {
		return false;
	}
	if (!this.iface.guardarMaculas(nodoParam, cursor)) {
		return false;
	}
	if (!this.iface.guardarOtros(nodoParam, cursor)) {
		return false;
	}
	return this.iface.xmlParam_;
}

function oficial_guardarImpresora(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idImpresora:String = cursor.valueBuffer("idimpresora");
	if (!idImpresora || idImpresora == "") {
		return true;
	}
	var nodoImpresora:FLDomNode = this.iface.crearNodoHijo(nodoParam, "TipoImpresoraParam");
	var xmlElemento:FLDomElement = nodoImpresora.toElement();
	
	var paramImpresora:FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(idImpresora);
	if (!paramImpresora)
		return false;
		
	var refPlancha:String = paramImpresora.toElement().attribute("RefPlancha");
	var numCuerpos:String = paramImpresora.toElement().attribute("NumCuerpos");
	if (!numCuerpos || numCuerpos == "") {
		numCuerpos = "0";
	}

	var anchoPinza:String = paramImpresora.toElement().attribute("AnchoPinza");
	var areaPlancha:String = util.sqlSelect("articulos", "dimpliego", "referencia = '" + refPlancha + "'");
	
	xmlElemento.setAttribute("Valor", idImpresora);
	xmlElemento.setAttribute("AreaPlancha", areaPlancha);
	xmlElemento.setAttribute("RefPlancha", refPlancha);
	xmlElemento.setAttribute("NumCuerpos", numCuerpos);
	xmlElemento.setAttribute("AnchoPinza", anchoPinza);
	
	if (cursor.valueBuffer("maculasmanual")) {
		var totalMaculas:Number = parseInt(cursor.valueBuffer("totalmaculas"));
		if (isNaN(totalMaculas)) {
			totalMaculas = 0;
		}
		xmlElemento.setAttribute("MaculasManual", "true");
		xmlElemento.setAttribute("TotalMaculas", totalMaculas);
	} else {
		xmlElemento.setAttribute("MaculasManual", "false");
	}

	return true;
}

function oficial_guardarMaculas(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var nodoImpresora:FLDomNode = this.iface.crearNodoHijo(nodoParam, "MaculasParam");
	var xmlElemento:FLDomElement = nodoImpresora.toElement();
	
	if (cursor.valueBuffer("maculasmanual")) {
		var totalMaculas:Number = parseInt(cursor.valueBuffer("totalmaculas"));
		if (isNaN(totalMaculas)) {
			totalMaculas = 0;
		}
		xmlElemento.setAttribute("MaculasManual", "true");
		xmlElemento.setAttribute("TotalMaculas", totalMaculas);
	} else {
		xmlElemento.setAttribute("MaculasManual", "false");
	}

	return true;
}
function oficial_guardarEstiloImpresion(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var estiloImpresion:String = cursor.valueBuffer("estiloimpresion");
	if (estiloImpresion == "(calcular)" || estiloImpresion == "") {
		return true;
	}
	var nodoEstiloImpresion:FLDomNode = this.iface.crearNodoHijo(nodoParam, "EstiloImpresionParam");
	var xmlElemento:FLDomElement = nodoEstiloImpresion.toElement();
	xmlElemento.setAttribute("Valor", estiloImpresion);

	return true;
}

function oficial_guardarOtros(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var nodoOtros:FLDomNode = nodoParam.namedItem("FondosLisosParam");
	if (!nodoOtros) {
		nodoOtros = this.iface.crearNodoHijo(nodoParam, "FondosLisosParam");
		if (!nodoOtros)
			return false;
	}
	var fondosLisos:Boolean = cursor.valueBuffer("fondoslisos");
	if (fondosLisos) {
		nodoOtros.toElement().setAttribute("Valor", "true");
	} else {
		nodoOtros.toElement().setAttribute("Valor", "false");
	}

	var nodoOtros:FLDomNode = nodoParam.namedItem("NumeracionParam");
	if (!nodoOtros) {
		nodoOtros = this.iface.crearNodoHijo(nodoParam, "NumeracionParam");
		if (!nodoOtros)
			return false;
	}
	var numeracion:Boolean = cursor.valueBuffer("numeracion");
	if (numeracion) {
		nodoOtros.toElement().setAttribute("Valor", "true");
	} else {
		nodoOtros.toElement().setAttribute("Valor", "false");
	}

	var nodoOtros:FLDomNode = nodoParam.namedItem("CalidadEspecialParam");
	if (!nodoOtros) {
		nodoOtros = this.iface.crearNodoHijo(nodoParam, "CalidadEspecialParam");
		if (!nodoOtros) {
			return false;
		}
	}
	var calidadEspecial:Boolean = cursor.valueBuffer("calidadespecial");
	if (calidadEspecial) {
		nodoOtros.toElement().setAttribute("Valor", "true");
	} else {
		nodoOtros.toElement().setAttribute("Valor", "false");
	}

	var referencia:String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
	var nombrePagina:String = "Letra";
	var nodoOtros:FLDomNode = nodoParam.namedItem("NombrePaginaParam");
	if (!nodoOtros) {
		nodoOtros = this.iface.crearNodoHijo(nodoParam, "NombrePaginaParam");
		if (!nodoOtros) {
			return false;
		}
	}
	nodoOtros.toElement().setAttribute("Valor", nombrePagina);
	
	return true;
}

function oficial_guardarSangrias(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var xmlSangrias:FLDomNode = this.iface.crearNodoHijo(nodoParam, "SangriaParam");
	var xmlElemento:FLDomElement = xmlSangrias.toElement();	

	var sangria:Number = cursor.valueBuffer("sangriasup");
	xmlElemento.setAttribute("Arriba", sangria);

	var sangria:Number = cursor.valueBuffer("sangriainf");
	xmlElemento.setAttribute("Abajo", sangria);

	var sangria:Number = cursor.valueBuffer("sangriader");
	xmlElemento.setAttribute("Derecha", sangria);

	var sangria:Number = cursor.valueBuffer("sangriaizq");
	xmlElemento.setAttribute("Izquierda", sangria);
	
	return true;
}

function oficial_guardarColor(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var xmlDocColores:FLDomDocument = new FLDomDocument;
	var contenidoColor:String = util.sqlSelect("paramcolor", "xml", "idparamtaco = " + cursor.valueBuffer("id"));
	if (!contenidoColor) {
		MessageBox.warning(util.translate("scripts", "Error al guardar los datos de color: No existe el registro de par�metros de color"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!xmlDocColores.setContent(contenidoColor)) {
		MessageBox.warning(util.translate("scripts", "Error al guardar los datos de color: Error al establecer los datos XML"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	nodoParam.appendChild(xmlDocColores.firstChild().cloneNode());
	
	return true;
}

function oficial_guardarCantidad(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var xmlCantidad:FLDomNode = this.iface.crearNodoHijo(nodoParam, "PaginasParam");
	var xmlElemento:FLDomElement = xmlCantidad.toElement();

	var numCopias:Number = cursor.valueBuffer("numcopias");
	var numPaginas:Number = cursor.valueBuffer("numpaginas");
	var total:Number = numCopias * numPaginas;
	xmlElemento.setAttribute("NumCopias", numCopias);
	xmlElemento.setAttribute("NumPaginas", numPaginas);
	xmlElemento.setAttribute("Total", total);
	xmlElemento.setAttribute("CanTaco", cursor.valueBuffer("cantaco"));
	xmlElemento.setAttribute("TipoTaco", cursor.valueBuffer("tipotaco"));
	return true;
}

function oficial_guardarPapel(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var refPliego:String = cursor.valueBuffer("papel0");
	if (!refPliego || refPliego == "") {
		return true;
	}
	
	var ePapel:FLDomElement = this.iface.xmlParam_.createElement("PapelParam");
	nodoParam.appendChild(ePapel);
	
	var dimPliego:String = cursor.valueBuffer("anchop") + "x" + cursor.valueBuffer("altop");
	ePapel.setAttribute("AreaPliego", dimPliego);

	var eCapa:FLDomElement;
	var refPapel:String;
	var primero:Boolean = true;
	var capas:Number = 0;
	
	for (var i:Number = 0; i < 5; i++) {
		refPapel = cursor.valueBuffer("papel" + i.toString());
		if (!refPapel || refPapel == "") {
			continue;
		}
		eCapa = this.iface.xmlParam_.createElement("Papel");
		ePapel.appendChild(eCapa);
		eCapa.setAttribute("Ref", refPapel);
		eCapa.setAttribute("Copia", (primero ? "1" : "2"));
		primero = false;
		capas++;
		eCapa.setAttribute("Capa", capas);
	}
	if (eCapa) {
		eCapa.setAttribute("Copia", "3");
	}
	ePapel.setAttribute("Capas", capas);

	refCarton = cursor.valueBuffer("carton");
	if (refCarton && refCarton != "") {
		eCapa = this.iface.xmlParam_.createElement("Carton");
		ePapel.appendChild(eCapa);
		eCapa.setAttribute("Ref", refCarton);
	}

	return true;
}

function oficial_guardarPliegoImpresion(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	if (!this.iface.xmlPrecorteActual_) {
		return true;
	}
	
	var precorte:Number = cursor.valueBuffer("precorte");
	if (!precorte || precorte == "") {
		return true;
	}
	var xmlParamNode:FLDomNode = this.iface.crearNodoHijo(nodoParam, "PliegoImpresionParam");
	var xmlElemento:FLDomElement = xmlParamNode.toElement();

	xmlElemento.setAttribute("Corte", precorte);

	var dimPrecorte:Array = precorte.split("x");
	var factor:Number = parseInt(dimPrecorte[0]) * parseInt(dimPrecorte[1]);
	xmlElemento.setAttribute("Factor", factor);

	var dimPI:String = cursor.valueBuffer("anchopi") + "x" + cursor.valueBuffer("altopi");
	xmlElemento.setAttribute("Valor", dimPI);

	return true;
}

function oficial_guardarTrabajosPliego(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	if (!this.iface.xmlTPOActual_ && !this.iface.xmlTPMSActual_) {
		return true;
	}
	if (this.iface.xmlTPOActual_) {
		nodoParam.appendChild(this.iface.xmlTPOActual_.cloneNode());
	} else if (this.iface.xmlTPMSActual_) {
		nodoParam.appendChild(this.iface.xmlTPMSActual_.cloneNode());
	}
	
	return true;
}

function oficial_crearNodoHijo(nodoPadre:FLDomNode, nombreHijo:String):FLDomNode
{
	var xmlDocAux:FLDomDocument = new FLDomDocument;
	xmlDocAux.setContent("<" + nombreHijo + "/>");
	var xmlNodo:FLDomNode = xmlDocAux.firstChild();
	nodoPadre.appendChild(xmlNodo);
	return xmlNodo;
}

function oficial_validarDatos(xmlProceso:FLDomNode):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var capas:Number = cursor.valueBuffer("capas");
	if (isNaN(capas) || capas < 1) {
		MessageBox.warning(util.translate("scripts", "El taco debe tener al menos una capas."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (this.iface.xmlTPMSActual_ && this.iface.xmlTPOActual_) {
		MessageBox.warning(util.translate("scripts", "No puede establecer dos distribuciones de trabajos en pliego.\nBorre una de ellas"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var codImpresora:String = cursor.valueBuffer("idimpresora");
debug("codImpresora = " + codImpresora);
	if (!codImpresora || codImpresora == "") {
		var datosImp:String = this.iface.datosImpresoraGral();
		if (!datosImp) {
			return false;
		}
		var areaPI:String = cursor.valueBuffer("anchopi") + "x" + cursor.valueBuffer("altopi");
		if (areaPI != "0x0") {
			if (!flfacturac.iface.pub_entraEnArea(datosImp["min"], areaPI)) {
				MessageBox.warning(util.translate("scripts", "El �rea del pliego de impresi�n (%1) es inferior al �rea m�nima total (%2).").arg(areaPI).arg(datosImp["min"]), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			if (!flfacturac.iface.pub_entraEnArea(areaPI, datosImp["max"])) {
				MessageBox.warning(util.translate("scripts", "El �rea del pliego de impresi�n (%1) es superior al �rea m�xima total (%2).").arg(areaPI).arg(datosImp["max"]), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	} else {
		var xmlImpresora:FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codImpresora);
		var msgError:String = flfacturac.iface.pub_validarImpresora(xmlProceso, xmlImpresora);
debug("msgError = " + msgError);
		if (!msgError) {
			return false;
		}
		if (msgError != "OK") {
			MessageBox.warning(msgError, MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("estiloimpresion") == "TiraRetira") {
		if (!flfacturac.iface.pub_tiraRetiraPosible(xmlProceso)) {
			MessageBox.warning(util.translate("scripts", "La configuraci�n de colores no permite el estilo TiraRetira."), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (!flfacturac.iface.pub_validarPinzas(xmlProceso)) {
		MessageBox.warning(util.translate("scripts", "La distribuci�n escogida no encaja en el pliego de impresi�n para la impresora y estilo de impresi�n escogidos"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

function oficial_datosImpresoraGral():Array
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var datos:Array = [];
	var texto:String = "";

	datos["nombre"] = util.translate("scripts", "(impresora sin definir)");
	datos["min"] = flfacturac.iface.minPliegoImpresion_;
	datos["max"] = flfacturac.iface.maxPliegoImpresion_;

	return datos;
}

function oficial_tbnColores_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		if (!cursor.commitBuffer()) {
			return false;
		}
		cursor.refresh();
		cursor.setModeAccess(cursor.Edit);
		cursor.refreshBuffer();
	}

	if (this.iface.curColores_) {
		delete this.iface.curColores_;
	}
	this.iface.curColores_ = new FLSqlCursor("paramcolor");
	connect(this.iface.curColores_, "bufferCommited()", this, "iface.habilitarBotonColor");
	this.iface.curColores_.select("idparamtaco = " + cursor.valueBuffer("id"));
	if (!this.iface.curColores_.first()) {
		this.iface.curColores_.insertRecord();
	} else {
		this.iface.curColores_.editRecord();
	}
}

function oficial_habilitarPorReferencia()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var referencia:String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
	var idLinea:String = formRecordlineaspresupuestoscli.cursor().valueBuffer("idlinea");
	switch (referencia) {
		case "TACO": {
			break;
		}
	}
}

function oficial_comprobarRegistroEnvio():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var referencia:String = util.sqlSelect("lineaspresupuestoscli", "referencia", "idlinea = " + cursor.valueBuffer("idlinea"));
	if (referencia != "TACO") {
		return true;
	}
	
	if (cursor.valueBuffer("ignorarenvio")) {
		if (!util.sqlDelete("paramenvio", "idparamtaco = " + cursor.valueBuffer("id"))) {
			return false;
		}
	} else {
		if (util.sqlSelect("paramenvio", "id", "idparamtaco = " + cursor.valueBuffer("id"))) {
			var cantidad:Number = cursor.valueBuffer("numcopias");
			if (!cantidad) {
				cantidad = parseInt(util.sqlSelect("paramcantidad", "total", "idparamtaco = " + cursor.valueBuffer("id")));
			}
			var cantidadEnvio:Number = parseInt(util.sqlSelect("paramenvio", "numcopias", "idparamtaco = " + cursor.valueBuffer("id")));
debug("cantidad = " + cantidad);
debug("cantidadEnvio = " + cantidadEnvio);
			if (cantidadEnvio != cantidad) {
				var res:Number = MessageBox.warning(util.translate("scripts", "La cantidad indicada no coincide con la cantidad el env�o.\n�Desea recalcular el registro de env�o?"), MessageBox.Yes, MessageBox.No);
				if (res == MessageBox.Yes) {
					if (!this.iface.crearRegistroEnvio(cursor, true)) {
						return false;
					}
				}
			}
		} else {
			if (!this.iface.crearRegistroEnvio(cursor, true)) {
				return false;
			}
		}
	}
	return true;
}

function oficial_crearRegistroEnvio(cursor:FLSqlCursor, desdeForm:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var curEnvio:FLSqlCursor;
	if (desdeForm) {
		/// Desparcheado porque si no no se calculan bien los datos del env�o en base a los del cursor el �ptico
		curEnvio = this.child("tdbParamEnvio").cursor();
	} else {
		curEnvio = new FLSqlCursor("paramenvio");
	}
	
	if (!util.sqlDelete("paramenvio", "idparamtaco = " + cursor.valueBuffer("id"))) {
		return false;
	}
	
	var datosPresupuesto:FLSqlQuery = new FLSqlQuery;
	datosPresupuesto.setTablesList("presupuestoscli,lineaspresupuestoscli");
	datosPresupuesto.setSelect("p.codcliente, p.nombrecliente, p.idpoblacion, p.idprovincia, p.codpais, p.coddir, p.direccion, p.codpostal, p.provincia, p.apartado, p.ciudad");
	datosPresupuesto.setFrom("lineaspresupuestoscli lp INNER JOIN presupuestoscli p ON lp.idpresupuesto = p.idpresupuesto");
	datosPresupuesto.setWhere("lp.idlinea = " + cursor.valueBuffer("idlinea"));
	datosPresupuesto.setForwardOnly(true);
	if (!datosPresupuesto.exec()) {
		return false;
	}
	if (!datosPresupuesto.first()) {
		return false;
	}
	
	var idProvincia:String;
	var idPoblacion:String;

	curEnvio.setModeAccess(curEnvio.Insert);
	curEnvio.refreshBuffer();
	curEnvio.setValueBuffer("idparamtaco", cursor.valueBuffer("id"));
	curEnvio.setValueBuffer("codcliente", datosPresupuesto.value("p.codcliente"));
	curEnvio.setValueBuffer("nombredestino", datosPresupuesto.value("p.nombrecliente"));
	curEnvio.setValueBuffer("direccion", datosPresupuesto.value("p.direccion"));
	curEnvio.setValueBuffer("codpostal", datosPresupuesto.value("p.codpostal"));
	idPoblacion = datosPresupuesto.value("p.idpoblacion");
	if (idPoblacion == "") {
		curEnvio.setNull("idpoblacion");
	} else {
		curEnvio.setValueBuffer("idpoblacion", idPoblacion);
	}
	curEnvio.setValueBuffer("ciudad", datosPresupuesto.value("p.ciudad"));
	idProvincia = datosPresupuesto.value("p.idprovincia");
	if (idProvincia == "") {
		curEnvio.setNull("idprovincia");
	} else {
		curEnvio.setValueBuffer("idprovincia", idProvincia);
	}
	curEnvio.setValueBuffer("provincia", datosPresupuesto.value("p.provincia"));
	curEnvio.setValueBuffer("apartado", datosPresupuesto.value("p.apartado"));
	
	var cantidad:Number = cursor.valueBuffer("numcopias");
	curEnvio.setValueBuffer("numcopias", cantidad);
	
	curEnvio.setValueBuffer("pesounidad", formRecordparamenvio.iface.pub_commonCalculateField("pesounidad", curEnvio));
	curEnvio.setValueBuffer("peso", formRecordparamenvio.iface.pub_commonCalculateField("peso", curEnvio));
	curEnvio.setValueBuffer("portes", formRecordparamenvio.iface.pub_commonCalculateField("portes", curEnvio));
	curEnvio.setValueBuffer("codagencia", formRecordparamenvio.iface.pub_commonCalculateField("codagencia", curEnvio));
	
	var xmlDatos:FLDomDocument = formRecordparamenvio.iface.pub_guardarDatos(curEnvio);
	if (!xmlDatos) {
		return false;
	}
	curEnvio.setValueBuffer("xml", xmlDatos.toString(4));
	if (!curEnvio.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_habilitarEnvio()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String = util.sqlSelect("lineaspresupuestoscli", "referencia", "idlinea = " + cursor.valueBuffer("idlinea"));
	switch (referencia) {
		case "TACO": {
			this.child("tbwIptico1").setTabEnabled("envio", true);
			if (cursor.valueBuffer("ignorarenvio")) {
				this.child("gbxEnvio").enabled = false;
			} else {
				this.child("gbxEnvio").enabled = true;
			}
			break;
		}
		default: {
			break;
		}
	}
}

function oficial_habilitarPorTipoTaco()
{
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.valueBuffer("tipotaco")) {
		case "Juegos sueltos": {
			this.child("fdbCanTaco").setDisabled(true);
			break;
		}
		default: {
			this.child("fdbCanTaco").setDisabled(false);
		}
	}
}

function oficial_guardarDiseno(nodoParam:FLDomNode, cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var nodoDiseno:FLDomNode = this.iface.crearNodoHijo(nodoParam, "DisenoParam");
	var xmlElemento:FLDomElement = nodoDiseno.toElement();
	
	var diseno:Boolean = cursor.valueBuffer("diseno");
	if (diseno) {
		xmlElemento.setAttribute("Valor", "true");
	} else {
		xmlElemento.setAttribute("Valor", "false");
	}
	if (cursor.isNull("tiempodiseno")) {
		xmlElemento.setAttribute("TiempoUsuario", "");
	} else {
		xmlElemento.setAttribute("TiempoUsuario", cursor.valueBuffer("tiempodiseno"));
	}
	
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////