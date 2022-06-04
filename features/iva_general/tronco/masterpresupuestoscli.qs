
/** @class_declaration ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
class ivaGeneral extends oficial {
    function ivaGeneral( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaGeneral_commonCalculateField(fN, cursor);
	}
	function totalesPedido():Boolean {
		return this.ctx.ivaGeneral_totalesPedido();
	}
	function datosPedido(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.ivaGeneral_datosPedido(curPresupuesto);
	}
	function datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.ivaGeneral_datosLineaPedido(curLineaPresupuesto);
	}
}
//// IVA_GENERAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
function ivaGeneral_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var codImpuesto:String = cursor.valueBuffer("codimpuesto");
	
	switch (fN) {
		case "totaliva":{
			var iva:Number = 0;
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM(pvptotal)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
			if(codImpuesto)
				iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + codImpuesto + "'");
			valor = valor * iva /100; 
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totaliva"));
			break;
		}
		
		case "totalrecargo":{
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");debug(aplicarRecEq);
			if (aplicarRecEq == true) {
				var recargo:Number = 0;
				valor = util.sqlSelect("lineaspresupuestoscli", "SUM(pvptotal)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
				if(codImpuesto)
					recargo = util.sqlSelect("impuestos", "recargo", "codimpuesto = '" + codImpuesto + "'");
				valor = valor * recargo /100; 
				valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalrecargo"));
			}
			else valor = 0;
			break;
		}
		default: valor = this.iface.__commonCalculateField(fN, cursor)
	}
	return valor;
}

/** \D Informa los datos de un pedido a partir de los de un presupuesto
@param	curPresupuesto: Cursor que contiene los datos a incluir en el pedido
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosPedido(curPresupuesto:FLSqlCursor):Boolean
{
	var numeroPedido:Number = flfacturac.iface.pub_siguienteNumero(curPresupuesto.valueBuffer("codserie"), curPresupuesto.valueBuffer("codejercicio"), "npedidocli");
			
	with (this.iface.curPedido) {
		setValueBuffer("numero", numeroPedido);
		setValueBuffer("codserie", curPresupuesto.valueBuffer("codserie"));
		setValueBuffer("codejercicio", curPresupuesto.valueBuffer("codejercicio"));
		setValueBuffer("irpf", curPresupuesto.valueBuffer("irpf"));
		setValueBuffer("fecha", curPresupuesto.valueBuffer("fecha"));
		setValueBuffer("codagente", curPresupuesto.valueBuffer("codagente"));
		setValueBuffer("porcomision", curPresupuesto.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curPresupuesto.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curPresupuesto.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curPresupuesto.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPresupuesto.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curPresupuesto.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curPresupuesto.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curPresupuesto.valueBuffer("nombrecliente"));
		setValueBuffer("coddir", curPresupuesto.valueBuffer("coddir"));
		setValueBuffer("direccion", curPresupuesto.valueBuffer("direccion"));
		setValueBuffer("codpostal", curPresupuesto.valueBuffer("codpostal"));
		setValueBuffer("ciudad", curPresupuesto.valueBuffer("ciudad"));
		setValueBuffer("provincia", curPresupuesto.valueBuffer("provincia"));
		setValueBuffer("apartado", curPresupuesto.valueBuffer("apartado"));
		setValueBuffer("codpais", curPresupuesto.valueBuffer("codpais"));
		setValueBuffer("recfinanciero", curPresupuesto.valueBuffer("recfinanciero"));
		setValueBuffer("idpresupuesto", curPresupuesto.valueBuffer("idpresupuesto"));
		setValueBuffer("codimpuesto", curPresupuesto.valueBuffer("codimpuesto"));
	}
	
	return true;
}

/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_totalesPedido():Boolean
{
	with (this.iface.curPedido) {
		setValueBuffer("neto", formpedidoscli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formpedidoscli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formpedidoscli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formpedidoscli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
		setValueBuffer("codigo", formpedidoscli.iface.pub_commonCalculateField("codigo", this));
	}
	return true;
}

/** \D Copia los datos de una línea de presupuesto en una línea de pedido
@param	curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean
{
	var idPedido:Number = this.iface.curLineaPedido.valueBuffer("idpedido");
	
	with (this.iface.curLineaPedido) {
		setValueBuffer("idpedido", idPedido);
		setValueBuffer("pvpunitario", curLineaPresupuesto.valueBuffer("pvpunitario"));
		setValueBuffer("pvpsindto", curLineaPresupuesto.valueBuffer("pvpsindto"));
		setValueBuffer("pvptotal", curLineaPresupuesto.valueBuffer("pvptotal"));
		setValueBuffer("cantidad", curLineaPresupuesto.valueBuffer("cantidad"));
		setValueBuffer("referencia", curLineaPresupuesto.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaPresupuesto.valueBuffer("descripcion"));
		setValueBuffer("dtolineal", curLineaPresupuesto.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaPresupuesto.valueBuffer("dtopor"));
	}
	return true;
}

//// IVA_GENERAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
