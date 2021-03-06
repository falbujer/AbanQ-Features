
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
class extraescolar extends ivaIncluido {
	function extraescolar( context ) { ivaIncluido ( context ); }
	function bufferChanged(fN) {
		return this.ctx.extraescolar_bufferChanged(fN);
	}
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
function extraescolar_bufferChanged(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	switch (fN) {
		case "codcliente": {
			this.child("fdbCodCentroEsc").setValue(_i.calculateField("codcentroesc"));
			_i.__bufferChanged(fN);
			break;
		}
		default: {
			_i.__bufferChanged(fN);
		}
	}
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
