
/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PEDPROVCLI /////////////////////////////////////////////////
class pedProvCli extends oficial {
    function pedProvCli( context ) { oficial ( context ); }
	function calcularTotales() {
		return this.ctx.pedProvCli_calcularTotales();
	}
}
//// PEDPROVCLI /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedProvCli */
/////////////////////////////////////////////////////////////////
//// PEDPROVCLI /////////////////////////////////////////////////
function pedProvCli_calcularTotales()
{
	this.iface.__calcularTotales();
/*	
	var cursor:FLSqlCursor = this.cursor();
	var idPedido:String = cursor.valueBuffer("idpedido");
	var estado:String = flfacturac.iface.pub_estadoPedidoCliProv(idPedido);
	cursor.setValueBuffer("pedido", estado);
*/
}
//// PEDPROVCLI /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
