
/** @class_declaration fluxecPro */
/////////////////////////////////////////////////////////////////
//// FLUX EC PRO /////////////////////////////////////////////////
class fluxecPro extends fluxEcommerce {
    function fluxecPro( context ) { fluxEcommerce ( context ); }
	function setModificado(cursor:FLSqlCursor)  {
		return this.ctx.fluxecPro_setModificado(cursor);
	}
}
//// FLUX EC PRO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxecPro */
//////////////////////////////////////////////////////////////////
//// FLUX EC PRO //////////////////////////////////////////////////

function fluxecPro_setModificado(cursor:FLSqlCursor) {
	
	if (!cursor.isModifiedBuffer() || cursor.valueBufferCopy("modificado"))
		return true;

	var tabla:String = cursor.table();
	
	switch(tabla) {
		
		// Solo se marcan para coordinar los que son publicos (usamos valueBufferCopy por si se ha actualizado de publico a no publico)
		case "articulos":
			if (cursor.valueBufferCopy("publico") || cursor.valueBuffer("publico"))
				cursor.setValueBuffer("modificado", true);
			else
				return true;
		break;
		
		// Tablas relacionadas. Solamente los registros de articulos publicos
		case "stocks":
		case "articuloscomp":
		case "articulostarifas":
		case "formasenvio":
		 	var util:FLUtil = new FLUtil();
			if (!util.sqlSelect("articulos", "publico", "referencia = '" + cursor.valueBuffer("referencia") + "'"))
				return true;
		break;
	}
	
	cursor.setValueBuffer("modificado", true);

	return true;
}

//// FLUX EC PRO //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
