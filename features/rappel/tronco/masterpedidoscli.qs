
/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends oficial {
    function rappel( context ) { oficial ( context ); }
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.rappel_datosLineaAlbaran(curLineaPedido);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
/** \D Copia los datos de una l�nea de pedido en una l�nea de albar�n a�adiendo el dato de descuento por rappel a una l�nea de albar�n
@param	curLineaPedido: Cursor que contiene los datos a incluir en la l�nea de albar�n
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function rappel_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("dtorappel", curLineaPedido.valueBuffer("dtorappel"));
	}
	
	if(!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;
		
	return true;
}

//// RAPPEL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
