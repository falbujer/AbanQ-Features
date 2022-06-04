
/** @class_declaration ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
class ivaGeneral extends oficial {
    function ivaGeneral( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaGeneral_commonCalculateField(fN, cursor);
	}
	function totalesFactura():Boolean {
		return this.ctx.ivaGeneral_totalesFactura();
	}
	function datosFactura(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.ivaGeneral_datosFactura(curAlbaran);
	}
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.ivaGeneral_datosLineaFactura(curLineaAlbaran);
	}
	function asociarAAlbaran() {
		return this.ctx.ivaGeneral_asociarAAlbaran();
	}
	function validarAgrupacion(where:String,codCliente:String):Boolean { 
		return this.ctx.ivaGeneral_validarAgrupacion(where,codCliente);
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
			valor = util.sqlSelect("lineasalbaranescli", "SUM(pvptotal)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			if(codImpuesto)
				iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + codImpuesto + "'");
			valor = valor * iva /100; 
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totaliva"));
			break;
		}
		
		case "totalrecargo":{
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
			if (aplicarRecEq == true) {
				var recargo:Number = 0;
				valor = util.sqlSelect("lineasalbaranescli", "SUM(pvptotal)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
				if(codImpuesto)
					recargo = util.sqlSelect("impuestos", "recargo", "codimpuesto = '" + codImpuesto + "'");
				valor = valor * recargo /100; 
				valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalrecargo"));
			}
			else valor = 0;
			break;
		}
		default: valor = this.iface.__commonCalculateField(fN, cursor)
	}
	return valor;
}

/** \D Informa los datos de una factura a partir de los de uno o varios albaranes
@param	curAlbaran: Cursor que contiene los datos a incluir en la factura
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosFactura(curAlbaran:FLSqlCursor):Boolean
{
	var fecha:String;
	if (curAlbaran.action() == "albaranescli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curAlbaran.valueBuffer("fecha");
		
	var numeroFactura:Number = flfacturac.iface.pub_siguienteNumero(curAlbaran.valueBuffer("codserie"),curAlbaran.valueBuffer("codejercicio"), "nfacturacli");
	
	with (this.iface.curFactura) {
		setValueBuffer("numero", numeroFactura);
		setValueBuffer("codserie", curAlbaran.valueBuffer("codserie"));
		setValueBuffer("codejercicio", curAlbaran.valueBuffer("codejercicio"));
		setValueBuffer("irpf", curAlbaran.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codagente", curAlbaran.valueBuffer("codagente"));
		setValueBuffer("porcomision", curAlbaran.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curAlbaran.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curAlbaran.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curAlbaran.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curAlbaran.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curAlbaran.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curAlbaran.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curAlbaran.valueBuffer("nombrecliente"));
		setValueBuffer("coddir", curAlbaran.valueBuffer("coddir"));
		setValueBuffer("direccion", curAlbaran.valueBuffer("direccion"));
		setValueBuffer("codpostal", curAlbaran.valueBuffer("codpostal"));
		setValueBuffer("ciudad", curAlbaran.valueBuffer("ciudad"));
		setValueBuffer("provincia", curAlbaran.valueBuffer("provincia"));
		setValueBuffer("apartado", curAlbaran.valueBuffer("apartado"));
		setValueBuffer("codpais", curAlbaran.valueBuffer("codpais"));
		setValueBuffer("recfinanciero", curAlbaran.valueBuffer("recfinanciero"));
		setValueBuffer("codimpuesto", curAlbaran.valueBuffer("codimpuesto"));
		setValueBuffer("automatica", true);
	}
	return true;
}

/** \D Copia los datos de una línea de albarán en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	var idFactura:Number = this.iface.curLineaFactura.valueBuffer("idfactura");

	with (this.iface.curLineaFactura) {
		setValueBuffer("idfactura", idFactura);
		setValueBuffer("referencia", curLineaAlbaran.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaAlbaran.valueBuffer("descripcion"));
		setValueBuffer("pvpunitario", curLineaAlbaran.valueBuffer("pvpunitario"));
		setValueBuffer("pvpsindto", curLineaAlbaran.valueBuffer("pvpsindto"));
		setValueBuffer("cantidad", curLineaAlbaran.valueBuffer("cantidad"));
		setValueBuffer("pvptotal", curLineaAlbaran.valueBuffer("pvptotal"));
		setValueBuffer("dtolineal", curLineaAlbaran.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaAlbaran.valueBuffer("dtopor"));
	}
	return true;
}

/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_totalesFactura():Boolean
{
	with (this.iface.curFactura) {
		setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
		setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", this));
	}
	return true;
}
/** \C
Al pulsar el botón de asociar a albarán se abre la ventana de agrupar pedidos de cliente
\end */
function ivaGeneral_asociarAAlbaran()
{
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("agruparpedidoscli");
	var cursor:FLSqlCursor = f.cursor();
	var where:String;
	var codCliente:String;

	cursor.setActivatedCheckIntegrity(false);
	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var acpt:String = f.exec("codejercicio");

	if (acpt) {
		cursor.commitBuffer();
		var curAgruparPedidos:FLSqlCursor = new FLSqlCursor("agruparpedidoscli");
		curAgruparPedidos.select();
		if (curAgruparPedidos.first()) {
			where = this.iface.whereAgrupacion(curAgruparPedidos);
			var excepciones = curAgruparPedidos.valueBuffer("excepciones");
			if (!excepciones.isEmpty())
				where += " AND idpedido NOT IN (" + excepciones + ")";

			var qryAgruparPedidos = new FLSqlQuery;
			qryAgruparPedidos.setTablesList("pedidoscli");
			qryAgruparPedidos.setSelect("codcliente");
			qryAgruparPedidos.setFrom("pedidoscli");
			qryAgruparPedidos.setWhere(where + " GROUP BY codcliente");
			if (!qryAgruparPedidos.exec())
				return;
				
			var totalClientes:Number = qryAgruparPedidos.size();
			util.createProgressDialog(util.translate("scripts", "Generando albaranes"), totalClientes);
			util.setProgress(1);
			var j:Number = 0; 
			var curPedido :FLSqlCursor= new FLSqlCursor("pedidoscli");
			var whereAlbaran:String;
			while (qryAgruparPedidos.next()) {
				codCliente = qryAgruparPedidos.value(0);
				whereAlbaran = where + " AND codcliente = '" + codCliente + "'";
				
				if(!this.iface.ivaGeneral_validarAgrupacion(whereAlbaran,codCliente)) 
					continue;
					
				curPedido.transaction(false);
				curPedido.select(whereAlbaran);
				if (!curPedido.first()) {
					curPedido.rollback();
					util.destroyProgressDialog();
					return;
				}
				curPedido.setValueBuffer("fecha", curAgruparPedidos.valueBuffer("fecha"));
				if (formpedidoscli.iface.pub_generarAlbaran(whereAlbaran, curPedido)) {
					curPedido.commit();
				} else {
					curPedido.rollback();
					util.destroyProgressDialog();
					return;
				}
				util.setProgress(++j);
			}
			util.setProgress(totalClientes);
			util.destroyProgressDialog();
		}
		f.close();
		this.iface.tdbRecords.refresh();
	}
}

/** \C
Comprueba que todos los pedidos de la agrupacion de un cliente tengan el mismo --codimpuesto--
@param where claúsula where para seleccionar los pedidos
@param codCliente código del cliente de los pedidos a asociar
@return devuelve true si todos tienen el mismo --codimpuesto-- y falso si no lo tienen o hay algún error
\end */
function ivaGeneral_validarAgrupacion(where:String,codCliente:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var qryAgruparPedidos:FLSqlCursor = new FLSqlQuery;
	qryAgruparPedidos.setTablesList("pedidoscli");
	qryAgruparPedidos.setSelect("codimpuesto");
	qryAgruparPedidos.setFrom("pedidoscli");
	qryAgruparPedidos.setWhere(where);

	if (!qryAgruparPedidos.exec())
		return false;
	
	if(!qryAgruparPedidos.next())
		return false;
		
	var codImpuesto:String = qryAgruparPedidos.value(0);
	
	while (qryAgruparPedidos.next()){
		if(codImpuesto != qryAgruparPedidos.value(0)){
			MessageBox.warning(util.translate("scripts","No se puede generar el albaran para el cliente ") + codCliente + ("scripts","\nLos pedidos seleccionados tienen distinto I.V.A."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}
//// IVA_GENERAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
