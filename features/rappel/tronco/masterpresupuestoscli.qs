
/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends oficial {
    function rappel( context ) { oficial ( context ); }
	function datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.rappel_datosLineaPedido(curLineaPresupuesto);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
/** \D Copia los datos de una l�nea de presupuesto en una l�nea de pedido a�adiendo el dato de descuento por rappel a una l�nea de pedido
@param	curLineaPresupuesto: Cursor que contiene los datos a incluir en la l�nea de pedido
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function rappel_datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean
{
	if(!this.iface.__datosLineaPedido(curLineaPresupuesto))
		return false;

	with (this.iface.curLineaPedido) {
		setValueBuffer("dtorappel", curLineaPresupuesto.valueBuffer("dtorappel"));
	}
	return true;
}

//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////