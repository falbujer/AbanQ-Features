/***************************************************************************
                 masternumerosserie.qs  -  description
                             -------------------
    begin                : lun abr 26 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
	var tableDBRecords:Object;
    function interna( context ) { this.ctx = context; }
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var chkNoVendidas:Object;
	var filtroAnterior:String;
    function oficial( context ) { interna( context ); } 
	function cambioChkNoVendidas() { this.ctx.oficial_cambioChkNoVendidas(); }
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
function interna_init()
{
	this.iface.filtroAnterior = this.cursor().mainFilter();

	if (!this.iface.filtroAnterior)
		this.iface.filtroAnterior = ""

//	this.cursor().setMainFilter("vendido = false");
	
	this.iface.chkNoVendidas = this.child("chkNoVendidas");
	this.iface.chkNoVendidas.checked = true;
	
	this.iface.tableDBRecords = this.child("tableDBRecords")
	
	connect(this.iface.chkNoVendidas, "clicked()", this, "iface.cambioChkNoVendidas");
	this.iface.cambioChkNoVendidas();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Filtra la tabla de referencias. Si est� activa la opci�n de 'S�lo unidades no vendidas' muestra los n�meros de referencia de las unidades no vendidas y refresca la tabla
\end */
function oficial_cambioChkNoVendidas()
{ 
	if(this.iface.chkNoVendidas.checked) {
		if (this.iface.filtroAnterior != "") {
			this.cursor().setMainFilter("vendido = false AND " + this.iface.filtroAnterior);
		} else {
			this.cursor().setMainFilter("vendido = false");
		}
	} else {
		this.cursor().setMainFilter(this.iface.filtroAnterior);
	}
		
	this.iface.tableDBRecords.refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
