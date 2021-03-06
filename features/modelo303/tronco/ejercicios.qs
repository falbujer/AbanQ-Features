
/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends oficial {
    function modelo303( context ) { oficial ( context ); }
    function datosSubcuenta(curSubcuentaAnt:FLSqlCursor):Boolean {
		return this.ctx.modelo303_datosSubcuenta(curSubcuentaAnt);
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_datosSubcuenta(curSubcuentaAnt:FLSqlCursor):Boolean
{
	if (!this.iface.__datosSubcuenta(curSubcuentaAnt)) {
		return false;
	}
	this.iface.curSubcuenta_.setValueBuffer("casilla303", curSubcuentaAnt.valueBuffer("casilla303"));
	
	return true;
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
