/***************************************************************************
                 mastercalendario.qs  -  description
                             -------------------
    begin                : mar abr 10 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	
    function oficial( context ) { interna( context ); }
	
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration calendarioLab */
//////////////////////////////////////////////////////////////////
//// CALENDARIO_LAB /////////////////////////////////////////////////////
class calendarioLab extends oficial {
	var pbncalcula:Object;
    function calendarioLab( context ) { oficial( context ); }
	function init() {
		this.ctx.calendarioLab_init();
	}
	function calcularCalendario() {
		return this.ctx.oficial_calcularCalendario();
	}
	function crearDia(fecha:Date) {
		return this.ctx.oficial_crearDia(fecha);
	}
}
//// CALENDARIO_LAB /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends calendarioLab {
    function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C Si en la tabla de direcciones de clientes no hay todav�a ninguna direcci�n asociada al cliente, la primera direcci�n introducida se tomar� como direcci�n de facturaci�n y direcci�n de env�o
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition calendarioLab */
//////////////////////////////////////////////////////////////////
//// CALENDARIO_LAB /////////////////////////////////////////////////////
function calendarioLab_init(){

	this.iface.__init();
	this.iface.pbncalcular = this.child("pbnCalcularDias");
	connect(this.iface.pbncalcular, "clicked()", this, "iface.calcularCalendario()");
}

function calendarioLab_calcularCalendario()
{
	var util:FLUtil = new FLUtil;
	var hoy:Date = new Date;

	var dialog = new Dialog;
	dialog.caption = "Intervalo de Fechas";
	dialog.okButtonText = "Calcular"
	dialog.cancelButtonText = "Cancelar";
	
	var fecha1 = new DateEdit;
	fecha1.label = "Fecha Inicial: ";
	fecha1.date = hoy;
	dialog.add( fecha1 );

	var fecha2 = new DateEdit;
	fecha2.label = "Fecha Final: ";
	dialog.add( fecha2 );
	
	if (!dialog.exec())
		return false;

	var fechaInicial:Date = fecha1.date;
	var fechaFinal:Date = fecha2.date;
	if (!fechaInicial || fechaInicial == "" || !fechaFinal ||fechaFinal == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer las fechas inicial y final"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (util.daysTo(fechaInicial,hoy) > 0) {
		MessageBox.warning(util.translate("scripts", "La fecha inicial no puede ser anterior a la fecha actual"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var fechaCalculada:Date = fechaInicial;
 	var dias:Number = util.daysTo(fechaCalculada,fechaFinal);

	util.createProgressDialog(util.translate("scripts", "Regenerando Calendario"), dias);
	util.setProgress(0);
	var i:Number = 0;

	while (util.daysTo(fechaCalculada,fechaFinal) >= 0) {
		if(!this.iface.crearDia(fechaCalculada)) {
			util.destroyProgressDialog();
			return;
		}
		fechaCalculada = util.addDays(fechaCalculada,1);
		util.setProgress(i++);
	}
	util.setProgress(dias);
	util.destroyProgressDialog();
}

function calendarioLab_crearDia(fecha:Date)
{
	var util:FLUtil;
	var diaSemana:Number = fecha.getDay();
	var horaInicioManana:String = "";
	var horaFimManana:String = "";
	var horaInicioTarde:String = "";
	var horaFinTarde:String = "";
	var tiempo:Number = 0;

	var  horarioLaboral:String = util.sqlSelect("empresa","codhorariolaboral","1 = 1");
	var  horarioSabado:String = util.sqlSelect("empresa","codhorariosabado","1 = 1");
	var  horarioDomingo:String = util.sqlSelect("empresa","codhorariodomingo","1 = 1");
	var horario:String = "";
	if(!horarioLaboral || horarioLaboral == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer un tipo de horario para los dias laborales"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	switch (diaSemana) {
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
			horaInicioManana = util.sqlSelect("pr_horarios","horaentradamanana","codhorario = '" + horarioLaboral + "'");
			horaFinManana = util.sqlSelect("pr_horarios","horasalidamanana","codhorario = '" + horarioLaboral + "'");
			horaInicioTarde = util.sqlSelect("pr_horarios","horaentradatarde","codhorario = '" + horarioLaboral + "'");
			horaFinTarde = util.sqlSelect("pr_horarios","horasalidatarde","codhorario = '" + horarioLaboral + "'");
debug(horaFinTarde);
			tiempo = util.sqlSelect("pr_horarios","tiempo","codhorario = '" + horarioLaboral + "'");
			horario = horarioLaboral;
			
			break;
		case 6:
			if (horarioSabado && horarioSabado != "") {
				horaInicioManana = util.sqlSelect("pr_horarios","horaentradamanana","codhorario = '" + horarioSabado + "'");
				horaFinManana = util.sqlSelect("pr_horarios","horasalidamanana","codhorario = '" + horarioSabado + "'");
				horaInicioTarde = util.sqlSelect("pr_horarios","horaentradatarde","codhorario = '" + horarioSabado + "'");
				horaFinTarde = util.sqlSelect("pr_horarios","horasalidatarde","codhorario = '" + horarioSabado + "'");
				tiempo = util.sqlSelect("pr_horarios","tiempo","codhorario = '" + horarioSabado + "'");
			}
			else {
				horaInicioManana = "";
				horaFinManana = "";
				horaInicioTarde = "";
				horaFinTarde = "";
				horarioSabado = "";
				tiempo = 0;
			}
			horario = horarioSabado;
			break;
		case 7:
			if (horarioDomingo && horarioDomingo != "") {
				horaInicioManana = util.sqlSelect("pr_horarios","horaentradamanana","codhorario = '" + horarioDomingo + "'");
				horaFinManana = util.sqlSelect("pr_horarios","horasalidamanana","codhorario = '" + horarioDomingo + "'");
				horaInicioTarde = util.sqlSelect("pr_horarios","horaentradatarde","codhorario = '" + horarioDomingo + "'");
				horaFinTarde = util.sqlSelect("pr_horarios","horasalidatarde","codhorario = '" + horarioDomingo + "'");
				tiempo = util.sqlSelect("pr_horarios","tiempo","codhorario = '" + horarioDomingo + "'");
			}
			else {
				horaInicioManana = "";
				horaFinManana = "";
				horaInicioTarde = "";
				horaFinTarde = "";
				horarioDomingo = "";
				tiempo = 0;
			}
			horario = horarioDomingo;
			break;
		default:
			return;
	}

	var curCalendario:FLSqlCursor = new FLSqlCursor("pr_calendario");

	if (util.sqlSelect("pr_calendario","fecha","fecha = '" + fecha + "'")) {
		curCalendario.select("fecha = '" + fecha + "'");
		curCalendario.setModeAccess(curCalendario.Edit);
		if (!curCalendario.first())
			return;
		curCalendario.refreshBuffer();
	}
	else {
		curCalendario.setModeAccess(curCalendario.Insert);
		curCalendario.refreshBuffer();
		curCalendario.setValueBuffer("fecha",fecha);
	}

	var semana = [ "Lunes", "Martes", "Mi�rcoles", "Jueves", "Viernes", "S�bado", "Domingo" ];

	curCalendario.setValueBuffer("codhorario",horario);
	curCalendario.setValueBuffer("descripcion",semana[diaSemana - 1]);
	curCalendario.setValueBuffer("horaentradamanana",horaInicioManana);
	curCalendario.setValueBuffer("horasalidamanana",horaFinManana);
	curCalendario.setValueBuffer("horaentradatarde",horaInicioTarde);
	curCalendario.setValueBuffer("horasalidatarde",horaFinTarde);
	curCalendario.setValueBuffer("tiempo",tiempo);

	if (!curCalendario.commitBuffer())
		return false;

	return true;
}
//// CALENDARIO_LAB /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
