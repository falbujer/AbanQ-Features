
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
	function funNumSerie( context ) { oficial( context ); } 
	function insertarNumSerie(referencia:String, numSerie:String, idAlbaran:Number, idFactura:Number ):Boolean {
		return this.ctx.funNumSerie_insertarNumSerie(referencia, numSerie, idAlbaran, idFactura);
	}
	function borrarNumSerie(referencia:String, numSerie:String ):Boolean {
		return this.ctx.funNumSerie_borrarNumSerie(referencia, numSerie);
	}
	function borrarNumSerie(referencia:String, numSerie:String ):Boolean {
		return this.ctx.funNumSerie_borrarNumSerie(referencia, numSerie);
	}
	function modificarNumSerie(referencia:String, numserie:String, campo:String, valor:Number):Boolean {
		return this.ctx.funNumSerie_modificarNumSerie(referencia, numserie, campo, valor);
	}
	function afterCommit_numerosserie(curNS:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_numerosSerie(curNS);
	}
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
//////////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////

function funNumSerie_insertarNumSerie(referencia:String, numSerie:String, idAlbaran:Number, idFactura:Number ):Boolean 
{
	var util:FLUtil = new FLUtil();
	
	var curNS:FLSqlCursor = new FLSqlCursor("numerosserie");
	
	// Ye existe
	curNS.select("referencia = '" + referencia + "' AND numserie = '" + numSerie + "'");
	if (curNS.first()) return true;
	
	curNS.setModeAccess(curNS.Insert);
	curNS.refreshBuffer();
	curNS.setValueBuffer("referencia", referencia);
	curNS.setValueBuffer("numserie", numSerie);
	if (idAlbaran > -1) {
		curNS.setValueBuffer("idalbarancompra", idAlbaran);
		curNS.setValueBuffer("codalmacen", util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + idAlbaran));
	}
	if (idFactura > -1) {
		curNS.setValueBuffer("idfacturacompra", idFactura);
		curNS.setValueBuffer("codalmacen", util.sqlSelect("facturasprov", "codalmacen", "idfactura = " + idFactura));
	}
	if (!curNS.commitBuffer()) return false;
	
	return true;
}

function funNumSerie_borrarNumSerie(referencia:String, numSerie:String ):Boolean 
{
	var curNS:FLSqlCursor = new FLSqlCursor("numerosserie");
	
	curNS.select("referencia = '" + referencia + "' AND numserie = '" + numSerie + "'");
	if (curNS.first()) {
		curNS.setModeAccess(curNS.Del);
		curNS.refreshBuffer();
		if (!curNS.commitBuffer()) return false;
	}
	return true;
}

function funNumSerie_modificarNumSerie(referencia:String, numserie:String, campo:String, valor:Number)
{
	var curNS:FLSqlCursor = new FLSqlCursor("numerosserie");
	curNS.select("referencia = '" + referencia + "' AND numserie = '" + numserie + "'");
	if (curNS.first()) {
		curNS.setModeAccess(curNS.Edit);
		curNS.refreshBuffer();
		curNS.setValueBuffer(campo, valor);
		if (!curNS.commitBuffer()) return false;
	}
	return true;
}

/** Recalcula el stock de unidades del art�culo; lo hace para poder introducir n�meros
de serie directamente -sin facturacion-
*/
function funNumSerie_afterCommit_numerosSerie(curNS:FLSqlCursor) 
{
	if (curNS.modeAccess() == curNS.Edit) return true;
	
	var util:FLUtil = new FLUtil();
	var stockNS:Number = util.sqlSelect("numerosserie", "count(id)", "referencia = '" + curNS.valueBuffer("referencia") + "' AND vendido = false AND codalmacen = '" + curNS.valueBuffer("codalmacen") + "'");
	
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("referencia = '" + curNS.valueBuffer("referencia") + "' AND codalmacen = '" + curNS.valueBuffer("codalmacen") + "'");
	
	if (curStock.first()) {
		curStock.setModeAccess(curStock.Edit);
		curStock.refreshBuffer();
		curStock.setValueBuffer("cantidad", stockNS);
		if (!curStock.commitBuffer()) {
			MessageBox.warning(util.translate("scripts", "Error al actualizar el stock del art�culo por n�meros de serie"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}	
	else 
	
	if (curNS.modeAccess() == curNS.Insert) {
		// No hay stock en este almac�n, nueva l�nea de stocks
		curStock.setModeAccess(curStock.Insert);
		curStock.refreshBuffer();
		curStock.setValueBuffer("referencia", curNS.valueBuffer("referencia"));
		curStock.setValueBuffer("codalmacen", curNS.valueBuffer("codalmacen"));
		curStock.setValueBuffer("cantidad", stockNS);
		if (!curStock.commitBuffer()) {
			MessageBox.warning(util.translate("scripts", "Error al actualizar el stock del art�culo por n�meros de serie"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}
	
	
	return true;
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
