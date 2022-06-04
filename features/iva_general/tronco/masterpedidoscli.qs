
/** @class_declaration ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
class ivaGeneral extends oficial {
    function ivaGeneral( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaGeneral_commonCalculateField(fN, cursor);
	}
	function totalesAlbaran():Boolean {
		return this.ctx.ivaGeneral_totalesAlbaran();
	}
	function datosAlbaran(curPedido:FLSqlCursor):Boolean {
		return this.ctx.ivaGeneral_datosAlbaran(curPedido);
	}
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.ivaGeneral_datosLineaAlbaran(curLineaPedido);
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
			valor = util.sqlSelect("lineaspedidoscli", "SUM(pvptotal)", "idpedido = " + cursor.valueBuffer("idpedido"));
			if(codImpuesto)
				iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + codImpuesto + "'");
			valor = valor * iva /100; 
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totaliva"));
			break;
		}
		
		case "totalrecargo":{
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
			if (aplicarRecEq == true) {
				var recargo:Number = 0;
				valor = util.sqlSelect("lineaspedidoscli", "SUM(pvptotal)", "idpedido = " + cursor.valueBuffer("idpedido"));
				if(codImpuesto)
					recargo = util.sqlSelect("impuestos", "recargo", "codimpuesto = '" + codImpuesto + "'");
				valor = valor * recargo /100; 
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalrecargo"));
			}
			else valor = 0;
			break;
		}
		default: valor = this.iface.__commonCalculateField(fN, cursor)
	}
	return valor;
}

/** \D Copia los datos de una línea de pedido en una línea de albarán
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var cantidad:Number = parseFloat(curLineaPedido.valueBuffer("cantidad")) - parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
	var pvpSinDto:Number = parseFloat(curLineaPedido.valueBuffer("pvpsindto")) * cantidad / parseFloat(curLineaPedido.valueBuffer("cantidad"));
	pvpSinDto = util.roundFieldValue(pvpSinDto, "lineasalbaranescli", "pvpsindto");
	var idAlbaran = this.iface.curLineaAlbaran.valueBuffer("idalbaran");
	
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("idalbaran", idAlbaran);
		setValueBuffer("idlineapedido", curLineaPedido.valueBuffer("idlinea"));
		setValueBuffer("idpedido", curLineaPedido.valueBuffer("idpedido"));
		setValueBuffer("referencia", curLineaPedido.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaPedido.valueBuffer("descripcion"));
		setValueBuffer("pvpunitario", curLineaPedido.valueBuffer("pvpunitario"));
		setValueBuffer("cantidad", cantidad);
		setValueBuffer("dtolineal", curLineaPedido.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaPedido.valueBuffer("dtopor"));
		setValueBuffer("pvpsindto", pvpSinDto);
		setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this));
	}
	return true;
}

/** \D Informa los datos de un albarán a partir de los de uno o varios pedidos
@param	curPedido: Cursor que contiene los datos a incluir en el albarán
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosAlbaran(curPedido:FLSqlCursor):Boolean
{
	var fecha:String;
	if (curPedido.action() == "pedidoscli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPedido.valueBuffer("fecha");
		
	var numeroAlbaran:Number = flfacturac.iface.pub_siguienteNumero(curPedido.valueBuffer("codserie"), curPedido.valueBuffer("codejercicio"), "nalbaranprov");
			
	with (this.iface.curAlbaran) {
		setValueBuffer("numero", numeroAlbaran);
		setValueBuffer("codserie", curPedido.valueBuffer("codserie"));
		setValueBuffer("codejercicio", curPedido.valueBuffer("codejercicio"));
		setValueBuffer("irpf", curPedido.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codagente", curPedido.valueBuffer("codagente"));
		setValueBuffer("porcomision", curPedido.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curPedido.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curPedido.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curPedido.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curPedido.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curPedido.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curPedido.valueBuffer("nombrecliente"));
		setValueBuffer("coddir", curPedido.valueBuffer("coddir"));
		setValueBuffer("direccion", curPedido.valueBuffer("direccion"));
		setValueBuffer("codpostal", curPedido.valueBuffer("codpostal"));
		setValueBuffer("ciudad", curPedido.valueBuffer("ciudad"));
		setValueBuffer("provincia", curPedido.valueBuffer("provincia"));
		setValueBuffer("apartado", curPedido.valueBuffer("apartado"));
		setValueBuffer("codpais", curPedido.valueBuffer("codpais"));
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
		setValueBuffer("codimpuesto", curPedido.valueBuffer("codimpuesto"));
	}
	
	return true;
}

/** \D Informa los datos de un albarán referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_totalesAlbaran():Boolean
{
	with (this.iface.curAlbaran) {
		setValueBuffer("neto", formalbaranescli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formalbaranescli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formalbaranescli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formalbaranescli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formalbaranescli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formalbaranescli.iface.pub_commonCalculateField("totaleuros", this));
		setValueBuffer("codigo", formalbaranescli.iface.pub_commonCalculateField("codigo", this));
	}
	return true;
}
//// IVA_GENERAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
