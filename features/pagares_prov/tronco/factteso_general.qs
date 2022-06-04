
/** @class_declaration pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
class pagareProv extends oficial {
	function pagareProv( context ) { oficial ( context ); }
	function init() {
		this.ctx.pagareProv_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.pagareProv_bufferChanged(fN);
	}
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
function pagareProv_init()
{
	this.iface.__init();
	this.iface.bufferChanged("contdirectapagare");
}

function pagareProv_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "contdirectapagare": {
			var msg:String;
			if (cursor.valueBuffer("contdirectapagare") == true) {
				msg = util.translate("scripts", "Al incluir un recibo de proveedor en un pagar� no se genera el correspondiente asiento de pago. Se genera un �nico asiento al insertar un registro de pago para el pagar� completo, que se asigna directamente a la subcuenta de la cuenta bancaria indicada en el pagar�.");
			} else {
				msg = util.translate("scripts", "Al incluir un recibo de proveedor en un pagar�, el correspondiente asiento de pago del recibo se asigna a la subcuenta de Efectos comerciales de gesti�n de pago (E.C.G.P.) asociada a la cuenta bancaria del pagar�. Cuando se recibe la confirmaci�n del banco el usuario inserta un registro de pago para el pagar� completo, que lleva las partidas de E.C.G.P. a la subcuenta de la cuenta bancaria.");
			}
			this.child("lblDesContDirectaPagare").text = msg;
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
			break;
		}
	}
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
