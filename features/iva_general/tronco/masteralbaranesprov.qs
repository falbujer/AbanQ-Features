
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
	function validarAgrupacion(where:String,codProveedor:String):Boolean { 
		return this.ctx.ivaGeneral_validarAgrupacion(where,codProveedor);
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
			valor = util.sqlSelect("lineasalbaranesprov", "SUM(pvptotal)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			if(codImpuesto)
				iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + codImpuesto + "'");
			valor = valor * iva /100; 
			valor = parseFloat(util.roundFieldValue(valor, "albaranesprov", "totaliva"));
			break;
		}
		
		case "totalrecargo":{
			var aplicarRecEq:Boolean = flfactppal.iface.pub_valorDefectoEmpresa("recequivalencia");
			if (aplicarRecEq == true) {
				var recargo:Number = 0;
				valor = util.sqlSelect("lineasalbaranesprov", "SUM(pvptotal)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
				if(codImpuesto)
					recargo = util.sqlSelect("impuestos", "recargo", "codimpuesto = '" + codImpuesto + "'");
				valor = valor * recargo /100; 
				valor = parseFloat(util.roundFieldValue(valor, "albaranesprov", "totalrecargo"));
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
	if (curAlbaran.action() == "albaranesprov") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curAlbaran.valueBuffer("fecha");
	
	var numeroFactura:Number = flfacturac.iface.pub_siguienteNumero(curAlbaran.valueBuffer("codserie"),curAlbaran.valueBuffer("codejercicio"),"nfacturaprov");
		
	with(this.iface.curFactura) {
		setValueBuffer("numero", numeroFactura);
		setValueBuffer("codproveedor", curAlbaran.valueBuffer("codproveedor"));
		setValueBuffer("nombre", curAlbaran.valueBuffer("nombre"));
		setValueBuffer("cifnif", curAlbaran.valueBuffer("cifnif"));
		setValueBuffer("coddivisa", curAlbaran.valueBuffer("coddivisa"));
		setValueBuffer("codpago", curAlbaran.valueBuffer("codpago"));
		setValueBuffer("codalmacen", curAlbaran.valueBuffer("codalmacen"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codejercicio", curAlbaran.valueBuffer("codejercicio"));
		setValueBuffer("codserie", curAlbaran.valueBuffer("codserie"));
		setValueBuffer("tasaconv", curAlbaran.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curAlbaran.valueBuffer("recfinanciero"));
		setValueBuffer("codimpuesto", curAlbaran.valueBuffer("codimpuesto"));
		setValueBuffer("automatica", true);
	}
	return true;
}

/** \D Copia los datos de una línea de albarán en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idFactura:Number = this.iface.curLineaFactura.valueBuffer("idfactura");
	
	with (this.iface.curLineaFactura) {
		setValueBuffer("idfactura", idFactura);
		setValueBuffer("referencia", curLineaAlbaran.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaAlbaran.valueBuffer("descripcion"));
		setValueBuffer("pvpunitario", curLineaAlbaran.valueBuffer("pvpunitario"));
		setValueBuffer("pvpsindto", curLineaAlbaran.valueBuffer("pvpsindto"));
		setValueBuffer("cantidad", curLineaAlbaran.valueBuffer("cantidad"));
		setValueBuffer("pvptotal", curLineaAlbaran.valueBuffer("pvptotal"));
		setValueBuffer("dtopor", curLineaAlbaran.valueBuffer("dtopor"));
		setValueBuffer("dtolineal", curLineaAlbaran.valueBuffer("dtolineal"));
	}
	
	/** \C La subcuenta de compras asociada a cada línea será la establecida en la tabla de artículos
	\end */
	if (sys.isLoadedModule("flcontppal") && referencia != "") {
		var codSubcuenta = util.sqlSelect("articulos", "codsubcuentacom", "referencia = '" + referencia + "'");
		if (codSubcuenta) {
			var ejercicioActual:String = flfactppal.iface.pub_ejercicioActual();
			var idSubcuenta:Number = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + ejercicioActual + "'");
			if (!idSubcuenta) {
				MessageBox.warning(util.translate("scripts", "No existe la subcuenta de compras con código ") + codSubcuenta +  util.translate("scripts", " y ejercicio ") + ejercicioActual + ".\n" + util.translate("scripts", "Debe crear la subcuenta en el área Financiera."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
			this.iface.curLineaFactura.setValueBuffer("codsubcuenta", codSubcuenta);
			this.iface.curLineaFactura.setValueBuffer("idsubcuenta", idSubcuenta);
		}
	}
	return true;
}

/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function ivaGeneral_totalesFactura():Boolean
{
	with (this.iface.curFactura) {
		setValueBuffer("codigo", formfacturasprov.iface.pub_commonCalculateField("codigo", this));
		setValueBuffer("neto", formfacturasprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formfacturasprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalrecargo", formfacturasprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formfacturasprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formfacturasprov.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}

/** \C
Al pulsar el botón de asociar a albarán se abre la ventana de agrupar pedidos de proveedor
\end */
function ivaGeneral_asociarAAlbaran()
{
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("agruparpedidosprov");
	var cursor:FLSqlCursor = f.cursor();
	var where:String;
	var codProveedor:String;

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
		var curAgruparPedidos:FLSqlCursor = new FLSqlCursor("agruparpedidosprov");
		curAgruparPedidos.select();
		if (curAgruparPedidos.first()) {
			where = this.iface.whereAgrupacion(curAgruparPedidos);
			var excepciones:String = curAgruparPedidos.valueBuffer("excepciones");
			if (!excepciones.isEmpty())
				where += " AND idpedido NOT IN (" + excepciones + ")";

			var qryAgruparPedidos:FLSqlQuery = new FLSqlQuery;
			qryAgruparPedidos.setTablesList("pedidosprov");
			qryAgruparPedidos.setSelect("codproveedor");
			qryAgruparPedidos.setFrom("pedidosprov");
			qryAgruparPedidos.setWhere(where + " GROUP BY codproveedor");

			if (!qryAgruparPedidos.exec())
				return;

			var totalProv:Number = qryAgruparPedidos.size();
			util.createProgressDialog(util.translate("scripts", "Generando albaranes"), totalProv);
			util.setProgress(1);
			var j:Number = 0;

			var curPedido:FLSqlCursor = new FLSqlCursor("pedidosprov");
			var whereAlbaran:String;
			while (qryAgruparPedidos.next()) {
				codProveedor = qryAgruparPedidos.value(0);
				whereAlbaran = where + " AND codproveedor = '" + codProveedor + "'";
				
				if(!this.iface.ivaGeneral_validarAgrupacion(whereAlbaran,codProveedor)) 
					continue;
				
				curPedido.transaction(false);
				curPedido.select(whereAlbaran);
				if (!curPedido.first()) {
					curPedido.rollback();
					util.destroyProgressDialog();
					return;
				}
				curPedido.setValueBuffer("fecha", curAgruparPedidos.valueBuffer("fecha"));
				if (formpedidosprov.iface.pub_generarAlbaran(whereAlbaran, curPedido)) {
					curPedido.commit();
				} else {
					curPedido.rollback();
					util.destroyProgressDialog();
					return;
				}
				util.setProgress(++j);
			}
			util.setProgress(totalProv);
			util.destroyProgressDialog();
		}

		f.close();
		this.iface.tdbRecords.refresh();
	}
}

/** \C
Comprueba que todos los pedidos de la agrupacion de un proveedor tengan el mismo --codimpuesto--
@param where claúsula where para seleccionar los pedidos
@param codProveedor código del proveedor de los pedidos a asociar
@return devuelve true si todos tienen el mismo --codimpuesto-- y falso si no lo tienen o hay algún error
\end */
function ivaGeneral_validarAgrupacion(where:String,codProveedor:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var qryAgruparPedidos:FLSqlCursor = new FLSqlQuery;
	qryAgruparPedidos.setTablesList("pedidosprov");
	qryAgruparPedidos.setSelect("codimpuesto");
	qryAgruparPedidos.setFrom("pedidosprov");
	qryAgruparPedidos.setWhere(where);

	if (!qryAgruparPedidos.exec())
		return false;
	
	if(!qryAgruparPedidos.next())
		return false;
		
	var codImpuesto:String = qryAgruparPedidos.value(0);
	
	while (qryAgruparPedidos.next()){
		if(codImpuesto != qryAgruparPedidos.value(0)){
			MessageBox.warning(util.translate("scripts","No se puede generar el albaran para el proveedor ") + codProveedor + ("scripts","\nLos pedidos seleccionados tienen distinto I.V.A."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}
//// IVA_GENERAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
