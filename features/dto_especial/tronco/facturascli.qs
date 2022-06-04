
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial {
    var bloqueoDto:Boolean;
    function dtoEspecial( context ) { oficial ( context ); }
	function init() {
		return this.ctx.dtoEspecial_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.dtoEspecial_bufferChanged(fN);
	}
	function calcularTotales() {
		return this.ctx.dtoEspecial_calcularTotales();
	}
	function actualizarLineasIva(curFactura:FLSqlCursor):Boolean {
		return this.ctx.dtoEspecial_actualizarLineasIva(curFactura);
	}
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
//////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ////////////////////////////////////////////////
function dtoEspecial_bufferChanged(fN:String)
{
	switch (fN) {
		case "neto": {
			form.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			form.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			this.iface.__bufferChanged(fN);
			break;
		}
		/** \C
		El --neto-- es el producto del --netosindtoesp-- por el --pordtoesp--
		\end */
		case "netosindtoesp": {
			if (!this.iface.bloqueoDto) {
				this.iface.bloqueoDto = true;
				this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
				this.iface.bloqueoDto = false;
			}

			break;
		}
		case "pordtoesp": {
			if (!this.iface.bloqueoDto) {
				this.iface.bloqueoDto = true;
				this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
				this.iface.bloqueoDto = false;
			}
			break;
		}
		case "dtoesp": {
			if (!this.iface.bloqueoDto) {
				this.iface.bloqueoDto = true;
				this.child("fdbPorDtoEsp").setValue(this.iface.calculateField("pordtoesp"));
				this.iface.bloqueoDto = false;
			}
			this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
			break;
		}
	}
}

function dtoEspecial_calcularTotales()
{
	var idFactura:Number = this.cursor().valueBuffer("idfactura");
	this.child("fdbNetoSinDtoEsp").setValue(this.iface.calculateField("netosindtoesp"));
	this.iface.__calcularTotales();
}

/** \D
Actualiza (borra y reconstruye) los datos referentes a la factura en la tabla de agrupaciones por IVA (lineasivafactcli)
@param curFactura: Cursor posicionado en la factura
\end */
function dtoEspecial_actualizarLineasIva(curFactura:FLSqlCursor):Boolean
{
	var util = new FLUtil;
	var _i = this.iface;
	
	var idFactura;
	try {
		idFactura = curFactura.valueBuffer("idfactura");
	} catch (e) {
		// Antes se recib�a s�lo idFactura
		MessageBox.critical(util.translate("scripts", "Hay un problema con la actualizaci�n de su personalizaci�n.\nPor favor, p�ngase en contacto con InfoSiAL para solucionarlo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var porDto:Number = parseFloat(curFactura.valueBuffer("pordtoesp"));
	if (isNaN(porDto))
		porDto = 0;
	if (!porDto || porDto == 0)
		return _i.__actualizarLineasIva(curFactura);

	var netoExacto:Number = curFactura.valueBuffer("neto");
	var lineasSinIVA:Number = util.sqlSelect("lineasfacturascli", "SUM(pvptotal)", "idfactura = " + idFactura + " AND iva IS NULL");
	lineasSinIVA = (isNaN(lineasSinIVA) ? 0 : lineasSinIVA);
	netoExacto -= lineasSinIVA;
	netoExacto = util.roundFieldValue(netoExacto, "facturascli", "neto");

	var ivaExacto:Number = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + idFactura);
	if (!ivaExacto)
		ivaExacto = 0;
	var reExacto:Number = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + idFactura);
	if (!reExacto)
		reExacto = 0;
	
	if (!util.sqlDelete("lineasivafactcli", "idfactura = " + idFactura)) {
		return false;
	}

	var codImpuestoAnt:String = "";
	var codImpuesto:String = "";
	var iva:Number;
	var recargo:Number;
	var totalNeto:Number = 0;
	var totalIva:Number = 0;
	var totalRecargo:Number = 0;
	var totalLinea:Number = 0;
	var acumNeto:Number = 0;
	var acumIva:Number = 0;
	var acumRecargo:Number = 0;
	
	var curLineaIva:FLSqlCursor = new FLSqlCursor("lineasivafactcli");
	var qryLineasFactura:FLSqlQuery = new FLSqlQuery;
	with (qryLineasFactura) {
		setTablesList("lineasfacturascli");
		setSelect("codimpuesto, iva, recargo, pvptotal");
		setFrom("lineasfacturascli");
		setWhere("idfactura = " + idFactura + " AND pvptotal <> 0 AND iva IS NOT NULL ORDER BY codimpuesto");
		setForwardOnly(true);
	}
	if (!qryLineasFactura.exec())
		return false;
	
	var regIva = flfacturac.iface.pub_regimenIVACliente(curFactura);

	while (qryLineasFactura.next()) {
		codImpuesto = qryLineasFactura.value("codimpuesto");
		if (codImpuestoAnt != "" && codImpuestoAnt != codImpuesto) {
			totalNeto = (totalNeto * (100 - porDto)) / 100;
			totalNeto = util.roundFieldValue(totalNeto, "lineasivafactcli", "neto");
			totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactcli", "totaliva");
			totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactcli", "totalrecargo");
			totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
			totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");
			
			acumNeto += parseFloat(totalNeto);
			acumIva += parseFloat(totalIva);
			acumRecargo += parseFloat(totalRecargo);

			with(curLineaIva) {
				setModeAccess(Insert);
				refreshBuffer();
				setValueBuffer("idfactura", idFactura);
				setValueBuffer("codimpuesto", codImpuestoAnt);
				setValueBuffer("iva", iva);
				setValueBuffer("recargo", recargo);
				setValueBuffer("neto", totalNeto);
				setValueBuffer("totaliva", totalIva);
				setValueBuffer("totalrecargo", totalRecargo);
				setValueBuffer("totallinea", totalLinea);
			}
			if (!curLineaIva.commitBuffer())
					return false;
			totalNeto = 0;
		}
		
		codImpuestoAnt = codImpuesto;
		if (regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones") {
			ivaExacto = 0;
			reExacto = 0;
			iva = 0;
			recargo = 0;
		} else {
			iva = parseFloat(qryLineasFactura.value("iva"));
			recargo = parseFloat(qryLineasFactura.value("recargo"));
			if (isNaN(recargo)) {
				recargo = 0;
			}
		}
		totalNeto += parseFloat(qryLineasFactura.value("pvptotal"));
	}

	if (totalNeto != 0) {
		totalNeto = util.roundFieldValue(netoExacto - acumNeto, "lineasivafactcli", "neto");
		totalIva = util.roundFieldValue(ivaExacto - acumIva, "lineasivafactcli", "totaliva");
		totalRecargo = util.roundFieldValue(reExacto - acumRecargo, "lineasivafactcli", "totalrecargo");
		totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
		totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");

		with(curLineaIva) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idfactura", idFactura);
			setValueBuffer("codimpuesto", codImpuestoAnt);
			setValueBuffer("iva", iva);
			setValueBuffer("recargo", recargo);
			setValueBuffer("neto", totalNeto);
			setValueBuffer("totaliva", totalIva);
			setValueBuffer("totalrecargo", totalRecargo);
			setValueBuffer("totallinea", totalLinea);
		}
		if (!curLineaIva.commitBuffer())
			return false;
	}
	return true;
}

function dtoEspecial_init()
{
	this.iface.__init();

	this.iface.bloqueoDto = false;
}
//// DTO ESPECIAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////