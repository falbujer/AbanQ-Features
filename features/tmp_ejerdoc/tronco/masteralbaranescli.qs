
/** @class_declaration tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
class tmpEjerDoc extends oficial {
    function tmpEjerDoc( context ) { oficial ( context ); }
	function datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.tmpEjerDoc_datosFactura(curAlbaran, where, datosAgrupacion);
	}
	function generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.ctx.tmpEjerDoc_generarFactura(where, curAlbaran, datosAgrupacion);
	}
}
//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
/** \D Informa los datos de una factura a partir de los de uno o varios albaranes
@param	curAlbaran: Cursor que contiene los datos a incluir en la factura
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function tmpEjerDoc_datosFactura(curAlbaran:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var fecha:String;
	if (curAlbaran.action() == "albaranescli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curAlbaran.valueBuffer("fecha");
		
	var codEjercicio:String = curAlbaran.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio);
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}
	
	var codDir:Number = util.sqlSelect("dirclientes", "id", "codcliente = '" + curAlbaran.valueBuffer("codcliente") + "' AND domfacturacion = 'true'");
	
	with (this.iface.curFactura) {
		setValueBuffer("codserie", curAlbaran.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
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
		if(!codDir){
			setValueBuffer("coddir", curAlbaran.valueBuffer("coddir"));
			setValueBuffer("direccion", curAlbaran.valueBuffer("direccion"));
			setValueBuffer("codpostal", curAlbaran.valueBuffer("codpostal"));
			setValueBuffer("ciudad", curAlbaran.valueBuffer("ciudad"));
			setValueBuffer("provincia", curAlbaran.valueBuffer("provincia"));
			setValueBuffer("apartado", curAlbaran.valueBuffer("apartado"));
			setValueBuffer("codpais", curAlbaran.valueBuffer("codpais"));
		}
		else {
			setValueBuffer("coddir", codDir);
			setValueBuffer("direccion", util.sqlSelect("dirclientes","direccion","id = " + codDir));
			setValueBuffer("codpostal", util.sqlSelect("dirclientes","codpostal","id = " + codDir));
			setValueBuffer("ciudad", util.sqlSelect("dirclientes","ciudad","id = " + codDir));
			setValueBuffer("provincia", util.sqlSelect("dirclientes","provincia","id = " + codDir));
			setValueBuffer("apartado", util.sqlSelect("dirclientes","apartado","id = " + codDir));
			setValueBuffer("codpais", util.sqlSelect("dirclientes","codpais","id = " + codDir));
		}
		setValueBuffer("recfinanciero", curAlbaran.valueBuffer("recfinanciero"));
		setValueBuffer("automatica", true);
	}
	return true;
}

/** \D
Genera la factura asociada a uno o más albaranes
@param where: Sentencia where para la consulta de búsqueda de los albaranes a agrupar
@param curAlbaran: Cursor con los datos principales que se copiarán del albarán a la factura
@return True: Copia realizada con éxito, False: Error
\end */
function tmpEjerDoc_generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion:Array):Number
{
		var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
		var idAlbaran:Number;
		var numeroFactura:Number = flfacturac.iface.pub_siguienteNumero(curAlbaran.valueBuffer("codserie"),curAlbaran.valueBuffer("codejercicio"), "nfacturacli");
		if (!numeroFactura)
			return false;

		var fecha:String;
		if (curAlbaran.action() == "albaranescli") {
			var hoy:Date = new Date();
			fecha = hoy.toString();
		} else
			fecha = curAlbaran.valueBuffer("fecha");
			
	var codEjercicio:String = curAlbaran.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio);
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}
	
		
		with(curFactura) {
				setModeAccess(Insert);
				refreshBuffer();
				setValueBuffer("numero", numeroFactura);
				setValueBuffer("codserie", curAlbaran.valueBuffer("codserie"));
				setValueBuffer("codejercicio", codEjercicio);
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
				setValueBuffer("automatica", true);
		}
		if (!curFactura.commitBuffer()) {
				return false;
		}

		var idFactura:Number = curFactura.valueBuffer("idfactura");
		var curAlbaranes:FLSqlCursor = new FLSqlCursor("albaranescli");
		curAlbaranes.select(where);
		while (curAlbaranes.next()) {
				curAlbaranes.setModeAccess(curAlbaranes.Edit);
				curAlbaranes.refreshBuffer();
				idAlbaran = curAlbaranes.valueBuffer("idalbaran");
				if (!this.iface.copiaLineasAlbaran(idAlbaran, idFactura)) {
						return false;
				}
				curAlbaranes.setValueBuffer("idfactura", idFactura);
				curAlbaranes.setValueBuffer("ptefactura", false);
				if (!curAlbaranes.commitBuffer()) {
						return false;
				}
		}

		curFactura.select("idfactura = " + idFactura);
		if (curFactura.first()) {
				if (!formRecordfacturascli.iface.pub_actualizarLineasIva(idFactura))
						return false;
				with(curFactura) {
						setModeAccess(Edit);
						refreshBuffer();
						setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", curFactura));
						setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", curFactura));
						setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", curFactura));
						setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", curFactura));
						setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", curFactura));
						setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", curFactura));
						setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", curFactura));
				}
				if (curFactura.commitBuffer() == false)
						return false;
		}
		return idFactura;
}

//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

