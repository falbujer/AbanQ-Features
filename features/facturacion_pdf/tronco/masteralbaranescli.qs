
/** @class_declaration documentosPdf */
/////////////////////////////////////////////////////////////////
//// DOCUMENTOSPDF //////////////////////////////////////////////////
class documentosPdf extends oficial {
    function documentosPdf( context ) { oficial ( context ); }
	function init() {
		return this.ctx.documentosPdf_init();
	}
	function generarPDF() {
		return this.ctx.documentosPdf_generarPDF();
	}
	function pub_generarPDF(curDocumento:FLSqlCursor, nomDocumento:String, nomQuery:String, nomReport:String, destino:String) {
		return this.ctx.documentosPdf_pubGenerarPDF(curDocumento, nomDocumento, nomQuery, nomReport, destino);
	}
}
//// DOCUMENTOSPDF //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition documentosPdf */
/////////////////////////////////////////////////////////////////
//// DOCUMENTOSPDF //////////////////////////////////////////////////

function documentosPdf_init() 
{
	connect(this.child("pbnGenerarPDF"), "clicked()", this, "iface.generarPDF");
	this.iface.__init();
}

function documentosPdf_generarPDF() {
	var util:FLUtil = new FLUtil;
	var destino:String = util.sqlSelect("clientes", "email", "codcliente = '" + this.cursor().valueBuffer("codcliente") + "'");
	this.iface.pub_generarPDF(this.cursor(), "Albaran", "i_albaranescli", "i_albaranescli", destino);
}

function documentosPdf_pubGenerarPDF(curDocumento:FLSqlCursor, nomDocumento:String, nomQuery:String, nomReport:String, destino:String) 
{
	var util:FLUtil = new FLUtil();
	
	if (!curDocumento.isValid())
			return;
	
	var pathLocal:String = 	util.readSettingEntry("scripts/flfacturac/pathLocal");
	if (!pathLocal) {	
		pathLocal = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "Ruta para guardar los ficheros PDF" ) );
		if ( !File.isDir( pathLocal ) ) {
			MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
									MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
			return;
		}
		util.writeSettingEntry("scripts/flfacturac/pathLocal", pathLocal);
 	}
	
	var codigo:String = curDocumento.valueBuffer("codigo");
	var fichPS:String = pathLocal + "tmp.ps";
	var fichPDF:String = pathLocal + nomDocumento + "_" + codigo + ".pdf";
	
	var rptViewer:FLReportViewer = new FLReportViewer();
	var qRpt:FLSqlQuery = new FLSqlQuery(nomQuery);
	qRpt.setWhere("codigo = '" + codigo + "'");
	
	rptViewer.setReportTemplate(nomReport);
	rptViewer.setReportData(qRpt);
	
	rptViewer.renderReport(0, 0);
	rptViewer.printReportToPS(fichPS);
	
	var comando:String = "pstill -c -F a4 -o " + fichPDF + " " + fichPS;
	Process.execute(comando);
	
	var res = MessageBox.information( util.translate( "scripts", "Se creó el fichero %1\n\n¿Desea enviarlo por email?" ).arg(fichPDF),
			MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	
	if (res == MessageBox.Yes) {
		var argumentos:Array;
		argumentos[0] = "kmail";
		argumentos[1] = destino;
		argumentos[2] = "-s";
		argumentos[3] = nomDocumento + " " + codigo;
		argumentos[4] = "--body";
		argumentos[5] = util.translate("scripts", "Adjuntamos una copia correspondiente a %1 %2 en formato PDF").arg(nomDocumento).arg(codigo);
		argumentos[6] = "--attach";
		argumentos[7] = fichPDF;
	
		try {
			Process.execute(argumentos);
		} catch (e) {
			MessageBox.critical( util.translate( "scripts", "Se produjo un error al ejecutar el comando de kmail. Asegúrese de que kmail está disponible en su sistema"),
					MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			this.setDisabled( false );
		}
	}	
}

//// DOCUMENTOSPDF //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
