
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial {
    function dtoEspecial( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
	function totalesAlbaran():Boolean {
		return this.ctx.dtoEspecial_totalesAlbaran();
	}
	function datosAlbaran(curPedido:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean {
		return this.ctx.dtoEspecial_datosAlbaran(curPedido,where,datosAgrupacion);
	}
	function buscarPorDtoEsp(where:String):Number {
		return this.ctx.dtoEspecial_buscarPorDtoEsp(where);
	}
	function damePorDtoCabecera(cursor) {
		return this.ctx.dtoEspecial_damePorDtoCabecera(cursor);
	}
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
function dtoEspecial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util = new FLUtil();
	var valor;

	switch (fN) {
/// Se usa la funci�n damePorDtoCabecera
// 		case "totaliva":{
// 			var porDto:Number = cursor.valueBuffer("pordtoesp");
// 			if (!porDto || porDto == 0) {
// 				valor = this.iface.__commonCalculateField(fN, cursor);
// 				break;
// 			}
// 			var codCli:String = cursor.valueBuffer("codcliente");
// 			var regIva:String = util.sqlSelect("clientes", "regimeniva", "codcliente = '" + codCli + "'");
// 			if (regIva == "U.E." || regIva == "Exento") {
// 				valor = 0;
// 				break;
// 			}
// 			valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
// 			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totaliva"));
// 			break;
// 		}
// 	/** \C
// 	El --totarecargo-- es la suma del recargo correspondiente a las l�neas de factura
// 	\end */
// 		case "totalrecargo":{
// 			var porDto:Number = cursor.valueBuffer("pordtoesp");
// 			if (!porDto || porDto == 0) {
// 				valor = this.iface.__commonCalculateField(fN, cursor);
// 				break;
// 			}
// 			valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
// 			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalrecargo"));
// 			break;
// 		}
	/** \C
	El --netosindtoesp-- es la suma del pvp total de las l�neas de factura
	\end */
		case "netosindtoesp":{
			valor = this.iface.__commonCalculateField("neto", cursor);
			break;
		}
	/** \C
	El --neto-- es el --netosindtoesp-- menos el --dtoesp--
	\end */
		case "neto": {
			valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "dtoesp"));
			break;
		}
	/** \C
	El --pordtoesp-- es el --dtoesp-- entre el --netosindtoesp-- por 100
	\end */
		case "pordtoesp": {
			if (parseFloat(cursor.valueBuffer("netosindtoesp")) != 0) {
				valor = (parseFloat(cursor.valueBuffer("dtoesp")) / parseFloat(cursor.valueBuffer("netosindtoesp"))) * 100;
			} else {
				valor = cursor.valueBuffer("pordtoesp");
			}
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "pordtoesp"));
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

/** \D Informa los datos de un albar�n a partir de los de uno o varios pedidos
@param	curPedido: Cursor que contiene los datos a incluir en el albar�n
@return	True si el c�lculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_datosAlbaran(curPedido:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var porDtoEsp:Number = this.iface.buscarPorDtoEsp(where);
	if (porDtoEsp == -1) {
		MessageBox.critical(util.translate("scripts", "No es posible generar un �nico albar�n para pedidos con distinto porcentaje de descuento especial"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var fecha:String;
	if (curPedido.action() == "pedidoscli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPedido.valueBuffer("fecha");
			
	with (this.iface.curAlbaran) {
		setValueBuffer("pordtoesp", porDtoEsp);
	}
	
	if(!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
		return false;
	
	return true;
}

/** \D Informa los datos de un albar�n referentes a totales (I.V.A., neto, etc.)
@return	True si el c�lculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_totalesAlbaran():Boolean
{
	with (this.iface.curAlbaran) {
		setValueBuffer("netosindtoesp", formalbaranescli.iface.pub_commonCalculateField("netosindtoesp", this));
		setValueBuffer("dtoesp", formalbaranescli.iface.pub_commonCalculateField("dtoesp", this));
		setValueBuffer("neto", formalbaranescli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formalbaranescli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formalbaranescli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formalbaranescli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formalbaranescli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formalbaranescli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}

/** \D
Busca el porcentaje de descuento especial realizado a los pedidos que se agrupar�n en un albar�n. Si existen dos pedidos con distinto porcentaje devuelve un c�digo de error.
@param where: Cl�usula where para buscar los pedidos
@return porcenteje de descuento (-1 si hay error);
\end */
function dtoEspecial_buscarPorDtoEsp(where:String):Number
{
	var util:FLUtil = new FLUtil;
	var porDtoEsp:Number = util.sqlSelect("pedidoscli", "pordtoesp", where);
	var porDtoEsp2:Number = util.sqlSelect("pedidoscli", "pordtoesp", where + " AND pordtoesp <> " + porDtoEsp);
	if (!porDtoEsp2 && isNaN(parseFloat(porDtoEsp2)))
		return porDtoEsp;
	else
		return -1;
}

function dtoEspecial_damePorDtoCabecera(cursor)
{
	var dto = cursor.valueBuffer("pordtoesp");
	dto = isNaN(dto) ? 0 : dto;
	return dto;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////