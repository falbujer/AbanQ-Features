
/** @class_declaration promocionesTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
class promocionesTpv extends oficial {
	function promocionesTpv( context ) { 
		oficial( context ); 
	}
	function init() {
    return this.ctx.promocionesTpv_init();
  }
	function bufferChanged(fN) {
		return this.ctx.promocionesTpv_bufferChanged(fN);
	}
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition promocionesTpv */
//////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV /////////////////////////////////////////////

function promocionesTpv_init()
{
	var _i = this.iface;
  var cursor = this.cursor();
	
	_i.__init();
	_i.bufferChanged("promosobreprecio");
}

function promocionesTpv_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
	switch (fN) {
		case "promosobreprecio":{
			var msg;
			if (cursor.valueBuffer("promosobreprecio") == false || cursor.isNull("promosobreprecio")) {
				msg = sys.translate("El descuento de la promoci�n correspondiente se aplica sobre el total de la l�nea.");
			} else {
				msg = sys.translate("El descuento de la promoci�n correspondiente se aplica sobre el precio unitario del art�culo.");
			}
			this.child("lblPromoSobrePrecio").text = msg;
			break;
		}
		default:{
			_i.__bufferChanged(fN);
		}
	}
}
//// PROMOCIONES TPV /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
