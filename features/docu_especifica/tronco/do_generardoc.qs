
/** @class_declaration docuEspecifica */
/////////////////////////////////////////////////////////////////
//// docuEspecifica /////////////////////////////////////////////////
class docuEspecifica extends head {
	var procesarFun:Boolean;
	var arrayPatch = [];
    function docuEspecifica( context ) { head ( context ); }
	function init() { return this.ctx.docuEspecifica_init() ;}
	function preprocesar() { return this.ctx.docuEspecifica_preprocesar() ;}
	function accionTienePatch(nodoAccion) { return this.ctx.docuEspecifica_accionTienePatch(nodoAccion); }
	function procesarModulo(rutaArea, dirModulo, nomFicheroMod) { return this.ctx.docuEspecifica_procesarModulo(rutaArea, dirModulo, nomFicheroMod) ;}
	function parsearPatchs() { return this.ctx.docuEspecifica_parsearPatchs() ;}
	function enPatch(fichero):Boolean { return this.ctx.docuEspecifica_enPatch(fichero) ;}
	function comprobarPatchs():Boolean { return this.ctx.docuEspecifica_comprobarPatchs() ;}
	function actualizarFun() { return this.ctx.docuEspecifica_actualizarFun() ;}
	function cambiarEstadoFun() { return this.ctx.docuEspecifica_cambiarEstadoFun() ;}
	function vaciarContenidos() { return this.ctx.docuEspecifica_vaciarContenidos() ;}
	function bufferChanged(fN:String) {	return this.ctx.docuEspecifica_bufferChanged(fN); }
	function funcionalParaDocumentar():Boolean { return this.ctx.docuEspecifica_funcionalParaDocumentar() ;}
}
//// docuEspecifica /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition docuEspecifica */
/////////////////////////////////////////////////////////////////
//// docuEspecifica /////////////////////////////////////////////////

/** \C
Cuando --procesarfun-- está deshabilitado la pestaña funcionalidades 
también lo está.
La ruta a los módulos muestra la ubicación de los módulos que serán documentados
y de los que se obtiene la lista.

Antes del proceso de documentación se comprueba que la ruta a los módulos
a documentar coincide con la ruta del cliente descargado con el módulo de
mantenimiento de versiones.

Los contenidos de la página de inicio son eliminados para generar la documentación
completamente nueva. El listado de módulos a documentar se resetea con todos los 
valores documentar a falso para después establecer a verdadero sólo aquellos que en
los que están contenidas las funcionalidades que se desean documentar.

Se comprueba también que los módulos afectados por las funcionalidades a documentar han sido 
cargados. Si todos los módulos necesarios han sido cargados, los valores del campo 'documentar'
de los módulos a documentar se ponen a false en todos los casos salvo los módulos necesarios

\end */
function docuEspecifica_init()
{
	this.iface.__init();		
	
	connect(this.child("pbnActualizarFun"), "clicked()", this, "iface.actualizarFun");
	connect(this.child("pbnCambiarEstadoFun"), "clicked()", this, "iface.cambiarEstadoFun");	
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");	
	
	this.child("twgEspecifica").setTabEnabled(1, this.child("fdbProcesarFun").value());
	this.child("lblDirModulos").text = this.iface.util.readSettingEntry("scripts/fldocuppal/dirModulos");
}

/** \D
Cuando --procesarfun-- está deshabilitado la pestaña funcionalidades 
también lo está
\end */
function docuEspecifica_bufferChanged(fN:String)
{ 
	switch (fN) {
		case "procesarfun": 
			this.child("twgEspecifica").setTabEnabled(1, this.child("fdbProcesarFun").value());
		break;
	}
}


/** \D
Antes del proceso de documentación se comprueba que la ruta a los módulos
a documentar coincide con la ruta del cliente descargado con el módulo de
mantenimiento de versiones

Los contenidos de la página de inicio son eliminados para generar la documentación
completamente nueva. El listado de módulos a documentar se resetea con todos los 
valores documentar a falso para después establecer a verdadero sólo aquellos que en
los que están contenidas las funcionalidades que se desean documentar.
\end */
function docuEspecifica_preprocesar()
{
	this.iface.procesarFun = this.child("fdbProcesarFun").value();
	
	if (!this.iface.procesarFun) 
			return this.iface.__preprocesar();

	if (!this.iface.funcionalParaDocumentar()) return false;
	
	var rutaFun:String = this.iface.util.readSettingEntry("scripts/flmaveppal/pathlocal") + this.child("fdbIdCliente").value() + "/modulos/";
	if (this.iface.util.readSettingEntry("scripts/fldocuppal/dirModulos") != rutaFun) {
		MessageBox.critical(this.iface.util.
			translate("scripts", "Para documentar las funcionalidades la ruta a los módulos debe ser\n") + rutaFun,
			MessageBox.Ok, MessageBox.NoButton,
			MessageBox.NoButton);
		return false;
	}
	
	this.iface.vaciarContenidos();
	
	if (!this.iface.parsearPatchs()) return false;
	
	if (!this.iface.comprobarPatchs()) return false;
	
	this.iface.__preprocesar();
}


/** \D
Procesa un módulo sólo con las acciones de las funcionalidades
seleccionadas

Obtiene del fichero '.mod' nombre, título, descripción, área y dependencias del módulo. Lee el fichero xml de acciones del módulo y obtiene un listado de acciones. Para cada una de ellas hace una llamada a la función 'procesarAccion'. 

@param	rutaArea Ruta en disco al directorio del área
@param	dirMódulo Nombre del directorio que contiene el módulo
@param	nomFicheroMod Nombre del fichero '.mod' del módulo
\end */
function docuEspecifica_procesarModulo(rutaArea, dirModulo, nomFicheroMod)
{
	if (!this.iface.procesarFun)
		return this.iface.__procesarModulo(rutaArea, dirModulo, nomFicheroMod);
	
	var fichModulo = new File(rutaArea + "/" + dirModulo + "/" + nomFicheroMod);
	fichModulo.open(File.ReadOnly);
	
	var xmlModulo:FLDomDocument = new FLDomDocument();
	xmlModulo.setContent(fichModulo.read());
	fichModulo.close();
	
	var listaModulo = xmlModulo.elementsByTagName("MODULE");
	var aliasArea:String = "";
	var dependencia:String;
	var version:String = "<span class=\"textogris_doc\">" + txVersion + "</span> ";
	var dependencias:String = "";
	var descModulo:String = "";
	
	// Se establecen las variables globales de alias y nombre del módulo
	if (listaModulo.item(0).namedItem("name")) 
			this.iface.nomModuloActual = listaModulo.item(0).namedItem("name").toElement().text();		
	if (listaModulo.item(0).namedItem("alias"))
			this.iface.aliasModuloActual = this.iface.obtenerAlias(listaModulo.item(0).namedItem("alias").toElement().text());
	if (listaModulo.item(0).namedItem("version"))
			version += listaModulo.item(0).namedItem("version").toElement().text();
	if (listaModulo.item(0).namedItem("areaname"))
			aliasArea = this.iface.obtenerAlias(listaModulo.item(0).namedItem("areaname").toElement().text());
	if (listaModulo.item(0).namedItem("description")) 
			descModulo = listaModulo.item(0).namedItem("description").toElement().text();
								

/** \D Se comprueba que el módulo está cargado
\end */		
	if (!sys.isLoadedModule(this.iface.nomModuloActual)) {
		MessageBox.information(this.iface.aliasModuloActual + " | " + aliasArea + 
				txModNoCargado, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	// Se obtiene el listado de dependencias
	if (listaModulo.item(0).namedItem("dependencies")) {
		var listaDepend = listaModulo.item(0).namedItem("dependencies").toElement().childNodes();				
		var areaYmodulo:Array;
				
		dependencias = "<span class=\"textogris_doc\">";
		dependencias += txDependencias + "</span> ";
		
		for(var i = 0; i < listaDepend.length(); i++) {
			if (listaDepend.item(i))
				areaYmodulo = this.iface.infoModulo(listaDepend.item(i).toElement().text());
			if (areaYmodulo) {
				dependencias += txModulo;
				dependencias += " " + areaYmodulo["modulo"] + " - ";
				dependencias += areaYmodulo["area"] + "\n";
				dependencias += "&nbsp;&nbsp;&nbsp;";
			}
		}
	}
	
	
	var htmlModulo:String = "\n<span class=\"descripcion_doc\">" + descModulo + "</span>";
	htmlModulo += "\n<br>&nbsp;<br>" + version + "\n<br>" + dependencias;
	htmlModulo += "\n\t<br>&nbsp;<br><span class=\"cabecera_menu_doc\">";
	htmlModulo += txFuncionalidades + "</span>";
	htmlModulo += "\n<br><ul class=\"menu_doc\">\n";
	
	// Procesado del fichero xml del módulo para obtener la lista de acciones
	var fichAcciones = new File(rutaArea + "/" + dirModulo + "/" + this.iface.nomModuloActual + ".xml");
	fichAcciones.open(File.ReadOnly);
	var xmlAcciones = new FLDomDocument();
	xmlAcciones.setContent(fichAcciones.read());
	fichAcciones.close();
	
	var listaAcciones = xmlAcciones.elementsByTagName("action");
	var nomAccion:String;
	var aliasAccion:String;
	var nodoAccion;
			
	this.iface.util.setProgress(0);		
	this.iface.util.setLabelText(txDocumentandoMod + " " + this.iface.aliasModuloActual + " - " + aliasArea);
	this.iface.util.setTotalSteps(listaAcciones.length());
	
	// arrayAcciones almacena el listado de las acciones para luego ordenarlas alfabéticamente
	var arrayAcciones:Array = [];
	var numAcciones:Number = 0;
	
	for(var i = 0; i < listaAcciones.length(); i++) {
			
/** \D
Antes de procesar las acciones se comprueba que están afectadas por las funcionalidades 
a documentar
Sólo se procesan aquellos ficheros referentes a acciones a de funcionalidades a documentar
\end */
		if (!this.iface.accionTienePatch(listaAcciones.item(i))) continue;
		
		nomAccion = listaAcciones.item(i).namedItem("name").toElement().text();
				
		aliasAccion = nomAccion;
		if (listaAcciones.item(i).namedItem("alias")) {
				aliasAccion = listaAcciones.item(i).namedItem("alias").toElement().text();
				aliasAccion = this.iface.obtenerAlias(aliasAccion);
		}
 		arrayAcciones[numAcciones++] = aliasAccion + "--__--" + nomAccion;
		
		nodoAccion = listaAcciones.item(i);
		nomPagina = ("xml_" + nomAccion); 
		
		// Se procesa cada una de las acciones
		this.iface.procesarAccion(nomPagina,nomAccion,nodoAccion,rutaArea,dirModulo);
		this.iface.util.setProgress(i);
	}
	
	// Se ordenan las acciones
	arrayAcciones.sort();
	for(i = 0; i < arrayAcciones.length; i++) {
		aliasYnombre = arrayAcciones[i];
		aliasYnombre = aliasYnombre.split("--__--");
		htmlModulo += "\t<li><a href=\"xml_" + aliasYnombre[1] + ".html\">" + aliasYnombre[0] + "</a>\n";
	}
		
		
/** \D Si el tipo de documentación es de desarrollador, hay que incluir el script ppal del módulo
\end */
	if (this.iface.tipoDoc == "D") {
		htmlsScript = new Array(2);
		htmlsScript = this.iface.procesarScript();

		if (htmlsScript) {
			cabecera = this.iface.crearCabecera(this.iface.nomModuloActual, "_paginafinal", "", txScriptPpal + " " + this.iface.aliasModuloActual);
			htmlScriptPpal = cabecera;
			htmlScriptPpal += htmlsScript[1];
			htmlModulo += "\t<li><a href\"" + this.iface.nomModuloActual + "_script.html\">[" + txScriptPpal + "]</a>\n";
			this.iface.escribirFichero(this.iface.nomModuloActual + "_script.html", htmlScriptPpal);
		}
	}				
	
	this.iface.util.setProgress(listaAcciones.length());
	htmlModulo += "</ul>";
	
	var cabecera:String = this.iface.crearCabecera(this.iface.nomModuloActual);
	htmlModulo = cabecera + htmlModulo;			
	this.iface.escribirFichero(this.iface.nomModuloActual + ".html", htmlModulo);
		

/** \D Las dependencias del módulo y la versión se guardan en la tabla de contenidos para elaborar después el html del área
\end */				
	var cursor:FLSqlCursor = new FLSqlCursor("do_modulos");
	cursor.select("modulo = '" + this.iface.nomModuloActual + "'");
	if (!cursor.first()) {
		cursor.setModeAccess(cursor.Insert);
		cursor.refreshBuffer();
		cursor.setValueBuffer("area", this.iface.nomAreaActual);
		cursor.setValueBuffer("modulo", this.iface.nomModuloActual);
		cursor.setValueBuffer("aliasmodulo", this.iface.aliasModuloActual);
		cursor.setValueBuffer("dependencias", dependencias);
		cursor.setValueBuffer("version", version);
		cursor.commitBuffer();
	}
	
	return true;
}

/** \D
Para cada una de las funcionalidades seleccionadas para documentar se busca el
fichero xml (ubicado en directorio_funcional/nombre_cliente/config/nombre_funcionalidad.xml) 
que contiene los nombres de los ficheros afectados por parches
Estos nombres se introducen en el array 'arrayPatch'
Posteriormente, al procesar una acción se comprueba si alguno de los ficheros de 
dicha acción se encuentra en el array de patch, en cuyo caso dicha acción será 
documentada.
\end */
function docuEspecifica_parsearPatchs() 
{
	var idCliente:String = this.cursor().valueBuffer("idcliente");
 	this.iface.arrayPatch = [];
	
	var fichero:String;
	var lonArrayPatch:Number = 0;
	var id:Number = this.cursor().valueBuffer("id");
	var q:FLSqlQuery = new FLSqlQuery();
	
	q.setTablesList("do_funcionalcli");
	q.setFrom("do_funcionalcli");
	q.setSelect("codfuncional");
	q.setWhere("documentar = 'true' AND idgenerardoc = " + id);

	if (!q.exec()) {
		MessageBox.critical(this.iface.util.
												translate("scripts", "Falló la consulta"),
												MessageBox.Ok, MessageBox.NoButton,
												MessageBox.NoButton);
		return false;
	}
	
	while (q.next()) {
		var xmlPatch:FLDomDocument = new FLDomDocument();
		fichero = this.iface.util.readSettingEntry("scripts/flmaveppal/pathlocal") + idCliente + "/config/" + q.value(0) + ".xml"	
		
		if (!File.exists(fichero)) {
			MessageBox.critical(this.iface.util.
					translate("scripts", "No existe el fichero de parche\n") + fichero,
					MessageBox.Ok, MessageBox.NoButton,
					MessageBox.NoButton);
			return false;
		}
		
		fich = new File(fichero);
		fich.open(File.ReadOnly);
		xmlPatch.setContent(fich.read());
		fich.close();
		
		var listaPatch = xmlPatch.elementsByTagName("flpatch:modifications");
		var listaPatchs = listaPatch.item(0).childNodes();
		
		for(var i = 0; i < listaPatchs.length(); i++) {
	   		this.iface.arrayPatch[lonArrayPatch++] = listaPatchs.item(i).attributeValue("name");
		}
	}
	return true;
}

/** \D 
Comprueba si un nodo obtenido del fichero de acciones de un módulo contiene algún
fichero afectado por un parche

@param nodo Nodo xml con la acción
@return true si el nodo contiene un fichero de parche, false en caso contrario
\end */
function docuEspecifica_accionTienePatch(nodo) 
{	
	var nomFich:String;
	var item:FLDomNode;
	
	item = nodo.namedItem("table");
	if (item) {
		nomFich = item.toElement().text() + ".mtd";
		if (this.iface.enPatch(nomFich)) return true;
	}
	
	item = nodo.namedItem("scriptform");
	if (item) {
		nomFich = item.toElement().text() + ".qs";
		if (this.iface.enPatch(nomFich)) return true;
	}
	
	item = nodo.namedItem("scriptformrecord");
	if (item) {
		nomFich = item.toElement().text() + ".qs";
		if (this.iface.enPatch(nomFich)) return true;
	}
	
	item = nodo.namedItem("form");
	if (item) {
		nomFich = item.toElement().text() + ".ui";
		if (this.iface.enPatch(nomFich)) return true;
	}
	
	item = nodo.namedItem("formrecord");
	if (item) {
		nomFich = item.toElement().text() + ".ui";
		if (this.iface.enPatch(nomFich)) return true;
	}
	return false;
}

/** \D 
Indica si un nombre de fichero se encuentra en el array de patchs

@param fichero Nombre del fichero
@return true si el nombre está en el array; false en caso contrario
\end */
function docuEspecifica_enPatch(fichero):Boolean
{
	for(var i = 0; i < this.iface.arrayPatch.length; i++) {
		if (this.iface.arrayPatch[i] == fichero) 
			return true;
	}
	return false;	
}

/** \D 
Actualiza el listado de funcionalidades que afectan al --idcliente--

En primer lugar se eliminan todos los registros de funcionalidades

Posteriormente se abre el fichero xml de configuración que debe ser
directorio_funcional/nombre_cliente/config/config.xml
El parseado de este fichero dobtiene el listado de funcionalidades, que
se traducen en registros de la tabla de funcionalidades

\end */
function docuEspecifica_actualizarFun() 
{
	var id:String = this.cursor().valueBuffer("id");
	var idCliente:String = this.cursor().valueBuffer("idcliente");

	// borrar la tabla				
	var curFun:FLSqlCursor = new FLSqlCursor("do_funcionalcli");
	curFun.select("idgenerardoc = " + id) ;
	while (curFun.next()) {
		curFun.setModeAccess(curFun.Del);
		curFun.refreshBuffer();
		curFun.commitBuffer();
	}

	fichero = this.iface.util.readSettingEntry("scripts/flmaveppal/pathlocal") + idCliente + "/config/config.xml"	
	if (!File.exists(fichero)) {
		MessageBox.critical(this.iface.util.
				translate("scripts", "No existe el fichero de configuración del cliente\n") + fichero,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	var xmlPatch:FLDomDocument = new FLDomDocument();
	fich = new File(fichero);
	fich.open(File.ReadOnly);
	xmlPatch.setContent(fich.read());
	fich.close();
	
	var listaPatch = xmlPatch.elementsByTagName("flmaveconfig:client");
	var listaPatchs = listaPatch.item(0).childNodes();
	
	for(var i = 0; i < listaPatchs.length(); i++) {
		curFun.setModeAccess(curFun.Insert);
		curFun.refreshBuffer();
		curFun.setValueBuffer("codfuncional", listaPatchs.item(i).attributeValue("name"));
		curFun.setValueBuffer("idgenerardoc", id);
		curFun.commitBuffer();
	}
	
	this.child("tdbFuncionalidades").refresh();
}

/** \D 
Cambia el estado del campo 'documentar' del registro de funcionalidad
activo en la tabla
\end */
function docuEspecifica_cambiarEstadoFun()
{
	var id:Number = this.child("tdbFuncionalidades").cursor().valueBuffer("id");

	var cursor:FLSqlCursor = new FLSqlCursor("do_funcionalcli");
	cursor.select("id = " + id);
	if (cursor.first()) {
		cursor.setModeAccess(cursor.Edit);
		cursor.refreshBuffer();
		documentar = cursor.valueBuffer("documentar");		
		cursor.setValueBuffer("documentar", true);
		if (documentar) cursor.setValueBuffer("documentar", false);
		cursor.commitBuffer();
	}

	this.child("tdbFuncionalidades").refresh();
}

/** \D 
Se utiliza para vaciar la tabla de contenidos de la documentación antes de comenzar
\end */
function docuEspecifica_vaciarContenidos()
{
	var curCon:FLSqlCursor = new FLSqlCursor("do_contenidos");
	curCon.select("") ;
	while (curCon.next()) {
		curCon.setModeAccess(curCon.Del);
		curCon.refreshBuffer();
		curCon.commitBuffer();
	}
}

/** \D 
Comprueba que los módulos afectados por las funcionalidades a documentar han sido 
cargados.

Si todos los módulos necesarios han sido cargados, los valores del campo 'documentar'
de los módulos a documentar se ponen a false en todos los casos salvo los módulos necesarios
\end */
function docuEspecifica_comprobarPatchs():Boolean
{
	var id:String = this.cursor().valueBuffer("id");
	var idCliente:String = this.cursor().valueBuffer("idcliente");
	var faltan = [];
	
	var curMod:FLSqlCursor = new FLSqlCursor("do_modulosdoc");
	var curFun:FLSqlCursor = new FLSqlCursor("do_funcionalcli");
	curFun.select("idgenerardoc = " + id + "AND documentar = 'true'");
	while (curFun.next()) {
		curFun.setModeAccess(curFun.Browse);
		codFuncional = curFun.valueBuffer("codfuncional");
		
		fichero = this.iface.util.readSettingEntry("scripts/flmaveppal/pathlocal") + idCliente + "/config/" + codFuncional + ".xml"	
		if (!File.exists(fichero)) {
			MessageBox.critical(this.iface.util.
					translate("scripts", "No existe el fichero de configuración\n") + fichero,
					MessageBox.Ok, MessageBox.NoButton,
					MessageBox.NoButton);
			return false;
		}
		
		curMod.select("idgenerardoc = " + id);
		while (curMod.next())	{
			curMod.setModeAccess(curMod.Edit);
			curMod.refreshBuffer();
			curMod.setValueBuffer("documentar", false);
			curMod.commitBuffer();
		}
		
		var xmlPatch:FLDomDocument = new FLDomDocument();
		fich = new File(fichero);
		fich.open(File.ReadOnly);
		xmlPatch.setContent(fich.read());
		fich.close();
		
		var listaPatch = xmlPatch.elementsByTagName("flpatch:modifications");
		var listaPatchs = listaPatch.item(0).childNodes();
		
		for(var i = 0; i < listaPatchs.length(); i++) {
			path = listaPatchs.item(i).attributeValue("path");
			arrayPath = path.split("/");
			
			curMod.select("idgenerardoc = " + id + " and area ='" + arrayPath[0] + "' and modulo = '" + arrayPath[1] + "'");
			if (curMod.first())	{
				curMod.setModeAccess(curMod.Edit);
				curMod.refreshBuffer();
				curMod.setValueBuffer("documentar", true);
				curMod.commitBuffer();
			}
		}
		
		this.child("tdbModulosDoc").refresh();
	}
	
	return true;
}

/** \D 
Comprueba que al menos una funcionalidad ha sido seleccionada para ser documentada
\end */
function docuEspecifica_funcionalParaDocumentar():Boolean
{
	var id:String = this.cursor().valueBuffer("id");
	
	var cursor:FLSqlCursor = new FLSqlCursor("do_funcionalcli");
	cursor.select("idgenerardoc = " + id + " AND documentar = 'true'") ;
	if (cursor.first()) {
		return true;
	}
	
	MessageBox.critical(this.iface.util.
			translate("scripts", "No hay funcionalidades seleccionadas en la tabla"),
			MessageBox.Ok, MessageBox.NoButton,
			MessageBox.NoButton);
	return false;
}

//// docuEspecifica /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
///////////////////////////////////////////////////////////