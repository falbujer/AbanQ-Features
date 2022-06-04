
/** @class_declaration compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACI�N DE RECIBOS ////////////////////////////////////
class compRecibos extends oficial {
    function compRecibos( context ) { oficial ( context ); }
	function vencimiento(nodo:FLDomNode, campo:String):String {
		return this.ctx.compRecibos_vencimiento(nodo, campo);
	}
	function reemplazar(cadena:String, patronOrigen:String, patronDestino:String):String {
		return this.ctx.compRecibos_reemplazar(cadena, patronOrigen, patronDestino);
	}
}
//// COMPENSACI�N DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACI�N DE RECIBOS ////////////////////////////////////
/** \D
Si el recibo est� compensado, no puede editarse ni pagarse
@param	idRecibo: Identificador del recibo cuyo estado se desea calcular
@return	Estado del recibo
\end */
function compRecibos_vencimiento(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flfactteso")) {
		return "";
	}
	var idFactura:String = nodo.attributeValue("facturascli.idfactura");
	var qryRecibos:FLSqlQuery = new FLSqlQuery();
	var vencimientos:String = "";
	var aPagar:Number = parseFloat(nodo.attributeValue("facturascli.total"));
	var compensado:Number = 0;
	with (qryRecibos) {
		setTablesList("reciboscli");
		setSelect("fechav,importe,estado");
		setFrom("reciboscli");
		setWhere("idfactura = '" + idFactura + "' ORDER BY fechav");
	}
	if (!qryRecibos.exec())
		return false;

	var fecha:Date;
	while (qryRecibos.next()) {
		fecha = util.dateAMDtoDMA(qryRecibos.value(0));
		importe = qryRecibos.value(1);
		if (qryRecibos.value(2) == "Compensado") {
			aPagar -= parseFloat(importe);
			compensado += parseFloat(importe);
		} else {
			if (vencimientos != "")
				vencimientos += ", ";
			vencimientos += fecha.substring(0,10) + " de " + util.roundFieldValue(importe, "reciboscli", "importe");
		}
	}
	aPagar = util.roundFieldValue(aPagar, "reciboscli", "importe");
	compensado = util.roundFieldValue(compensado, "reciboscli", "importe");
	if (compensado > 0)
		vencimientos += "   Total a pagar: " + aPagar + ".   Compensado: " + compensado;
		
	var res:String = this.iface.reemplazar(vencimientos, '-', '/');
	return res;
}

function compRecibos_reemplazar(cadena:String, patronOrigen:String, patronDestino:String):String
{
	var res:String = "";
	if (cadena != "") {
		for (var i:Number = 0; i < cadena.length; i++) {
			if (cadena.charAt(i) == patronOrigen)
				res += patronDestino;
			else
				res += cadena.charAt(i);
		}
	}
	return res;
}

//// COMPENSACI�N DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
