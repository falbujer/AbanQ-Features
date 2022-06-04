
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
			valor = util.sqlSelect("lineaspedidosprov", "SUM(pvptotal)", "idpedido = " + cursor.valueBuffer("idpedido"));
			if(codImpuesto)
				iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + codImpuesto + "'");
			valor = valor * iva /100; 
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totaliva"));
			break;
		}
		
		case "totalrecargo":{
			var aplicarRecEq:Boolean = flfactppal.iface.pub_valorDefectoEmpresa("recequivalencia");
			if (aplicarRecEq == true) {
				var recargo:Number = 0;
				valor = util.sqlSelect("lineaspedidosprov", "SUM(pvptotal)", "idpedido = " + cursor.valueBuffer("idpedido"));
				if(codImpuesto)
					recargo = util.sqlSelect("impuestos", "recargo", "codimpuesto = '" + codImpuesto + "'");
				valor = valor * recargo /100; 
				valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totalrecargo"));
			}
			else valor = 0;
			break;
		}
		default: valor = this.iface.__commonCalculateField(fN, cursor)
	}
	return valor;
}

/** \D Informa los datos de un albarán a partir de los de uno o varios pedidos
@param	curPedido: Cursor que contiene los datos a incluir en el albarán
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosAlbaran(curPedido:FLSqlCursor):Boolean
{
	var fecha:String;
	if (curPedido.action() == "pedidosprov") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPedido.valueBuffer("fecha");
	
	var numeroAlbaran:Number = flfacturac.iface.pub_siguienteNumero(curPedido.valueBuffer("codserie"), curPedido.valueBuffer("codejercicio"), "nalbaranprov");
				
	with (this.iface.curAlbaran) {
		setValueBuffer("numero", numeroAlbaran);
		setValueBuffer("codproveedor", curPedido.valueBuffer("codproveedor"));
		setValueBuffer("nombre", curPedido.valueBuffer("nombre"));
		setValueBuffer("cifnif", curPedido.valueBuffer("cifnif"));
		setValueBuffer("coddivisa", curPedido.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
		setValueBuffer("codpago", curPedido.valueBuffer("codpago"));
		setValueBuffer("codalmacen", curPedido.valueBuffer("codalmacen"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codserie", curPedido.valueBuffer("codserie"));
		setValueBuffer("codejercicio", curPedido.valueBuffer("codejercicio"));
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
		setValueBuffer("irpf", curPedido.valueBuffer("irpf"));
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
		setValueBuffer("neto", formalbaranesprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formalbaranesprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalrecargo", formalbaranesprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formalbaranesprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formalbaranesprov.iface.pub_commonCalculateField("totaleuros", this));
		setValueBuffer("codigo", formalbaranesprov.iface.pub_commonCalculateField("codigo", this));
	}
	return true;
}

/** \D Copia los datos de una línea de pedido en una línea de albarán
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var cantidad:Number = parseFloat(curLineaPedido.valueBuffer("cantidad")) - parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
	var idAlbaran:Number = this.iface.curLineaAlbaran.valueBuffer("idalbaran");
		
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("idalbaran", idAlbaran);
		setValueBuffer("idlineapedido", curLineaPedido.valueBuffer("idlinea"));
		setValueBuffer("idpedido", curLineaPedido.valueBuffer("idpedido"));
		setValueBuffer("referencia", curLineaPedido.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaPedido.valueBuffer("descripcion"));
		setValueBuffer("pvpunitario", curLineaPedido.valueBuffer("pvpunitario"));
		setValueBuffer("cantidad", cantidad);
		setValueBuffer("codimpuesto", curLineaPedido.valueBuffer("codimpuesto"));
		setValueBuffer("iva", curLineaPedido.valueBuffer("iva"));
		setValueBuffer("recargo", curLineaPedido.valueBuffer("recargo"));
		setValueBuffer("dtolineal", curLineaPedido.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaPedido.valueBuffer("dtopor"));
		setValueBuffer("pvpsindto", curLineaPedido.valueBuffer("pvpsindto"));
		setValueBuffer("pvptotal", curLineaPedido.valueBuffer("pvptotal"));
	}
	return true;
}


//// IVA_GENERAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
