
/** @class_declaration intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT //////////////////////////////////////////////////
class intrastat extends oficial {
    function intrastat( context ) { oficial ( context ); }
	function init() { 
		return this.ctx.intrastat_init(); 
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.intrastat_commonCalculateField(fN, cursor);
	}
}
//// INTRASTAT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT //////////////////////////////////////////////////
function intrastat_init()
{
	this.iface.__init();
   	var cursor:FLSqlCursor = this.cursor();

	try {
		// Permisos concretos para campos
		// rw lectura/escritura
		var campos:Array = new Array("codiso", "rw", "codprovincia", "rw", "codcondicionentrega", "rw", "codnaturaleza", "rw", "codmodotransporte", "rw", "codpuerto", "rw", "codmercancia", "rw", "codpaisorigen", "rw", "codregimen", "rw", "masaneta", "rw", "udssuplementarias", "rw", "nointrastat", "rw" );
		cursor.setAcTable( "r-" ); // Permiso global s�lo lectura
		cursor.setAcosTable( campos ); // Lista permisos de campos
		
		// La condicion para aplicar la regla es que el campo ptefactura tenga el 
		// valor false
		cursor.setAcosCondition( "ptefactura", cursor.Value, false );
	} catch (e) {}
}	

function intrastat_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var valor:String;
	switch (fN) {
		case "nointrastat": {
			var codPaisEmpresa:String = flfactppal.iface.pub_valorDefectoEmpresa("codpais");
			if (!codPaisEmpresa) {
				return false;
			}
			if (cursor.valueBuffer("codpais") == codPaisEmpresa) {
				valor = true;
			} else {
				valor = false;
			}
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
		}
	}
	return valor;
}

//// INTRASTAT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
