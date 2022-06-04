
/** @class_declaration exTienda */
/////////////////////////////////////////////////////////////////
//// EXTENSION TIENDA //////////////////////////////////////
class exTienda extends ivaIncluido {
	function exTienda( context ) { ivaIncluido ( context ); }
	function afterCommit_lineasalbaranescli(curLA) {
		return this.ctx.exTienda_afterCommit_lineasalbaranescli(curLA);
	}
	function afterCommit_lineasfacturascli(curLF) {
		return this.ctx.exTienda_afterCommit_lineasfacturascli(curLF);
	}
	function afterCommit_albaranescli(curA) {
		return this.ctx.exTienda_afterCommit_albaranescli(curA);
	}
	function afterCommit_facturascli(curF) {
		return this.ctx.exTienda_afterCommit_facturascli(curF);
	}
	
	function beforeCommit_lineasalbaranescli(curLA) {
		return this.ctx.exTienda_beforeCommit_lineasalbaranescli(curLA);
	}
	function beforeCommit_lineasfacturascli(curLF) {
		return this.ctx.exTienda_beforeCommit_lineasfacturascli(curLF);
	}
	function beforeCommit_albaranescli(curA) {
		return this.ctx.exTienda_beforeCommit_albaranescli(curA);
	}
	function beforeCommit_facturascli(curF) {
		return this.ctx.exTienda_beforeCommit_facturascli(curF);
	}
}
//// EXTENSION TIENDA //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exTienda */
/////////////////////////////////////////////////////////////////
//// EXTENSION TIENDA //////////////////////////////////////
function exTienda_afterCommit_lineasalbaranescli(curLA)
{
	var _i = this.iface;
	
	if(!_i.__afterCommit_lineasalbaranescli(curLA))
		return false;
	
	return flfactalma.iface.registrarDel(curLA);
}

function exTienda_afterCommit_lineasfacturascli(curLF)
{
	var _i = this.iface;
	
	if(!_i.__afterCommit_lineasfacturascli(curLF))
		return false;
	
	return flfactalma.iface.registrarDel(curLF);
}

function exTienda_afterCommit_albaranescli(curA)
{
	var _i = this.iface;
	
	if(!_i.__afterCommit_albaranescli(curA))
		return false;
	
	return flfactalma.iface.registrarDel(curA);
}

function exTienda_afterCommit_facturascli(curF)
{
	var _i = this.iface;
	
	if(!_i.__afterCommit_facturascli(curF))
		return false;
	
	return flfactalma.iface.registrarDel(curF);
}

function exTienda_beforeCommit_lineasalbaranescli(curLA)
{
	var _i = this.iface;
	
	if(!_i.__beforeCommit_lineasalbaranescli(curLA))
		return false;
	
	return this.iface.setModificado(curLA);
}

function exTienda_beforeCommit_lineasfacturascli(curLF)
{
	var _i = this.iface;
	
	if(!_i.__beforeCommit_lineasfacturascli(curLF))
		return false;
	
	return this.iface.setModificado(curLF);
}

function exTienda_beforeCommit_albaranescli(curA)
{
	var _i = this.iface;
	
	if(!_i.__beforeCommit_albaranescli(curA))
		return false;
	
	return this.iface.setModificado(curA);
}

function exTienda_beforeCommit_facturascli(curF)
{
	var _i = this.iface;
	
	if(!_i.__beforeCommit_facturascli(curF))
		return false;
	
	return this.iface.setModificado(curF);
}
//// EXTENSION TIENDA //////////////////////////////////////
/////////////////////////////////////////////////////////////////
