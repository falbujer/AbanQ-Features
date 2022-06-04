
/** @class_declaration etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ART�CULOS /////////////////////////////////////
class etiArticulo extends oficial {
	function etiArticulo( context ) { oficial ( context ); }
	function lanzarEtiArticulo(xmlKD:FLDomDocument) {
		return this.ctx.etiArticulo_lanzarEtiArticulo(xmlKD);
	}
	function tipoInformeEtiquetas() {
		return this.ctx.etiArticulo_tipoInformeEtiquetas();
	}
}
//// ETIQUETAS DE ART�CULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEtiArticulo */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class pubEtiArticulo extends ifaceCtx {
	function pubEtiArticulo( context ) { ifaceCtx( context ); }
	function pub_lanzarEtiArticulo(xmlKD) {
		return this.lanzarEtiArticulo(xmlKD);
	}
}
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ART�CULOS /////////////////////////////////////
/** \D Lanza el informe de etiquetas de art�culos.
\end */
function etiArticulo_lanzarEtiArticulo(xmlKD:FLDomDocument)
{
debug(xmlKD.toString(4));
	var rptViewer:FLReportViewer = new FLReportViewer();

	var datosReport:Array = this.iface.tipoInformeEtiquetas();
	try {
		rptViewer.setReportData(xmlKD);
	} catch (e) {
		return;
	}

	var etiquetaInicial:Array;
	if (datosReport["cols"] > 0) {
		etiquetaInicial = flfactinfo.iface.seleccionEtiquetaInicial();
	}

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(datosReport["nombreinforme"]);
	rptViewer.setReportData(xmlKD);
	if (datosReport["cols"] > 0) {
		rptViewer.renderReport(etiquetaInicial.fila, etiquetaInicial.col);
	} else {
		rptViewer.renderReport();
	}
	rptViewer.exec();
}

function etiArticulo_tipoInformeEtiquetas()
{
	var res:Array = [];
	res["nombreinforme"] = "i_a4_4x11";
	res["cols"] = 4;
	return res;
}
//// ETIQUETAS DE ART�CULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////
