
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOSTPV ///////////////////////////////////////////////////
class puntosTpv extends oficial {
	function puntosTpv( context ) { oficial( context ); }
	
	function gestionPuntos() {
		return this.ctx.puntosTpv_gestionPuntos();
	}
	function afterCommit_tpv_comandas(curComanda){
		return this.ctx.puntosTpv_afterCommit_tpv_comandas(curComanda);
	}
}
//// PUNTOSTPV ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////


function puntosTpv_gestionPuntos(curComanda)
{
	/*var _i = this.iface;

	var valorPunto =  AQUtil.sqlSelect("clientes", "valorpunto", "codcliente = '" + curComanda.valueBuffer("codcliente") + "'");
	var canPuntos = valorPunto * curComanda.valueBuffer("total");
	debug (canPuntos);
	var curMovPuntos = new FLSqlCursor("tpv_movpuntos");
  curMovPuntos.setModeAccess(curMovPuntos.Insert);
  curMovPuntos.refreshBuffer();
  curMovPuntos.setValueBuffer("codcliente", curComanda.valueBuffer("codcliente"));
  curMovPuntos.setValueBuffer("idtpv_comanda", curComanda.valueBuffer("idtpv_comanda"));
  //curMovPuntos.setValueBuffer("idpago", );
  curMovPuntos.setValueBuffer("fecha",  curComanda.valueBuffer("fecha"));
  curMovPuntos.setValueBuffer("canpuntos", canPuntos);
	
  if (!curMovPuntos.commitBuffer()){
    return false;
	}
	
	var curCliente = new FLSqlCursor("clientes");
	curCliente.select("codcliente = '" + curComanda.valueBuffer("codcliente") + "'");
	curCliente.first();
	curCliente.setModeAccess(curCliente.Edit);
	curCliente.refreshBuffer();
	curCliente.setValueBuffer("saldoactual", (curCliente.valueBuffer("saldoactual") + canPuntos ));
	
	if (!curCliente.commitBuffer()){
    return false;
	}*/
	
	debug("gestionPuntos bien");
	return true;
}

function puntosTpv_afterCommit_tpv_comandas(curComanda){
  var _i = this.iface;
	MessageBox.warning(AQUtil.translate("After commit"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "Abanq");
	debug("after commit bien");
  if (!_i.gestionPuntos(curComanda)) {
    return false;
  }
  return true;
}

//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
