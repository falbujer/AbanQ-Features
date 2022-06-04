
/** @class_declaration numLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS DE L�NEA ///////////////////////////////////////////
class numLinea extends oficial {
	var numLinea_:Number;
    function numLinea( context ) { oficial ( context ); }
	function generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.ctx.numLinea_generarFactura(where, curAlbaran, datosAgrupacion);
	}
// 	function copiaLineasAlbaran(idAlbaran:Number, idFactura:Number):Boolean {
// 		return this.ctx.numLinea_copiaLineasAlbaran(idAlbaran, idFactura);
// 	}
	function dameSelectLineasAlbaran(idAlbaran, idFactura) {
		return this.ctx.numLinea_dameSelectLineasAlbaran(idAlbaran, idFactura);
	}
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.numLinea_datosLineaFactura(curLineaAlbaran);
	}
}
//// NUMEROS DE L�NEA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numLinea */
/////////////////////////////////////////////////////////////////
//// N�MEROS DE L�NEA ///////////////////////////////////////////
function numLinea_generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion:Array):Number
{
	this.iface.numLinea_ = 0;

	var idFactura:String = this.iface.__generarFactura(where, curAlbaran, datosAgrupacion);
	if (!idFactura) {
		return false;
	}

	return idFactura;
}

// function numLinea_copiaLineasAlbaran(idAlbaran:Number, idFactura:Number):Boolean
// {
// 	var curLineaAlbaran:FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
// 	curLineaAlbaran.select("idalbaran = " + idAlbaran + " ORDER BY numlinea");
// 	
// 	while (curLineaAlbaran.next()) {
// 		curLineaAlbaran.setModeAccess(curLineaAlbaran.Browse);
// 		if (!this.iface.copiaLineaAlbaran(curLineaAlbaran, idFactura))
// 			return false;
// 	}
// 	return true;
// }

function numLinea_dameSelectLineasAlbaran(idAlbaran, idFactura)
{
	var s = "idalbaran = " + idAlbaran + " ORDER BY numlinea"; 
	return s;
}


function numLinea_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran)) {
		return false;
	}

	this.iface.numLinea_++;
	this.iface.curLineaFactura.setValueBuffer("numlinea", this.iface.numLinea_);

	return true;
}

//// N�MEROS DE L�NEA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
