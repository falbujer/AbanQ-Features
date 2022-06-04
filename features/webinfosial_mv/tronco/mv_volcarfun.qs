/***************************************************************************
                 mv_volcarfun.qs  -  description
                             -------------------
    begin                : lun sep 21 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
    function init() { this.ctx.interna_init(); }
    function main() { this.ctx.interna_main(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	
	var conexion:String;
	var tablas:Array;
	
    function oficial( context ) { interna( context ); } 
	
	function conectar(bd:String):Boolean {
		return this.ctx.oficial_conectar(bd);
	}
	function desconectar(bd:String):Boolean {
		return this.ctx.oficial_desconectar(bd);
	}
	
	function subirDatos():Boolean {
		return this.ctx.oficial_subirDatos();
	}
	function subirDatosIS():Boolean {
		return this.ctx.oficial_subirDatosIS();
	}
	
	function exportarTabla(tabla:String, nomTabla:String, tablaGeneral:Boolean):Number {
		return this.ctx.oficial_exportarTabla(tabla, nomTabla, tablaGeneral);
	}
	function actualizarArticulos() {
		return this.ctx.oficial_actualizarArticulos();
	}
	function obtenerListaCampos(tabla:String):Array {
		return this.ctx.oficial_obtenerListaCampos(tabla);
	}
	function eliminarObsoletos(tabla:String):Number {
		return this.ctx.oficial_eliminarObsoletos(tabla);
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function init() {
    this.iface.init();
}

function main() {
    this.iface.main();
}

function interna_init() 
{
	this.iface.conexion = "remota";
	connect( this.child( "pbnUpWeb" ), "clicked()", this, "iface.subirDatos" );
	connect( this.child( "pbnUpIS" ), "clicked()", this, "iface.subirDatosIS" );

	this.iface.tablas = new Array(
		"mv_ambitos",
// 		"mv_tramoscoste",
		"mv_funcional",
		"mv_dependencias"
	);
}

function interna_main()
{
	var f = new FLFormSearchDB("mv_volcarfun");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
					commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
					cursor.commit();
					commitOk = true;
			}
		}
		f.close();
	}
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Actualiza las extensiones y los artículos de las mismas en la bd web
*/
function oficial_subirDatos()
{
	var util:FLUtil = new FLUtil();
	
	var res = MessageBox.information(util.translate("scripts", "A continuación se establecerá una conexión con la base de datos remota\ny se actualizarán las funcionalidades\n\n¿Desea continuar?"),
		MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return false;

	if (!this.iface.conectar())
		return false;
	
	var msgResumen:String = util.translate("scripts", "Resultados:\n");
	var numExportados:Number;
	var numEliminados:Number;
	var totalExportados:Number = 0;

	for (var i:Number = 0; i < this.iface.tablas.length; i++) {
	
		numExportados = this.iface.exportarTabla(this.iface.tablas[i], this.iface.tablas[i]);
		if (numExportados > 0)
			msgResumen += "\n" + this.iface.tablas[i] + "   " + 
				util.translate("scripts", "Modificados o nuevos: ") + numExportados;

		totalExportados += numExportados;
	}

	numExportados = this.iface.actualizarArticulos();
	if (numExportados > 0)
	msgResumen += "\nArtículos de extensiones actualizados: " + numExportados;

	totalExportados += numExportados;

// 	for (var i:Number = this.iface.tablas.length - 1; i >= 0; i--) {
// 	
// 		numEliminados = this.iface.eliminarObsoletos(this.iface.tablas[i]);
// 		if (numEliminados > 0)
// 			msgResumen += "\n" + this.iface.tablas[i] + "   " + 
// 				util.translate("scripts", "Eliminados: ") + numEliminados;
// 
// 		totalExportados += numEliminados;
// 	}

	if (totalExportados > 0)
		MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	else
		MessageBox.information(util.translate("scripts", "No se encontraron registros para actualizar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

	this.iface.desconectar();
}

/** \D Actualiza las extensiones como artículos en la bd infosial
*/
function oficial_subirDatosIS()
{
	var util:FLUtil = new FLUtil();
	
	var res = MessageBox.information(util.translate("scripts", "A continuación se establecerá una conexión con la base de datos remota\ny se actualizarán las funcionalidades\n\n¿Desea continuar?"),
		MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return false;

	if (!this.iface.conectar("_is"))
		return false;
	
	var msgResumen:String = util.translate("scripts", "Resultados:\n");
	var numExportados:Number;
	var numEliminados:Number;
	var totalExportados:Number = 0;

	numExportados = this.iface.actualizarArticulos();
	if (numExportados > 0)
	msgResumen += "\nArtículos de extensiones actualizados: " + numExportados;

	totalExportados += numExportados;

// 	for (var i:Number = this.iface.tablas.length - 1; i >= 0; i--) {
// 	
// 		numEliminados = this.iface.eliminarObsoletos(this.iface.tablas[i]);
// 		if (numEliminados > 0)
// 			msgResumen += "\n" + this.iface.tablas[i] + "   " + 
// 				util.translate("scripts", "Eliminados: ") + numEliminados;
// 
// 		totalExportados += numEliminados;
// 	}

	if (totalExportados > 0)
		MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	else
		MessageBox.information(util.translate("scripts", "No se encontraron registros para actualizar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

	this.iface.desconectar();
}


function oficial_conectar(bd:String) 
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (!bd) bd = "";
	var driver:String = cursor.valueBuffer("driver" + bd);
	var nombreBD:String = cursor.valueBuffer("nombrebd" + bd);
	var usuario:String = cursor.valueBuffer("usuario" + bd);
	var host:String = cursor.valueBuffer("host" + bd);
	var puerto:String = cursor.valueBuffer("puerto" + bd);

	var tipoDriver:String;
	if (sys.nameDriver().search("PSQL") > -1)
		tipoDriver = "PostgreSQL";
	else
		tipoDriver = "MySQL";

	if (host == sys.nameHost() && nombreBD == sys.nameBD() && driver == tipoDriver) {
		MessageBox.warning(util.translate("scripts",
			"Los datos de conexión son los de la presente base de datos\nDebe indicar los datos de conexión de la base de datos remota"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (!driver || !nombreBD || !usuario || !host) {
		MessageBox.warning(util.translate("scripts",
			"Debe indicar el tipo de base de datos, nombre de la misma, usuario y servidor"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	var password:String = Input.getText( util.translate("scripts", "Password de conexión (en caso necesario)") );

	util.createProgressDialog( util.translate( "scripts", "Conectando..." ), 10);
	util.setProgress(2);

	if (!sys.addDatabase(driver, nombreBD, usuario, password, host, puerto, this.iface.conexion)) {
		util.destroyProgressDialog();
		return false;
	}
		
	util.destroyProgressDialog();
	return true;
}

function oficial_desconectar(bd:String) 
{
	var cursor:FLSqlCursor = this.cursor();
	
	if (!bd) bd = "";
	var nombreBD:String = cursor.valueBuffer("nombrebd" + bd);
	
	if (!sys.removeDatabase(this.iface.conexion));
		return false;
		
	return true;
}

function oficial_exportarTabla(tabla:String, nomTabla:String, tablaGeneral:Boolean)
{
	var util:FLUtil = new FLUtil();

	var curLoc:FLSqlCursor = new FLSqlCursor(tabla);
  	var curRem:FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

	var campoClave:String = curLoc.primaryKey();
	var listaCampos:Array = this.iface.obtenerListaCampos(tabla);

	var valorClave;
	var paso:Number = 0;
	var exportados:Number = 0;
	var eliminados:Number = 0;

 	curLoc.select();

	if (curLoc.size() == 0) 
		return 0;

	util.createProgressDialog( util.translate( "scripts", "Exportando " ) + nomTabla, curLoc.size());
	util.setProgress(1);

 	while (curLoc.next()) {

		util.setProgress(paso++);

 		valorClave = curLoc.valueBuffer(campoClave);

		curRem.select(campoClave + " = '" + valorClave + "'");

		// Actualizacion (si toca)
		if (curRem.first()) {
			curRem.setModeAccess(curRem.Edit);
		}
		else {
			curRem.setModeAccess(curRem.Insert);
		}

		curRem.refreshBuffer();

		// Bucle de campos
		for(var i = 0; i < listaCampos.length; i++) {
			curRem.setValueBuffer(listaCampos[i], curLoc.valueBuffer(listaCampos[i]));
		}

		// OK remoto
		if (curRem.commitBuffer() && !tablaGeneral) {
			exportados++;
		}
		// Error
		else {
			debug(util.translate("scripts",	"Error al exportar en la tabla remota %0 el código/id " ).arg(tabla) + valorClave);
		}

	}

	util.destroyProgressDialog();

	return exportados;
}

/** Actualiza los artículos de extensiones al precio establecido y crea las nuevas
referencias para las extensiones
*/
function oficial_actualizarArticulos()
{
	var util:FLUtil = new FLUtil();

	var curLoc:FLSqlCursor = new FLSqlCursor("mv_funcional");
  	var curRem:FLSqlCursor = new FLSqlCursor("articulos", this.iface.conexion);
  	var referencia:String;
  	var paso:Number = 0;
  	var exportados:Number = 0;

 	curLoc.select();

	if (curLoc.size() == 0) 
		return 0;

	util.createProgressDialog( util.translate( "scripts", "Actualizando extensiones..."), curLoc.size());
	util.setProgress(1);

 	while (curLoc.next()) {

		util.setProgress(paso++);
		
		if (!curLoc.valueBuffer("enventa") || curLoc.valueBuffer("esproyecto"))
			continue;

 		referencia = "Ext_" + curLoc.valueBuffer("codigo");
 		
 		pvp = util.sqlSelect("mv_tramoscoste", "coste", "codigo = '" + curLoc.valueBuffer("codtramo") + "'");

		curRem.select("referencia = '" + referencia + "'");

		// Actualizacion (si toca)
		if (curRem.first()) {
			curRem.setModeAccess(curRem.Edit);
			curRem.refreshBuffer();
		}
		else {
			curRem.setModeAccess(curRem.Insert);
			curRem.refreshBuffer();
			curRem.setValueBuffer("referencia", referencia);
		}

		curRem.setValueBuffer("codimpuesto", "IVA16");
		curRem.setValueBuffer("ivaincluido", true);
		curRem.setValueBuffer("codfamilia", "EXT");
		curRem.setValueBuffer("descripcion", "Extensión " + curLoc.valueBuffer("desccorta"));
		curRem.setValueBuffer("pvp", pvp);

		if (curRem.commitBuffer()) {
			exportados++;
		}
		// Error
		else {
			debug(util.translate("scripts",	"Error al exportar en la tabla remota %0 el código/id " ).arg(tabla) + valorClave);
		}

	}

	util.destroyProgressDialog();

	return exportados;
}

/** \D Elimina los registros en remoto que han sido eliminados en local previamente
*/
function oficial_eliminarObsoletos(tabla:String):Number
{
	var util:FLUtil = new FLUtil();

	var curDel:FLSqlCursor = new FLSqlCursor("registrosdel");
  	var curRem:FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);
	var campoClave:String = curRem.primaryKey();
	var eliminados:Number = 0;
	var paso:Number = 0;

	curDel.select("tabla = '" + tabla + "'");
	util.createProgressDialog( util.translate( "scripts", "Eliminando obsoletos de " ) + tabla, curDel.size());

	while(curDel.next()) {

		util.setProgress(paso++);
		curRem.select(campoClave + " = '" + curDel.valueBuffer("idcampo") + "'");
		if (curRem.first()) {
			curRem.setModeAccess(curRem.Del);
			curRem.refreshBuffer();
			if (curRem.commitBuffer()) {
				eliminados++;
				curDel.setModeAccess(curDel.Del);
				curDel.refreshBuffer();
				if (!curDel.commitBuffer())
					debug(util.translate("scripts",	"Error al eliminar en la tabla de registro eliminados %0 el código/id " ).arg(tabla) + valorClave);
			}
			else {
				debug(util.translate("scripts",	"Error al eliminar en la tabla remota %0 el código/id " ).arg(tabla) + valorClave);
			}
		}

		// Eliminamos una entrada obsoleta en registrosdel
		else {
			curDel.setModeAccess(curDel.Del);
			curDel.refreshBuffer();
			if (!curDel.commitBuffer())
				debug(util.translate("scripts",	"Error al eliminar en la tabla de registro eliminados %0 el código/id " ).arg(tabla) + valorClave);
		}

	}
	util.destroyProgressDialog();

	return eliminados;
}

function oficial_obtenerListaCampos(tabla:String):Array
{
	debug(tabla);
	var util:FLUtil = new FLUtil();
	var contenido:String = util.sqlSelect("flfiles", "contenido", "nombre = '" + tabla + ".mtd'");
	
	var xmlContenido = new FLDomDocument();
	xmlContenido.setContent(contenido);
	
	var listaCampos:FLDomNodeList;
	listaCampos= xmlContenido.elementsByTagName("field");
	
	var arrayCampos:Array = [];
	var paso:Number = 0;
	for(var i = 0; i < listaCampos.length(); i++) {
		if (!listaCampos.item(i).namedItem("name")) 
			continue;
		arrayCampos[paso] = listaCampos.item(i).namedItem("name").toElement().text();
		paso++;
	}
	return arrayCampos;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
