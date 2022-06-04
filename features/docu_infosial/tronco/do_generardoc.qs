
/** @class_declaration docuInfosial */
/////////////////////////////////////////////////////////////////
//// DOCUINFOSIAL /////////////////////////////////////////////////
class docuInfosial extends oficial {
	var rutaWeb:String;
	var rutaWebDescargas:String;
    function docuInfosial( context ) { oficial ( context ); }
    function init() { this.ctx.docuInfosial_init(); }
	function publicarWeb() { return this.ctx.docuInfosial_publicarWeb() ;}
	function inicializarPub() { return this.ctx.docuInfosial_inicializarPub() ;}
	function procesarHTMLPub(fichero, esArea:String) { return this.ctx.docuInfosial_procesarHTMLPub(fichero, esArea) ;}
	function generarContenidosPub() { return this.ctx.docuInfosial_generarContenidosPub() ;}
	function copiarImagenesPub(rutaI) { return this.ctx.docuInfosial_copiarImagenesPub(rutaI) ;}
	function crearZip() { return this.ctx.docuInfosial_crearZip() ;}
	function cambiarDirWeb() { return this.ctx.docuInfosial_cambiarDirWeb() ;}
	function cambiarDirWebDescargas() { return this.ctx.docuInfosial_cambiarDirWebDescargas() ;}
}
//// DOCUINFOSIAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition docuInfosial */
/////////////////////////////////////////////////////////////////
//// DOCUINFOSIAL /////////////////////////////////////////////////

function docuInfosial_init()
{
	connect(this.child("pbnPublicarWeb"), "clicked()", this, "iface.publicarWeb");
	connect( this.child( "pbnCambiarDirWeb" ), "clicked()", this, "iface.cambiarDirWeb" );	
	connect( this.child( "pbnCambiarDirWebDescargas" ), "clicked()", this, "iface.cambiarDirWebDescargas" );	
	
	this.child("fdbDirWeb").setDisabled(true);	
	this.child("fdbDirWebDescargas").setDisabled(true);	
	
	this.iface.__init();
}

function docuInfosial_publicarWeb()
{
	var util:FLUtil = new FLUtil();	
	this.iface.inicializarPub();

	if (!File.exists(this.iface.rutaDoc)) {
		MessageBox.critical(this.iface.util.
				translate("scripts", "No se ha definido la ruta de documentación"),
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
	}
		
	res = MessageBox.information(this.iface.util.translate("scripts", "Se va a publicar en la web el contenido de la documentación\nLa documentación previa de la web será eliminada\n\n¿Estás seguro?"),
			MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes) return;
	
	var dirHTMLs;	

	var q:FLSqlQuery = new FLSqlQuery();

	q.setTablesList("do_modulosdoc");
	q.setFrom("do_modulosdoc");
	q.setSelect("area, codigomodulo");
	q.setWhere("documentar = 'true' AND idgenerardoc = " + this.cursor().valueBuffer("id"));

	if (!q.exec()) {
		MessageBox.critical(this.iface.util.
												translate("scripts", "Falló la consulta"),
												MessageBox.Ok, MessageBox.NoButton,
												MessageBox.NoButton);
		return false;
	}
		
	while (q.next()) {
			
		dirHTMLs = new Dir(this.iface.rutaDoc + q.value(0) + "/" + q.value(1));
		listaHTMLs = dirHTMLs.entryList("*.html", Dir.Files);
		
		util.createProgressDialog(
				this.iface.util.translate("scripts", "Publicando Documentacion de ") 
				+ q.value(0) + " / " + q.value(1), listaHTMLs.length);
		util.setProgress(1);
				
		this.iface.procesarHTMLPub(q.value(0) + "/" + q.value(0) + ".html", true);
		
		for (var k = 0; k < listaHTMLs.length; k++) {
			this.iface.procesarHTMLPub(q.value(0) + "/" + q.value(1) + "/" + listaHTMLs[k]);
			
			if (this.child("chkPublicarImg").checked)
					this.iface.copiarImagenesPub(q.value(0) + "/" + q.value(1));
			
			util.setProgress(k);
		}
		
		util.destroyProgressDialog();
	}
	
	this.iface.generarContenidosPub();
	
	if (this.child("chkPublicarZip").checked)
			this.iface.crearZip();
		
	MessageBox.information(this.iface.util.
			translate("scripts", "Proceso finalizado"),
			MessageBox.Ok, MessageBox.NoButton,
			MessageBox.NoButton);
}


function docuInfosial_cambiarDirWeb()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "RUTA DE PUBLICACION WEB" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	this.child("fdbDirWeb").setValue(ruta);
}

function docuInfosial_cambiarDirWebDescargas()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "RUTA DE DESCARGAS WEB" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	this.child("fdbDirWebDescargas").setValue(ruta);
}


function docuInfosial_procesarHTMLPub(fichero, esArea)
{
	var nomFichero, contenido:String;
	var arrayContenido:Array;
	
	fichero = this.iface.rutaDoc + fichero;
	
	if (!File.exists(fichero)) {
		MessageBox.critical(this.iface.util.
				translate("scripts", "No se encontró el fichero \n") + fichero,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	fich = new File(fichero);
	nomFichero = fich.baseName;
	fich.open(File.ReadOnly);
	contenido = fich.read();
	fich.close();
	
	arrayContenido = contenido.split("<body>");
	if (arrayContenido.length == 0) {
		MessageBox.critical(this.iface.util.
				translate("scripts", "No se encontró la etiqueta <body> en el fichero \n") + fichero,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	contenido = arrayContenido["1"];
	arrayContenido = contenido.split("</body>");
	contenido = arrayContenido["0"];
	
	var re = /\.\.\//g;	
	contenido = contenido.replace(re, "");
 	contenido = this.iface.sustituyeString(contenido, "a href=\"", "a href=\"ver_doc.php?pag=" + this.iface.tipoDoc + "/");
 	contenido = this.iface.sustituyeString(contenido, "pag=" + this.iface.tipoDoc + "\/#", 	"pag=" + this.iface.tipoDoc + "/" + nomFichero + ".html#");
	contenido = this.iface.sustituyeString(contenido, "<br>\\n<a name=\"inicio\">", "<a name=\"inicio\">");

	if (esArea) {
		var q:FLSqlQuery = new FLSqlQuery();
	
		q.setTablesList("do_modulosdoc");
		q.setFrom("do_modulosdoc");
		q.setSelect("codigomodulo");
		q.setWhere("idgenerardoc = " + this.cursor().valueBuffer("id"));
	
		if (!q.exec()) {
			MessageBox.critical(this.iface.util.
													translate("scripts", "Falló la consulta"),
													MessageBox.Ok, MessageBox.NoButton,
													MessageBox.NoButton);
			return false;
		}
			
		while (q.next()) {
			contenido = this.iface.sustituyeString(contenido, q.value(0) + "\/" + q.value(0), q.value(0));
		}
	}		
			
	fich = new File(this.iface.rutaWeb + this.iface.tipoDoc + "/" + nomFichero + ".html");
	fich.open(File.WriteOnly);
	fich.write(contenido);
	fich.close();
}

function docuInfosial_copiarImagenesPub(rutaI)
{
	var origenI:String = this.iface.rutaDoc + rutaI + "/images/";
	
	dirI = new Dir(origenI);
	listaI = dirI.entryList("*.png", Dir.Files);
	for (var i = 0; i < listaI.length; i++) {
	
		var comando = [ "cp",  origenI + listaI[i], this.iface.rutaWeb + "images"];
		
		var res:Array = [];
		Process.execute(comando);
		if (Process.stderr != "") {
				res["ok"] = false;
				res["salida"] = Process.stderr;
		} else {
				res["ok"] = true;
				res["salida"] = Process.stdout;
		}
		debug(res["ok"]);
		debug(res["salida"]);
 		Process.execute(comando);
	}
}
	
function docuInfosial_crearZip()
{
	var comando:String;
	var nomZip:String = "facturalux-doc-usr.zip";		
	if (this.iface.tipoDoc == "D") nomZip = "facturalux-doc-dev.zip";
	nomZip = this.iface.rutaDestino + nomZip;debug("zip -r " + nomZip + " " + this.iface.rutaDoc);

	// Borrar el anterior		
	comando = "rm -f " + nomZip;
	Process.execute(comando);
	
	if (Process.stderr != "") {
		MessageBox.critical(
				this.iface.util.
				translate("scripts", "Se produjo un error al ejecutar el comando\n") + comando + "\n\n " + Process.stderr,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
	}

					
	// Crear el nuevo
	comando = 
		"cd " + this.iface.rutaDestino + ";" + 
		"zip -r " + nomZip + " " + this.iface.tipoDoc + " " +
		"estilos.css " +
		"estilosD.css " +
		"estilosU.css " +
		"terminos.html " +
		"licencia.html " +
		"footer.html ";
		
	fich = new File(this.iface.rutaDestino + "comando");
	fich.open(File.WriteOnly);
	fich.write(comando);
	fich.close();
	
	// Permiso de ejecución
	Process.execute("chmod +x " + this.iface.rutaDestino + "comando");
	
	Process.execute(this.iface.rutaDestino + "comando");	
	
	if (Process.stderr != "") {
		MessageBox.critical(
				this.iface.util.
				translate("scripts", "Se produjo un error al ejecutar el comando\n") + comando + "\n\n " + Process.stderr,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
	}
	
	// Moverlo a la web
	comando = "mv -f " + nomZip + " " + this.iface.rutaWebDescargas;
	Process.execute(comando);
	
	if (Process.stderr != "") {
		MessageBox.critical(
				this.iface.util.
				translate("scripts", "Se produjo un error al ejecutar el comando\n") + comando + "\n\n" + Process.stderr,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
	}
}
	
function docuInfosial_inicializarPub():Boolean
{
	var util:FLUtil = new FLUtil();	

	this.iface.tipoDoc = "guia_usuario";
	if (this.child("fdbTipoDoc").value() == 1) this.iface.tipoDoc = "D";
	
	this.iface.rutaDestino = util.readSettingEntry("scripts/fldocuppal/dirDestino");
	this.iface.rutaWeb = this.cursor().valueBuffer("dirweb");
	this.iface.rutaWebDescargas = this.cursor().valueBuffer("dirwebdescargas");

	// las rutas deben finalizar en '/'
	if (this.iface.rutaDestino.right(1) != "/") {
		this.iface.rutaDestino += "/";
	}
	
	// las rutas deben finalizar en '/'
	if (this.iface.rutaWeb.right(1) != "/") {
		this.iface.rutaWeb += "/";
	}
	
	// las rutas deben finalizar en '/'
	if (this.iface.rutaWebDescargas.right(1) != "/") {
		this.iface.rutaWebDescargas += "/";
	}
	
	// Se comprueba la existencia de las rutas
	if (!File.exists(this.iface.rutaDestino)) {
		MessageBox.critical(this.iface.util.
				translate("scripts", "La ruta de destino especificada no existe"),
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	// Se comprueba la existencia de las rutas
	if (!File.exists(this.iface.rutaWeb)) {
		MessageBox.critical(this.iface.util.
				translate("scripts", "La ruta de publicación web especificada no existe"),
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	// Se comprueba la existencia de las rutas
	if (!File.exists(this.iface.rutaWebDescargas)) {
		MessageBox.critical(this.iface.util.
				translate("scripts", "La ruta de descargas web especificada no existe"),
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	this.iface.rutaDoc = this.iface.rutaDestino + this.iface.tipoDoc + "/";
	this.iface.rutaIncludes = this.iface.rutaDoc + "includes/";
	
	// Verifica que existe la ruta principal
	var dirRutaDoc = new Dir(this.iface.rutaDoc);
	if (!File.exists(this.iface.rutaDoc))
			dirRutaDoc.mkdir();
			
	// Verifica que existe la ruta de includes
	var dirRutaIncludes = new Dir(this.iface.rutaIncludes);
	if (!File.exists(this.iface.rutaIncludes))
			dirRutaIncludes.mkdir();
			
	
	this.iface.rutaImg = this.iface.rutaDestino + "images/";
	this.iface.dirImg = "images/";
	this.iface.rutaDoc = this.iface.rutaDestino + this.iface.tipoDoc + "/";
	this.iface.rutaPDF = this.iface.rutaDestino + "pdf/";

	var dirRutaWeb = new Dir(this.iface.rutaWeb);
	if (!dirRutaWeb.fileExists(this.iface.tipoDoc)) dirRutaWeb.mkdir(this.iface.tipoDoc);
	
	return true;	
}

function docuInfosial_generarContenidosPub():String
{
	var q:FLSqlQuery = new FLSqlQuery();
	
	q.setTablesList("do_contenidos");
	q.setFrom("do_contenidos");
	q.setSelect("area, aliasarea, modulo, aliasmodulo, accion, pagina");
	q.setOrderBy("area, modulo, accion");
	
	if (!q.exec()) {
			MessageBox.critical(this.iface.util.
													translate("scripts", "Error al ejecutar la consulta de generación de contenidos"),
													MessageBox.Ok, MessageBox.NoButton,
													MessageBox.NoButton);
			return false;
	}
	
	var htmlIndice:String = "";
	var areaQ:String = "";
	var moduloQ:String = "";
	
	while (q.next()) {
	
		if (q.value(0) != areaQ) {
		
			if (areaQ != "") htmlIndice += "<br>&nbsp;<br>";
			htmlIndice += "<a href=\"" + q.value(0) + ".html\">";
			htmlIndice += "<b>" + q.value(1) + "</b></a>";						
			
			areaQ = q.value(0);
		}
				
		if (q.value(2) != moduloQ) {
			htmlIndice += "<br>&nbsp;<br>" + sepTOC;
			htmlIndice += "<span class=\"toc_modulo_doc\">\n";
			htmlIndice += "<a href=\"" + q.value(2) + ".html\">"; 
			htmlIndice += "<b>" + txModulo + " " + q.value(3) + "</b></a></span>";
			
			moduloQ = q.value(2);
		}
				
		htmlIndice += "<br>" + sepTOC + sepTOC;
		htmlIndice += "<span class=\"toc_accion_doc\">\n";
		htmlIndice += "<a href=\"" + q.value(5) + "\">";
		htmlIndice += q.value(4) + "</a></span>";
	}		

	/** \D Al final de la tabla de contenidos se añade un enlace a la página de términos
	\end */		
	htmlIndice += "<br>&nbsp;<br>&nbsp;<br>";
	htmlIndice += "<span class=\"toc_accion_doc\">\n";
	htmlIndice += "<a href=\"terminos.html\">";
	htmlIndice += txTerminos + "</a></span>";
	
	htmlIndice = "<div class = \"toc_menucompleto_doc\">" + htmlIndice + "</div>";
	
	var cabecera:String = this.iface.crearCabecera("", "_indice", "", "");
	htmlIndice = "<div class = \"toc_menucompleto_doc\">" + htmlIndice + "</div>";
	var contenido:String = cabecera + htmlIndice;
	
	contenido = this.iface.sustituyeString(contenido, "a href=\"", "a href=\"ver_doc.php?pag=" + this.iface.tipoDoc + "/");
	
	fich = new File(this.iface.rutaWeb + this.iface.tipoDoc + "/index.html");
	fich.open(File.WriteOnly);
	fich.write(contenido);
	fich.close();
}

//// DOCUINFOSIAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////