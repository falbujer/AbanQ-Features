
/** @class_declaration modelo340 */
/////////////////////////////////////////////////////////////////
//// MODELO 340 /////////////////////////////////////////////////
class modelo340 extends oficial {
	function modelo340( context ) { oficial ( context ); }
	function init() {
		return this.ctx.modelo340_init();
	}
	function rellenarTablasModelo340() {
		return this.ctx.modelo340_rellenarTablasModelo340();
	}
	function tablas340_2012() {
		return this.ctx.modelo340_tablas340_2012();
	}
}
//// MODELO 340 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo340 */
/////////////////////////////////////////////////////////////////
//// MODELO 340 /////////////////////////////////////////////////
function modelo340_init()
{
	var _i = this.iface;
	_i.__init();

	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = new FLSqlCursor("co_identifpaisresidencia");
	cursor.select();
	if (!cursor.first()) {
		var res:Number = MessageBox.information(util.translate("scripts","Insertar tablas para el modelo 340."),MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return false;
		} else {
			_i.rellenarTablasModelo340();
		}
	}
	if (!_i.tablas340_2012()) {
		return false;
	}
}

function modelo340_tablas340_2012()
{
	var util = new FLUtil;
	if (!util.sqlSelect("co_claveoperacion", "codigo", "codigo = 'R'")) {
		var cursor = new FLSqlCursor("co_claveoperacion");
		var claveOperacion =
			[["R", "Arrendamientos"],["S", "Subvenciones"],["T", "Cobros por cuenta de terceros"],["U", "Seguros"],["V", "Compras de agencias de viajes"],["W", "Operaciones sujetas al Impuesto sobre Producci�n, Servicios y Importaci�n en Ceuta y Melilla"],["X", "Operaciones por las que empresarios que satisfagan compensaciones agr�colas hayan expedido recibo"]];
		for (var i = 0; i < claveOperacion.length; i++) {
			with(cursor) {
				setModeAccess(cursor.Insert);
				refreshBuffer();
				setValueBuffer("codigo", claveOperacion[i][0]);
				setValueBuffer("descripcion", claveOperacion[i][1]);
				commitBuffer();
			}
		}
	}
	
	return true;
}

function modelo340_rellenarTablasModelo340()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = new FLSqlCursor("co_identifpaisresidencia");
	var clavePaisResidencia:Array =
		[["1", "Corresponde a un NIF"],["2", "Se consigna el NIF/IVA (NIF OPERADOR INTRACOMUNITARIO)"],["3", "Pasaporte"],["4", "Documento oficial de identificaci�n expedido por el pa�s o territorio de residencia"],["5", "Certificado de residencia fiscal"],["6", "Otro documento probatorio"]];
	for (var i:Number = 0; i < clavePaisResidencia.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codigo", clavePaisResidencia[i][0]);
			setValueBuffer("descripcion", clavePaisResidencia[i][1]);
			commitBuffer();
		}
	}

	var cursor:FLSqlCursor = new FLSqlCursor("co_tipolibro");
	var tipoLibro:Array =
		[["E", "Libro registro de facturas expedidas"],["I", "Libro registro de bienes de inversi�n"],["R", "Libro registro de facturas recibidas"],["U", "Libro registro de determinadas operaciones intracomunitarias"],["F", "Libro registro de facturas expedidas IGIC"],["J", "Libro de registro de bienes de inversi�n IGIC"],["S", "Libro de registro de facturas recibidas IGIC"]];
	for (var i:Number = 0; i < tipoLibro.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codigo", tipoLibro[i][0]);
			setValueBuffer("descripcion", tipoLibro[i][1]);
			commitBuffer();
		}
	}

	var cursor:FLSqlCursor = new FLSqlCursor("co_claveoperacion");
	var claveOperacion:Array =
		[["A", "Asiento resumen de facturas"],["B", "Asiento resumen de tique"],["C", "Factura con varios asientos (varios tipos impositivos)"],["D", "Factura rectificativa"],["F", "Adquisiciones realizadas por las agencias de viajes directamente en inter�s del viajero (R�gimen especial de agencias de viajes)"],["G", "R�gimen especial de grupo de entidades en IVA o IGIC (Incorpora la contraprestaci�n real a coste)"],["H", "R�gimen especial de oro de inversi�n"],["I", "Inversi�n del sujeto pasivo (ISP)"],["J", "Tiques"],["K", "Rectificaci�n de errores registrales"],["L", "Adquisiciones a comerciantes minoristas del IGIC. Ninguna de las anteriores"]];
	for (var i:Number = 0; i < claveOperacion.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codigo", claveOperacion[i][0]);
			setValueBuffer("descripcion", claveOperacion[i][1]);
			commitBuffer();
		}
	}
}

//// MODELO 340 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
