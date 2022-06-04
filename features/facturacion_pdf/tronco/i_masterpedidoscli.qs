
/** @class_declaration factPdf */
/////////////////////////////////////////////////////////////////
//// FACTURACIÓN PDF ////////////////////////////////////////////
class factPdf extends oficial {
    function factPdf( context ) { oficial ( context ); }
	function init() {
		this.ctx.factPdf_init();
	}
	function generarPdf() {
		return this.ctx.factPdf_generarPdf();
	}
	function establecerDatosPdf():Array {
		return this.ctx.factPdf_establecerDatosPdf();
	}
}
//// FACTURACIÓN PDF ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition factPdf */
/////////////////////////////////////////////////////////////////
//// FACTURACIÓN PDF ////////////////////////////////////////////
function factPdf_init()
{
	this.iface.__init();
	connect(this.child("tbnGenerarPDF"), "clicked()", this, "iface.generarPdf()");
}

/** \D Lanza el informe especificando que debe generarse en formato PDF
\end */
function factPdf_generarPdf()
{
	var cursor:FLSqlCursor = this.cursor();
	var pI:Array = this.iface.obtenerParamInforme();
	if (!pI)
		return;

	var datosPdf:Array = this.iface.establecerDatosPdf();
	if (!datosPdf)
		return;

	flfactinfo.iface.pub_lanzarInforme(cursor, pI.nombreInforme, pI.orderBy, pI.groupBy, pI.etiquetas, pI.impDirecta, pI.whereFijo, pI.nombreReport, pI.numCopias, datosPdf);
}

/** \D Establece los datos necesarios para generar el fichero pdf correspondiente al informe
@return	array con los datos o false si hay error
\end */
function factPdf_establecerDatosPdf():Array
{
	var util:FLUtil = new FLUtil;
	var hoy:Date = new Date;
	var cursor:FLSqlCursor = this.cursor();

	var datosPdf:Array = [];
	datosPdf["pdf"] = true;
	if (cursor.action() == "i_respedidoscli")
		datosPdf["nombreFichero"] = util.translate("scripts", "Resumen_de_pedidos_%1-%2-%3").arg(hoy.getDate()).arg(hoy.getMonth()).arg(hoy.getYear());
	else
		datosPdf["nombreFichero"] = util.translate("scripts", "Detalle_de_pedidos_%1-%2-%3").arg(hoy.getDate()).arg(hoy.getMonth()).arg(hoy.getYear());

	datosPdf["destinoMail"] = "";

	return datosPdf;
}
//// FACTURACIÓN PDF ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
