
/** @class_declaration modImpresion */
/////////////////////////////////////////////////////////////////
//// MOD_IMPRESION //////////////////////////////////////////////
class modImpresion extends oficial {
    function modImpresion( context ) { oficial ( context ); }
	function lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora, pdf) {
		return this.ctx.modImpresion_lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora, pdf);
	}
	function lanzaInforme(cursor, oParam) {
		return this.ctx.modImpresion_lanzaInforme(cursor, oParam);
	}
}
//// MOD_IMPRESION ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modImpresion */
//////////////////////////////////////////////////////////////////
//// MOD_IMPRESION ///////////////////////////////////////////////

function modImpresion_lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora, datosPdf)
{
	var oParam = this.iface.dameParamInforme();
	oParam.nombreInforme = nombreInforme;
	oParam.orderBy = orderBy;
	oParam.groupBy = groupBy;
	oParam.etiquetas = etiquetas;
	oParam.impDirecta = impDirecta;
	oParam.whereFijo = whereFijo;
	oParam.nombreReport = nombreReport;
	oParam.numCopias = numCopias;
	oParam.datosPdf = datosPdf;
	
	this.iface.lanzaInforme(cursor, oParam);
}

function modImpresion_lanzaInforme(cursor, oParam)
{
	debug("nombreInforme " + oParam.nombreInforme);
	switch(oParam.nombreInforme) {
		case "i_presupuestoscli":
		case "i_pedidoscli":
		case "i_albaranescli":
		case "i_facturascli":
		case "i_reciboscli":
		case "i_pedidosprov":
		case "i_albaranesprov":
		case "i_facturasprov":
		case "i_recibosprov": {
			break;
		}
		default: {
			return this.iface.__lanzaInforme(cursor, oParam);
		}
	}
	
	var util= new FLUtil();
	var report= "";
	var consulta= "";
	var ordenacion= "";
	var arrayModelos= [];
	var nombreReport = oParam.nombreReport;
	
	var nomTabla= cursor.table();
	if (nomTabla.startsWith("i_"))
		nomTabla = nomTabla.right(nomTabla.length - 2);
		
	var q= new FLSqlQuery();
	q.setTablesList("modelosimpresion");
	q.setFrom("modelosimpresion");
	q.setSelect("descripcion, report, consulta, modelodefecto, ordenacion");
 	q.setWhere("tipointerno = '" + nomTabla + "' ORDER BY descripcion");
	if (!q.exec()) {
		return false;
	}
	
	var dialog = new Dialog(util.translate ( "scripts", "Modelos de impresion" ), 0);
	dialog.caption = "Seleccionar un modelo de impresion";
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	
	var bgroup:GroupBox = new GroupBox;
	dialog.add( bgroup );
	var rB= [];
	var nModelos= 0;	
	var hayDefecto= false;
	var hayOficial= false;
	
	while (q.next())  {
		rB[nModelos] = new RadioButton;
		rB[nModelos].text = q.value("descripcion");
		arrayModelos[nModelos] = [];
// debug("Report " + q.value("report") + " Consulta " + q.value("consulta"));
		arrayModelos[nModelos]["report"] = q.value("report");
		arrayModelos[nModelos]["consulta"] = q.value("consulta");
		arrayModelos[nModelos]["ordenacion"] = q.value("ordenacion");
		if (q.value("modelodefecto")) {
			hayDefecto = true;
			rB[nModelos].checked = true;
		} else {
			rB[nModelos].checked = false;
		}
		if (arrayModelos[nModelos]["report"] == nombreReport && arrayModelos[nModelos]["consulta"] == nombreReport && arrayModelos[nModelos]["ordenacion"] == "") {
			hayOficial = true;
		}
		bgroup.add( rB[nModelos] );
		nModelos ++;
	}
	
	if (!hayOficial) {
		rB[nModelos] = new RadioButton;
		rB[nModelos].text = util.translate ( "scripts", "Modelo oficial" );
		arrayModelos[nModelos] = [];
		arrayModelos[nModelos]["report"] = nombreReport;
		arrayModelos[nModelos]["consulta"] = nombreReport;
		arrayModelos[nModelos]["ordenacion"] = "";
		rB[nModelos].checked = !hayDefecto;
		bgroup.add( rB[nModelos] );
	}

	// No hay modelos adicionales	
	if (nModelos == 0) {
		this.iface.__lanzaInforme(cursor, oParam);
		return;
	}
	
	var lista= "";
	if (!dialog.exec()) {
		return;
	}
	for (var i= 0; i <= nModelos; i++) {
		if (rB[i].checked == true) {
			oParam.nombreReport = arrayModelos[i]["report"];
			consulta = arrayModelos[i]["consulta"];
			if (consulta && consulta != "") {
				oParam.nombreInforme = consulta;
			}
			ordenacion = arrayModelos[i]["ordenacion"];
			if (ordenacion && ordenacion != "") {
				oParam.orderBy = ordenacion;
			}
			break;
		}
	}
	
	if (oParam.nombreReport == undefined) {
		oParam.nombreReport = nombreReport;
	}
// debug("Report final " + report + " Consulta " + consulta);
	this.iface.__lanzaInforme(cursor, oParam);
}

//// MOD_IMPRESION ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
