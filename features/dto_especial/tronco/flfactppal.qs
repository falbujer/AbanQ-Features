
/** @class_declaration dtoEsp */
/////////////////////////////////////////////////////////////////
//// DESCUENTO ESPECIAL /////////////////////////////////////////
class dtoEsp extends oficial {
	function dtoEsp( context ) { oficial ( context ); }
// 	function calcularLiquidacionAgente(where:String):Number {
// 		return this.ctx.dtoEsp_calcularLiquidacionAgente(where);
// 	}
	function extension(nE) {
		return this.ctx.dtoEsp_extension(nE);
	}
}
//// DESCUENTO ESPECIAL /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEsp */
/////////////////////////////////////////////////////////////////
//// DESCUENTO ESPECIAL /////////////////////////////////////////

// function dtoEsp_calcularLiquidacionAgente(where:String):Number {
// 	var util:FLUtil = new FLUtil();
// 	
// 	var qryFacturas:FLSqlQuery = new FLSqlQuery();
// 	qryFacturas.setTablesList("facturascli,lineasfacturascli");
// 	qryFacturas.setSelect("coddivisa, tasaconv, facturascli.porcomision, lineasfacturascli.porcomision, neto, facturascli.idfactura, lineasfacturascli.pvptotal, facturascli.pordtoesp");
// 	qryFacturas.setFrom("facturascli INNER JOIN lineasfacturascli ON facturascli.idfactura = lineasfacturascli.idfactura");
// 	qryFacturas.setWhere(where);
// 	if (!qryFacturas.exec()) {
// 		return false;
// 	}
// 	var total:Number = 0;
// 	var comision:Number = 0;
// 	var descuento:Number = 0;
// 	var tasaconv:Number = 0;
// 	var divisaEmpresa:String = util.sqlSelect("empresa","coddivisa","1=1");
// 	var idfactura:Number = 0;
// 	var comisionFactura:Boolean = false;
// 	while (qryFacturas.next()) {
// 		if (!idfactura || idfactura != qryFacturas.value("facturascli.idfactura")) {
// 			idfactura = qryFacturas.value("facturascli.idfactura");
// 			if (parseFloat(qryFacturas.value("facturascli.porcomision"))) {
// 				comisionFactura = true;
// 				comision = parseFloat(qryFacturas.value("facturascli.porcomision")) * parseFloat(qryFacturas.value("neto")) / 100;
// 				tasaconv = parseFloat(qryFacturas.value("tasaconv"));
// 				if (qryFacturas.value("coddivisa") == divisaEmpresa) {
// 					total += comision;
// 				} else {
// 					total += comision * tasaconv;
// 				}
// 			} else {
// 				comisionFactura = false;
// 			}
// 		}
// 		if (!comisionFactura) {
// 			descuento = parseFloat(qryFacturas.value("facturascli.pordtoesp"));
// 			descuento = (isNaN(descuento) ? 0 : descuento);
// 			comision = parseFloat(qryFacturas.value("lineasfacturascli.porcomision")) * (parseFloat(qryFacturas.value("lineasfacturascli.pvptotal") * (100 - descuento) / 100)) / 100;
// 			tasaconv = parseFloat(qryFacturas.value("tasaconv"));
// 			if (qryFacturas.value("coddivisa") == divisaEmpresa) {
// 				total += comision;
// 			} else {
// 				total += comision * tasaconv ;
// 			}
// 		}
// 	}
// 	return total;
// }

function dtoEsp_extension(nE)
{
	var _i = this.iface;
	if (nE == "dto_especial") {
		return true;
	}
	return _i.__extension(nE);
}
//// DESCUENTO ESPECIAL /////////////////////////////////////////
/////////////////////////////////////////////////////////////////
