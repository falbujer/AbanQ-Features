
/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends modelos {
    function modelo347( context ) { modelos ( context ); }
	function completarOpcionesModelos(arrayOps:Array):Boolean {
		return this.ctx.modelo347_completarOpcionesModelos(arrayOps);
	}
	function ejecutarOpcionModelo(opcion:String):Boolean {
		return this.ctx.modelo347_ejecutarOpcionModelo(opcion);
	}
	function incluirExcluir347(incluir:Boolean):Boolean {
		return this.ctx.modelo347_incluirExcluir347(incluir);
	}
	function incluirExcluir347Trans(incluir:Boolean):Boolean {
		return this.ctx.modelo347_incluirExcluir347Trans(incluir);
	}
	function configurarBotonModelos() {
		return this.ctx.modelo347_configurarBotonModelos();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.modelo347_commonCalculateField(fN, cursor);
	}
	function totalesFactura():Boolean {
		return this.ctx.modelo347_totalesFactura();
	}
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
function modelo347_completarOpcionesModelos(arrayOps:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var idFactura:String = cursor.valueBuffer("idfactura");
	if (!idFactura) {
		return false;
	}
	var codFactura:String = cursor.valueBuffer("codigo");
	var noModelo347:Boolean = cursor.valueBuffer("nomodelo347");
	var i:Number = arrayOps.length;
	arrayOps[i] = [];
	if (noModelo347) {
		arrayOps[i]["texto"] = util.translate("scripts", "Incluir factura %1 en modelo 347").arg(codFactura);
		arrayOps[i]["opcion"] = "347S";
	} else {
		arrayOps[i]["texto"] = util.translate("scripts", "Excluir factura %1 de modelo 347").arg(codFactura);
		arrayOps[i]["opcion"] = "347N";
	}
	return true;
}

function modelo347_ejecutarOpcionModelo(opcion:String):Boolean
{
	switch (opcion) {
		case "347S": {
			this.iface.incluirExcluir347(true);
			break;
		}
		case "347N": {
			this.iface.incluirExcluir347(false);
			break;
		}
		default: {
			this.iface.__ejecutarOpcionModelo(opcion);
		}
	}
	return true;
}

function modelo347_incluirExcluir347(incluir:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var curTrans:FLSqlCursor = new FLSqlCursor("empresa");
	curTrans.transaction(false);
	try {
		if (this.iface.incluirExcluir347Trans(incluir)) {
			curTrans.commit();
		} else {
			curTrans.rollback();
			MessageBox.warning(util.translate("scripts", "Error al incluir/excluir la factura del modelo 347"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} catch (e) {
		curTrans.rollback();
		MessageBox.critical(util.translate("scripts", "Error al incluir/excluir la factura del modelo 347: ") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.tdbRecords.refresh();
	if (incluir) {
		MessageBox.information(util.translate("scripts", "Factura incluida correctamente"), MessageBox.Ok, MessageBox.NoButton);
	} else {
		MessageBox.information(util.translate("scripts", "Factura excluida correctamente"), MessageBox.Ok, MessageBox.NoButton);
	}
	return true;
}

function modelo347_incluirExcluir347Trans(incluir:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var idFactura:String = cursor.valueBuffer("idfactura");
	if (!idFactura) {
		return false;
	}
	if (!flfacturac.iface.pub_cambiarCampoRegistroBloqueado("facturasprov", "idfactura", idFactura, "nomodelo347", !incluir, "editable")) {
		return false;
	}
	var idAsiento:String = cursor.valueBuffer("idasiento");
	if (!idAsiento) {
		return false;
	}
	if (!flfacturac.iface.pub_cambiarCampoRegistroBloqueado("co_asientos", "idasiento", idAsiento, "nomodelo347", !incluir, "editable")) {
		return false;
	}
	return true;
}

function modelo347_configurarBotonModelos()
{
	return true; //this.child("tbnModelos").close();
}

function modelo347_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		case "nomodelo347": {
			var totalIrpf:Number = parseFloat(cursor.valueBuffer("totalirpf"));
			if (totalIrpf != 0) {
				valor = true;
			} else {
				valor = false;
			}
			break;
		}
		default : {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

function modelo347_totalesFactura():Boolean
{
	if (!this.iface.__totalesFactura()) {
		return false;
	}
	with (this.iface.curFactura) {
		setValueBuffer("nomodelo347", formfacturasprov.iface.pub_commonCalculateField("nomodelo347", this));
	}
	return true;
}

//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
