
/** @class_declaration diasPagoProv */
/////////////////////////////////////////////////////////////////
//// DIAS_PAGO_PROV /////////////////////////////////////////////
class diasPagoProv extends proveed {
    function diasPagoProv( context ) { proveed ( context ); }
	function calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado) {
		return this.ctx.diasPagoProv_calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado);
	}
	function procesarDiasPagoProv(fechaV:String, diasPago:Array):String {
		return this.ctx.diasPagoProv_procesarDiasPagoProv(fechaV, diasPago);
	}
	function procesarDiasPagoProvAnt(fechaV:String, diasPago:Array):String {
		return this.ctx.diasPagoProv_procesarDiasPagoProvAnt(fechaV, diasPago);
	}
}
//// DIAS_PAGO_PROV //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition diasPagoProv */
/////////////////////////////////////////////////////////////////
//// DIAS_PAGO_PROV /////////////////////////////////////////////
/* \D Calcula la fecha de vencimiento de un recibo en base a los d�as de pago y vacaciones del proveedor
@param curFactura: Cursor posicionado en el registro de facturas correspondiente a la factura
@param numPlazo: N�mero del plazo actual
@param diasAplazado: D�as de aplazamiento del pago
@return Fecha de vencimiento
\end */
function diasPagoProv_calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado)
{
	var util:FLUtil = new FLUtil;
	var fechaFactura = this.iface.dameFechaEmisionProv(curFactura);
	var f:String = this.iface.__calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado);
	
	var codProveedor:String = curFactura.valueBuffer("codproveedor");
	if (!codProveedor || codProveedor == "")
		return f;
	
	var diasPago:Array;
	var cadenaDiasPago:String = util.sqlSelect("proveedores", "diaspago", "codproveedor = '" + codProveedor + "'");
	if (!cadenaDiasPago || cadenaDiasPago == "")
		diasPago = "";
	else
		diasPago = cadenaDiasPago.split(",");
		
	var buscarDia:String = util.sqlSelect("proveedores", "buscardia", "codproveedor = '" + codProveedor + "'");
	if (buscarDia == "Posterior")
		fechaVencimiento = this.iface.procesarDiasPagoProv(f, diasPago);
	else {
		fechaVencimiento = this.iface.procesarDiasPagoProvAnt(f, diasPago);
		if (util.daysTo(fechaVencimiento, fechaFactura) > 0)
			fechaVencimiento = this.iface.procesarDiasPagoProv(f, diasPago);
	}
	
	return fechaVencimiento;
}

/** \D Modifica la fecha de vencimiento en funci�n del d�a de pago al proveedor, buscando el siguiente d�a de pago
@param	fechaV: String con la fecha de vencimiento actual
@param	diasPago: Array con los d�as de pago para cada plazo
@return	Fecha de vencimiento modificada
\end */
function diasPagoProv_procesarDiasPagoProv(fechaV:String, diasPago:Array):String
{
	var util:FLUtil = new FLUtil;
	var fechaVencimiento:Date = new Date (Date.parse(fechaV.toString()));

	if (diasPago == "" || !diasPago)
		return fechaV;
	var diaFV:Number = parseFloat(fechaVencimiento.getDate());

	var i:Number = 0;
	var distancia:Number;
	var diaPago:Number;
	for (i = 0; i < diasPago.length && parseFloat(diasPago[i]) < diaFV; i++);
	
	if (i < diasPago.length) {
		diaPago = diasPago[i];
	} else {
		var aux = util.addMonths(fechaVencimiento.toString(), 1);
		fechaVencimiento = new Date(Date.parse(aux.toString()));
		diaPago = diasPago[0];
	}
	
	// Control de fechas inexistentes (30 de febrero, 31 de abril, etc)
	var fechaVencimientoBk:String = fechaVencimiento.toString();
	
	var paso:Number = 0;
	fechaVencimiento.setDate(diaPago);
	while (!fechaVencimiento) {
		fechaVencimiento = new Date(Date.parse(fechaVencimientoBk));
		fechaVencimiento.setDate(--diaPago);
		if (paso++ == 10) {
			MessageBox.warning(util.translate("scripts", "Hubo un problema al establecer el d�a de pago"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}	

	return fechaVencimiento.toString();
}

/** \D Modifica la fecha de vencimiento en funci�n del d�a de pago del proveedor, buscando el anterior d�a de pago
@param	fechaV: String con la fecha de vencimiento actual
@param	diasPago: Array con los d�as de pago para cada plazo
@return	Fecha de vencimiento modificada
\end */
function diasPagoProv_procesarDiasPagoProvAnt(fechaV:String, diasPago:Array):String
{
	var util:FLUtil = new FLUtil; 
	var fechaVencimiento:Date = new Date (Date.parse(fechaV.toString()));
	if (diasPago == "" || !diasPago)
		return fechaV;
	var diaFV:Number = parseFloat(fechaVencimiento.getDate());
	var i:Number = 0;
	var distancia:Number;
	for (i = (diasPago.length - 1); i >= 0 && parseFloat(diasPago[i]) > diaFV; i--);
	if (i >= 0 ) {
		fechaVencimiento.setDate(diasPago[i]);
	} else {
		var aux = util.addMonths(fechaVencimiento.toString(), -1);
		fechaVencimiento = new Date(Date.parse(aux.toString()));
		fechaVencimiento.setDate(diasPago[(diasPago.length - 1)]);
	}
	
	return fechaVencimiento.toString();
}
//// DIAS_PAGO_PROV /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
