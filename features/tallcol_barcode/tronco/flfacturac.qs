
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial {
    function barCode( context ) { oficial ( context ); }
// 	function afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean {
// 		return this.ctx.barCode_afterCommit_lineaspedidosprov(curLP);
// 	}
	function validarLinea(curLinea:FLSqlCursor):Boolean {
		return this.ctx.barCode_validarLinea(curLinea);
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBarcode */
/////////////////////////////////////////////////////////////////
//// PUB BARCODE ////////////////////////////////////////////////
class pubBarcode extends ifaceCtx {
	function pubBarcode( context ) { ifaceCtx( context ); }
	function pub_validarLinea(curLinea:FLSqlCursor):Boolean {
		return this.validarLinea(curLinea);
	}
}
//// PUB BARCODE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/** \C
Actualiza el stock correspondiente al art�culo seleccionado en la l�nea
\end */
// function barCode_afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean
// {
// 	if (sys.isLoadedModule("flfactalma")) 
// 		if (!flfactalma.iface.pub_controlStockPedidosProv(curLP))
// 			return false;
// 	
// 	return true;
// }

function barCode_validarLinea(curLinea:FLSqlCursor):Boolean
{
	var talla = curLinea.valueBuffer("talla");
	var color = curLinea.valueBuffer("color");
	var barcode = curLinea.valueBuffer("barcode");
	var referencia = curLinea.valueBuffer("referencia");
	var barCodeAtr = AQUtil.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "'")
	if(barCodeAtr && (!barcode || barcode == "")){
		MessageBox.warning(AQUtil.translate("scripts", "Debe especificar el barcode del art�culo."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (barcode && barcode != "") {
		var refBarcode:String = AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + barcode + "'");
		if (refBarcode != curLinea.valueBuffer("referencia")) {
			MessageBox.warning(AQUtil.translate("scripts", "La referencia y el barcode del art�culo no coinciden"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	if (((talla && talla != "") || (color && color != "")) && (!barcode || barcode == "")) {
		MessageBox.warning(AQUtil.translate("scripts", "Si establece la talla o color debe indicar el c�digo de barras (barcode) del art�culo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}


//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
