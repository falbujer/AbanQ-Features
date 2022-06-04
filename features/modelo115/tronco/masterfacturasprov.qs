
/** @class_declaration modelo115 */
/////////////////////////////////////////////////////////////////
//// MODELO 115 /////////////////////////////////////////////////
class modelo115 extends modelos {
    function modelo115( context ) { modelos ( context ); }
	function completarOpcionesModelos(arrayOps:Array):Boolean {
		return this.ctx.modelo115_completarOpcionesModelos(arrayOps);
	}
	function ejecutarOpcionModelo(opcion:String):Boolean {
		return this.ctx.modelo115_ejecutarOpcionModelo(opcion);
	}
	function configurarBotonModelos() {
		return this.ctx.modelo115_configurarBotonModelos();
	}
}

//// MODELO 115 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo115 */
/////////////////////////////////////////////////////////////////
//// MODELO 115 /////////////////////////////////////////////////
function modelo115_configurarBotonModelos()
{
	return true;
}

function modelo115_completarOpcionesModelos(arrayOps:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var i:Number = arrayOps.length;
	arrayOps[i] = [];
	if (cursor.valueBuffer("incluir115")) {
		arrayOps[i]["texto"] = util.translate("scripts", "Excluir de modelo 115/180");
		arrayOps[i]["opcion"] = "115EX";
	} else {
		arrayOps[i]["texto"] = util.translate("scripts", "Incluir en modelo 115/180");
		arrayOps[i]["opcion"] = "115IN";
	}
	return true;
}

function modelo115_ejecutarOpcionModelo(opcion:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (opcion != "115IN" && opcion != "115EX") {
		return this.iface.__ejecutarOpcionModelo(opcion);
	}

	var curFactura:FLSqlCursor = new FLSqlCursor("facturasprov");
	curFactura.setActivatedCheckIntegrity(false);
	curFactura.setActivatedCommitActions(false);
	var idFactura:String = cursor.valueBuffer("idfactura");
	curFactura.select("idfactura = " + idFactura);
	if (!curFactura.first()) {
		return false;
	}

	var editable:Boolean = curFactura.valueBuffer("editable");
	if (!editable) {
		curFactura.setUnLock("editable", true);
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
			return false;
		}
	}

	curFactura.setModeAccess(curFactura.Edit);
	curFactura.refreshBuffer();
	if (opcion == "115IN") {
		curFactura.setValueBuffer("incluir115", true);
	} else {
		curFactura.setValueBuffer("incluir115", false);
	}
	if (!curFactura.commitBuffer()) {
		return false;
	}

	if (!editable) {
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
			return false;
		}
		curFactura.setUnLock("editable", false);
	}

	if (opcion == "115EX") {
		MessageBox.information(util.translate("scripts", "La factura %1 ser� excluida del modelo 115/180").arg(cursor.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
	} else {
		MessageBox.information(util.translate("scripts", "La factura %1 ser� incluida en el modelo 115/180").arg(cursor.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbRecords.refresh();
	return true;
}

//// MODELO 115 /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
