
/** @class_declaration funServiciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS CLI //////////////////////////////////////////////
class funServiciosCli extends oficial {
	function funServiciosCli( context ) { oficial ( context ); }
	function afterCommit_albaranescli(curAlbaran) {
		return this.ctx.funServiciosCli_afterCommit_albaranescli(curAlbaran);
	}
	function afterCommit_servicioscli(curS) {
		return this.ctx.funServiciosCli_afterCommit_servicioscli(curS);
	}
	function controlPedidoServCli(curS) {
		return this.ctx.funServiciosCli_controlPedidoServCli(curS);
	}
}
//// SERVICIOS CLI //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS CLI //////////////////////////////////////////////
/** \C Si el albar�n se borra se actualizan los pedidos asociados
\end */
function funServiciosCli_afterCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__afterCommit_albaranescli(curAlbaran)) {
		return false;
	}
	switch (curAlbaran.modeAccess()) {
		case curAlbaran.Del: {
			var idAlbaran:Number = curAlbaran.valueBuffer("idalbaran");
			if (idAlbaran) {
				var curServicio:FLSqlCursor = new FLSqlCursor("servicioscli");
				curServicio.select("idalbaran = " + idAlbaran);
				if (curServicio.first()) {
					curServicio.setUnLock("editable", true);
					curServicio.select("idalbaran = " + idAlbaran);
					curServicio.first();
					curServicio.setModeAccess(curServicio.Edit);
					curServicio.refreshBuffer();
					curServicio.setValueBuffer("idalbaran", "");
					curServicio.commitBuffer();
				}
			}
			break;
		}
	}
	return true;
}

/** \C Si el albar�n se borra se actualizan los pedidos asociados
\end */
function funServiciosCli_afterCommit_servicioscli(curS)
{
	var _i = this.iface;
	if (!_i.controlPedidoServCli(curS)) {
		return false;
	}
	return true;
}

function funServiciosCli_controlPedidoServCli(curS)
{
	switch (curS.modeAccess()) {
		case curS.Del: {
			var idPedido = curS.valueBuffer("idpedido");
			if (idPedido) {
				var curPedido = new FLSqlCursor("pedidoscli");
				curPedido.select("idpedido = " + idPedido);
				if (curPedido.first()) {
					curPedido.setUnLock("editable", true);
				}
			}
			break;
		}
	}
	return true;
}
//// SERVICIOS CLI //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
