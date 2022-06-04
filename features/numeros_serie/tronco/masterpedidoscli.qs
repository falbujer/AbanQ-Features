
/** @class_declaration funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
class funNumSerie extends oficial {
	function funNumSerie( context ) { oficial ( context ); }
	function copiaLineaPedido(curLineaPedido:FLSqlCursor, idAlbaran:Number):Number {
		return this.ctx.funNumSerie_copiaLineaPedido(curLineaPedido, idAlbaran);
	}
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_datosLineaAlbaran(curLineaPedido);
	}
}
//// FUN_NUMEROS_SERIE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/** \D
Copia una l�neas de un pedido en su albar�n asociado. Si se trata de una l�nea de
n�mero de serie genera tantas l�neas de cantidad 1 como cantidad hay en la l�nea.
@param curdPedido: Cursor posicionado en la l�nea de pedido a copiar
@param idAlbaran: Identificador del albar�n
@return identificador de la l�nea de albar�n creada si no hay error. FALSE en otro caso.
\end */
function funNumSerie_copiaLineaPedido(curLineaPedido:FLSqlCursor, idAlbaran:Number):Number
{
	var util:FLUtil = new FLUtil();
	
	if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLineaPedido.valueBuffer("referencia") + "'"))
		return this.iface.__copiaLineaPedido(curLineaPedido, idAlbaran);

	if (!this.iface.curLineaAlbaran)
		this.iface.curLineaAlbaran = new FLSqlCursor("lineasalbaranescli");
	
	var cantidad:Number = parseFloat(curLineaPedido.valueBuffer("cantidad"));
	var cantidadServida:Number = parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
	
	for (var i:Number = cantidadServida; i < cantidad; i++) {
	
		with (this.iface.curLineaAlbaran) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idalbaran", idAlbaran);
		}
		
		if (!this.iface.datosLineaAlbaran(curLineaPedido))
			return false;
			
		if (!this.iface.curLineaAlbaran.commitBuffer())
			return false;
	}
	
	curLineaPedido.setValueBuffer("cantidad", cantidad);
	
	return this.iface.curLineaAlbaran.valueBuffer("idlinea");
}

function funNumSerie_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if(!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;

	var pvpSinDto:Number;
	var pvpTotal:Number;
	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLineaPedido.valueBuffer("referencia") + "'")) {
		this.iface.curLineaAlbaran.setValueBuffer("cantidad", 1);
			
		pvpSinDto = parseFloat(this.iface.curLineaAlbaran.valueBuffer("pvpunitario") * this.iface.curLineaAlbaran.valueBuffer("cantidad"));
		this.iface.curLineaAlbaran.setValueBuffer("pvpsindto", pvpSinDto);

		var dtoPor:Number = (this.iface.curLineaAlbaran.valueBuffer("pvpsindto") * this.iface.curLineaAlbaran.valueBuffer("dtopor")) / 100;
		dtoPor = util.roundFieldValue(dtoPor, "lineasalbaranescli", "pvpsindto");
		pvpTotal = this.iface.curLineaAlbaran.valueBuffer("pvpsindto") - parseFloat(dtoPor) - this.iface.curLineaAlbaran.valueBuffer("dtolineal");
		pvpTotal = util.roundFieldValue(pvpTotal, "lineasalbaranescli", "pvptotal");
		this.iface.curLineaAlbaran.setValueBuffer("pvptotal", pvpTotal);
	}

	return true;
}


//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
