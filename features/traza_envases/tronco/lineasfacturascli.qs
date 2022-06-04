
/** @class_declaration lotesEnv */
/////////////////////////////////////////////////////////////////
//// LOTES + ENVASES ////////////////////////////////////////////
class lotesEnv extends lotes {
    function lotesEnv( context ) { lotes ( context ); }
	function habilitarControlesPorLotes()  {
		return this.ctx.lotesEnv_habilitarControlesPorLotes();
	}
	function calcularCantidad() {
		return this.ctx.lotesEnv_calcularCantidad();
	}
	function calculateField(fN:String):String {
		return this.ctx.lotesEnv_calculateField(fN);
	}
}
//// LOTES + ENVASES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesEnv */
/////////////////////////////////////////////////////////////////
//// LOTES + ENVASES ////////////////////////////////////////////
/** \D Habilita y pone los valores iniciales para los controles del formulario en funci�n de si el art�culo seleccionado es por lotes o no
\end */
function lotesEnv_habilitarControlesPorLotes()
{
	var util = new FLUtil;
	var cursor = this.cursor();
	this.iface.porLotes = flfacturac.iface.pub_lineaPorLotes(cursor);
	if (this.iface.porLotes) {
		this.child("gbxMoviLote").setDisabled(false);
		this.child("fdbCantidad").setDisabled(true);
		this.child("fdbCanEnvases").setDisabled(true);
		this.child("fdbValorMetrico").setDisabled(true);
		this.iface.calcularCantidad();
	} else {
		this.child("gbxMoviLote").setDisabled(true);
		this.child("fdbCantidad").setDisabled(false);
		this.child("fdbCanEnvases").setDisabled(false);
		this.child("fdbValorMetrico").setDisabled(false);
		this.child("fdbReferencia").setDisabled(false);
		this.child("fdbCodEnvase").setDisabled(false);
	}
}

/** \D Calcula la cantidad como suma de los movimientos asociados a la l�nea. 

Si hay uno o m�s movimientos, la referencia no podr� ser modificada
\end */
function lotesEnv_calcularCantidad()
{
	var util:FLUtil = new FLUtil;
	if (this.child("tdbMoviLote").cursor().size() > 0) {
		this.child("fdbReferencia").setDisabled(true);
		this.child("fdbCodEnvase").setDisabled(true);
		this.child("fdbValorMetrico").setValue(util.sqlSelect("movilote", "valormetrico", "docorigen = 'FC' AND idlineafc = " + this.cursor().valueBuffer("idlinea")));
	} else {
		this.child("fdbReferencia").setDisabled(false);
		this.child("fdbCodEnvase").setDisabled(false);
	}
		
	this.cursor().setValueBuffer("canenvases", this.iface.calculateField("canenvases"));
}

/** \D Calcula el valor de un campo

@param	fN: Nombre del campo
@return	Valor del campo calculado
\end */
function lotesEnv_calculateField(fN:String):String
{
	var res:String;
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "canenvases": {
			if (this.iface.porLotes) {
				res = util.sqlSelect("movilote", "SUM(canenvases)", "idlineafc = " + cursor.valueBuffer("idlinea"));
				res = -1 * parseFloat(res);
			} else
				res = this.iface.__calculateField(fN);
			break;
		}
		default: {
			res = this.iface.__calculateField(fN);
		}
	}
	return res;
}

//// LOTES + ENVASES ////////////////////////////////////////////
////////////////////////////////////////////////////////////////
