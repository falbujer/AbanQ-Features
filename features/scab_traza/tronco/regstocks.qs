
/** @class_declaration scabTraza */
/////////////////////////////////////////////////////////////////
//// SCAB_TRAZA /////////////////////////////////////////////////////
class scabTraza extends scab {
	function scabTraza( context ) { scab( context ); }
	function commonCalculateField(fN, cursor, oParam) {
		return this.ctx.scabTraza_commonCalculateField(fN, cursor, oParam);
	}
}
//// SCAB_TRAZA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scabTraza */
/////////////////////////////////////////////////////////////////
//// SCAB_TRAZA /////////////////////////////////////////////////
function scabTraza_commonCalculateField(fN, cursor, oParam)
{
// debug("Calculando en scab_traza " + fN);
	var _i = this.iface;
	var util:FLUtil = new FLUtil;
	var valor:String;
	var referencia:String = cursor.valueBuffer("referencia");
	var codAlmacen:String = cursor.valueBuffer("codalmacen");
	
	var almacenTrazable:Boolean = util.sqlSelect("almacenes", "trazabilidad", "codalmacen = '" + codAlmacen + "'");
	var articuloTrazable:Boolean = util.sqlSelect("articulos", "porlotes", "referencia = '" + referencia + "'");
	var porLotes:Boolean = almacenTrazable && articuloTrazable;
	
	switch (fN) {
		case "cantidadac": 
		case "cantidadap":
		case "cantidadfc":
		case "cantidadfp":
		case "cantidadtpv":
		case "cantidadts": {
			if (porLotes) {
				valor = 0;
			} else {
				valor = _i.__commonCalculateField(fN, cursor, oParam);
			}
			break;
		}
		case "cantidad": {
			if (porLotes) {
				var idStock:Number = cursor.valueBuffer("idstock");
				valor = util.sqlSelect("movilote INNER JOIN lotes ON movilote.codlote = lotes.codlote", "SUM(movilote.cantidad)", "movilote.idstock = " + idStock, "movilote,lotes");
				if (!valor) {
					valor = 0;
				}
			} else {
				valor = _i.__commonCalculateField(fN, cursor, oParam);
			}
			break;
		}
		default: {
			valor = _i.__commonCalculateField(fN, cursor, oParam);
		}
	}
	return valor;
}
//// SCAB_TRAZA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
