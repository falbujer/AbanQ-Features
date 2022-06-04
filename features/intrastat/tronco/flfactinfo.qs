
/** @class_declaration intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT /////////////////////////////////////////////////
class intrastat extends oficial {
    function intrastat( context ) { oficial ( context ); }
    function init() { 
		return this.ctx.intrastat_init(); }
	function valoresIniciales() {
		return this.ctx.intrastat_valoresIniciales();
	}
	function crearCondicionesEntrega() {
		return this.ctx.intrastat_crearCondicionesEntrega();
	}
	function crearNaturalezaTransaccionA() {
		return this.ctx.intrastat_crearNaturalezaTransaccionA();
	}
	function crearNaturalezaTransaccion() {
		return this.ctx.intrastat_crearNaturalezaTransaccion();
	}
	function crearModoTransporte() {
		return this.ctx.intrastat_crearModoTransporte();
	}
	function crearPuertoAeropuerto() {
		return this.ctx.intrastat_crearPuertoAeropuerto();
	}
	function crearRegimenEstadistico() {
		return this.ctx.intrastat_crearRegimenEstadistico();
	}
	function beforeCommit_intrastat(curIntrastat:FLSqlCursor):Boolean {
		return this.ctx.intrastat_beforeCommit_intrastat(curIntrastat);
	}
	function liberarAlbaranesIntrastat(idIntrastat:String):Boolean {
		return this.ctx.intrastat_liberarAlbaranesIntrastat(idIntrastat);
	}
	function liberarAlbaran(idAlbaran:String, tabla:String):Boolean {
		return this.ctx.intrastat_liberarAlbaran(idAlbaran, tabla);
	}
}
//// INTRASTAT /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT //////////////////////////////////////////////////
function intrastat_init() 
{
	this.iface.__init();
	this.iface.valoresIniciales();
}

function intrastat_valoresIniciales()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = new FLSqlCursor("condicionesentrega");
	cursor.select();
	if (!cursor.first()) {
		MessageBox.information(util.translate("scripts", "Se van a importar algunos datos para la declaraci�n Intrastat"), MessageBox.Ok, MessageBox.NoButton);

		this.iface.crearCondicionesEntrega();
		this.iface.crearNaturalezaTransaccionA();
		this.iface.crearNaturalezaTransaccion();
		this.iface.crearModoTransporte();
		this.iface.crearPuertoAeropuerto();
		this.iface.crearRegimenEstadistico();

		MessageBox.information(util.translate("scripts", "Proceso finalizado"), MessageBox.Ok, MessageBox.NoButton);
	}
}


function intrastat_crearCondicionesEntrega()
{
	var cursor:FLSqlCursor = new FLSqlCursor("condicionesentrega");
	var condicionesEntrega:Array =
		[["EXW", "EN LA F�BRICA", "LOCALIZACI�N DE LA F�BRICA"],["FCA", "FRANCO TRANSPORTISTA", "PUNTO ACORDADO"],["FAS", "FRANCO AL COSTADO DEL BUQUE", "PUERTO DE EMBARQUE ACORDADO"],["FOB", "FRANCO A BORDO", "PUERTO DE EMBARQUE ACORDADO"],["CFR", "COSTE Y FLETE (C&F)", "PUNTO DE DESTINO ACORDADO"],["CIF", "COSTE, SEGURO Y FLETE", "PUNTO DE DESTINO ACORDADO"],["CPT", "PORTE PAGADO HASTA", "PUNTO DE DESTINO ACORDADO"],["CIP", "PORTE PAGADO, INCLUIDO SEGURO, HASTA", "PUNTO DE DESTINO ACORDADO"],["DAF", "FRANCO FRONTERA", "LUGAR DE ENTREGA ACORDADO EN FRONTERA"],["DES", "FRANCO 'EX SHIP'", "PUNTO DE DESTINO ACORDADO"],["DEQ", "FRANCO MUELLE", "DESPACHO EN ADUANA PUERTO ACORDADO"],["DDU", "FRANCO SIN DESPACHAR EN ADUANA", "LUGAR DE DESTINO ACORDADO EN EL PA�S DE IMPORTACI�N"],["DDP", "FRANCO DESPACHO EN ADUANA", "LUGAR DE ENTREGA ACORDADO EN EL PA�S DE IMPORTACI�N"],["XXX", "CONDICIONES DE ENTREGA DISTINTA DE LAS ANTERIORES", "INDICACI�N PRECISA DE LAS CONDICIONES QUE SE ESTIPULAN EN EL CONTRATO"]];
	for (var i:Number = 0; i < condicionesEntrega.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codcondicionentrega", condicionesEntrega[i][0]);
			setValueBuffer("significado", condicionesEntrega[i][1]);
			setValueBuffer("lugar", condicionesEntrega[i][2]);
			commitBuffer();
		}
	}
}

function intrastat_crearNaturalezaTransaccionA()
{
	var cursor:FLSqlCursor = new FLSqlCursor("naturalezatransacciona");
	var naturalezaTransaccionA:Array =
		[["1", "Transacciones que supongan un traspaso de propiedad legal o previsto y una contrapartida (financiera o de otro tipo) (excepto las transacciones que se registren en los ep�grafes 2, 7 y 8)"],["2", "Devoluci�n de mercanc�as tras registro de la transacci�n original en el ep�grafe 1; sustituci�n gratuita de mercancias"],["3", "Transacciones (no temporales) que supongan un traspaso de propiedad sin contrapartida (financiera ni de otro tipo)"],["4", "Operaciones con miras al trabajo por encargo (excepto las que se registren en el ep�grafe 7)"],["5", "Operaciones tras el trabajo por encargo (excepto las que se registren en el ep�grafe 7)"],["6", "No utilizada"],["7", "Operaciones en el marco de programas comunes de defensa u otros programas intergubernamentales de producci�n conjunta"]];
	for (var i:Number = 0; i < naturalezaTransaccionA.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codnaturalezaa", naturalezaTransaccionA[i][0]);
			setValueBuffer("descripcion", naturalezaTransaccionA[i][1]);
			commitBuffer();
		}
	}
}

function intrastat_crearNaturalezaTransaccion()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = new FLSqlCursor("naturalezatransaccion");
	var descripcionA:String;
	var naturalezaTransaccion:Array =
		[["11", "1", "1", "Compra/venta en firme"],["12", "1", "2", "Suministro para la venta salvo aprobaci�n o de prueba, para consignaci�n o con la mediaci�n de un agente comisionado"],["13", "1", "3", "Trueque (compensaci�n en especie)"],["14", "1", "4", "Compras por particulares"],["15", "1", "5", "Arrendamiento financiero (alquiler-compra)"],["21", "2", "1", "Devoluci�n de mercanc�as"],["22", "2", "2", "Sustituci�n de mercanc�as devueltas"], ["23", "2","3", "Sustituci�n (por ejemplo, bajo garant�a) de mercanc�as no devueltas"], ["31", "3", "1", "Mercanc�as entregadas en el marco de programas de ayuda gestionados o financiados parcial o totalmente por la Comunidad Europea"],["32", "3", "2", "Otras entregas de ayuda gubernamental"],["33", "3", "3", "Otras entregas de ayuda (particulares, organizaciones no gubernamentales)"],["34", "3", "4", "Otros"]];
	for (var i:Number = 0; i < naturalezaTransaccion.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codigo", naturalezaTransaccion[i][0]);
			setValueBuffer("codnaturalezaa", naturalezaTransaccion[i][1]);
			descripcionA = util.sqlSelect("naturalezatransacciona", "descripcion", "codnaturalezaa = '" + naturalezaTransaccion[i][1] + "'");
			setValueBuffer("descripciona", descripcionA);

			setValueBuffer("codnaturalezab", naturalezaTransaccion[i][2]);
			setValueBuffer("descripcionb", naturalezaTransaccion[i][3]);
			commitBuffer();
		}
	}
}

function intrastat_crearModoTransporte()
{
	var cursor:FLSqlCursor = new FLSqlCursor("modotransporte");
	var modoTransporte:Array =
		[["1", "Transporte mar�timo"],["2", "Transporte por ferrocarril"],["3", "Transporte por carretera"],["4", "Transporte a�reo"],["5", "Env�os postales"],["7", "Instalaciones fijas de transporte"],["8", "Transporte de navegaci�n interior"],["9", "Autopropulsi�n"]];
	for (var i:Number = 0; i < modoTransporte.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codmodotransporte", modoTransporte[i][0]);
			setValueBuffer("descripcion", modoTransporte[i][1]);
			commitBuffer();
		}
	}
}

function intrastat_crearPuertoAeropuerto()
{
	var cursor:FLSqlCursor = new FLSqlCursor("puertosaeropuertos");
	var puertosAeropuertos:Array =
		[["Alava/Araba", "101", "Alava Aeropuerto"],["Alicante/Alacant", "301", "Alicante Aeropuerto"],["Alicante/Alacant", "311", "Alicante Mar�tima"],["Almer�a", "401", "Almer�a Aeropuerto"],["Almer�a", "411", "Almer�a Mar�tima"],["Baleares/Balears", "701", "P.Mallorca Aeropuerto"],["Baleares/Balears", "707", "Ibiza Aeropuerto"],["Baleares/Balears", "708", "Mah�n Aeropuerto"],["Baleares/Balears", "711", "P.Mallorca Mar�tima"],["Baleares/Balears", "717", "Alcudia Mar�tima"],["Baleares/Balears", "721", "Ibiza Mar�tima"],["Baleares/Balears", "731", "Mah�n Mar�tima"],["Barcelona", "801", "Barcelona Aeropuerto"],["Barcelona", "811", "Barcelona Mar�tima Imp."],["Barcelona", "812", "Barcelona Mar�tima Exp."],["C�diz", "1101", "Jerez Aeropuerto"],["C�diz", "1111", "C�diz Mar�tima"],["C�diz", "1121", "Puerto de Santa Mar�a"],["C�diz", "1131", "Algeciras Mar�tima"],["Castell�n/Castello", "1211", "Castell�n Mar�tima"],["A Coru�a", "1501", "La Coru�a Aeropuerto"],["A Coru�a", "1507", "Santiago Aeropuerto"],["A Coru�a", "1511", "La Coru�a Mar�tima"],["A Coru�a", "1521", "El Ferrol Mar�tima"],["Girona", "1701", "Gerona Aeropuerto"],["Girona", "1711", "Palam�s Mar�tima"],["Granada", "1801", "Granada Aeropuerto"],["Granada", "1811", "Motril Mar�tima"],["Guip�zcua/Gipuzkoa", "2001", "Guip�zcua Aeropuerto"],["Guip�zcua/Gipuzkoa", "2011", "Pasajes Mar�tima"],["Huelva", "2111", "Huelva Mar�tima"],["Lugo", "2711", "Ribadeo Mar�tima"],["Madrid", "2801", "Madrid Aeropuerto"],["M�laga", "2901", "M�laga Aeropuerto"],["M�laga", "2911", "M�laga Mar�tima"],["Murcia", "3001", "Murcia Aeropuerto"],["Murcia", "3011", "Cartagena Mar�tima"],["Asturias", "3301", "Asturias Aeropuerto"],["Asturias", "3311", "Gij�n Mar�tima"],["Asturias", "3331", "Avil�s Mar�tima"],["Pontevedra", "3601", "Vigo Aeropuerto"],["Pontevedra", "3611", "Vigo Mar�tima"],["Pontevedra", "3621", "Mar�n Mar�tima"],["Pontevedra", "3631", "Villagarc�a Mar�tima"],["Cantabria", "3901", "Santander Aeropuerto"],["Cantabria", "3911", "Santander Mar�tima"],["Sevilla", "4101", "Sevilla Aeropuerto"],["Sevilla", "4111", "Sevilla Mar�tima"],["Tarragona", "4301", "Tarragona Aeropuerto"],["Tarragona", "4311", "Tarragona Mar�tima"],["Tarragona", "4321", "San Carlos Mar�tima"],["Valencia", "4601", "Valencia Aeropuerto"],["Valencia", "4611", "Valencia Mar�tima"],["Valencia", "4621", "Sagunto Mar�tima"],["Valencia", "4631", "Gand�a Mar�tima"],["Valladolid", "4701", "Valladolid Aeropuerto"],["Bilbao", "4801", "Bilbao Aeropuerto"],["Bilbao", "4811", "Bilbao Mar�tima"],["Zaragoza", "5001", "Zaragoza Aeropuerto"]];
	for (var i:Number = 0; i < puertosAeropuertos.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("provincia", puertosAeropuertos[i][0]);
			setValueBuffer("codpuerto", puertosAeropuertos[i][1]);
			setValueBuffer("recinto", puertosAeropuertos[i][2]);
			commitBuffer();
		}
	}
}

function intrastat_crearRegimenEstadistico()
{
	var cursor:FLSqlCursor = new FLSqlCursor("regimenesestadisticos");
	var regimenEstadistico:Array =
		[["1", "I", "Llegadas de mercanc�as comunitarias con destino final en el Estado miembro de introducci�n"],["2", "I", "LLegadas temporales de mercanc�as comunitarias para ser reexpedidas al Estado miembro de procedencia o a otro Estado miembro, en el mismo estado en que llegaron"],["3", "I", "Llegadas temporales de mercanc�as comunitarias para ser reexpedidas al Estado miembro de procedencia o a otro estado miembro, despu�s de sufrir una operaci�n de transformaci�n"],["4", "I", "Llegada de mercanc�as comunitarias, devueltas en el mismo estado en el que fueron previamente expedidas al Estado miembro de procedencia o a otros estados miembros"],["5", "I", "Llegada de mercanc�as comunitarias, devueltas despu�s de haber sufrido una operaci�n de reparaci�n o transformaci�n, previamente expedidos al Estado miembro de procedencia o a otro Estado miembro"],["1", "E", "Salida de mercanc�as comunitarias con destino final en el Estado miembro de destino"],["2", "E", "Salida temporal de mercanc�as comunitarias para ser reintroducidas con posterioridad desde el Estado miembro de destino o desde otro Estado miembro en el mismo estado en que son expedidas"],["3", "E", "Salida temporal de mercanc�as comunitarias para ser reintroducidas con posterioridad, desde el Estado miembro de destino o desde otro Estado miembro despu�s de haber sufrido una operaci�n de reparaci�n o transformaci�n"], ["4","E","Salida de mercanc�as comunitarias, que se devuelven en el mismo estado en el que previamente llegaron procedentes del Estado miembro de destino o procedentes de otro Estado miembro"], ["5","E","Salida de mercanc�as comunitarias, que se devuelven despu�s de haber sufrido una operaci�n de transformaci�n, previamente recibidas del Estado miembro de destino o de otro Estado miembro"]];
	for (var i:Number = 0; i < regimenEstadistico.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codregimen", regimenEstadistico[i][0]);
			setValueBuffer("tipo", regimenEstadistico[i][1]);
			setValueBuffer("descripcion", regimenEstadistico[i][2]);
			commitBuffer();
		}
	}
}

function intrastat_beforeCommit_intrastat(curIntrastat:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curIntrastat.modeAccess() == curIntrastat.Del) {

		if (!this.iface.liberarAlbaranesIntrastat(curIntrastat.valueBuffer("idintrastat"))) {
			return false;
		}
	}
	return true;
}

function intrastat_liberarAlbaranesIntrastat(idIntrastat:String):Boolean
{
	var qryAlbaranesCli:FLSqlQuery = new FLSqlQuery();
	qryAlbaranesCli.setTablesList("albaranescli");
	qryAlbaranesCli.setSelect("idalbaran");
	qryAlbaranesCli.setFrom("albaranescli");
	qryAlbaranesCli.setWhere("idintrastat = " + idIntrastat);
	if (!qryAlbaranesCli.exec()) {
		return false;
	}
	while (qryAlbaranesCli.next()) {
		if (!this.iface.liberarAlbaran(qryAlbaranesCli.value("idalbaran"), "albaranescli")) {
			return false;
		}
	}

	var qryAlbaranesProv:FLSqlQuery = new FLSqlQuery();
	qryAlbaranesProv.setTablesList("albaranesprov");
	qryAlbaranesProv.setSelect("idalbaran");
	qryAlbaranesProv.setFrom("albaranesprov");
	qryAlbaranesProv.setWhere("idintrastat = " + idIntrastat);
	if (!qryAlbaranesProv.exec()) {
		return false;
	}
	while (qryAlbaranesProv.next()) {
		if (!this.iface.liberarAlbaran(qryAlbaranesProv.value("idalbaran"), "albaranesprov")) {
			return false;
		}
	}
	return true;
}

function intrastat_liberarAlbaran(idAlbaran:String, tabla:String):Boolean
{
	var curAlbaran:FLSqlCursor = new FLSqlCursor(tabla);	
	curAlbaran.setActivatedCommitActions(false);
	curAlbaran.setActivatedCheckIntegrity(false);
	curAlbaran.select("idalbaran = " + idAlbaran);
	if (!curAlbaran.first()) {
		return false;
	}
	var pteFactura:Boolean = curAlbaran.valueBuffer("ptefactura");
	if (!pteFactura) {
		curAlbaran.setUnLock("ptefactura", true);
	}
	curAlbaran.select("idalbaran = " + idAlbaran);
	if (!curAlbaran.first()) {
		return false;
	}
	curAlbaran.setModeAccess(curAlbaran.Edit);
	curAlbaran.refreshBuffer();
	curAlbaran.setNull("idintrastat");
	if (!curAlbaran.commitBuffer()) {
		return false;
	}	
	
	if (!pteFactura) {
		curAlbaran.select("idalbaran = " + idAlbaran);
		if (!curAlbaran.first()) {
			return false;
		}
		curAlbaran.setUnLock("ptefactura", false);
	}
	return true;
}

//// INTRASTAT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
