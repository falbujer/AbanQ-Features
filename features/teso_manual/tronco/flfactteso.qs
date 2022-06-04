
/** @class_declaration tesoMan */
/////////////////////////////////////////////////////////////////
//// TESORERIA MANUAL ///////////////////////////////////////////
class tesoMan extends oficial {
    function tesoMan( context ) { oficial ( context ); }
	function beforeCommit_tesomanual(curTM:FLSqlCursor):Boolean {
		return this.ctx.tesoMan_beforeCommit_tesomanual(curTM);
	}
	function afterCommit_pagostesomanual(curPTM:FLSqlCursor):Boolean {
		return this.ctx.tesoMan_afterCommit_pagostesomanual(curPTM);
	}
	function cambiaUltimoPagoManual(idRecibo:String, idPagoDevol:String, unlock:Boolean):Boolean {
		return this.ctx.tesoMan_cambiaUltimoPagoManual(idRecibo, idPagoDevol, unlock);
	}
}
//// TESORERIA MANUAL ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tesoMan */
/////////////////////////////////////////////////////////////////
//// TESORERIA MANUAL ///////////////////////////////////////////
function tesoMan_beforeCommit_tesomanual(curTM:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curTM.modeAccess()) {
		case curTM.Insert: {
			if (curTM.valueBuffer("numero") == 0) {
				numero = util.sqlSelect("tesomanual", "numero", "codejercicio = '" + curTM.valueBuffer("codejercicio") + "' AND codserie = '" + curTM.valueBuffer("codserie") + "' ORDER BY numero DESC");
				if (!numero)
					numero = 0;
				numero++;
				curTM.setValueBuffer("numero", numero);
				
				curTM.setValueBuffer("codigo", flfacturac.iface.pub_construirCodigo(curTM.valueBuffer("codserie"), curTM.valueBuffer("codejercicio"), curTM.valueBuffer("numero")));
			}
			break;
		}
	}
	return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devolución
\end */
function tesoMan_afterCommit_pagostesomanual(curPTM:FLSqlCursor):Boolean
{
	var idRecibo:String = curPTM.valueBuffer("idrecibo");
	/** \C Se cambia el pago anterior al actual para que sólo el último sea editable
	\end */
	switch (curPTM.modeAccess()) {
		case curPTM.Insert:
		case curPTM.Edit: {
			if (!this.iface.cambiaUltimoPagoManual(idRecibo, curPTM.valueBuffer("idpagodevol"), false))
				return false;
			break;
		}
		case curPTM.Del: {
			if (!this.iface.cambiaUltimoPagoManual(idRecibo, curPTM.valueBuffer("idpagodevol"), true))
				return false;
			break;
		}
	}
	
	return true;
}
/** \D Cambia la el estado del último pago anterior al especificado, de forma que se mantenga como único pago editable el último de todos
@param	idRecibo: Identificador del recibo al que pertenecen los pagos tratados
@param	idPagoDevol: Identificador del pago que ha cambiado
@param	unlock: Indicador de si el últim pago debe ser editable o no
@return	true si la verificación del estado es correcta, false en caso contrario
\end */
function tesoMan_cambiaUltimoPagoManual(idRecibo:String, idPagoDevol:String, unlock:Boolean):Boolean
{
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagostesomanual");
	curPagosDevol.select("idrecibo = " + idRecibo + " AND idpagodevol <> " + idPagoDevol + " ORDER BY fecha, idpagodevol");
	if (curPagosDevol.last())
		curPagosDevol.setUnLock("editable", unlock);
		
	return true;
}

//// TESORERIA MANUAL ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
