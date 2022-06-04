
/** @class_declaration scabTraza */
/////////////////////////////////////////////////////////////////
//// CONTROL STOCK CABECERA TRAZABILIDAD ////////////////////////
class scabTraza extends scab {
	var arrayLotes_:Array;
    function scabTraza( context ) { scab ( context ); }
	function init() {
		return this.ctx.scabTraza_init();
	}
	function validateForm():Boolean {
		return this.ctx.scabTraza_validateForm();
	}
	function cargarArrayLotes():Boolean {
		return this.ctx.scabTraza_cargarArrayLotes();
	}
	function controlLotesCabecera():Boolean {
		return this.ctx.scabTraza_controlLotesCabecera();
	}
}
//// CONTROL STOCK CABECERA TRAZABILIDAD ////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scabTraza */
/////////////////////////////////////////////////////////////////
//// CONTROL STOCK CABECERA TRAZABILIDAD ////////////////////////
function scabTraza_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil;

	this.iface.arrayLotes_ = this.iface.cargarArrayLotes();
	if (!this.iface.arrayLotes_) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los datos de lotes"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
}

function scabTraza_cargarArrayLotes():Array
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var arrayLotes:Array = [];

	var qryLotes:FLSqlQuery = new FLSqlQuery;
	qryLotes.setTablesList("lineasalbaranescli,movilote");
	qryLotes.setSelect("ml.codlote");
	qryLotes.setFrom("lineasalbaranescli la INNER JOIN movilote ml ON la.idlinea = ml.idlineaac");
	qryLotes.setWhere("la.idalbaran = " + cursor.valueBuffer("idalbaran") + " GROUP BY ml.codlote");
	qryLotes.setForwardOnly(true);
	if (!qryLotes.exec()) {
		return false;
	}
	var i:Number = 0;
	while (qryLotes.next()) {
		arrayLotes[i] = [];
		arrayLotes[i]["codlote"] = qryLotes.value("ml.codlote");
		i++;
	}
	return arrayLotes;
}

function scabTraza_validateForm():Boolean
{
	if (!this.iface.__validateForm()) {
		return false;
	}

	if (!this.iface.controlLotesCabecera()) {
		return false;
	}

	return true;
}

function scabTraza_controlLotesCabecera():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var arrayActual:Array = this.iface.cargarArrayLotes();
	if (!arrayActual) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los datos de lotes"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var arrayAfectados:Array = flfactalma.iface.pub_arrayLotesAfectados(this.iface.arrayLotes_, arrayActual);
	if (!arrayAfectados) {
		return false;
	}
	for (var i:Number = 0; i < arrayAfectados.length; i++) {
		if (!flfactalma.iface.actualizarCantidadLote(arrayAfectados[i]["codlote"])) {
			return false;
		}
	}

	return true;
}
//// CONTROL STOCK CABECERA TRAZABILIDAD ////////////////////////
/////////////////////////////////////////////////////////////////
