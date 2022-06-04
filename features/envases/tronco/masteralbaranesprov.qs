
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial {
    function envases( context ) { oficial ( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.envases_datosLineaFactura(curLineaAlbaran);
	}
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
/** \D Copia los datos de una l�nea de albar�n en una l�nea de factura a�adiendo los datos relativos al envase (--valormetrico-- y --canenvases--)
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la l�nea de factura
@return	True si el c�lculo se realiza correctamente, false en caso contrario
\end */
function envases_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	with (this.iface.curLineaFactura) {
		setValueBuffer("valormetrico", curLineaAlbaran.valueBuffer("valormetrico"));
		setValueBuffer("canenvases", curLineaAlbaran.valueBuffer("canenvases"));
		setValueBuffer("codenvase", curLineaAlbaran.valueBuffer("codenvase"));
	}
	
	if(!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;
		
	return true;
}


//// ENVASES ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////