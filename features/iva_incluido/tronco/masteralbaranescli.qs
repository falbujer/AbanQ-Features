
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial {
    function ivaIncluido( context ) { oficial( context ); } 	
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.ivaIncluido_datosLineaFactura(curLineaAlbaran);
	}
	function totalesFactura():Boolean {
		return this.ctx.ivaIncluido_totalesFactura();
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
/** \D Copia los datos de una l�nea de albar�n en una l�nea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la l�nea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaIncluido_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran)) {
		return false;
	}
	with (this.iface.curLineaFactura) {
		setValueBuffer("ivaincluido", curLineaAlbaran.valueBuffer("ivaincluido"));
		setValueBuffer("pvpunitarioiva", curLineaAlbaran.valueBuffer("pvpunitarioiva"));
	}
	/// El cambio puede deberse a que la fecha del nuevo documento est� asociada a un tipo de IVA distinto del documento origens
	if (curLineaAlbaran.valueBuffer("iva") != this.iface.curLineaFactura.valueBuffer("iva")) {
		if (this.iface.curLineaFactura.valueBuffer("ivaincluido")) {
// 			this.iface.curLineaFactura.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaFactura));
// 			this.iface.curLineaFactura.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaFactura));
// 			this.iface.curLineaFactura.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaFactura));
			
			this.iface.curLineaFactura.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva2", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto2", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva2", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal2", this.iface.curLineaFactura));
		}
		else {
			this.iface.curLineaFactura.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva", this.iface.curLineaFactura));
		}
	}
	else {
		this.iface.curLineaFactura.setValueBuffer("pvpsindtoiva", curLineaAlbaran.valueBuffer("pvpsindtoiva"));
		this.iface.curLineaFactura.setValueBuffer("pvptotaliva", curLineaAlbaran.valueBuffer("pvptotaliva"));
	}
	
	return true;
}

function ivaIncluido_totalesFactura():Boolean
{
	this.iface.__totalesFactura();

	// Comprobar redondeo y recalcular totales
	formRecordfacturascli.iface.comprobarRedondeoIVA(this.iface.curFactura, "idfactura")
	with (this.iface.curFactura) {
		setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}


//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

