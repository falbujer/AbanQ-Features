
/** @class_declaration liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////
class liqAgentes extends oficial {
	var porComision:Number;
	var baseLiq:Number;
	var ivaLiq:Number;
	var irpfLiq:Number;

    function liqAgentes( context ) { oficial ( context ); }
	function totalComisionFactura(nodo:FLDomNode, campo:String):Number {
		return this.ctx.liqAgentes_totalComisionFactura(nodo, campo);
	}
	function porComisionFactura(nodo:FLDomNode, campo:String):Number {
		return this.ctx.liqAgentes_porComisionFactura(nodo, campo);
	}
	function iniciarValoresLiq(nodo:FLDomNode, campo:String) {
		return this.ctx.liqAgentes_iniciarValoresLiq(nodo, campo);
	}
	function calcularValoresLiq(nodo:FLDomNode, campo:String) {
		return this.ctx.liqAgentes_calcularValoresLiq(nodo, campo);
	}
	function mostrarValoresLiq(nodo:FLDomNode, campo:String):Number {
		return this.ctx.liqAgentes_mostrarValoresLiq(nodo, campo);
	}
}
//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubLiqAgentes */
/////////////////////////////////////////////////////////////////
//// PUB_LIQ_AGENTES ////////////////////////////////////////////
class pubLiqAgentes extends ifaceCtx {
	function pubLiqAgentes( context ) { ifaceCtx( context ); }
	function pub_iniciarValoresLiq(nodo:FLDomNode, campo:String) {
		return this.iniciarValoresLiq(nodo, campo);
	}
	function pub_calcularValoresLiq(nodo:FLDomNode, campo:String) {
		return this.calcularValoresLiq(nodo, campo);
	}
	function pub_mostrarValoresLiq(nodo:FLDomNode, campo:String):Number {
		return this.mostrarValoresLiq(nodo, campo);
	}
}
//// PUB_LIQ_AGENTES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////
/** \D
Obtiene el porcentaje de comisi�n de la factura. Si no lo tiene el porcentaje ser� la media de los porcentajes de sus l�neas.
@param	nodo: Nodo XML con los datos de la l�nea que se va a mostrar en el informe
@param	campo: Campo a mostrar
@return	Valor del campo
\end */
function liqAgentes_porComisionFactura(nodo:FLDomNode, campo:String):Number
{debug("liqAgentes_porComisionFactura");
		var util:FLUtil = new FLUtil();
		
	var res:Number = parseFloat(nodo.attributeValue("facturascli.porcomision"));
	if(res && res != 0) {
		this.iface.porComision = res;
		return res;
	}
	
	var idFactura:String = nodo.attributeValue("facturascli.idfactura");
	var numLineas:Number = parseFloat(util.sqlSelect("lineasfacturascli","COUNT(idlinea)","idfactura = " + idFactura));
debug("numLineas " + numLineas);
	if(!numLineas) {
		this.iface.porComision = 0;
		return 0;
	}

	var sumCom:Number = parseFloat(util.sqlSelect("lineasfacturascli","SUM(porcomision)","idfactura = " + idFactura));
debug("sumCom " + sumCom);
	res = sumCom/numLineas;
debug("res " + res);
	this.iface.porComision = res;

	return res;
}

/** \D
Obtiene la comisi�n total de una factura
@param	nodo: Nodo XML con los datos de la l�nea que se va a mostrar en el informe
@param	campo: Campo a mostrar
@return	Valor del campo
\end */
function liqAgentes_totalComisionFactura(nodo:FLDomNode, campo:String):Number
{
	var util:FLUtil = new FLUtil();
	
	if (!this.iface.porComision) {
		return 0;
	}
	var tabla:String = campo;
	var totalDoc:Number = nodo.attributeValue(tabla + ".neto");
	var res:Number = totalDoc * this.iface.porComision / 100;
	return res;
}

function liqAgentes_iniciarValoresLiq(nodo, campo)
{
	var _i = this.iface;
	_i.baseLiq = 0;
	_i.ivaLiq = 0;
	_i.irpfLiq = 0;
}

function liqAgentes_calcularValoresLiq(nodo, campo)
{
	var util = new FLUtil();
	var _i = this.iface;
	
	_i.baseLiq = nodo.attributeValue("liquidaciones.total");
	
	var porIrpf = util.sqlSelect("agentes", "irpf", "codagente = '" + nodo.attributeValue("liquidaciones.codagente") + "'");
	porIrpf = isNaN(porIrpf) ? 0 : porIrpf;
	_i.irpfLiq = (nodo.attributeValue("liquidaciones.total") * porIrpf) / 100;

	var hoy:Date = new Date();
	var codImpuesto:Number = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") + "'");
	if (codImpuesto) {
		var iva:Number = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, hoy);
		var codAgente = nodo.attributeValue("agentes.codagente");
		var codProveedor = util.sqlSelect("agentes", "codproveedor", "codagente = '" + codAgente + "'");
		if (codProveedor) {
			var regimenIVA = util.sqlSelect("proveedores", "regimeniva", "codproveedor = '" + codProveedor + "'");
			if (regimenIVA != "General") {
				iva = 0;
			}
		}
		_i.ivaLiq = (nodo.attributeValue("liquidaciones.total") * iva) / 100;
	}	
}

function liqAgentes_mostrarValoresLiq(nodo:FLDomNode, campo:String):Number
{
	var util:FLUtil = new FLUtil();
	var valor:Number;
	switch (campo) {
		case "baseimponible": {
			valor = this.iface.baseLiq;
			break;
		}
		case "irpf": {
			valor = this.iface.irpfLiq;
			break;
		}
		case "iva": {
			valor = this.iface.ivaLiq;
			break;
		}
		case "total": {
			valor = parseFloat(this.iface.baseLiq) + parseFloat(this.iface.ivaLiq) - parseFloat(this.iface.irpfLiq);
			break;
		}
	}
	return valor;
}

//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
