
/** @class_declaration tmpEjerDoc */
/////////////////////////////////////////////////////////////////
//// EJERDOC ////////////////////////////////////////////////////
class tmpEjerDoc extends oficial {
    function tmpEjerDoc( context ) { oficial ( context ); }
	function datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.tmpEjerDoc_datosFactura(curAlbaran, where, datosAgrupacion);
	}
	function generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion:Array):Boolean {
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
	var fecha:String;
	if (curAlbaran.action() == "albaranesprov") {
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
	
	with(this.iface.curFactura) {
		setValueBuffer("codproveedor", curAlbaran.valueBuffer("codproveedor"));
		setValueBuffer("nombre", curAlbaran.valueBuffer("nombre"));
		setValueBuffer("cifnif", curAlbaran.valueBuffer("cifnif"));
		setValueBuffer("coddivisa", curAlbaran.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curAlbaran.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curAlbaran.valueBuffer("recfinanciero"));
		setValueBuffer("codpago", curAlbaran.valueBuffer("codpago"));
		setValueBuffer("codalmacen", curAlbaran.valueBuffer("codalmacen"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("codserie", curAlbaran.valueBuffer("codserie"));
		setValueBuffer("tasaconv", curAlbaran.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curAlbaran.valueBuffer("recfinanciero"));
		setValueBuffer("irpf", curAlbaran.valueBuffer("irpf"));
		setValueBuffer("automatica", true);
	}
	return true;
}

/** \D 
Genera la factura asociada a uno o más albaranes
@param where: Sentencia where para la consulta de búsqueda de los albaranes a agrupar
@param curAlbaran: Cursor con los datos principales que se copiarán del albarán a la factura
@return Identificador de la factura creada, False: si hay error
\end */
function tmpEjerDoc_generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion:Array):Boolean
{
	var curFactura:FLSqlCursor = new FLSqlCursor("facturasprov");
	var idAlbaran:Number;
	var numeroFactura:Number = flfacturac.iface.pub_siguienteNumero(curAlbaran.valueBuffer("codserie"), curAlbaran.valueBuffer("codejercicio"), "nfacturaprov");
	if (!numeroFactura)
			return false;
	
	var fecha:String;
	if (curAlbaran.action() == "albaranesprov") {
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
		setValueBuffer("codproveedor", curAlbaran.valueBuffer("codproveedor"));
		setValueBuffer("nombre", curAlbaran.valueBuffer("nombre"));
		setValueBuffer("cifnif", curAlbaran.valueBuffer("cifnif"));
		setValueBuffer("coddivisa", curAlbaran.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curAlbaran.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curAlbaran.valueBuffer("recfinanciero"));
		setValueBuffer("codpago", curAlbaran.valueBuffer("codpago"));
		setValueBuffer("codalmacen", curAlbaran.valueBuffer("codalmacen"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("codserie", curAlbaran.valueBuffer("codserie"));
		setValueBuffer("tasaconv", curAlbaran.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curAlbaran.valueBuffer("recfinanciero"));
		setValueBuffer("automatica", true);
	}
	if (!curFactura.commitBuffer())
		return false;
	
	var idFactura:Number = curFactura.valueBuffer("idfactura");

	var curAlbaranes:FLSqlCursor = new FLSqlCursor("albaranesprov");
	curAlbaranes.select(where);
	while (curAlbaranes.next()) {
		curAlbaranes.setModeAccess(curAlbaranes.Edit);
		curAlbaranes.refreshBuffer();
		idAlbaran = curAlbaranes.valueBuffer("idalbaran");
		if (!this.iface.copiaLineasAlbaran(idAlbaran, idFactura))
			return false;

		curAlbaranes.setValueBuffer("idfactura", idFactura);
		curAlbaranes.setValueBuffer("ptefactura", false);
		if (!curAlbaranes.commitBuffer())
			return false;
	}

	curFactura.select("idfactura = " + idFactura);
	if (curFactura.first()) { 
		if (!formRecordfacturasprov.iface.pub_actualizarLineasIva(idFactura))
			return false;
		with(curFactura) {
			setModeAccess(Edit);
			refreshBuffer();
			setValueBuffer("neto", formfacturasprov.iface.pub_commonCalculateField("neto", curFactura));
			setValueBuffer("totaliva", formfacturasprov.iface.pub_commonCalculateField("totaliva", curFactura));
			setValueBuffer("totalrecargo", formfacturasprov.iface.pub_commonCalculateField("totalrecargo", curFactura));
			setValueBuffer("total", formfacturasprov.iface.pub_commonCalculateField("total", curFactura));
			setValueBuffer("totaleuros", formfacturasprov.iface.pub_commonCalculateField("totaleuros", curFactura));
			setValueBuffer("codigo", formfacturasprov.iface.pub_commonCalculateField("codigo", curFactura));
		}
		if (curFactura.commitBuffer() == false)
			return false;
	}
	return idFactura;
}

//// EJERDOC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
