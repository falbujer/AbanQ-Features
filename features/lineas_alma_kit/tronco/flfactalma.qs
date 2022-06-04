
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// LINEAS ALMACEN KIT /////////////////////////////////////////
class lineasAlma extends articuloscomp {
	function lineasAlma( context ) { articuloscomp ( context ); }
	function dameDatosStockLinea(curLinea:FLSqlCursor, curArticuloComp:FLSqlCursor):Array {
		return this.ctx.lineasAlma_dameDatosStockLinea(curLinea, curArticuloComp);
	}
}
//// LINEAS ALMACEN KIT /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// LINEAS ALMACEN KIT /////////////////////////////////////////
/** \D Obtiene los datos de almac�n y fecha correspondientes a los movimientos asociados a una l�nea de facturaci�n
@param	curLinea: Cursor de la l�nea
@param	curArticuloComp: Cursor de la composici�n
@return array con los datos:
\end */
function lineasAlma_dameDatosStockLinea(curLinea:FLSqlCursor, curArticuloComp):Array
{
debug("articuloscomp_dameDatosStockLinea");
	var util:FLUtil = new FLUtil;
	var aDatos:Array;
	var tabla:String = curLinea.table();
	
	switch (tabla) {
		case "lineaspresupuestoscli":
		case "lineaspedidoscli":
		case "lineaspedidosprov":
		case "lineasalbaranescli": 
		case "lineasalbaranesprov":
		case "lineasfacturascli":
		case "lineasfacturasprov":
		case "lineastransstock": {
			aDatos = this.iface.__dameDatosStockLinea(curLinea, curArticuloComp);
			if (!aDatos) {
				return false;
			}
			aDatos.codAlmacen = curLinea.valueBuffer("codalmacen");
			break;
		}
		default: {
			aDatos = this.iface.__dameDatosStockLinea(curLinea, curArticuloComp);
		}
	}
	return aDatos;
}
//// LINEAS ALMACEN KIT /////////////////////////////////////////
////////////////////////////////////////////////////////////
