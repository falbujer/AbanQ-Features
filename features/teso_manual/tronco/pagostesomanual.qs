/***************************************************************************
                 pagostesomanual.qs  -  description
                             -------------------
    begin                : lun may 29 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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

/** @ file */

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
	function validateForm() { return this.ctx.interna_validateForm(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var ejercicioActual:String;
	var contabActivada:Boolean;
	var bngTasaCambio:Object;
	var divisaEmpresa:String;
	
	function oficial( context ) { interna( context ); } 
	function desconexion() {
		return this.ctx.oficial_desconexion();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function bngTasaCambio_clicked(opcion:Number) {
		return this.ctx.oficial_bngTasaCambio_clicked(opcion);
	}
	function asignarAsiento() {
		return this.ctx.oficial_asignarAsiento();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
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
/** \C El marco 'Contabilidad' se habilitará en caso de que esté cargado el módulo principal de contabilidad.
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	this.iface.bngTasaCambio = this.child("bngTasaCambio");
	this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
			
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	if (!this.iface.contabActivada) {
		this.child("tbwPagoTesoManual").setTabEnabled("contabilidad", false);
	}

	this.child("fdbTipo").setDisabled(true);
	this.child("fdbTasaConv").setDisabled(true);
	this.child("tdbPartidas").setReadOnly(true);

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconexion");
	connect(this.iface.bngTasaCambio, "clicked(int)", this, "iface.bngTasaCambio_clicked()");
	connect(this.child("tbnAsiento"), "clicked()", this, "iface.asignarAsiento");

	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagostesomanual");
	curPagosDevol.select("idrecibo = " + cursor.cursorRelation().valueBuffer("idrecibo") + " ORDER BY fecha, idpagodevol");
	var last:Boolean = false;
	if (curPagosDevol.last()) {
		last = true;
		curPagosDevol.setModeAccess(curPagosDevol.Browse);
		curPagosDevol.refreshBuffer();
	}
	switch (cursor.modeAccess()) {
	/** \C
	En modo inserción. Los pagos y devoluciones funcionan de forma alterna: un nuevo recibo generará un pago. El siguiente será una devolucion, después un pago y así sucesivamente
	\end */
		case cursor.Insert: {
			if (last) {
				if (curPagosDevol.valueBuffer("tipo") == "Pago") {
					this.child("fdbTipo").setValue("Devolución");
					this.child("fdbCodCuenta").setValue(util.sqlSelect("pagostesomanual", "codcuenta", "idrecibo = " + cursor.valueBuffer ("idrecibo") + " AND tipo = 'Pago' ORDER BY fecha DESC"));
				} else {
					this.child("fdbTipo").setValue("Pago");
					this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
					if (cursor.cursorRelation().valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
						this.child("fdbTasaConv").setDisabled(false);
						this.child("rbnTasaActual").checked = true;
						this.iface.bngTasaCambio_clicked(0);
					}
				}
				this.child("fdbFecha").setValue(util.addDays(curPagosDevol.valueBuffer("fecha"), 1));
			} else {
				this.child("fdbTipo").setValue("Pago");
				this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
				if (cursor.cursorRelation().valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
					this.child("fdbTasaConv").setDisabled(false);
					this.child("rbnTasaActual").checked = true;
					this.iface.bngTasaCambio_clicked(0);
				}
			}
			break;
		}
		case cursor.Edit: {
			break;
		}
	}
}

function interna_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	/** \C
	La fecha de un pago o devolución debe ser siempre posterior\na la fecha del pago o devolución anterior
	\end */
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagostesomanual");
	curPagosDevol.select("idrecibo = " + cursor.cursorRelation().valueBuffer("idrecibo") + " AND idpagodevol <> " + cursor.valueBuffer("idpagodevol") + " ORDER BY  fecha, idpagodevol");
	if (curPagosDevol.last()) {
		curPagosDevol.setModeAccess(curPagosDevol.Browse);
		curPagosDevol.refreshBuffer();
		if (util.daysTo(curPagosDevol.valueBuffer("fecha"), cursor.valueBuffer("fecha")) <= 0) {
			MessageBox.warning(util.translate("scripts", "La fecha de un pago o devolución debe ser siempre posterior\na la fecha del pago o devolución anterior."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}

	return true;
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var res:String;
	switch (fN) {
		case "codcuenta": {
			res = cursor.cursorRelation().valueBuffer("codcuentapago");
			break;
		}
		case "dc": {
			var entidad:String = cursor.valueBuffer("ctaentidad");
			var agencia:String = cursor.valueBuffer("ctaagencia");
			var cuenta:String = cursor.valueBuffer("cuenta");
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() 
					&& entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var util:FLUtil = new FLUtil();
				var dc1:String = util.calcularDC(entidad + agencia);
				var dc2:String = util.calcularDC(cuenta);
				res = dc1 + dc2;
			}
			break;
		}
	}
	return res;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconexion()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "codcuenta":
		case "ctaentidad":
		case "ctaagencia":
		case "cuenta": {
			this.child("fdbDc").setValue(this.iface.calculateField("dc"));
			break;
		}
	}
}

/** \D
Establece el valor de --tasaconv-- obteniéndolo de la factura original o del cambio actual de la divisa del recibo
@param	opcion: Origen de la tasa: tasa actual o tasa de la factura original
\end */
function oficial_bngTasaCambio_clicked(opcion:Number)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (opcion) {
	case 0: // Tasa actual
		this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + cursor.cursorRelation().valueBuffer("coddivisa") + "'"));
		break;
	case 1: // Tasa del recibo manual
		this.child("fdbTasaConv").setValue(util.sqlSelect("tesomanual", "tasaconv", "idrecibo = " + cursor.valueBuffer("idrecibo")));
		break;
	}
}

/* \D Muestra el formulario de busqueda de asientos contables, filtrando los asientos por ejercicio
\end */
function oficial_asignarAsiento()
{
	var f:Object = new FLFormSearchDB("co_asientos");
	var curAsientos:FLSqlCursor = f.cursor();
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	//curAsientos.setMainFilter("deabono = false and idfactura <> " + this.cursor().valueBuffer("idfactura") + masFiltro);

	f.setMainWidget();
	var idAsiento:String = f.exec("idasiento");

	if (idAsiento) {
		cursor.setValueBuffer("idasiento", idAsiento);
		this.child("tdbPartidas").refresh();
	}

}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////