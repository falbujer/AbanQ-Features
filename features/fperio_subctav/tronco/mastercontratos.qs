
/** @class_declaration funFperioSctaV */
/////////////////////////////////////////////////////////////////
//// FUN_FPERIOSCTAV /////////////////////////////////////////////////
class funFperioSctaV extends oficial {
	function funFperioSctaV( context ) { oficial ( context ); }
    function generarFactura(idPeriodo:Number, codCliente:String, codContrato:String, coste:Number):Boolean { 
    	return this.ctx.funFperioSctaV_generarFactura(idPeriodo, codCliente, codContrato, coste);
    }
}
//// FUN_FPERIOSCTAV //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funFperioSctaV */
/////////////////////////////////////////////////////////////////
//// FUN_FPERIOSCTAV /////////////////////////////////////////////////

function funFperioSctaV_generarFactura(idPeriodo:Number, codCliente:String, codContrato:String, coste:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	
	var hoy = new Date();
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("clientes");
	q.setFrom("clientes");
	q.setSelect("nombre,cifnif,coddivisa,codpago,codserie,codagente");
	q.setWhere("codcliente = '" + codCliente + "'");
	
	if (!q.exec()) return;
	if (!q.first()) {
		MessageBox.warning(util.translate("scripts", "Error al obtener los datos del cliente\nNo se generará la factura de este cliente: ") + codCliente,
			MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var qDir:FLSqlQuery = new FLSqlQuery();
	qDir.setTablesList("dirclientes");
	qDir.setFrom("dirclientes");
	qDir.setSelect("id,direccion,codpostal,ciudad,provincia,apartado,codpais");
	qDir.setWhere("codcliente = '" + codCliente + "' and domfacturacion = '" + true + "'");
	
	if (!qDir.exec()) return;
	if (!qDir.first()) {
		MessageBox.warning(util.translate("scripts", "Error al obtener la dirección del cliente\nAsegúrate de que este cliente tiene una dirección de facturación\nNo se generará la factura de este cliente: ") + codCliente,
			MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
	var numeroFactura:Number = flfacturac.iface.pub_siguienteNumero(q.value(4),flfactppal.iface.pub_ejercicioActual(), "nfacturacli");
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();

	with(curFactura) {
		setModeAccess(Insert);
		refreshBuffer();
		
		setValueBuffer("codigo", flfacturac.iface.pub_construirCodigo(q.value(4), codEjercicio, numeroFactura));
		setValueBuffer("numero", numeroFactura);
		setValueBuffer("irpf", util.sqlSelect("series", "irpf", "codserie = '" + q.value(4) + "'"));
		setValueBuffer("recfinanciero", 0);
		
		setValueBuffer("codcliente", codCliente);
		setValueBuffer("nombrecliente", q.value(0));
		setValueBuffer("cifnif", q.value(1));
		
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("coddivisa", q.value(2));
		setValueBuffer("codpago", q.value(3));
		setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
		setValueBuffer("codserie", q.value(4));
		setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + q.value(2) + "'"));
		setValueBuffer("fecha", hoy);
		setValueBuffer("hora", hoy);
		
		setValueBuffer("codagente", q.value(5));
		setValueBuffer("porcomision", util.sqlSelect("agentes", "porcomision", "codagente = '" + q.value(5) + "'"));
				
		setValueBuffer("coddir", qDir.value(0));
		setValueBuffer("direccion", qDir.value(1));
		setValueBuffer("codpostal", qDir.value(2));
		setValueBuffer("ciudad", qDir.value(3));
		setValueBuffer("provincia", qDir.value(4));
		setValueBuffer("apartado", qDir.value(5));
		setValueBuffer("codpais", qDir.value(6));
	}
	
	if (!curFactura.commitBuffer()) {
		return false;
	}

	
	var datosPeriodo = flfactppal.iface.pub_ejecutarQry("periodoscontratos", "codcontrato,fechainicio,fechafin,referencia,coste,codimpuesto", "id = " + idPeriodo);
	
	var iva:Number = 0;
	var recargo:Number = 0;
	var datosImpuesto = flfacturac.iface.pub_datosImpuesto(datosPeriodo.codimpuesto, util.dateAMDtoDMA(hoy));
	if (datosImpuesto) {
		iva = datosImpuesto.iva;
		recargo = datosImpuesto.recargo;
	}
	
	var datosContabilidad = flfactppal.iface.pub_ejecutarQry("articulos", "codsubcuentaven,idsubcuentaven", "referencia = '" + datosPeriodo.referencia + "'");
	
	var idFactura:Number = curFactura.valueBuffer("idfactura");
	var curLineaFactura:FLSqlCursor = new FLSqlCursor("lineasfacturascli");
	var descripcion = util.sqlSelect("contratos", "descripcion", "codigo = '" + codContrato + "'");
	if (!descripcion)
		descripcion = "";

	with(curLineaFactura) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idfactura", idFactura);
		setValueBuffer("referencia", datosPeriodo.referencia);
		setValueBuffer("descripcion", descripcion + " / Periodo " + datosPeriodo.fechainicio.toString().left(10) + "-" + datosPeriodo.fechafin.toString().left(10));
		setValueBuffer("pvpunitario", datosPeriodo.coste);
		setValueBuffer("pvpsindto", datosPeriodo.coste);
		setValueBuffer("cantidad", 1);
		setValueBuffer("pvptotal", datosPeriodo.coste);
		setValueBuffer("codimpuesto", datosPeriodo.codimpuesto);
		if (datosContabilidad.result > 0) {
			if (datosContabilidad.idsubcuentaven) {
				setValueBuffer("codsubcuenta", datosContabilidad.codsubcuentaven);
				setValueBuffer("idsubcuenta", datosContabilidad.idsubcuentaven);
			}
		}
		setValueBuffer("iva", iva);
		setValueBuffer("recargo", recargo);
		setValueBuffer("dtolineal", 0);
		setValueBuffer("dtopor", 0);
	}
	if (!curLineaFactura.commitBuffer())
		return false;
	
	curFactura.select("idfactura = " + idFactura);
	
	if (curFactura.first()) {
		
		if (!formRecordfacturascli.iface.pub_actualizarLineasIva(curFactura))
			return false;
	
		this.iface.totalesFactura(curFactura);
// 		with(curFactura) {
// 			setModeAccess(Edit);
// 			refreshBuffer();
// 			setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", curFactura));
// 			setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", curFactura));
// 			setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", curFactura));
// 			setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", curFactura));
// 			setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", curFactura));
// 			setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", curFactura));
// 			setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", curFactura));
// 		}
		
		if (!curFactura.commitBuffer())
			return false;
	}
	
	this.iface.actualizarPeriodo(idPeriodo, idFactura);
	this.iface.actualizarContrato(idPeriodo);
	
	return true;
}

//// FUN_FPERIOSCTAV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
