
/** @class_declaration mrp */
/////////////////////////////////////////////////////////////////
//// MRP ////////////////////////////////////////////////////////
class mrp extends prod {
	var listaArticulos_:Array;
	var listaNombreArticulo_:Array;
	var maxSemanas_:Number = 9;
	var semanas_:Array;
	var fechaCalculo_:Date;
    function mrp( context ) { prod ( context ); }
	function init() {
		return this.ctx.mrp_init();
	}
	function tbnMRP_clicked() {
		return this.ctx.mrp_tbnMRP_clicked();
	}
	function obtenerOpcionMRP(arrayOps:Array):Number {
		return this.ctx.mrp_obtenerOpcionMRP(arrayOps);
	}
	function listaMateriales() {
		return this.ctx.mrp_listaMateriales();
	}
	function mostrarLista() {
		return this.ctx.mrp_mostrarLista();
	}
	function cargarLista() {
		return this.ctx.mrp_cargarLista();
	}
	function obtenerNivelesLM(referencia:String, nivel:Number):Boolean {
		return this.ctx.mrp_obtenerNivelesLM(referencia, nivel);
	}
	function lanzarListaMateriales() {
		return this.ctx.mrp_lanzarListaMateriales();
	}
	function segmentoMaestroDatos() {
		return this.ctx.mrp_segmentoMaestroDatos();
	}
	function segmentoEstadoInventarios() {
		return this.ctx.mrp_segmentoEstadoInventarios();
	}
	function explosionNecesidades() {
		return this.ctx.mrp_explosionNecesidades();
	}
	function cuboTiempo(refCubo:String, tipoInforme:String) {
		return this.ctx.mrp_cuboTiempo(refCubo, tipoInforme);
	}
	function fechasCantidades(refFC:String) {
		return this.ctx.mrp_fechasCantidades(refFC);
	}
	function diasASemanasSMD(nodo:FLDomNode, campo:String):String {
		return this.ctx.mrp_diasASemanasSMD(nodo, campo);
	}
// 	function disponibilidadesSDI(nodo:FLDomNode, campo:String):String {
// 		return this.ctx.mrp_disponibilidadesSDI(nodo, campo);
// 	}
// 	function necesidadesNetasSDI(nodo:FLDomNode, campo:String):String {
// 		return this.ctx.mrp_necesidadesNetasSDI(nodo, campo);
// 	}
	function tiempoRecepcionesSDI(nodo:FLDomNode, campo:String):String {
		return this.ctx.mrp_tiempoRecepcionesSDI(nodo, campo);
	}
	function diasASemanas(dias:Number):Number {
		return this.ctx.mrp_diasASemanas(dias);
	}
	function cargarArrayEN(arrayArticuo:Array):Boolean {
		return this.ctx.mrp_cargarArrayEN(arrayArticuo);
	}
	function cargarSemanas():Boolean {
		return this.ctx.mrp_cargarSemanas();
	}
	function cargarNB(arrayArticulo:Array, referencia:String):Boolean {
		return this.ctx.mrp_cargarNB(arrayArticulo, referencia);
	}
	function cargarD(arrayArticulo:Array, referencia:String, iPeriodo:Number):Boolean {
		return this.ctx.mrp_cargarD(arrayArticulo, referencia, iPeriodo);
	}
	function cargarRP(arrayArticulo:Array, referencia:String):Boolean {
		return this.ctx.mrp_cargarRP(arrayArticulo, referencia);
	}
	function cargarNN(arrayArticulo:Array, referencia:String, iPeriodo:Number):Boolean {
		return this.ctx.mrp_cargarNN(arrayArticulo, referencia, iPeriodo);
	}
	function cargarRPPL(arrayArticulo:Array, referencia:String, iPeriodo:Number):Boolean {
		return this.ctx.mrp_cargarRPPL(arrayArticulo, referencia, iPeriodo);
	}
	function cargarPPL(arrayArticulo:Array, referencia:String):Boolean {
		return this.ctx.mrp_cargarPPL(arrayArticulo, referencia);
	}
	function cargarNBComponentes(arrayArticulo:Array, referencia:String):Boolean {
		return this.ctx.mrp_cargarNBComponentes(arrayArticulo, referencia);
	}
	function indiceSemana(fecha:String):Number {
		return this.ctx.mrp_indiceSemana(fecha);
	}
	function traspasarDatosNodo(eRow:FLDomElement, referencia:String):Boolean {
		return this.ctx.mrp_traspasarDatosNodo(eRow, referencia);
	}
	function cargarExplosionArticulo(referencia:String):Boolean {
		return this.ctx.mrp_cargarExplosionArticulo(referencia);
	}
	function compararFS(fs1:Array, fs2:Array):Number {
		return this.ctx.mrp_compararFS(fs1, fs2);
	}
}
//// MRP ////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubMrp*/
/////////////////////////////////////////////////////////////////
//// PUB MRP ////////////////////////////////////////////////////
class pubMrp extends ifaceCtx {
    function pubMrp ( context ) { ifaceCtx( context ); }
	function pub_diasASemanasSMD(nodo:FLDomNode, campo:String):String {
		return this.diasASemanasSMD(nodo, campo);
	}
// 	function pub_disponibilidadesSDI(nodo:FLDomNode, campo:String):String {
// 		return this.disponibilidadesSDI(nodo, campo);
// 	}
// 	function pub_necesidadesNetasSDI(nodo:FLDomNode, campo:String):String {
// 		return this.necesidadesNetasSDI(nodo, campo);
// 	}
	function pub_tiempoRecepcionesSDI(nodo:FLDomNode, campo:String):String {
		return this.tiempoRecepcionesSDI(nodo, campo);
	}
}

//// PUB MRP ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition mrp */
/////////////////////////////////////////////////////////////////
//// MRP ////////////////////////////////////////////////////////
function mrp_init()
{
	this.iface.__init();

	connect (this.child("tbnMRP"), "clicked()", this, "iface.tbnMRP_clicked");
}

function mrp_tbnMRP_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var referencia:String = cursor.valueBuffer("referencia");

	var opciones:Array = [util.translate("scripts", "Lista de materiales"),
		util.translate("scripts", "Segmento maestro de datos"),
		util.translate("scripts", "Segmento de estado de inventarios"),
		util.translate("scripts", "Explosión de necesidades"),
		util.translate("scripts", "P.M. (Cubos de tiempo I) para %1").arg(referencia),
		util.translate("scripts", "P.M. (Cubos de tiempo II) para %1").arg(referencia),
		util.translate("scripts", "P.M. (Fechas/Cantidad) para %1").arg(referencia)];
	var opcion:Number = this.iface.obtenerOpcionMRP(opciones);
debug("Opcion = " + opcion);
	switch (opcion) {
		case 0: {
			this.iface.listaMateriales();
			break;
		}
		case 1: {
			this.iface.segmentoMaestroDatos();
			break;
		}
		case 2: {
			this.iface.segmentoEstadoInventarios();
			break;
		}
		case 3: {
			this.iface.explosionNecesidades();
			break;
		}
		case 4: {
			this.iface.cuboTiempo(referencia, "I");
			break;
		}
		case 5: {
			this.iface.cuboTiempo(referencia, "II");
			break;
		}
		case 6: {
			this.iface.fechasCantidades(referencia);
			break;
		}
	}
}

function mrp_obtenerOpcionMRP(arrayOps:Array):Number
{
	var util:FLUtil = new FLUtil;
	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione opción");
	
	var rButton:Array = new Array(arrayOps.length);
	for (var i:Number = 0; i < rButton.length; i++) {
		rButton[i] = new RadioButton;
		rButton[i].text = arrayOps[i];
		rButton[i].checked = false;
		gbxDialogo.add(rButton[i]);
	}
	
	dialogo.add(gbxDialogo);

	var hoy:Date = new Date;
	var dedFecha = new DateEdit;
	dedFecha.date = hoy.toString();
	dedFecha.label = util.translate("scritps", "Fecha inicial");
	dialogo.add(dedFecha);
	
	if (!dialogo.exec()) {
		return -1;
	}

	this.iface.fechaCalculo_ = dedFecha.date;
	for (var i:Number = 0; i < rButton.length; i++) {
		if (rButton[i].checked) {
			return i;
		}
	}
	return -1;
}

function mrp_listaMateriales()
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.cargarLista()) {
		return false;
	}

	this.iface.mostrarLista();
	this.iface.lanzarListaMateriales();
}

function mrp_mostrarLista()
{
	var qryArticulos:FLSqlQuery = new FLSqlQuery;
	with (qryArticulos) {
		setTablesList("articulos");
		setSelect("referencia");
		setFrom("articulos");
		setWhere("1 = 1");
		setForwardOnly(true);
	}
	if (!qryArticulos.exec()) {
debug("!qryArticulos.exec()");
		return false;
	}

	var referencia:String;
	while (qryArticulos.next()) {
		referencia = qryArticulos.value("referencia");
		debug(referencia + " = " + this.iface.listaArticulos_[referencia]["nivel"]);
	}
	return true;
}

function mrp_cargarLista()
{
	var qryArticulos:FLSqlQuery = new FLSqlQuery;
	with (qryArticulos) {
		setTablesList("articulos,articulosprov,stocks");
		setSelect("a.referencia, a.stockmin, ap.plazo, a.descripcion, a.calculolote, SUM(s.cantidad)");
		setFrom("articulos a LEFT OUTER JOIN articulosprov ap ON (a.referencia = ap.referencia AND ap.pordefecto = true) LEFT OUTER JOIN stocks s ON a.referencia = s.referencia ");
		setWhere("1 = 1 GROUP BY a.referencia, a.stockmin, ap.plazo, a.descripcion, a.calculolote ORDER BY a.referencia");
		setForwardOnly(true);
	}
	if (!qryArticulos.exec()) {
		return false;
	}

	if (this.iface.listaArticulos_) {
		delete this.iface.listaArticulos_;
	}
	if (this.iface.listaNombreArticulo_) {
		delete this.iface.listaNombreArticulo_;
	}
	this.iface.listaArticulos_ = [];
	this.iface.listaNombreArticulo_ = [];

	var referencia:String;
	var semanas:Number;
	var d0:Number;
debug(qryArticulos.sql());
	while (qryArticulos.next()) {
		referencia = qryArticulos.value("a.referencia");
		this.iface.listaArticulos_[referencia] = [];
		this.iface.listaArticulos_[referencia]["nivel"] = 0;
		this.iface.listaArticulos_[referencia]["SS"] = parseFloat(qryArticulos.value("a.stockmin"));
		semanas = this.iface.diasASemanas(qryArticulos.value("ap.plazo"));
		if (isNaN(semanas)) {
			semanas = 0;
		}
		this.iface.listaArticulos_[referencia]["TS"] = parseFloat(semanas);
		d0 = parseFloat(qryArticulos.value("SUM(s.cantidad)"));
		if (isNaN(d0)) {
			d0 = 0;
		}
		this.iface.listaArticulos_[referencia]["D0"] = d0 - this.iface.listaArticulos_[referencia]["SS"];
		this.iface.listaArticulos_[referencia]["ID"] = qryArticulos.value("a.descripcion");
		this.iface.listaArticulos_[referencia]["TL"] = qryArticulos.value("a.calculolote");
		this.iface.listaNombreArticulo_[this.iface.listaNombreArticulo_.length] = referencia;
// 		this.iface.listaArticulos_[referencia] = 0;
	}
	
	var qryPadres:FLSqlQuery = new FLSqlQuery;
	with (qryPadres) {
		setTablesList("articulos,articuloscomp");
		setSelect("a.referencia");
		setFrom("articulos a LEFT OUTER JOIN articuloscomp ac ON a.referencia = ac.refcomponente");
		setWhere("ac.id IS NULL");
		setForwardOnly(true);
	}
	if (!qryPadres.exec()) {
debug("!qryPadres.exec()");
		return false;
	}

	var referencia:String;
	while (qryPadres.next()) {
		referencia = qryPadres.value("a.referencia");
		if (!this.iface.obtenerNivelesLM(referencia, 0)) {
			return false;
		}
	}
	
	return true;
}

function mrp_obtenerNivelesLM(referencia:String, nivel:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryHijos:FLSqlQuery = new FLSqlQuery;
	with (qryHijos) {
		setTablesList("articulos,articuloscomp");
		setSelect("ac.refcomponente");
		setFrom("articulos a INNER JOIN articuloscomp ac ON a.referencia = ac.refcompuesto");
		setWhere("a.referencia = '" + referencia + "'");
		setForwardOnly(true);
	}
	if (!qryHijos.exec()) {
		return false;
	}

	var refComponente:String;
	var nuevoNivel = nivel + 1;
	while (qryHijos.next()) {
		refComponente = qryHijos.value("ac.refcomponente");
		if (this.iface.listaArticulos_[refComponente]["nivel"] < nuevoNivel) {
			this.iface.listaArticulos_[refComponente]["nivel"] = nuevoNivel;
		}
		if (!this.iface.obtenerNivelesLM(refComponente, nuevoNivel)) {
			return false;
		}
	}
	return true;
}

function mrp_lanzarListaMateriales()
{
	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var nodoRow:FLDomNode;
	var eRow:FLDomElement;

	var qryPadres:FLSqlQuery = new FLSqlQuery;
	with (qryPadres) {
		setTablesList("articulos,articuloscomp");
		setSelect("a.referencia");
		setFrom("articulos a LEFT OUTER JOIN articuloscomp ac ON a.referencia = ac.refcomponente");
		setWhere("ac.id IS NULL ORDER BY a.referencia");
		setForwardOnly(true);
	}
	if (!qryPadres.exec()) {
debug("!qryPadres.exec()");
		return false;
	}

	var referencia:String;
	var qryComposicion:FLSqlQuery;
	with (qryComposicion) {
		setTablesList("articulos,articuloscomp");
		setSelect("a.referencia, ac0.refcomponente, ac0.cantidad, ac1.refcomponente, ac1.cantidad, ac2.refcomponente, ac2.cantidad, ac3.refcomponente, ac3.cantidad, ac4.refcomponente, ac4.cantidad, ac5.refcomponente, ac5.cantidad");
		setFrom("articulos a LEFT OUTER JOIN articuloscomp ac0 ON a.referencia = ac0.refcompuesto LEFT OUTER JOIN articuloscomp ac1 ON ac0.refcomponente = ac1.refcompuesto LEFT OUTER JOIN articuloscomp ac2 ON ac1.refcomponente = ac2.refcompuesto LEFT OUTER JOIN articuloscomp ac3 ON ac2.refcomponente = ac3.refcompuesto LEFT OUTER JOIN articuloscomp ac4 ON ac3.refcomponente = ac4.refcompuesto LEFT OUTER JOIN articuloscomp ac5 ON ac4.refcomponente = ac5.refcompuesto");
		setForwardOnly(true);
	}
	var level:Number = 0;
	var refComponente:String;
	var canComponente:String;
	var nivelComponente:Number;
	var nivelesAnteriores:Array = new Array(6);
	for (var i:Number = 0; i < 6; i++) {
		nivelesAnteriores[i] = false;
	}
	var nivelRotura:Number;
	while (qryPadres.next()) {
		referencia = qryPadres.value("a.referencia");
		qryComposicion.setWhere("a.referencia = '" + referencia + "' ORDER BY a.referencia, ac0.refcomponente, ac1.refcomponente, ac2.refcomponente, ac3.refcomponente, ac4.refcomponente, ac5.refcomponente");
debug(qryComposicion.sql());
		if (!qryComposicion.exec()) {
debug("!qryComposicion.exec()");
			return false;
		}
		while (qryComposicion.next()) {
			nivelRotura = -1;
			level = 0;
			eRow = xmlKD.createElement("Row");
			eRow.setAttribute("c0", referencia);
			eRow.setAttribute("c1", "");
			eRow.setAttribute("c2", "");
			eRow.setAttribute("c3", "");
			eRow.setAttribute("c4", "");
			eRow.setAttribute("c5", "");
			eRow.setAttribute("n1", "X");
			eRow.setAttribute("n2", "X");
			eRow.setAttribute("n3", "X");
			eRow.setAttribute("n4", "X");
			eRow.setAttribute("n5", "X");
debug(nivelesAnteriores[0]);
debug(referencia);
			if (nivelesAnteriores[0] != referencia && nivelRotura == -1) {
				nivelRotura = 0;
			}
debug("nivelRotura = " + nivelRotura);

			nivelesAnteriores[0] = referencia;
			
			for (var i:Number = 0; i < 5; i++) {
				refComponente = qryComposicion.value("ac" + i.toString() + ".refcomponente");
				canComponente = qryComposicion.value("ac" + i.toString() + ".cantidad");
				if (refComponente && refComponente != "") {
					nivelComponente = this.iface.listaArticulos_[refComponente]["nivel"];
					eRow.setAttribute("c" + nivelComponente.toString(), refComponente + " (" + canComponente + ")");
					eRow.setAttribute("n" + nivelComponente.toString(), "");
				} else {
					refComponente = "";
				}
				if (nivelesAnteriores[i + 1] != refComponente && nivelRotura == -1) {
					nivelRotura = i + 1;
				}
				nivelesAnteriores[i + 1] = refComponente;
			}
			if (nivelRotura == -1) {
				nivelRotura = 0;
			}
			for (var i:Number = nivelRotura; i <= nivelComponente; i++) {
				eRow.setAttribute("level", i);
				var eRowLevel:FLDomElement = eRow.cloneNode();
				xmlKD.firstChild().appendChild(eRowLevel);
				ultimoNivel = nivelComponente;
			}
		}
	}
	debug(xmlKD.toString(4));

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate("i_listamateriales");
	rptViewer.setReportData(xmlKD);
	rptViewer.renderReport();
	rptViewer.exec();

}

function mrp_segmentoMaestroDatos()
{
	var util:FLUtil = new FLUtil;
	var qryDatos:FLSqlQuery = new FLSqlQuery;
	qryDatos.setTablesList("articulos,articulosprov");
	qryDatos.setSelect("a.referencia, a.descripcion, a.stockmin, a.calculolote, ap.plazo");
	qryDatos.setFrom("articulos a LEFT OUTER JOIN articulosprov ap ON (a.referencia = ap.referencia AND ap.pordefecto = true)");
	qryDatos.setWhere("1 = 1 ORDER BY a.referencia");
	qryDatos.setForwardOnly(true);
	
	if (!qryDatos.exec()){
		return false;
	}
debug(qryDatos.sql());
	if (!qryDatos.first()) {
		MessageBox.warning(util.translate("scripts", "No hay datos para crear el infome de Segmento Maestro de Datos"), MessageBox.Ok, MessageBox.NoButton);
	}
	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate("i_segmentomaestrodatos");
	rptViewer.setReportData(qryDatos);
	rptViewer.renderReport();
	rptViewer.exec();
}

function mrp_diasASemanasSMD(nodo:FLDomNode, campo:String):String
{
	var dias:Number = nodo.attributeValue("ap.plazo");
	var semanas:Number = this.iface.diasASemanas(dias);
	return semanas;
}

function mrp_diasASemanas(dias:Number):Number
{
	return Math.ceil(dias / 7);
}

function mrp_segmentoEstadoInventarios()
{
	if (!this.iface.cargarSemanas()) {
		return false;
	}

	var util:FLUtil = new FLUtil;
	var qryDatos:FLSqlQuery = new FLSqlQuery;
	qryDatos.setTablesList("articulos,stocks");
	qryDatos.setSelect("a.referencia, a.stockmin, SUM(s.cantidad), SUM(s.reservada), SUM(s.disponible), SUM(s.pterecibir)");
	qryDatos.setFrom("articulos a LEFT OUTER JOIN stocks s ON a.referencia = s.referencia");
	qryDatos.setWhere("1 = 1 GROUP BY a.referencia, a.stockmin ORDER BY a.referencia");
	qryDatos.setForwardOnly(true);
	
	if (!qryDatos.exec()){
		return false;
	}
debug(qryDatos.sql());
// 	if (!qryDatos.first()) {
// 		MessageBox.warning(util.translate("scripts", "No hay datos para crear el infome de Segmento de Estado de Inventarios"), MessageBox.Ok, MessageBox.NoButton);
// 	}

	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var nodoRow:FLDomNode;
	var eRow:FLDomElement;
	var nBrutas:Number;
	var nNetas:Number;
	var disponible:Number;
	var recepciones:Number;
	var referencia:String;
	while (qryDatos.next()) {
		referencia = qryDatos.value("a.referencia");
		eRow = xmlKD.createElement("Row");
		eRow.setAttribute("level", 0);
		eRow.setAttribute("referencia", referencia);
		eRow.setAttribute("ss", qryDatos.value("a.stockmin"));
		nBrutas = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "referencia = '" + referencia + "' AND cantidad < 0 AND estado = 'PTE' AND fechaprev BETWEEN '" + this.iface.semanas_[0]["desde"] + "' AND '" + this.iface.semanas_[0]["hasta"] + "'"));
		if (isNaN(nBrutas)) {
			nBrutas = 0;
		} else {
			nBrutas = nBrutas * -1;
		}
		eRow.setAttribute("nb", nBrutas);
		recepciones = parseFloat(qryDatos.value("SUM(s.pterecibir)"));
		eRow.setAttribute("rp", recepciones);
		disponible = parseFloat(qryDatos.value("SUM(s.cantidad)")) - parseFloat(qryDatos.value("a.stockmin"));
		eRow.setAttribute("d", disponible);
		nNetas = nBrutas - disponible - recepciones;
debug("Referencia = " + referencia + " - NNetas = " + nNetas);
		if (nNetas < 0) {
			nNetas = 0;
		}
		eRow.setAttribute("nn", nNetas);
		xmlKD.firstChild().appendChild(eRow);
	}
	debug(xmlKD.toString(4));

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate("i_segmentodatosinventario");
	rptViewer.setReportData(xmlKD);
	rptViewer.renderReport();
	rptViewer.exec();
}

// function mrp_disponibilidadesSDI(nodo:FLDomNode, campo:String):String
// {
// 	var disponibleTotal:Number = parseFloat(nodo.attributeValue("SUM(s.disponible)"));
// 	if (isNaN(disponibleTotal)) {
// 		disponibleTotal = 0;
// 	}
// 	var stockMinimo:Number = parseFloat(nodo.attributeValue("a.stockmin"));
// 	if (isNaN(stockMinimo)) {
// 		stockMinimo = 0;
// 	}
// 	return disponibleTotal - stockMinimo;
// }

function mrp_tiempoRecepcionesSDI(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	var referencia:Number = nodo.attributeValue("referencia");
	var pteRecibir:Number = parseFloat(nodo.attributeValue("rp"));
	if (isNaN(pteRecibir) || pteRecibir == 0) {
		return "";
	}
	var valor:String = util.translate("scripts", "En t = ");
	var qryMoviStock:FLSqlQuery = new FLSqlQuery;
	qryMoviStock.setTablesList("movistock");
	qryMoviStock.setSelect("fechaprev");
	qryMoviStock.setFrom("movistock");
	qryMoviStock.setWhere("referencia = '" + referencia + "' AND estado = 'PTE' AND cantidad > 0 ORDER BY fechaprev");
	qryMoviStock.setForwardOnly(true);
	if (!qryMoviStock.exec()) {
		return false;
	}
	var hoy:Date = this.iface.fechaCalculo_;
	var intervaloDias:Number;
	var t1:Number;
	var t2:Number;
	if (qryMoviStock.first()) {
		t1 = this.iface.indiceSemana(qryMoviStock.value("fechaprev"));
// 		intervaloDias = util.daysTo(hoy, qryMoviStock.value("fechaprev"));
// debug("intervalo1 = " + intervaloDias);
// 		t1 = this.iface.diasASemanas(intervaloDias);
		valor += t1.toString();
	}
	if (qryMoviStock.last()) {
		t2 = this.iface.indiceSemana(qryMoviStock.value("fechaprev"));
// 		intervaloDias = util.daysTo(hoy, qryMoviStock.value("fechaprev"));
// debug("intervalo2 = " + intervaloDias);
// 		t2 = this.iface.diasASemanas(intervaloDias);
		if (t2 != t1) {
			valor += " - " + t2.toString();
		}
	}
	
	return valor;
}

// function mrp_necesidadesNetasSDI(nodo:FLDomNode, campo:String):String
// {
// 	var nBrutas:Number = parseFloat(nodo.attributeValue("SUM(s.reservada)"));
// 	if (isNaN(nBrutas)) {
// 		nBrutas = 0;
// 	}
// 	var disponibilidades:Number = this.iface.disponibilidadesSDI(nodo, campo);
// 	if (isNaN(disponibilidades)) {
// 		disponibilidades = 0;
// 	}
// 	var recepciones:Number = parseFloat(nodo.attributeValue("SUM(s.pterecibir)"));
// 	if (isNaN(recepciones)) {
// 		recepciones = 0;
// 	}
// 	var nNetas:Number = nBrutas - disponibilidades + recepciones;
// 	return nNetas;
// }

function mrp_explosionNecesidades()
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.cargarLista()) {
		return false;
	}

	if (!this.iface.cargarSemanas()) {
		return false;
	}

	var referencia:String;
	for (var i:Number = 0; i < this.iface.listaNombreArticulo_.length; i++) {
		referencia = this.iface.listaNombreArticulo_[i];
		this.iface.cargarArrayEN(this.iface.listaArticulos_[referencia], referencia);
	}
	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var nodoRow:FLDomNode;
	var eRow:FLDomElement;
	for (var nivel = 0; nivel < 6; nivel++) {
		for (var i:Number = 0; i < this.iface.listaNombreArticulo_.length; i++) {
			referencia = this.iface.listaNombreArticulo_[i];
			if (this.iface.listaArticulos_[referencia]["nivel"] != nivel) {
				continue;
			}
			if (!this.iface.cargarExplosionArticulo(referencia)) {
				return false;
			}
			
			eRow = xmlKD.createElement("Row");
			eRow.setAttribute("level", 0);
			if (!this.iface.traspasarDatosNodo(eRow, referencia)) {
				return false;
			}
			xmlKD.firstChild().appendChild(eRow);
		}
	}
	debug(xmlKD.toString(4));

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate("i_explosionnecesidades");
	rptViewer.setReportData(xmlKD);
	rptViewer.renderReport();
	rptViewer.exec();
	return true;
}

function mrp_cuboTiempo(refCubo:String, tipoInforme)
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.cargarLista()) {
		return false;
	}

	if (!this.iface.cargarSemanas()) {
		return false;
	}

	var referencia:String;
	for (var i:Number = 0; i < this.iface.listaNombreArticulo_.length; i++) {
		referencia = this.iface.listaNombreArticulo_[i];
		this.iface.cargarArrayEN(this.iface.listaArticulos_[referencia], referencia);
	}
	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var nodoRow:FLDomNode;
	var eRow:FLDomElement;
	for (var nivel = 0; nivel < 6; nivel++) {
		for (var i:Number = 0; i < this.iface.listaNombreArticulo_.length; i++) {
			referencia = this.iface.listaNombreArticulo_[i];

			if (this.iface.listaArticulos_[referencia]["nivel"] != nivel) {
				continue;
			}
			if (!this.iface.cargarExplosionArticulo(referencia)) {
				return false;
			}
			
			if (referencia != refCubo) {
				continue;
			}
			eRow = xmlKD.createElement("Row");
			eRow.setAttribute("level", 0);
			eRow.setAttribute("descripcion", util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'"));
			if (!this.iface.traspasarDatosNodo(eRow, referencia)) {
				return false;
			}
			xmlKD.firstChild().appendChild(eRow);
		}
	}
	debug(xmlKD.toString(4));

	var rptViewer:FLReportViewer = new FLReportViewer();
	if (tipoInforme == "I") {
		rptViewer.setReportTemplate("i_cubotiempo");
	} else {
		rptViewer.setReportTemplate("i_cubotiempo_2");
	}
	rptViewer.setReportData(xmlKD);
	rptViewer.renderReport();
	rptViewer.exec();
	return true;
}

function mrp_fechasCantidades(refFC:String)
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.cargarLista()) {
		return false;
	}

	if (!this.iface.cargarSemanas()) {
		return false;
	}

	var referencia:String;
	for (var i:Number = 0; i < this.iface.listaNombreArticulo_.length; i++) {
		referencia = this.iface.listaNombreArticulo_[i];
		this.iface.cargarArrayEN(this.iface.listaArticulos_[referencia], referencia);
	}
	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var nodoRow:FLDomNode;
	var eRow:FLDomElement;
	for (var nivel = 0; nivel < 6; nivel++) {
		for (var i:Number = 0; i < this.iface.listaNombreArticulo_.length; i++) {
			referencia = this.iface.listaNombreArticulo_[i];

			if (this.iface.listaArticulos_[referencia]["nivel"] != nivel) {
				continue;
			}
			if (!this.iface.cargarExplosionArticulo(referencia)) {
				return false;
			}
		}
	}
	
	var hoy:Date = this.iface.fechaCalculo_;
	var cantidad:Number;
	var arrayFC:Array = [];

	var qryMS:FLSqlQuery = new FLSqlQuery;
	qryMS.setTablesList("movistock");
	qryMS.setSelect("cantidad, fechaprev");
	qryMS.setFrom("movistock");
	qryMS.setWhere("referencia = '" + refFC + "' AND estado = 'PTE' AND fechaprev >= '" + hoy.toString() + "'");
	qryMS.setForwardOnly(true);
	if (!qryMS.exec()) {
		return false;
	}
	var i:Number = 0;
	arrayFC[i] = [];
	arrayFC[i]["fecha"] = hoy;
	arrayFC[i]["tipodato"] = " - ";
	arrayFC[i]["cantidad"] = 0;
	i++;
	while (qryMS.next()) {
		cantidad = parseFloat(qryMS.value("cantidad"));
		if (isNaN(cantidad)) {
			cantidad = 0;
		}
		arrayFC[i] = [];
		arrayFC[i]["fecha"] = qryMS.value("fechaprev");
		if (cantidad > 0) {
			arrayFC[i]["tipodato"] = "RP";
		} else {
			arrayFC[i]["tipodato"] = "NB";
			cantidad = cantidad * -1;
		}
		arrayFC[i]["cantidad"] = cantidad;
		i++;
	}

	for (var k:Number = 0; k < this.iface.maxSemanas_; k++) {
		if (this.iface.listaArticulos_[refFC]["RPPL"][k] != 0) {
			arrayFC[i] = [];
			arrayFC[i]["fecha"] = this.iface.semanas_[k]["desde"];
			arrayFC[i]["tipodato"] = "RPPL";
			arrayFC[i]["cantidad"] = this.iface.listaArticulos_[refFC]["RPPL"][k];
			i++;
		}
		if (this.iface.listaArticulos_[refFC]["PPL"][k] != 0) {
			arrayFC[i] = [];
			arrayFC[i]["fecha"] = this.iface.semanas_[k]["desde"];
			arrayFC[i]["tipodato"] = "PPL";
			arrayFC[i]["cantidad"] = this.iface.listaArticulos_[refFC]["PPL"][k];
			i++;
		}
	}
	arrayFC.sort(this.iface.compararFS);
	var disponible:Number = this.iface.listaArticulos_[refFC]["D0"];
	var cantidad:Number;
	var tipoDato:String;
	for (var k:Number = 0; k < i; k++) {
		eRow = xmlKD.createElement("Row");
		eRow.setAttribute("level", 0);
		eRow.setAttribute("referencia", refFC);
		eRow.setAttribute("descripcion", util.sqlSelect("articulos", "descripcion", "referencia = '" + refFC + "'"));
		eRow.setAttribute("tl", this.iface.listaArticulos_[refFC]["TL"]);
		eRow.setAttribute("ts", this.iface.listaArticulos_[refFC]["TS"]);
		eRow.setAttribute("ss", this.iface.listaArticulos_[refFC]["SS"]);
		eRow.setAttribute("id", this.iface.listaArticulos_[refFC]["ID"]);
		eRow.setAttribute("nivel", this.iface.listaArticulos_[refFC]["nivel"]);
		
		eRow.setAttribute("fecha", arrayFC[k]["fecha"].toString().left(10));
		eRow.setAttribute("semana", this.iface.indiceSemana(arrayFC[k]["fecha"]));
		tipoDato = arrayFC[k]["tipodato"];
		eRow.setAttribute("tipodato", tipoDato);
		cantidad = arrayFC[k]["cantidad"];
		eRow.setAttribute("cantidad", cantidad);
		switch (tipoDato) {
			case "NB": {
				disponible -= parseFloat(cantidad);
				break;
			}
			case "RP":
			case "RPPL": {
				disponible += parseFloat(cantidad);
				break;
			}
		}
		eRow.setAttribute("disponible", disponible);
		xmlKD.firstChild().appendChild(eRow);
	}
	debug(xmlKD.toString(4));

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate("i_fechascantidades");
	rptViewer.setReportData(xmlKD);
	rptViewer.renderReport();
	rptViewer.exec();
	return true;
}

function mrp_compararFS(fs1:Array, fs2:Array):Number
{
	var ms1:Number = fs1["fecha"].getTime();
	var ms2:Number = fs2["fecha"].getTime();
	var resultado:Number;
	if (ms1 > ms2) {
		resultado = 1;
	} else if (ms1 < ms2) {
		resultado = -1;
	} else {
		resultado = 0;
	}
	return resultado;
}

function mrp_cargarExplosionArticulo(referencia:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.cargarNB(this.iface.listaArticulos_[referencia], referencia)) {
		MessageBox.warning(util.translate("scripts", "Error al cargar las necesidades brutas para %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.cargarRP(this.iface.listaArticulos_[referencia], referencia)) {
		MessageBox.warning(util.translate("scripts", "Error al cargar las recepciones programadas para %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) {
		if (!this.iface.cargarD(this.iface.listaArticulos_[referencia], referencia, i)) {
			MessageBox.warning(util.translate("scripts", "Error al cargar las disponibilidades para %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (!this.iface.cargarNN(this.iface.listaArticulos_[referencia], referencia, i)) {
			MessageBox.warning(util.translate("scripts", "Error al cargar las necesidades netas para %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (!this.iface.cargarRPPL(this.iface.listaArticulos_[referencia], referencia, i)) {
			MessageBox.warning(util.translate("scripts", "Error al cargar las recepciones de pedidos programados para %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	if (!this.iface.cargarPPL(this.iface.listaArticulos_[referencia], referencia)) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los lanzamientos de pedidos programados para %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.cargarNBComponentes(this.iface.listaArticulos_[referencia], referencia)) {
		MessageBox.warning(util.translate("scripts", "Error al cargar las necesidades brutas de los componentes de %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

function mrp_traspasarDatosNodo(eRow:FLDomElement, referencia:String):Boolean
{
	eRow.setAttribute("referencia", referencia);
	eRow.setAttribute("tl", this.iface.listaArticulos_[referencia]["TL"]);
	eRow.setAttribute("ts", this.iface.listaArticulos_[referencia]["TS"]);
	eRow.setAttribute("disp", this.iface.listaArticulos_[referencia]["D0"]);
	eRow.setAttribute("ss", this.iface.listaArticulos_[referencia]["SS"]);
	eRow.setAttribute("c", "0");
	eRow.setAttribute("id", this.iface.listaArticulos_[referencia]["ID"]);
	eRow.setAttribute("nivel", this.iface.listaArticulos_[referencia]["nivel"]);
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) {
		eRow.setAttribute("nb" + i.toString(), this.iface.listaArticulos_[referencia]["NB"][i]);
		eRow.setAttribute("d" + i.toString(), this.iface.listaArticulos_[referencia]["D"][i]);
		eRow.setAttribute("rp" + i.toString(), this.iface.listaArticulos_[referencia]["RP"][i]);
		eRow.setAttribute("nn" + i.toString(), this.iface.listaArticulos_[referencia]["NN"][i]);
		eRow.setAttribute("rppl" + i.toString(), this.iface.listaArticulos_[referencia]["RPPL"][i]);
		eRow.setAttribute("ppl" + i.toString(), this.iface.listaArticulos_[referencia]["PPL"][i]);
	}
	return true;
}

/** \D Carga los valores de Necesidades netas, añadiéndolos a los ya existentes, a partir de los movimientos negativos de stock en estado PTE
@param	arrayArticulo: Array que contiene los subarrays asociados al artícuo
@param	referencia: Referencia del artículo
\end */
function mrp_cargarNB(arrayArticulo:Array, referencia:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var qryMS:FLSqlQuery = new FLSqlQuery;
	qryMS.setTablesList("movistock");
	qryMS.setSelect("cantidad, fechaprev");
	qryMS.setFrom("movistock");
	qryMS.setWhere("referencia = '" + referencia + "' AND estado = 'PTE' AND cantidad < 0");
	qryMS.setForwardOnly(true);
	if (!qryMS.exec()) {
		return false;
	}
	var fechaPrev:String;
	var cantdad:Number;
	var indiceSemana:Number;
	while (qryMS.next()) {
		fechaPrev = qryMS.value("fechaprev");
		cantidad = -1 * parseFloat(qryMS.value("cantidad"));
		var i:Number = this.iface.indiceSemana(fechaPrev);
		if (i > -1) {
			arrayArticulo["NB"][i] = parseFloat(arrayArticulo["NB"][i]) + cantidad;
		}
	}
	return true;
}

/** \D Carga los valores de Disponibilidad, aplicando la fórmula D(i) = D(i-1) - NB(i-1). Si el resultado es menor que el stock de seguridad SS, D(i) = SS.
@param	arrayArticulo: Array que contiene los subarrays asociados al artícuo
@param	referencia: Referencia del artículo
@param	iPeriodo: Índice del período de cálculo
\end */
function mrp_cargarD(arrayArticulo:Array, referencia:String, iPeriodo:Number):Boolean
{
	var disponibilidades:Number;
	if (iPeriodo == 0) {
		arrayArticulo["D"][iPeriodo] = arrayArticulo["D0"];
	} else {
		arrayArticulo["D"][iPeriodo] = arrayArticulo["D"][(iPeriodo - 1)] + arrayArticulo["RP"][(iPeriodo - 1)] - arrayArticulo["NB"][(iPeriodo - 1)] + arrayArticulo["RPPL"][(iPeriodo - 1)];
	}
	return true;
}

/** \D Carga los valores de Recepciones programadas, añadiéndolos a los ya existentes, a partir de los movimientos positivos de stock en estado PTE
@param	arrayArticulo: Array que contiene los subarrays asociados al artícuo
@param	referencia: Referencia del artículo
\end */
function mrp_cargarRP(arrayArticulo:Array, referencia:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var qryMS:FLSqlQuery = new FLSqlQuery;
	qryMS.setTablesList("movistock");
	qryMS.setSelect("cantidad, fechaprev");
	qryMS.setFrom("movistock");
	qryMS.setWhere("referencia = '" + referencia + "' AND estado = 'PTE' AND cantidad > 0");
	qryMS.setForwardOnly(true);
	if (!qryMS.exec()) {
		return false;
	}
	var fechaPrev:String;
	var cantdad:Number;
	var indiceSemana:Number;
	while (qryMS.next()) {
		fechaPrev = qryMS.value("fechaprev");
		cantidad = parseFloat(qryMS.value("cantidad"));
		var i:Number = this.iface.indiceSemana(fechaPrev);
		if (i > -1) {
			arrayArticulo["RP"][i] = parseFloat(arrayArticulo["RP"][i]) + cantidad;
		}
	}
	return true;
}

/** \D Carga los valores de Necesidades Netas, aplicando la fórmula NN(i) = NB(i) + SS - D(i) - RP(i).
@param	arrayArticulo: Array que contiene los subarrays asociados al artícuo
@param	referencia: Referencia del artículo
@param	iPeriodo: Índice del período de cálculo
\end */
function mrp_cargarNN(arrayArticulo:Array, referencia:String, iPeriodo:Number):Boolean
{
	arrayArticulo["NN"][iPeriodo] = arrayArticulo["NB"][iPeriodo] - arrayArticulo["D"][iPeriodo] - arrayArticulo["RP"][iPeriodo];
	if (arrayArticulo["NN"][iPeriodo] < 0) {
		arrayArticulo["NN"][iPeriodo] = 0;
	}
	return true;
}

/** \D Carga los valores de Recepción de Pedidos Planificados, aplicando la fórmula RPPL(i) = NN(i)
@param	arrayArticulo: Array que contiene los subarrays asociados al artícuo
@param	referencia: Referencia del artículo
@param	iPeriodo: Índice del período de cálculo
\end */
function mrp_cargarRPPL(arrayArticulo:Array, referencia:String, iPeriodo:Number):Boolean
{
	arrayArticulo["RPPL"][iPeriodo] = arrayArticulo["NN"][iPeriodo];
	return true;
}

/** \D Carga los valores de Lanzamiento de Pedidos Planificados, aplicando la fórmula PPL(i) = RPPL(i + TS). TS = Tiempo de suministro
@param	arrayArticulo: Array que contiene los subarrays asociados al artícuo
@param	referencia: Referencia del artículo
\end */
function mrp_cargarPPL(arrayArticulo:Array, referencia:String):Boolean
{
	var iRecepcion:Number;
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) {
		iRecepcion = i + arrayArticulo["TS"];
		if (iRecepcion < this.iface.maxSemanas_) {
			arrayArticulo["PPL"][i] = arrayArticulo["RPPL"][iRecepcion];
		} else {
			arrayArticulo["PPL"][i] = 0;
		}
	}
	return true;
}

function mrp_cargarNBComponentes(arrayArticulo:Array, referencia:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var qryComp:FLSqlQuery = new FLSqlQuery;
	qryComp.setTablesList("articuloscomp");
	qryComp.setSelect("refcomponente, cantidad");
	qryComp.setFrom("articuloscomp");
	qryComp.setWhere("refcompuesto = '" + referencia + "'");
	qryComp.setForwardOnly(true);
	if (!qryComp.exec()) {
		return false;
	}
	var refComponente:String;
	var cantidad:String;
	while (qryComp.next()) {
		refComponente = qryComp.value("refcomponente");
		cantidad = parseFloat(qryComp.value("cantidad"));
		if (isNaN(cantidad)) {
			cantidad = 0;
		}
		for (var i:Number = 0; i < this.iface.maxSemanas_; i++) {
			if (arrayArticulo["PPL"][i] != 0) {
				this.iface.listaArticulos_[refComponente]["NB"][i] += parseFloat(arrayArticulo["PPL"][i]) * cantidad;
			}
		}
	}
	return true;
}

function mrp_indiceSemana(fecha:String):Number
{
debug("Buscando semana para " + fecha);
	var util:FLUtil = new FLUtil;
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) {
		if (util.daysTo(this.iface.semanas_[i]["desde"], fecha) >= 0 && util.daysTo(this.iface.semanas_[i]["hasta"], fecha) <= 0) {
debug("Encontrada semana " + i);
			return i;
		}
	}
debug("No encontrado");
	return -1;
}

function mrp_cargarSemanas():Boolean
{
	var util:FLUtil = new FLUtil;

	if (this.iface.semanas_) {
		delete this.iface.semanas_;
	}
	this.iface.semanas_ = new Array(this.iface.maxSemanas_);

	var hoy:Date = this.iface.fechaCalculo_;
	var diaSemana:Number = hoy.getDay();
	var lunes:String = util.addDays(hoy, (1 - diaSemana));
	var domingo:String;
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) {
		this.iface.semanas_[i] = [];
		this.iface.semanas_[i]["desde"] = lunes;
		domingo = util.addDays(lunes, 6);
		this.iface.semanas_[i]["hasta"] = domingo;
		lunes = util.addDays(domingo, 1);
debug("Semana " + i + " Desde " + this.iface.semanas_[i]["desde"] + " hasta " + this.iface.semanas_[i]["hasta"]);
	}
	return true;
}

function mrp_cargarArrayEN(arrayArticuo:Array):Boolean
{
	arrayArticuo["NB"] = new Array(this.iface.maxSemanas_);
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) { arrayArticuo["NB"][i] = 0; }
	arrayArticuo["D"] = new Array(this.iface.maxSemanas_);
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) { arrayArticuo["D"][i] = 0; }
	arrayArticuo["RP"] = new Array(this.iface.maxSemanas_);
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) { arrayArticuo["RP"][i] = 0; }
	arrayArticuo["NN"] = new Array(this.iface.maxSemanas_);
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) { arrayArticuo["NN"][i] = 0; }
	arrayArticuo["RPPL"] = new Array(this.iface.maxSemanas_);
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) { arrayArticuo["RPPL"][i] = 0; }
	arrayArticuo["PPL"] = new Array(this.iface.maxSemanas_);
	for (var i:Number = 0; i < this.iface.maxSemanas_; i++) { arrayArticuo["PPL"][i] = 0; }

	
	return true;
}
//// MRP ////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
