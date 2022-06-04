
/** @class_declaration funNumAcomp */
//////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////////

class funNumAcomp extends funNumSerie {
	function funNumAcomp( context ) { funNumSerie( context ); } 	
	function init() { return this.ctx.funNumAcomp_init(); }
	function validateForm():Boolean { return this.ctx.funNumAcomp_validateForm(); }
	function bufferChanged(fN:String) { return this.ctx.funNumAcomp_bufferChanged(fN); }
	function regenerarNumSerieComp() { return this.ctx.funNumAcomp_regenerarNumSerieComp(); }
	function controlNumSerieComp(regenerar:Boolean) { return this.ctx.funNumAcomp_controlNumSerieComp(regenerar); }
	function borrarNumSerieComp() { return this.ctx.funNumAcomp_borrarNumSerieComp(); }
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumAcomp */
/////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////

function funNumAcomp_init()
{
	this.iface.__init();
	this.iface.controlNumSerieComp();
}

/**
Se comprueba que el n�mero de serie no existe en una l�nea de ns
*/
function funNumAcomp_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	if (util.sqlSelect("lineasalbaranesclins", "idlinea", 
			"numserie = '" + this.cursor().valueBuffer("numserie") + "'"))
	{
		MessageBox.warning(util.translate("scripts", "Este n�mero de serie corresponde a un art�culo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}	
	
	return this.iface.__validateForm();
}

/**
Cuando la referencia es un art�culo compuesto, se regeneran las l�neas de 
n�meros de serie si alguno de los componentes se controla por ns
*/
function funNumAcomp_regenerarNumSerieComp()
{
	var util:FLUtil = new FLUtil();
	var referencia:String = this.cursor().valueBuffer("referencia");
	
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("articuloscomp,articulos");
	qry.setSelect("ac.refcomponente,ac.cantidad,a.controlnumserie");
	qry.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia");
	qry.setWhere("refcompuesto = '" + referencia + "'");
	
	if(!qry.exec())
		return;
		
	if(!qry.size())
		return;
		
	this.iface.borrarNumSerieComp();
		
	var curTab:FLSqlCursor = this.child("tdbLineasAlbaranesCliNS").cursor();
	var refComp:String = "";
	var cantidad:Number = 0;
	
	while (qry.next()) {
		
		if (!qry.value(2))
			continue;
		
		refComp = qry.value(0);
		cantidad = parseFloat(qry.value(1));
		
		for (i = 0; i < cantidad; i++) {
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("referencia", refComp);
			curTab.commitBuffer();
		}
	}
	
}

function funNumAcomp_bufferChanged(fN:String)
{
	this.iface.__bufferChanged(fN);

	switch (fN) {
		/** Si el art�culo tiene componentes se habilita el cuadro de n�meros de serie
		*/
		case "referencia":
			this.iface.controlNumSerieComp(true);
		break;
	}
}

/** Si el art�culo tiene componentes se habilita el cuadro de n�meros de serie
*/
function funNumAcomp_controlNumSerieComp(regenerar:Boolean)
{
	var util:FLUtil = new FLUtil();
	if (util.sqlSelect("articuloscomp", "refcompuesto", "refcompuesto = '" + this.cursor().valueBuffer("referencia") + "'")) {
		
		if (regenerar)
			this.iface.regenerarNumSerieComp();
		
		this.child("gbxNumSerieComp").setDisabled(false);
		
		// Si hay componentes con NS hay que forzar a 1 la cantidad
		var curTab:FLSqlCursor = this.child("tdbLineasAlbaranesCliNS").cursor();
		curTab.select();
		if (curTab.first()) {
			this.cursor().setValueBuffer("cantidad", 1);
			this.child("fdbCantidad").setDisabled(true);
		}
	}
	else {
		this.iface.borrarNumSerieComp();
		this.child("gbxNumSerieComp").setDisabled(true);
		this.iface.controlCantidad(true);
	}
}

/** Borra los registros de n�meros de serie de componentes
*/
function funNumAcomp_borrarNumSerieComp()
{
	var curTab:FLSqlCursor = this.child("tdbLineasAlbaranesCliNS").cursor();
	curTab.select();
	while(curTab.next()) {
		curTab.setModeAccess(curTab.Del)
		curTab.refreshBuffer();
		curTab.commitBuffer();
	}
	curTab.select();
	while(curTab.next()) {
		curTab.setModeAccess(curTab.Del)
		curTab.refreshBuffer();
		curTab.commitBuffer();
	}
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

