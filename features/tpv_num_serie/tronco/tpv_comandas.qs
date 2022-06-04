
/** @class_declaration numSerie */
/////////////////////////////////////////////////////////////////
//// N�MEROS DE SERIE ///////////////////////////////////////////
class numSerie extends oficial {
    function numSerie( context ) { oficial ( context ); }
	function datosLineaVenta():Boolean {
		return this.ctx.numSerie_datosLineaVenta();
	}
	function calculateField(fN:String):String {
		return this.ctx.numSerie_calculateField(fN);
	}
}
//// N�MEROS DE SERIE ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numSerie */
/////////////////////////////////////////////////////////////////
//// N�MEROS DE SERIE////////////////////////////////////////////
/** |D Establece los datos de la l�nea de ventas a crear mediante la inserci�n r�pida. Si lo que se inserta como referencia es un n�mero de serie, se comprueba que el n�mero no est� vendido y se ajusta la l�nea de venta con el dato
\end */
function numSerie_datosLineaVenta():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var numSerie = cursor.valueBuffer("referencia");
	if (!numSerie || numSerie == undefined) {
		numSerie = "";
	}
	var qryNumSerie:FLSqlQuery = new FLSqlQuery();
	with (qryNumSerie) {
		setTablesList("numerosserie,articulos,");
		setSelect("ns.numserie, ns.referencia, ns.idfacturaventa, ns.vendido, a.descripcion, a.pvp");
		setFrom("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia");
		setWhere("UPPER(ns.numserie) = '" + numSerie.toUpperCase() + "'")
		setForwardOnly(true);
	}
	if (!qryNumSerie.exec())
		return false;

	if (!qryNumSerie.first())
		return this.iface.__datosLineaVenta();

	if (qryNumSerie.value("ns.vendido")) {
		MessageBox.warning(util.translate("scripts", "Este n�mero de serie corresponde a un art�culo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	if (util.sqlSelect("tpv_lineascomanda", "idtpv_linea", "numserie = '" + qryNumSerie.value("ns.numserie") + "'")) {
		MessageBox.warning(util.translate("scripts", "Este n�mero de serie ya est� incluido en la venta actual"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	if (parseFloat(this.iface.txtCanArticulo.text) != 1) {
		MessageBox.warning(util.translate("scripts", "Si establece un n�mero de serie la cantidad debe ser siempre 1"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	this.iface.__datosLineaVenta();
	this.iface.curLineas.setValueBuffer("referencia", qryNumSerie.value("ns.referencia"));
	this.iface.curLineas.setValueBuffer("numserie", qryNumSerie.value("ns.numserie"));
	
	return true;
}
/** \D Los datos del art�culo se buscan primero suponiendo que la referencia es un n�mero de serie. Si no se encuantran se buscan de la forma normal
\end */
function numSerie_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();
	
	var numSerie = cursor.valueBuffer("referencia");
	if (!numSerie || numSerie == undefined) {
		numSerie = "";
	}
	switch (fN) {
		case "desarticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.descripcion", "UPPER(ns.numserie) = '" + numSerie.toUpperCase() + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			if (!valor)
				valor = "";
			break;
		}
		case "pvparticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.pvp", "UPPER(ns.numserie) = '" + numSerie.toUpperCase() + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			break;
		}
		case "ivaarticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.codimpuesto", "UPPER(ns.numserie) = '" + numSerie.toUpperCase() + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
	return valor;
}
//// N�MEROS DE SERIE////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
