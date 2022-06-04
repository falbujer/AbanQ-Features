
/** @class_declaration visual */
/////////////////////////////////////////////////////////////////
//// PRODUCCION VISUAL //////////////////////////////////////////
class visual extends prod {
    function visual( context ) { prod ( context ); }
	function init() {
		return this.ctx.visual_init();
	}
	function accionesAutomaticas() {
		return this.ctx.visual_accionesAutomaticas();
	}
	function realizarAccionAutomatica(accion:Array):Boolean {
		return this.ctx.visual_realizarAccionAutomatica(accion);
	}
}
//// PRODUCCION VISUAL //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition visual */
/////////////////////////////////////////////////////////////////
//// PRODUCCI�N VISUAL //////////////////////////////////////////
function visual_init()
{
	this.iface.__init();
	connect(this, "formReady()", this, "iface.accionesAutomaticas");
}

function visual_accionesAutomaticas()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var acciones:Array = flcolaproc.iface.pub_accionesAuto();
	if (!acciones) {
		return;
	}
	var i:Number = 0;
	while (i < acciones.length && acciones[i]["usada"]) { i++; }
	if (i == acciones.length) {
		return;
	}

	while (i < acciones.length && acciones[i]["contexto"] == "pedidosprov") {
		if (!this.iface.realizarAccionAutomatica(acciones[i])) {
			break;
		}
		i++;
	}
}

/** \D Realizar una determinada acci�n.
@return: Se devuelve false si algo falla o si la acci�n implica que no debe realizarse ninguna acci�n subsiguiente en el contexto actual.
\end */ 
function visual_realizarAccionAutomatica(accion:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	switch (accion["accion"]) {
		case "editar_linea": {
			accion["usada"] = true;
			var curLineas:FLSqlCursor = this.child("tdbArticulosPedProv").cursor();
			curLineas.select("idlinea = " + accion["idlinea"]);
			curLineas.first();
			curLineas.editRecord();
			break;
		}
		default: {
			return false;
		}
	}
	return true;
}
//// PRODUCCI�N VISUAL //////////////////////////////////////////
////////////////////////////////////////////////////////////////

