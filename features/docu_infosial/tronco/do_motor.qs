/***************************************************************************
                 do_motor.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration docuInfosial */
/////////////////////////////////////////////////////////////////
//// DOCUINFOSIAL /////////////////////////////////////////////////
class docuInfosial extends oficial {
	var proceso:FLProcess;
	var rutaDox:String;
	var rutaMotor:String;
    function init() { this.ctx.docuInfosial_init(); }
    function docuInfosial( context ) { oficial ( context ); }
	function cambiarDirPub() { return this.ctx.docuInfosial_cambiarDirPub() ;}
	function cambiarDirPubPub() { return this.ctx.docuInfosial_cambiarDirPubPub() ;}
	function generarDoc() { return this.ctx.docuInfosial_generarDoc() ;}
	function publicarWeb() { return this.ctx.docuInfosial_publicarWeb() ;}
	function procesarDoxyfile() { return this.ctx.docuInfosial_procesarDoxyfile() ;}
	function procesarHTMLPub(fichero) { return this.ctx.docuInfosial_procesarHTMLPub(fichero) ;}
	function procesarPiePagina() { return this.ctx.docuInfosial_procesarPiePagina() ;}
	function sustituyeString(texto, cadena1, cadena2):String { return this.ctx.docuInfosial_sustituyeString(texto, cadena1, cadena2) ;}
}
//// DOCUINFOSIAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends docuInfosial {
    function head( context ) { docuInfosial ( context ); }
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


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
///////////////////////////////////////////////////////////////


/** @class_definition docuInfosial */
/////////////////////////////////////////////////////////////////
//// DOCUINFOSIAL /////////////////////////////////////////////////

/** \C
Los campos --rutapub-- y --rutapubpub-- están deshabilitados.

La publicación privada de la documentación consiste en la generación de un conjunto de
ficheros html completos en un directorio de acceso privado. El directorio sera independiente
y podra copiarse o moverse sin perder funcionalidad, tambien puede crearse un fichero 
comprimido a partir del mismo
 
La publicación pública consiste en un procesado de los ficheros previamente creados para
su publicación privada, para después copiar estos ficheros dentro de la estructura de directorios
de la web de FacuraLUX. Este procesado consiste en quitar las cabeceras html y cambiar los enlaces
para ajustarlos al esquema de páginas de la web.
\end */
function docuInfosial_init() 
{
	connect( this.child( "pbnGenerarDoc" ), "clicked()", this, "iface.generarDoc" );
	connect( this.child( "pbnPublicarWeb" ), "clicked()", this, "iface.publicarWeb" );
	connect( this.child( "pbnCambiarDirPub" ), "clicked()", this, "iface.cambiarDirPub" );
	connect( this.child( "pbnCambiarDirPubPub" ), "clicked()", this, "iface.cambiarDirPubPub" );
	this.child("fdbRutaPub").setDisabled(true);
	this.child("fdbRutaPubPub").setDisabled(true);
}


/** \D
Arranca la generación de la documentación. Básicamente esto se limita a la ejecución del proceso
doxygen con un fichero doxyfile previamente formateado para ajustarlo a nuestras necesidades

En primer lugar se comprueba que todos ficheros y rutas de trabajo con correctas, y 
a continuación se arranca el proceso doxygen
\end */
function docuInfosial_generarDoc() 
{
	var util:FLUtil = new FLUtil();

	this.iface.rutaDox = util.readSettingEntry("scripts/fldocuppal/dirSistema") + "sistema/documentacion/doxygen/"
	
	if (!File.exists(this.iface.rutaDox)) {
		MessageBox.critical(util.translate("scripts", "No existe el directorio:\n") + this.iface.rutaDox,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	this.iface.rutaMotor = util.readSettingEntry("scripts/fldocuppal/dirMotor") + "flbase/"
	
	if (!File.exists(this.iface.rutaMotor)) {
		MessageBox.critical(util.translate("scripts", "No existe el directorio:\n") + this.iface.rutaMotor,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	if (!File.exists(this.child("fdbRutaPub").value())) {
		MessageBox.critical(util.translate("scripts", "No existe el directorio:\n") + this.child("fdbRutaPub").value(),
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	
	this.setDisabled(true);
	
	this.iface.procesarPiePagina();
	this.iface.procesarDoxyfile();
		
	var comando = [ "doxygen", this.iface.rutaDox + "motor_doxyfile"];
	
	var res:Array = [];
	Process.execute(comando);
	if (Process.stderr != "") {
			res["ok"] = false;
			res["salida"] = Process.stderr;
	} else {
			res["ok"] = true;
			res["salida"] = Process.stdout;
	}	
	
	MessageBox.information(util.translate("scripts", "Finalizada la generación de documentación en \n") + this.child("fdbRutaPub").value(), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	
	this.setDisabled(false);
}

/** \D
Realiza el procesado del fichero motor_doxyfile para establecer el fichero de origen de
la documentación (FLObjectFactory.h), el directorio de destino de los html generados, 
el pie de página y la hoja de estilos css.
\end */
function docuInfosial_procesarDoxyfile() 
{ 
	var fichDF = new File(this.iface.rutaDox + "motor_doxyfile");
	fichDF.open(File.ReadOnly);
	var contenido = fichDF.read();
	fichDF.close();

	contenido = contenido.split("##seccion_infosial##");
	contenido = contenido[0];
	contenido += "##seccion_infosial##";
	contenido += "\nHTML_OUTPUT = " + this.child("fdbRutaPub").value();
	contenido += "\nINPUT = " + this.iface.rutaMotor + "FLObjectFactory.h";
	contenido += "\nHTML_FOOTER = " + this.iface.rutaDox + "motor_footer.html";
	contenido += "\nHTML_STYLESHEET = " + this.iface.rutaDox + "motor_doxygen.css";
		
	fichDF.open(File.WriteOnly);
	fichDF.write(contenido);
	fichDF.close();
} 

/** \D
Crea un fichero footer.html que será incluido al pie de todas las páginas de la documentación
con la fecha de generación
\end */
function docuInfosial_procesarPiePagina() 
{ 
	var fecha:Date = new Date();
	
	var contenido:String;
	contenido += "<div style=\"color:#555555; font-size:11px; font-family:verdana, arial; margin-top:30px; text-align:center\">\n";
	contenido += "<hr size=\"1\">\n";	
	contenido += "Documentación del Motor de FacturaLUX - &copy; InfoSiAL, S.L.<br>\n";
	contenido += "Actualizado " + fecha.toString();
	contenido += "</div>";	
	
	var fichDF = new File(this.iface.rutaDox + "motor_footer.html");
	fichDF.open(File.WriteOnly);
	fichDF.write(contenido);
	fichDF.close();
} 

/** \D
Abre el cuadro de diálogo para seleccionar el directorio de publicación privada
\end */
function docuInfosial_cambiarDirPub()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "RUTA AL MOTOR" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	this.child("fdbRutaPub").setValue(ruta);
}


/** \D
Abre el cuadro de diálogo para seleccionar el directorio de publicación pública (en la web)
\end */
function docuInfosial_cambiarDirPubPub()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "RUTA AL MOTOR" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	this.child("fdbRutaPubPub").setValue(ruta);
}


/** \D
Arranca el procesado de los ficheros para publicarlos en la web
\end */
function docuInfosial_publicarWeb()
{	
	var util:FLUtil = new FLUtil();
	
	res = MessageBox.information(util.translate("scripts", "Se publicará la documentación en la web de forma abierta\n¿Estás seguro?"),
			MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes) return;
	
	if (!File.exists(this.child("fdbRutaPub").value())) {
		MessageBox.critical(util.translate("scripts", "No existe el directorio:\n") + this.child("fdbRutaPub").value(),
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	var rutaDoc:String = this.child("fdbRutaPub").value();
	var dirDoc = new Dir(rutaDoc);
	
	this.setDisabled(true);
	
	docs = dirDoc.entryList("*.html", Dir.Files);
	util.createProgressDialog(util.translate("scripts", "Publicando Documentacion del Motor"), docs.length);
	util.setProgress(1);
	var paso:Number = 0;
	
	for (var k = 0; k < docs.length; k++) {
		if (!this.iface.procesarHTMLPub(rutaDoc + docs[k])) {
			util.destroyProgressDialog();
			return false;
		}
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();

	MessageBox.information(util.translate("scripts", "Finalizada la publicación de la documentación en ") + this.child("fdbRutaPubPub").value(), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	this.setDisabled(false);

}

/** \D
Procesa un fichero previamente generado para su publicación privada para ajustarlo
al esquema de la web de FacturaLUX, y después lo copia a dicha web.

@param fichero Ruta completa al fichero a procesar 
\end */
function docuInfosial_procesarHTMLPub(fichero)
{
	var util:FLUtil = new FLUtil();
	var nomFichero, contenido:String;
	var arrayContenido:Array;
	
	if (!File.exists(fichero)) {
		MessageBox.critical(util.translate("scripts", "No se encontró el fichero \n") + fichero,
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
		MessageBox.critical(util.translate("scripts", "No se encontró la etiqueta <body> en el fichero \n") + fichero,
				MessageBox.Ok, MessageBox.NoButton,
				MessageBox.NoButton);
		return false;
	}
	
	contenido = arrayContenido["1"];
	arrayContenido = contenido.split("</body>");
	contenido = arrayContenido["0"];
		
 	contenido = this.iface.sustituyeString(contenido, "Jerarquía&nbsp;de&nbsp;la&nbsp;clase", "Jerarquía");
 	contenido = this.iface.sustituyeString(contenido, "Lista&nbsp;de&nbsp;componentes", "Componentes");
 	contenido = this.iface.sustituyeString(contenido, "href=\"", "href=\"ver_doc.php?pag=interfaz_scripts/");
 	contenido = this.iface.sustituyeString(contenido, "<hr>", "<hr size=\"1\">");
 	contenido = this.iface.sustituyeString(contenido, ">Más...</a>", "></a>");
	contenido = this.iface.sustituyeString(contenido, ">Página&nbsp;principal</a>", "></a>");
	
	
	fich = new File(this.child("fdbRutaPubPub").value() + "interfaz_scripts/" + nomFichero + ".html");
	fich.open(File.WriteOnly);
	fich.write(contenido);
	fich.close();
	
	return true;
}

/** \D Sustituye una cadena por otra en un texto. Utilizada para procesar ficheros de texto

@param	texto Texto original
@param	cadena1 Cadena buscada
@param	cadena2 Cadena de sustitución
@return	Texto modificado
\end */
function docuInfosial_sustituyeString(texto, cadena1, cadena2):String
{
	var patternRE:RegExp = new RegExp(cadena1);
	patternRE.global = true;
	return texto.replace(patternRE, cadena2);	
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
////////////////////////////////////////////////////////////////
