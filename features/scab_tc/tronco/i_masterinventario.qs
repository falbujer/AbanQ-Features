
/** @class_declaration scabTC */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA TALLAS Y COLORES ///////////////////////////
class scabTC extends oficial {
	function scabTC( context ) { oficial ( context ); }
	function dameCantidad(nodo, campo) {
		return this.ctx.scabTC_dameCantidad(nodo, campo);
	}
}
//// STOCKS CABECERA TALLAS Y COLORES ///////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scabTC */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA TALLAS Y COLORES ///////////////////////////
function scabTC_dameCantidad(nodo, campo)
{
debug("oficial_dameCantidad");
	var _i = this.iface;
	var cantidad;
	if (flfactinfo.iface.diaInv_) {
		if (!_i.curStock_) {
			_i.curStock_ = new FLSqlCursor("stocks");
			_i.curStock_.setModeAccess(_i.curStock_.Insert);
			_i.curStock_.refreshBuffer();
		}
		_i.curStock_.setValueBuffer("referencia", nodo.attributeValue("stocks.referencia"));
		_i.curStock_.setValueBuffer("barcode", nodo.attributeValue("stocks.barcode"));
		_i.curStock_.setValueBuffer("codalmacen", nodo.attributeValue("almacenes.codalmacen"));
		_i.curStock_.setValueBuffer("idstock", nodo.attributeValue("stocks.idstock"));
		var oP = formRecordregstocks.iface.pub_dameParamStock();
		oP.fechaMax = flfactinfo.iface.diaInv_;
		_i.cantidad_ = formRecordregstocks.iface.pub_commonCalculateField("cantidad", _i.curStock_, oP);
	} else {
		_i.cantidad_ = nodo.attributeValue("stocks.cantidad");
	}
	return _i.cantidad_;
}

//// STOCKS CABECERA TALLAS Y COLORES ///////////////////////////
/////////////////////////////////////////////////////////////////

