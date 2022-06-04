
/** @class_declaration factPdf */
/////////////////////////////////////////////////////////////////
//// FACTURACI�N PDF ////////////////////////////////////////////
class factPdf extends oficial {
    function factPdf( context ) { oficial ( context ); }
	function lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, groupBy:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, datosPdf:Array) {
		return this.ctx.factPdf_lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, datosPdf);
	}
	function generarPdf(rptViewer:FLReportViewer, datosPdf:Array) {
		return this.ctx.factPdf_generarPdf(rptViewer, datosPdf);
	}
}
//// FACTURACI�N PDF ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubfactPdf */
/////////////////////////////////////////////////////////////////
//// FACTURACI�N PDF ////////////////////////////////////////////
class pubfactPdf extends ifaceCtx {
    function pubfactPdf( context ) { ifaceCtx ( context ); }
	function pub_lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, groupBy:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, datosPdf:Array) {
		return this.lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, datosPdf);
	}
}
//// FACTURACI�N PDF ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition factPdf */
/////////////////////////////////////////////////////////////////
//// FACTURACI�N PDF ////////////////////////////////////////////
/** \D
Lanza un informe
@param	cursor: Cursor con los criterios de b�squeda para la consulta base del informe
@param	nombreinforme: Nombre del informe
@param	orderBy: Cl�usula ORDER BY de la consulta base
@param	groupBy: Cl�usula GROUP BY de la consulta base
@param	etiquetas: Indicador de si se trata de un informe de etiquetas
@param	impDirecta: Indicador para imprimir directaemnte el informe, sin previsualizaci�n
@param	whereFijo: Sentencia where que debe preceder a la sentencia where calculada por la funci�n
@param	datosPdf: Array con los datos para la generaci�n en pdf.
\end */
function factPdf_lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, groupBy:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, datosPdf:Array)
{
	var util:FLUtil = new FLUtil();
	var etiquetaInicial:Array = [];
	if (etiquetas == true) {
		etiquetaInicial = this.iface.seleccionEtiquetaInicial();
	} else {
		etiquetaInicial["fila"] = 0;
		etiquetaInicial["col"] = 0;
	}

	var q:FLSqlQuery = this.iface.establecerConsulta(cursor, nombreInforme, orderBy, groupBy, whereFijo);

	if (q.exec() == false) {
		MessageBox.critical(util.translate("scripts", "Fall� la consulta"), MessageBox.Ok, MessageBox.NoButton);
		return;
	} else {
		if (q.first() == false) {
			MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de b�squeda establecidos"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
	}

	if (!nombreReport) 
		nombreReport = nombreInforme;
			
	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreReport);
	rptViewer.setReportData(q);
	rptViewer.renderReport(etiquetaInicial.fila, etiquetaInicial.col);
	if (datosPdf && datosPdf.pdf == true)
		this.iface.generarPdf(rptViewer, datosPdf);
	else {
		if (numCopias)
			rptViewer.setNumCopies(numCopias);
		if (impDirecta)
			rptViewer.printReport();
		else
			rptViewer.exec();
	}
}

/** \D Genera un fichero pdf con el resultado del visor de informes
@param rptViewer: Visor de informes que contiene el informe a generar
@param datosPdf: Datos necesarios para la generaci�n y el env�o del fichero pdf. Son los siguientes:
	pdf: Indica si la impresi�n es directa en papel o en un documento pdf
	destinoMail: Indica la direcci�n de correo electr�nico de destino para enviar el pdf
	nombreFichero: Indica el nombre con el que se guardar� el fichero en disco
\end */
function factPdf_generarPdf(rptViewer:FLReportViewer, datosPdf:Array)
{
	var util:FLUtil = new FLUtil();
	
	var pathLocal:String = util.readSettingEntry("scripts/flfacturac/pathLocal");
	if (!pathLocal) {	
		pathLocal = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "Ruta para guardar los ficheros PDF" ) );
		if ( !File.isDir( pathLocal ) ) {
			MessageBox.information( util.translate( "scripts", "Ruta err�nea" ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
			return;
		}
		util.writeSettingEntry("scripts/flfacturac/pathLocal", pathLocal);
 	}
	
	var fichPS:String = pathLocal + "tmp.ps";
	var fichPDF:String = pathLocal + datosPdf.nombreFichero + ".pdf";
	
	rptViewer.printReportToPS(fichPS);
	
	var comando:String = "pstill -c -F a4 -o " + fichPDF + " " + fichPS;
	Process.execute(comando);
	
	var res = MessageBox.information( util.translate( "scripts", "Se cre� el fichero %1\n\n�Desea enviarlo por email?" ).arg(fichPDF), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res == MessageBox.Yes) {
		var argumentos:Array;
		argumentos[0] = "kmail";
		argumentos[1] = datosPdf.destinoMail;
		argumentos[2] = "-s";
		argumentos[3] = datosPdf.nombreFichero;
		argumentos[4] = "--body";
		argumentos[5] = util.translate("scripts", "Adjuntamos una copia correspondiente a %1 en formato PDF").arg(datosPdf.nombreFichero);
		argumentos[6] = "--attach";
		argumentos[7] = fichPDF;
	
		try {
			Process.execute(argumentos);
		} catch (e) {
			MessageBox.critical( util.translate( "scripts", "Se produjo un error al ejecutar el comando de kmail. Aseg�rese de que kmail est� disponible en su sistema"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		}
	}
}
//// FACTURACI�N PDF ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
