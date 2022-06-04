
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PRODUCCI�N SOF�S ///////////////////////////////////////////
class sofa extends prod {
	var tbnSiguienteOpcionCorte:Object;
    function sofa( context ) { prod ( context ); }
	function init() {
		return this.ctx.sofa_init();
	}
	function mostrarSiguienteOpcionCorte() {
		return this.ctx.sofa_mostrarSiguienteOpcionCorte();
	}
}
//// PRODUCCI�N SOF�S ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PRODUCCI�N SOF�S ///////////////////////////////////////////
/** \C En la creaci�n de componentes sobre art�culos de la familia corte, se indicar� autom�ticamente que la familia del componente es TELA y que la tarea de consumo es CORTE
\end */
function sofa_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.__init();

	var referencia:String = "";
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			if (util.sqlSelect("articulos", "codfamilia", "referencia = '" + formRecordarticulos.iface.referenciaComp_ + "'") == "CORT") {
				var idTipoTareaCorte:String = util.sqlSelect("pr_tipostareapro", "idtipotareapro", "idtipoproceso = 'CORTE'");
				if (idTipoTareaCorte)
					this.child("fdbIdTipoTareaPro").setValue(idTipoTareaCorte);
				this.child("fdbCodFamiliaComponente").setValue("TELA");
			}
			break;
		}
		case cursor.Edit : {
			break;
		}
	}

	this.iface.tbnSiguienteOpcionCorte = this.child("tbnSiguienteOpcionCorte");

	connect(this.iface.tbnSiguienteOpcionCorte, "clicked()", this, "iface.mostrarSiguienteOpcionCorte()");
}

function sofa_mostrarSiguienteOpcionCorte()
{
	var util:FLUtil;

	var idOpcionArticulo:Number = this.cursor().valueBuffer("idopcionarticulo");
	if(!idOpcionArticulo)
		return;
	var idOpcion:Number = util.sqlSelect("opcionesarticulocomp","idopcion","idopcionarticulo = " + idOpcionArticulo);
	if(!idOpcion)
		return;

	var parteCorte:String = "";
	var parteActual:String = this.child("fdbDescComponente").value();
	if(!parteActual || parteActual == "")
		parteCorte = util.sqlSelect("cortesopcion","parte","idopcion = " + idOpcion + " AND idcorteopcion > 0 ORDER BY idcorteopcion");
	else {
		var idCorteActual:Number = util.sqlSelect("cortesopcion","idcorteopcion","idopcion = " + idOpcion + " AND parte = '" + parteActual + "'");
		parteCorte = util.sqlSelect("cortesopcion","parte","idopcion = " + idOpcion + " AND idcorteopcion > " + idCorteActual + " ORDER BY idcorteopcion");
	}

	this.child("fdbDescComponente").setValue(parteCorte);
}
//// PRODUCCI�N SOF�S ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
