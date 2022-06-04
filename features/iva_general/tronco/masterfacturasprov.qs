
/** @class_declaration ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
class ivaGeneral extends oficial {
    function ivaGeneral( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaGeneral_commonCalculateField(fN, cursor);
	}
	function asociarAFactura() {
		return this.ctx.ivaGeneral_asociarAFactura();
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
			valor = util.sqlSelect("lineasfacturasprov", "SUM(pvptotal)", "idfactura = " + cursor.valueBuffer("idfactura"));
			if(codImpuesto)
				iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + codImpuesto + "'");
			valor = valor * iva /100; 
			valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "totaliva"));
			break;
		}
		
		case "totalrecargo":{
			var aplicarRecEq:Boolean = flfactppal.iface.pub_valorDefectoEmpresa("recequivalencia");
			if (aplicarRecEq == true) {
				var recargo:Number = 0;
				valor = util.sqlSelect("lineasfacturasprov", "SUM(pvptotal)", "idfactura = " + cursor.valueBuffer("idfactura"));
				if(codImpuesto)
					recargo = util.sqlSelect("impuestos", "recargo", "codimpuesto = '" + codImpuesto + "'");
				valor = valor * recargo /100; 
				valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "totalrecargo"));
			}
			else valor = 0;
			break;
		}
		case "neto":{
			valor = util.sqlSelect("lineasfacturasprov", "SUM(pvptotal)", "idfactura = " + cursor.valueBuffer("idfactura"));
			break;
		}
		default: valor = this.iface.__commonCalculateField(fN, cursor)
	}
	return valor;
}

/** \C
Al pulsar el botón de asociar a factura se abre la ventana de agrupar albaranes de proveedor
\end */
function ivaGeneral_asociarAFactura()
{
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("agruparalbaranesprov");
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

		var curAgruparAlbaranes:FLSqlCursor = new FLSqlCursor("agruparalbaranesprov");
		curAgruparAlbaranes.select();
		if (curAgruparAlbaranes.first()) {
			where = this.iface.whereAgrupacion(curAgruparAlbaranes);
			var excepciones:FLSqlCursor = curAgruparAlbaranes.valueBuffer("excepciones");
			if (!excepciones.isEmpty())
				where += " AND idalbaran NOT IN (" + excepciones + ")";
					
			var qryAgruparAlbaranes:FLSqlQuery = new FLSqlQuery;
			qryAgruparAlbaranes.setTablesList("albaranesprov");
			qryAgruparAlbaranes.setSelect("codproveedor");
			qryAgruparAlbaranes.setFrom("albaranesprov");
			qryAgruparAlbaranes.setWhere(where + " GROUP BY codproveedor");

			if (!qryAgruparAlbaranes.exec())
				return;

			var totalProv:Number = qryAgruparAlbaranes.size();
			util.createProgressDialog(util.translate("scripts", "Generando facturas"), totalProv);
			util.setProgress(1);
			var j:Number = 0;
			
			var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranesprov");
			var whereFactura:String;
			while (qryAgruparAlbaranes.next()) {
				codProveedor = qryAgruparAlbaranes.value(0);
				whereFactura = where + " AND codproveedor = '" + codProveedor + "'";
				
				if(!this.iface.ivaGeneral_validarAgrupacion(whereFactura,codProveedor)) 
					continue;
				
				curAlbaran.transaction(false);
				curAlbaran.select(whereFactura);
				if (!curAlbaran.first()) {
					curAlbaran.rollback();
					util.destroyProgressDialog();
					return;
				}
				curAlbaran.setValueBuffer("fecha", curAgruparAlbaranes.valueBuffer("fecha"));
				if (formalbaranesprov.iface.pub_generarFactura(whereFactura, curAlbaran)) {
					curAlbaran.commit();
				} else {
					curAlbaran.rollback();
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
Comprueba que todos los albaranes de la agrupacion de un proveedor tengan el mismo --codimpuesto--
@param where claúsula where para seleccionar los albaranes
@param codProveedor código del proveedor de los albaranes a asociar
@return devuelve true si todos tienen el mismo --codimpuesto-- y falso si no lo tienen o hay algún error
\end */
function ivaGeneral_validarAgrupacion(where:String,codProveedor:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var qryAgruparAlbaranes:FLSqlCursor = new FLSqlQuery;
	qryAgruparAlbaranes.setTablesList("albaranesprov");
	qryAgruparAlbaranes.setSelect("codimpuesto");
	qryAgruparAlbaranes.setFrom("albaranesprov");
	qryAgruparAlbaranes.setWhere(where);

	if (!qryAgruparAlbaranes.exec())
		return false;
	
	if(!qryAgruparAlbaranes.next())
		return false;
		
	var codImpuesto:String = qryAgruparAlbaranes.value(0);
	
	while (qryAgruparAlbaranes.next()){
		if(codImpuesto != qryAgruparAlbaranes.value(0)){
			MessageBox.warning(util.translate("scripts","No se puede generar la factura para el proveedor ") + codProveedor + ("scripts","\nLos albaranes seleccionados tienen distinto I.V.A."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}
//// IVA_GENERAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
