
/** @class_declaration lotes */
/////////////////////////////////////////////////////////////////
//// LOTES //////////////////////////////////////////////////////
class lotes extends oficial {
	var porLotes:Boolean;
	
    function lotes( context ) { oficial ( context ); }
	function init() {
		return this.ctx.lotes_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.lotes_bufferChanged(fN);
	}
	function calcularCantidad() {
		return this.ctx.lotes_calcularCantidad();
	}
	function calculateField(fN:String):String {
		return this.ctx.lotes_calculateField(fN);
	}
	function habilitarControlesPorLotes()  {
		return this.ctx.lotes_habilitarControlesPorLotes();
	}
}
//// LOTES //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotes */
/////////////////////////////////////////////////////////////////
//// LOTES //////////////////////////////////////////////////////
/** \C La tabla de movimientos mostrar� movimientos asociados a la l�nea de factura. En el caso de que la factura sea autom�tica (provenga de uno o m�s albaranes), la tabla de movimientos estar� vac�a.
\end */
function lotes_init() {
	this.iface.__init();
	
	if (this.cursor().cursorRelation().valueBuffer("automatica")) {
		this.child("gbxMoviLote").setDisabled(true);
// 		this.child("tdbMoviLote").cursor().setMainFilter("1 = 2");
		this.child("tdbMoviLote").refresh();
	} else {
		connect(this.child("tdbMoviLote").cursor(), "bufferCommited()", this, "iface.calcularCantidad()");
		this.iface.habilitarControlesPorLotes();
		this.child("fdbReferencia").editor().setFocus();
	}
}


/** \C Si el art�culo seleccionado est� gestionado por lotes se inhabilitar� el campo --cantidad--, que tomar� el valor de la suma del campo cantidad de los movimientos asociados a la l�nea. Si no est� gestionado por lotes, se inhabilitar� la secci�n 'Movimientos de lotes'.
\end */
function lotes_bufferChanged(fN:String) {
	
	switch (fN) {
		case "referencia": {
			this.iface.habilitarControlesPorLotes();
			this.iface.__bufferChanged(fN);
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}

/** \D Calcula la cantidad como suma de los movimientos asociados a la l�nea. 

Si hay uno o m�s movimientos, la referencia no podr� ser modificada
\end */
function lotes_calcularCantidad()
{
	if (this.child("tdbMoviLote").cursor().size() > 0)
		this.child("fdbReferencia").setDisabled(true);
	else 
		this.child("fdbReferencia").setDisabled(false);
		
	this.cursor().setValueBuffer("cantidad", this.iface.calculateField("cantidad"));
}

/** \D Calcula el valor de un campo

@param	fN: Nombre del campo
@return	Valor del campo calculado
\end */
function lotes_calculateField(fN:String):String
{
	var res:String;
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "cantidad": {
			if (this.iface.porLotes) {
				res = util.sqlSelect("movilote", "SUM(cantidad)", "docorigen = 'FP' AND idlineafp = " + cursor.valueBuffer("idlinea"));
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

/** \D Habilita y pone los valores iniciales para los controles del formulario en funci�n de si el art�culo seleccionado es por lotes o no
\end */
function lotes_habilitarControlesPorLotes() 
{
	var cursor = this.cursor();
	this.iface.porLotes = flfacturac.iface.pub_lineaPorLotes(cursor);
	
	if (this.iface.porLotes) {
		this.child("gbxMoviLote").setDisabled(false);
		this.child("fdbCantidad").setDisabled(true);
		this.iface.calcularCantidad();
	} else {
		this.child("gbxMoviLote").setDisabled(true);
		this.child("fdbCantidad").setDisabled(false);
		this.child("fdbReferencia").setDisabled(false);
	}
}
//// LOTES //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
