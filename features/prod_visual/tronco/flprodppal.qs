
/** @class_declaration visual */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN VISUAL //////////////////////////////////////////
class visual extends oficial {
	var curPedidoProv_:FLSqlCursor;
	var curLineaPedidoProv_:FLSqlCursor;
    function visual( context ) { oficial ( context ); }
	function asignarCentroCosteTarea(iTarea:Number):Boolean {
		return this.ctx.visual_asignarCentroCosteTarea(iTarea);
	}
	function sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Number {
		return this.ctx.visual_sumarTiempo(fecha, tiempo, codCentro);
	}
	function iniciarCentrosCoste():Boolean {
		return this.ctx.visual_iniciarCentrosCoste();
	}
	function beforeCommit_pr_lineasplancompras(curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_beforeCommit_pr_lineasplancompras(curLC);
	}
	function crearCompraPlan(curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_crearCompraPlan(curLC);
	}
	function modificarCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean {
		return this.ctx.visual_modificarCompraPlan(curLC, usarPrevios);
	}
	function borrarCompraPlan(curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_borrarCompraPlan(curLC);
	}
	function crearLineaCompraPlan(idPedido:String, curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_crearLineaCompraPlan(idPedido, curLC);
	}
	function modificarLineaCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean {
		return this.ctx.visual_modificarLineaCompraPlan(curLC, usarPrevios);
	}
	function datosLineaCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean {
		return this.ctx.visual_datosLineaCompraPlan(curLC, usarPrevios);
	}
	function datosCompraPlan(curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_datosCompraPlan(curLC);
	}
	function totalesPedido():Boolean {
		return this.ctx.visual_totalesPedido();
	}
	function restriccionesConsumo():Boolean {
		return this.ctx.visual_restriccionesConsumo();
	}
}
//// PRODUCCIÓN VISUAL //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition visual */
/////////////////////////////////////////////////////////////////
//// PRODUCCION VISUAL //////////////////////////////////////////
function visual_asignarCentroCosteTarea(iTarea:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var codLote:String = this.iface.tareaMemo[iTarea]["codlote"];
	var idProceso:String = this.iface.tareaMemo[iTarea]["idproceso"];
	var iLote:Number;
	iLote = this.iface.buscarProceso(idProceso);
	if (iLote < 0) {
		MessageBox.warning(util.translate("scripts", "Error al buscar los datos del proceso %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];
	var xmlTarea:FLDomNode = this.iface.tareaMemo[iTarea]["xmltarea"];
	var eTarea:FLDomElement;	
	if (xmlTarea) {
		eTarea = xmlTarea.toElement();
		if (eTarea.attribute("Estado") == "Saltada") {
			this.iface.tareaMemo[iTarea]["asignada"] = true;
			this.iface.tareaMemo[iTarea]["saltada"] = true;
			return true;
		}
	}
	this.iface.tareaMemo[iTarea]["saltada"] = false;
	
	var referencia:String = this.iface.loteMemo[iLote]["referencia"];

	var fechaMinTarea:Date = this.iface.fechaMinimaTarea(iTarea);

	var qryCentros:FLSqlQuery = new FLSqlQuery;
	if (eTarea && eTarea.attribute("CodTipoCentro") != "") {
		with (qryCentros) {
			setTablesList("pr_centroscoste");
			setSelect("codcentro, codtipocentro");
			setFrom("pr_centroscoste");
			setWhere("codTipoCentro = '" + eTarea.attribute("CodTipoCentro") + "'");
			setForwardOnly(true);
		}
	} else {
		with (qryCentros) {
			setTablesList("pr_costestarea,pr_centroscoste");
			setSelect("cc.codcentro, ct.codtipocentro");
			setFrom("pr_costestarea ct INNER JOIN pr_centroscoste cc ON ct.codtipocentro = cc.codtipocentro");
			setWhere("ct.idtipotareapro = " + idTipoTareaPro);
			setForwardOnly(true);
		}
	}
	if (!qryCentros.exec()) {
		return false;
	}

	var minFechaInicio:Date = false;
	var minFechaFin:Date = false;
	var minICentro:Number = -1;
	var minTiempo:Number;

	var fechaFin:Date;
	var fechaInicio:Date;
	var minCentro:String;
	var iCentro:Number;
	var dia:Date;
	var tiempo:Number;
	var costeFijo:Number;
	var costeUnidad:Number;
	var codCentro:String;
	var tiempoTotalTarea:Number;

	while (qryCentros.next()) {

		codCentro = qryCentros.value(0);
		iCentro = this.iface.buscarCentroCoste(codCentro);

		if (iCentro < 0) {
			MessageBox.warning(util.translate("scripts", "Error al buscar los datos del centro de coste %1").arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}

		tiempo = this.iface.costeCentroTarea(qryCentros.value(1),referencia,iTarea,iLote,codCentro);
		if (tiempo == -2)
			return false;

		if (tiempo == -1)
			continue;
tiempo *= 1000; /// Paso a s
		tiempoTotalTarea = tiempo;
debug("Tiempo inicial " + tiempo);
		if (fechaMinTarea && this.iface.compararFechas(fechaMinTarea, this.iface.centroMemo[iCentro]["fechainicio"]) == 1) {
			fechaInicio = fechaMinTarea;
		} else {
			fechaInicio = this.iface.centroMemo[iCentro]["fechainicio"];
		}
		if (!util.sqlSelect("pr_calendario","fecha","1 = 1")) {
			MessageBox.warning(util.translate("scripts", "Antes de calcular el tiempo de finalización de la tarea debe generar el calendario laboral."), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		var tiempoFinDia:Number = -1;
		var masDias:Boolean = true;
		tiempoFinDia = this.iface.calcularRestoDia(fechaInicio);;
debug("tiempoFinDia " + tiempoFinDia);
		if (tiempoFinDia > tiempo) {
			// Hay tiempo para hacerlo en un sólo día
			fechaFin = this.iface.sumarTiempo(fechaInicio, tiempo, codCentro);
		} else {
			// No hay tiempo para hacerlo en un sólo día
			fechaFin = new Date(fechaInicio.getTime());
			tiempo -= tiempoFinDia;
			var qryCalendario:FLSqlQuery = new FLSqlQuery;
			qryCalendario.setTablesList("pr_calendario");
			qryCalendario.setSelect("fecha,tiempo");
			qryCalendario.setFrom("pr_calendario");
			qryCalendario.setWhere("fecha > '" + fechaFin + "' ORDER BY fecha ASC");
			if (!qryCalendario.exec())
				return -1;
	
			var buscarSiguienteDia:Boolean = true;
			if (!qryCalendario.first())
				buscarSiguienteDia = false;
	
			while (buscarSiguienteDia) {
debug("tiempo = " + tiempo);
debug("tiempo = " + qryCalendario.value("fecha") + " = " + qryCalendario.value("tiempo"));
				if (parseFloat(qryCalendario.value("tiempo")) <= tiempo && tiempo > 0) {
					tiempo -= parseFloat(qryCalendario.value("tiempo"));
					fechaFin = qryCalendario.value("fecha");
					if(!qryCalendario.next())
						buscarSiguienteDia = false;
				}
				else
					buscarSiguienteDia = false;
			}
			fechaFin = this.iface.buscarSiguienteTiempoInicio(fechaFin);
	
			fechaFin = this.iface.sumarTiempo(fechaFin, tiempo, codCentro);
		}
		if (!fechaFin)
			return false;
		if (minFechaFin && this.iface.compararFechas(minFechaFin, fechaFin) == 2)
			continue;
		minFechaInicio = fechaInicio;
		minFechaFin = fechaFin;
		minCodCentro = codCentro;
		minTiempo = tiempoTotalTarea;
		minICentro = iCentro;
	}
	if (minICentro < 0) {
		MessageBox.warning(util.translate("scripts", "No se ha podido asignar centro de coste a la tarea:\n%1\nAsociada al lote %2").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	this.iface.tareaMemo[iTarea]["codcentrocoste"] = minCodCentro;
	this.iface.tareaMemo[iTarea]["fechainicio"] = minFechaInicio;
	this.iface.tareaMemo[iTarea]["fechafin"] = minFechaFin;

	this.iface.tareaMemo[iTarea]["duracion"] = minTiempo;
	this.iface.tareaMemo[iTarea]["asignada"] = true;
	this.iface.centroMemo[minICentro]["fechainicio"] = minFechaFin;

	return true;
}

/** \D Suma el tiempo en milisegundos a una fecha, teniendo en cuena el horario del centro de coste
@param	fechaInicio: Fecha inicial
@param	tiempo: Tiempo en ms
@param	codCentro: Código de centro
@return	Fecha final
\end */
function visual_sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Date
{
	if (!fecha)
		return false;

debug("Sumar " + tiempo + " a " + fecha);
	var tiempoInicio:Number = fecha.getTime(); //Date.parse(fecha);
debug("Inicio " + tiempoInicio);
	var fechaFin:Date = this.iface.buscarSiguienteTiempoFin(fecha);
debug("Siguiente fin" + fechaFin);

	if (!fechaFin)
		return false;
	var tiempoFin:Number = fechaFin.getTime();

	var tiempoAux:Number = tiempoFin - tiempoInicio;

	if (tiempoAux >= tiempo) {
		tiempoFin = tiempoInicio + tiempo;
		fechaFin = new Date(tiempoFin);
		return fechaFin;
	}
	
	tiempo = tiempo - tiempoAux;

	var fechaInicio:Date = this.iface.buscarSiguienteTiempoInicio(fechaFin);
	if (!fechaInicio)
		return false;
	return this.iface.sumarTiempo(fechaInicio,tiempo,codCentro);
	
// 	var fecha:Date = new Date(tiempoFin);
// 	return fecha;
}

function visual_iniciarCentrosCoste():Boolean
{
	var util:FLUtil = new FLUtil;

	var qryCentros:FLSqlQuery = new FLSqlQuery;
	with (qryCentros) {
		setTablesList("pr_centroscoste");
		setSelect("codcentro");
		setFrom("pr_centroscoste");
		setWhere("1 = 1");
		setForwardOnly(true);
	}
	if (!qryCentros.exec())
		return false;

	var iCentro:Number = this.iface.centroMemo.length;
	var dMaxFechaPrev:Date;
	var sMaxFechaPrev:String;
	var maxFecha:String;
	var hoy:Date;
	while (qryCentros.next()) {
		this.iface.centroMemo[iCentro] = this.iface.nuevoCentroCoste();
		this.iface.centroMemo[iCentro]["codcentro"] = qryCentros.value("codcentro");
		this.iface.centroMemo[iCentro]["codtipocentro"] = qryCentros.value("codtipocentro");
		this.iface.centroMemo[iCentro]["idtipotareapro"] = qryCentros.value("idtipotareapro");
		this.iface.centroMemo[iCentro]["costeinicial"] = qryCentros.value("costeinicial");
		this.iface.centroMemo[iCentro]["costeunidad"] = qryCentros.value("costeunidad");

		var qryMaxFecha:FLSqlQuery = new FLSqlQuery;
		qryMaxFecha.setTablesList("pr_tareas");
		qryMaxFecha.setSelect("fechafinprev, horafinprev");
		qryMaxFecha.setFrom("pr_tareas");
		qryMaxFecha.setWhere("codcentro = '" + qryCentros.value("codcentro") + "' ORDER BY fechafinprev DESC, horafinprev DESC");
		qryMaxFecha.setForwardOnly(true);
		if (!qryMaxFecha.exec()) {
			return false;
		}
		if (qryMaxFecha.first()) {
			sMaxFechaPrev = qryMaxFecha.value("fechafinprev").toString().left(10) + "T" + qryMaxFecha.value("horafinprev").toString().right(8);
debug("MFP = " + sMaxFechaPrev );
debug("CODCENTRO = " + qryCentros.value("codcentro"));
			if (sMaxFechaPrev == "T00:00:00") {
				dMaxFechaPrev = new Date();
			} else {
				dMaxFechaPrev = new Date(Date.parse(sMaxFechaPrev));
			}
			hoy = new Date;
			if (this.iface.compararFechas(dMaxFechaPrev, hoy) == 2) {
				this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
			} else {
				this.iface.centroMemo[iCentro]["fechainicio"] = dMaxFechaPrev;
			}
		} else {
			this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
		}
debug("FINICIO CC = " + this.iface.centroMemo[iCentro]["fechainicio"]);
		iCentro++;
	}
	return true;
}

function visual_beforeCommit_pr_lineasplancompras(curLC:FLSqlCursor):Boolean
{
	/// Sincroniza los pedidos de compras con la línea de plan de compras
	var util:FLUtil = new FLUtil;
	var curTran:FLSqlCursor = new FLSqlCursor("empresa");
	curTran.transaction(false);
	try {
		switch (curLC.modeAccess()) {
			case curLC.Insert: {
				if (!this.iface.crearCompraPlan(curLC)) {
					curTran.rollback();
					return false;
				}
				break;
			}
			case curLC.Edit: {
				if (!this.iface.modificarCompraPlan(curLC)) {
					curTran.rollback();
					return false;
				}
				break;
			}
			case curLC.Del: {
				if (!this.iface.borrarCompraPlan(curLC)) {
					curTran.rollback();
					return false;
				}
				break;
			}
		}
		curTran.commit();
	} catch (e) {
		curTran.rollback();
		MessageBox.critical(util.translate("scripts", "La sincronización de compras con la línea de plan de compras ha fallado: ") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \D Crea una línea de pedido a proveedor asociada a los datos de una línea de plan de compras
@param	curLC: Cursor de la línea de plan de compras
\end */
function visual_crearCompraPlan(curLC:FLSqlCursor):Boolean
{
	var idLineaPP:String = curLC.valueBuffer("idlineapedido");
	if (!idLineaPP || idLineaPP == "") {
		if (!this.iface.curPedidoProv_) {
			this.iface.curPedidoProv_ = new FLSqlCursor("pedidosprov");
		}
		this.iface.curPedidoProv_.setModeAccess(this.iface.curPedidoProv_.Insert);
		this.iface.curPedidoProv_.refreshBuffer();
		if (!this.iface.datosCompraPlan(curLC)) {
			return false;
		}
		if (!this.iface.curPedidoProv_.commitBuffer()) {
			return false;
		}
		idPedido = this.iface.curPedidoProv_.valueBuffer("idpedido");
		curLC.setValueBuffer("idpedido", idPedido);
		if (!this.iface.crearLineaCompraPlan(idPedido, curLC)) {
			return false;
		}
		this.iface.curPedidoProv_.select("idpedido = " + idPedido);
		if (!this.iface.curPedidoProv_.first()) {
			return false;
		}
		this.iface.curPedidoProv_.setModeAccess(this.iface.curPedidoProv_.Edit);
		this.iface.curPedidoProv_.refreshBuffer();
		if (!this.iface.totalesPedido()) {
			return false;
		}
		if (!this.iface.curPedidoProv_.commitBuffer()) {
			return false;
		}
	} else {
		if (!this.iface.modificarCompraPlan(curLC)) {
			return false;
		}
	}
	return true;
}

/** \D Modifica un pedido de proveedor con respecto a una línea de plan de ventas
@param	curLC: Cursor de la línea de plan de ventas
@param	usarPrevios: Indica si usar los valores de cantidad y fecha previos o actuales
\end */
function visual_modificarCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	var idPedido:String = curLC.valueBuffer("idpedido");
	if (!idPedido || idPedido == "") {
		return false;
	}
	var idLineaPP:String = curLC.valueBuffer("idlineapedido");
	if (!idLineaPP || idLineaPP == "") {
		return false;
	}
	if (!this.iface.curPedidoProv_) {
		this.iface.curPedidoProv_ = new FLSqlCursor("pedidosprov");
	}
	this.iface.curPedidoProv_.select("idpedido = " + idPedido);
	if (!this.iface.curPedidoProv_.first()) {
		MessageBox.warning(util.translate("scripts", "Error al buscar el pedido de compras asociado a la línea de plan de compras"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.curPedidoProv_.setModeAccess(this.iface.curPedidoProv_.Edit);
	this.iface.curPedidoProv_.refreshBuffer();
	if (usarPrevios) {
		this.iface.curPedidoProv_.setValueBuffer("fechaentrada", curLC.valueBuffer("fechaprevia"));
	} else {
		this.iface.curPedidoProv_.setValueBuffer("fechaentrada", curLC.valueBuffer("fecha"));
	}
	if (!this.iface.modificarLineaCompraPlan(curLC, usarPrevios)) {
		return false;
	}
	if (!this.iface.totalesPedido()) {
		return false;
	}
	if (!this.iface.curPedidoProv_.commitBuffer()) {
		return false;
	}
	
	return true;
}

/** \D Borra o modifica una línea de pedido a proveedor asociada a los datos de una línea de plan de compras. Si la línea de plan no tenía datos previos de cantidad y fechas, la línea de pedido se borra. Si sí los tenía los valores previos son restiuidos
@param	curLC: Cursor de la línea de plan de compras
\end */
function visual_borrarCompraPlan(curLC:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idPedido:String = curLC.valueBuffer("idpedido");
	if (!idPedido || idPedido == "") {
		return false;
	}
	var idLineaPP:String = curLC.valueBuffer("idlineapedido");
	if (!idLineaPP || idLineaPP == "") {
		return false;
	}
	var canPrevia:Number = curLC.valueBuffer("canprevia");
	if (canPrevia == 0) {
		if (!util.sqlDelete("lineaspedidosprov", "idlinea = " + idLineaPP)) {
			return false;
		}
		if (!util.sqlDelete("pedidosprov", "idpedido = " + idPedido)) {
			return false;
		}
	} else {
		if (!this.iface.modificarCompraPlan(curLC, true)) {
			return false;
		}
	}
	return true;
}

/** \D Crea una línea de pedido de proveedor asociada a una línea del plan de compras
@param	idPedido: Identificador del pedido al que asociar la línea
@param	curLC: Cursor de la línea de plan de compras
\end */
function visual_crearLineaCompraPlan(idPedido:String, curLC:FLSqlCursor):Boolean
{
	if (!this.iface.curLineaPedidoProv_) {
		this.iface.curLineaPedidoProv_ = new FLSqlCursor("lineaspedidosprov");
	}
	this.iface.curLineaPedidoProv_.setModeAccess(this.iface.curLineaPedidoProv_.Insert);
	this.iface.curLineaPedidoProv_.refreshBuffer();
	this.iface.curLineaPedidoProv_.setValueBuffer("idpedido", idPedido);
	if (!this.iface.datosLineaCompraPlan(curLC)) {
		return false;
	}
	if (!this.iface.curLineaPedidoProv_.commitBuffer()) {
		return false;
	}
	var idLinea:String = this.iface.curLineaPedidoProv_.valueBuffer("idlinea");
	curLC.setValueBuffer("idlineapedido", idLinea);
	return true;
}

/** \D Modifica una línea de pedido de proveedor asociada a una línea del plan de compras
@param	curLC: Cursor de la línea de plan de compras
@param	usarPrevios: Indica si usar los valores de cantidad y fecha previos o actuales
\end */
function visual_modificarLineaCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean
{
	if (!this.iface.curLineaPedidoProv_) {
		this.iface.curLineaPedidoProv_ = new FLSqlCursor("lineaspedidosprov");
	}
	this.iface.curLineaPedidoProv_.select("idlinea = " + curLC.valueBuffer("idlineapedido"));
debug("select lineapedprov idlinea = " + curLC.valueBuffer("idlineapedido"));
	if (!this.iface.curLineaPedidoProv_.first()) {
debug("no está");
		return false;
	}
	this.iface.curLineaPedidoProv_.setModeAccess(this.iface.curLineaPedidoProv_.Edit);
	this.iface.curLineaPedidoProv_.refreshBuffer();
	if (!this.iface.datosLineaCompraPlan(curLC, usarPrevios)) {
debug("!datosLineaCompraPlan");
		return false;
	}
	if (!this.iface.curLineaPedidoProv_.commitBuffer()) {
debug("!curLineaPedidoProv_.commitBuffer");
		return false;
	}
	return true;
}

function visual_datosLineaCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;

	var codProveedor:String = util.sqlSelect("pedidosprov", "codproveedor", "idpedido = " + this.iface.curLineaPedidoProv_.valueBuffer("idpedido"));

	var referencia:String = curLC.valueBuffer("referencia");
	var qryArticulo:FLSqlQuery = new FLSqlQuery;
	qryArticulo.setTablesList("articulos");
	qryArticulo.setSelect("descripcion, codimpuesto");
	qryArticulo.setFrom("articulos");
	qryArticulo.setWhere("referencia = '" + referencia + "'");
	qryArticulo.setForwardOnly(true);
	if (!qryArticulo.exec()) {
		return false;
	}
	if (!qryArticulo.first()) {
		return false;
	}
	
	with (this.iface.curLineaPedidoProv_) {
		if (usarPrevios) {
			setValueBuffer("cantidad", curLC.valueBuffer("canprevia"));
		} else {
			setValueBuffer("cantidad", curLC.valueBuffer("cantidad"));
		}
		setValueBuffer("referencia", referencia);
		setValueBuffer("descripcion", qryArticulo.value("descripcion"));
		setValueBuffer("codimpuesto", qryArticulo.value("codimpuesto"));
		setValueBuffer("iva", formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", this));
		setValueBuffer("recargo", formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", this));
		setValueBuffer("irpf", formRecordlineaspedidosprov.iface.pub_commonCalculateField("irpf", this));
		setValueBuffer("dtopor", formRecordlineaspedidosprov.iface.pub_commonCalculateField("dtopor", this));
		setValueBuffer("porcomision", formRecordlineaspedidosprov.iface.pub_commonCalculateField("porcomision", this));
		setValueBuffer("pvpunitario", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpunitario", this));
		setValueBuffer("pvpsindto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpsindto", this));
		setValueBuffer("pvptotal", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", this));
	}
	return true;
}

function visual_datosCompraPlan(curLC:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var codProveedor:String = curLC.valueBuffer("codproveedor");
	
	var qryProveedor:FLSqlQuery = new FLSqlQuery;
	qryProveedor.setTablesList("proveedores");
	qryProveedor.setSelect("codserie, codpago, coddivisa, cifnif, nombre");
	qryProveedor.setFrom("proveedores");
	qryProveedor.setWhere("codproveedor = '" + codProveedor + "'");
	qryProveedor.setForwardOnly(true);
	if (!qryProveedor.exec()) {
		return false;
	}
	if (!qryProveedor.first()) {
		return false;
	}
	
	var codSerie:String = qryProveedor.value("codserie");
	if (!codSerie) {
		codSerie = flfactppal.iface.pub_valorDefectoEmpresa("codserie");
	}
	var codPago:String = qryProveedor.value("codpago");
	if (!codPago) {
		codPago = flfactppal.iface.pub_valorDefectoEmpresa("codpago");
	}
	var codDivisa:String = qryProveedor.value("coddivisa");
	if (!codDivisa) {
		codDivisa = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
	}
	var tasaConv:String = util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + codDivisa + "'");
	var codEjercicio:FLSqlCursor = flfactppal.iface.pub_ejercicioActual();
	var hoy:Date = new Date;
	var codAlmacen:String;
	if (curLC.cursorRelation()) {
		codAlmacen = curLC.cursorRelation().valueBuffer("codalmacen");
	} else {
		codAlmacen = util.sqlSelect("pr_plancompras", "codalmacen", "idplan = " + curLC.valueBuffer("idplan"));
	}
	
	with (this.iface.curPedidoProv_) {
		setValueBuffer("codserie", codSerie);
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("fecha", hoy.toString());
		setValueBuffer("codalmacen", codAlmacen);
		setValueBuffer("codpago", codPago);
		setValueBuffer("coddivisa", codDivisa);
		setValueBuffer("tasaconv", tasaConv);
		setValueBuffer("codproveedor", codProveedor);
		setValueBuffer("cifnif", qryProveedor.value("cifnif"));
		setValueBuffer("nombre", qryProveedor.value("nombre"));
		setValueBuffer("fechaentrada", curLC.valueBuffer("fecha"));
	}
	return true;
}

/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function visual_totalesPedido():Boolean
{
	with (this.iface.curPedidoProv_) {
		setValueBuffer("neto", formpedidosprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formpedidosprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formpedidosprov.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formpedidosprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formpedidosprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidosprov.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}

/** \D Establece secuencias entre tareas de distintos procesos de producción cuando los lotes de dichos procesos son unos consumos de los otros, para evitar planificar el lote producto antes que el lote consumo
\end */
function visual_restriccionesConsumo():Boolean
{
	var util:FLUtil = new FLUtil;
	var codLote:String;
	var idProceso:Number;
	var idTipoTareaPro:String;
	var idProceso:Number;
	var iTarea:Number;
	var iLoteComsumo:Number;
	var estadoLoteConsumo:String;
	var codLoteConsumo:Number;
	var qryConsumos:FLSqlQuery = new FLSqlQuery;
	
	for (iLote = 0; iLote < this.iface.loteMemo.length; iLote++) {
		codLote = this.iface.loteMemo[iLote]["codlote"];
		idProceso = this.iface.loteMemo[iLote]["idproceso"];
		with (qryConsumos) {
			setTablesList("movistock");
			setSelect("ms.codlote, a.idtipoproceso, ac.idtipotareapro");
			setFrom("movistock ms INNER JOIN articuloscomp ac ON ms.idarticulocomp = ac.id INNER JOIN articulos a ON ac.refcomponente = a.referencia");
			setWhere("ms.codloteprod = '" + codLote + "' AND ms.idproceso = " + idProceso + " AND a.fabricado = true");
			setForwardOnly(true);
		}
		if (!qryConsumos.exec()) {
			return false;
		}
		while (qryConsumos.next()) {
			idTipoTareaPro = qryConsumos.value("ac.idtipotareapro");
			iTarea = this.iface.buscarTarea(codLote, idTipoTareaPro);
			if (iTarea < 0) {
				MessageBox.warning(util.translate("scripts", "Restricciones de consumo: Error al buscar la tarea:\n%1\nAsiciada al lote %2.").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}

			codLoteConsumo = qryConsumos.value("ms.codlote");
			idProceso = util.sqlSelect("pr_procesos", "idproceso", "idtipoproceso = '" + qryConsumos.value("a.idtipoproceso") + "' AND idobjeto = '" + codLoteConsumo + "' AND estado <> 'OFF'");
			if (idProceso && !isNaN(idProceso)) {
	///// POR HACER
			} else {
				iLoteComsumo = this.iface.buscarLote(codLoteConsumo);
				estadoLoteConsumo = util.sqlSelect("lotesstock","estado","codlote = '" + codLoteConsumo + "'");
/// Controlar que si el lote no está terminado esté en la orden y asociado a un proceso de tipo Fabricación
// 				if (estadoLoteConsumo != "TERMINADO"){
// 					if (iLoteComsumo < 0) {
// 						MessageBox.warning(util.translate("scripts", "Para fabricar el lote %1 es necesario tener disponible el lote %2.\nDicho lote no está fabricado ni incluido en esta orden.").arg(codLote).arg(codLoteConsumo), MessageBox.Ok, MessageBox.NoButton);
// 						return false;
// 					}
// 				}
				var tareasFin:Array = this.iface.tareasFinales(codLoteConsumo);
				if (tareasFin.length > 0) {
					for (var i:Number = 0; i < tareasFin.length; i++) {
						if (!this.iface.establecerSecuencia(tareasFin[i], iTarea))
							return false;
				
					}
				}
			}
		}
	}
	return true;
}

//// PRODUCCION VISUAL //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
