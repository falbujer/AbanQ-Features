
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial {
    function ivaIncluido( context ) { oficial( context ); } 	
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.ivaIncluido_datosLineaAlbaran(curLineaPedido);
	}
	function totalesAlbaran():Boolean {
		return this.ctx.ivaIncluido_totalesAlbaran();
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
/** \D Copia los datos de una l�nea de pedido en una l�nea de albar�n
@param	curLineaPedido: Cursor que contiene los datos a incluir en la l�nea de albar�n
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaIncluido_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaAlbaran(curLineaPedido)) {
		return false;
	}
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("ivaincluido", curLineaPedido.valueBuffer("ivaincluido"));
		setValueBuffer("pvpunitarioiva", curLineaPedido.valueBuffer("pvpunitarioiva"));
	}
	/// El cambio puede deberse a que la fecha del nuevo documento est� asociada a un tipo de IVA distinto del documento origens
	if (curLineaPedido.valueBuffer("iva") != this.iface.curLineaAlbaran.valueBuffer("iva")) {
		if (this.iface.curLineaAlbaran.valueBuffer("ivaincluido")) {
// 			this.iface.curLineaAlbaran.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaAlbaran));
// 			this.iface.curLineaAlbaran.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaAlbaran));
// 			this.iface.curLineaAlbaran.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaAlbaran));
			
			this.iface.curLineaAlbaran.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva2", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto2", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva2", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal2", this.iface.curLineaAlbaran));
		} else {
// 			this.iface.curLineaAlbaran.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineaAlbaran));
			
			this.iface.curLineaAlbaran.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva", this.iface.curLineaAlbaran));
		}
	}
	else {
		this.iface.curLineaAlbaran.setValueBuffer("pvpsindtoiva", curLineaPedido.valueBuffer("pvpsindtoiva"));
		this.iface.curLineaAlbaran.setValueBuffer("pvptotaliva", curLineaPedido.valueBuffer("pvptotaliva"));
	}
	
	return true;
}

function ivaIncluido_totalesAlbaran():Boolean
{
	this.iface.__totalesAlbaran();

	// Comprobar redondeo y recalcular totales
	formRecordfacturascli.iface.comprobarRedondeoIVA(this.iface.curAlbaran, "idalbaran")
	with (this.iface.curAlbaran) {
		setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}



//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

