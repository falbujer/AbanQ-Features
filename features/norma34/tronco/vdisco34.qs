/***************************************************************************
                      vdisco34.qs  -  description
                             -------------------
    begin                : mar jun 03 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
	function acceptedForm() { return this.ctx.interna_acceptedForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var zonaACabecera:String;
	var zonaBCabecera:String;
	var zonaCCabecera:String;
	var zonaDCabecera:String;
	var zonaABeneficiario:String;
	var zonaBBeneficiario:String;
	var zonaCBeneficiario:String;
	var zonaDBeneficiario:String;
	var restoDireccion:String;
	var sumaImportes:Number;
	var sumaRegistros:Number;
	var sumaRegistros010:Number;
	const tamRegistro:Number = 72;

    function oficial( context ) { interna( context ); }
	function establecerFichero() {
		return this.ctx.oficial_establecerFichero();
	}
	function cabeceraOrdenante1():String {
		return this.ctx.oficial_cabeceraOrdenante1();
	}
	function cabeceraOrdenante2():String {
		return this.ctx.oficial_cabeceraOrdenante2();
	}
	function cabeceraOrdenante3():String {
		return this.ctx.oficial_cabeceraOrdenante3();
	}
	function cabeceraOrdenante4():String {
		return this.ctx.oficial_cabeceraOrdenante4();
	}
	function registroBeneficiario1(curRecibo:FLSqlCursor):String {
		return this.ctx.oficial_registroBeneficiario1(curRecibo);
	}
	function registroBeneficiario2(curRecibo:FLSqlCursor):String {
		return this.ctx.oficial_registroBeneficiario2(curRecibo);
	}
	function registroBeneficiario3(curRecibo:FLSqlCursor):String {
		return this.ctx.oficial_registroBeneficiario3(curRecibo);
	}
	function registroBeneficiario4(curRecibo:FLSqlCursor):String {
		return this.ctx.oficial_registroBeneficiario4(curRecibo);
	}
	function registroBeneficiario5(curRecibo:FLSqlCursor):String {
		return this.ctx.oficial_registroBeneficiario5(curRecibo);
	}
	function registroBeneficiario6(curRecibo:FLSqlCursor):String {
		return this.ctx.oficial_registroBeneficiario6(curRecibo);
	}
	function registroBeneficiario7(curRecibo:FLSqlCursor):String {
		return this.ctx.oficial_registroBeneficiario7(curRecibo);
	}
	function registroBeneficiario8(curRecibo:FLSqlCursor):String {
		return this.ctx.oficial_registroBeneficiario8(curRecibo);
	}
	function eliminarCharRaros(cadena:String):String {
		return this.ctx.oficial_eliminarCharRaros(cadena);
	}
	function registroTotales():String {
		return this.ctx.oficial_registroTotales();
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
/** \D No de muestran los botones est�ndar de un formulario de registro
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil;
	with(form) {
		child("fdbDivisa").setDisabled(true);
		child("pushButtonAcceptContinue").close();
		child("pushButtonFirst").close();
		child("pushButtonLast").close();
		child("pushButtonNext").close();
		child("pushButtonPrevious").close();
		connect(child("pbnExaminar"), "clicked()", this, "iface.establecerFichero");
	}
}

/** \C El nombre del fichero de destino debe indicarse
\end */
function interna_validateForm():Boolean
{
	if (this.child("ledFichero").text.isEmpty()) {
		var util:FLUtil = new FLUtil();
		MessageBox.warning(util.translate("scripts", "Hay que indicar el fichero."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	/*
	if (!flfactteso.iface.pub_comprobarCuentasDom(this.cursor().valueBuffer("idremesa")))
		return false;
	*/
	return true;
}

/** \C Se genera el fichero de texto con los datos de la remesa en el fichero especificado
\end */
function interna_acceptedForm()
{
	var file = new File(this.child("ledFichero").text);
	file.open(File.WriteOnly);

	var incluirConcepto = this.child("chkConcepto").checked;
	
	this.iface.zonaACabecera = "03";
	this.iface.zonaBCabecera = "56";
	var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
	this.iface.zonaCCabecera = flfactppal.iface.pub_espaciosDerecha(cifnif, 10);
	this.iface.zonaDCabecera = flfactppal.iface.pub_espaciosDerecha("", 12);

	this.iface.zonaABeneficiario = "06";
	this.iface.zonaCBeneficiario = this.iface.zonaCCabecera;

	this.iface.sumaImportes = 0;
	this.iface.sumaRegistros = 0;
	this.iface.sumaRegistros010 = 0;

	var datos:String = "";

	datos = this.iface.cabeceraOrdenante1();
	if(!datos || datos.length != this.iface.tamRegistro){
		debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
		debug("Cadena ***" + datos + "***");
		return;
	}
	file.write(datos + "\r\n");
	
	datos = this.iface.cabeceraOrdenante2();
	if(!datos || datos.length != this.iface.tamRegistro){
		debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
		debug("Cadena ***" + datos + "***");
		return;
	}
	file.write(datos + "\r\n");

	datos = this.iface.cabeceraOrdenante3();
	if(!datos || datos.length != this.iface.tamRegistro){
		debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
		debug("Cadena ***" + datos + "***");
		return;
	}
	file.write(datos + "\r\n");

	datos = this.iface.cabeceraOrdenante4();
	if(!datos || datos.length != this.iface.tamRegistro){
		debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
		debug("Cadena ***" + datos + "***");
		return;
	}
	file.write(datos + "\r\n");

	var curRecibos:FLSqlCursor = new FLSqlCursor("recibosprov");
	curRecibos.select("idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + this.cursor().valueBuffer("idremesa") + ")");
	while (curRecibos.next()) {
		this.iface.restoDireccion = "";
		var cifnifBen:String = curRecibos.valueBuffer("cifnif");
		this.iface.zonaDBeneficiario = flfactppal.iface.pub_espaciosDerecha(cifnifBen, 12);
		
		// ZonaB: 56-Transferencia
		//		  57-Cheque bancario
		//		  58-Pagar�
		//		  59-Pago certificado	
		var tipoOperacion:String = curRecibos.valueBuffer("tipooperacion");
		switch (tipoOperacion) {
			case "N�minas y Transferencias": {
				this.iface.zonaBBeneficiario = "56";
				break;
			}
			case "Cheques bancarios": {
				this.iface.zonaBBeneficiario = "57";
				break;
			}
			case "Pagar�s": {
				this.iface.zonaBBeneficiario = "58";
				break;
			}
			case "Pagos certificados": {
				this.iface.zonaBBeneficiario = "59";
				break;
			}
			default: {
				MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Tipo de operaci�n.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibos.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
		datos = this.iface.registroBeneficiario1(curRecibos);
		if(!datos) {
			return;
		}
		if (datos.length != this.iface.tamRegistro){
			debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
			debug("Cadena ***" + datos + "***");
			return;
		}
		file.write(datos + "\r\n");
	
		datos = this.iface.registroBeneficiario2(curRecibos);
		if(!datos) {
			return;
		}
		if (datos.length != this.iface.tamRegistro){
			debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
			debug("Cadena ***" + datos + "***");
			return;
		}
		file.write(datos + "\r\n");

		datos = this.iface.registroBeneficiario3(curRecibos);
		if(!datos) {
			return;
		}
		if (datos.length != this.iface.tamRegistro){
			debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
			debug("Cadena ***" + datos + "***");
			return;
		}
		file.write(datos + "\r\n");

		if(this.iface.restoDireccion && this.iface.restoDireccion != "") {
			datos = this.iface.registroBeneficiario4(curRecibos);
			if(!datos) {
				return;
			}
			if (datos.length != this.iface.tamRegistro){
				debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
				debug("Cadena ***" + datos + "***");
				return;
			}
			file.write(datos + "\r\n");
		}

		datos = this.iface.registroBeneficiario5(curRecibos);
		if(!datos) {
			return;
		}
		if (datos.length != this.iface.tamRegistro){
			debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
			debug("Cadena ***" + datos + "***");
			return;
		}
		file.write(datos + "\r\n");

		datos = this.iface.registroBeneficiario6(curRecibos);
		if(!datos) {
			return;
		}
		if (datos.length != this.iface.tamRegistro){
			debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
			debug("Cadena ***" + datos + "***");
			return;
		}
		file.write(datos + "\r\n");
		
		if (incluirConcepto) {
			datos = this.iface.registroBeneficiario7(curRecibos);
			if(!datos) {
				return;
			}
			if (datos.length != this.iface.tamRegistro){
				debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
				debug("Cadena ***" + datos + "***");
				return;
			}
			file.write(datos + "\r\n");
			
			datos = this.iface.registroBeneficiario8(curRecibos);
			if(!datos) {
				return;
			}
			if (datos.length != this.iface.tamRegistro){
				debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
				debug("Cadena ***" + datos + "***");
				return;
			}
			file.write(datos + "\r\n");
		}
	}

	datos = this.iface.registroTotales();
	if(!datos || datos.length != this.iface.tamRegistro){
		debug("Longitud: " + datos.length + " de " + this.iface.tamRegistro);
		debug("Cadena ***" + datos + "***");
		return;
	}
	file.write(datos + "\r\n");

	file.close();

    // Genera copia del fichero en codificacion ISO
    // ### Por hacer: Incluir mas codificaciones
    file.open( File.ReadOnly );
    var content = file.read();
    file.close();

    var fileIso = new File( this.child("ledFichero").text + ".iso8859" );

    fileIso.open(File.WriteOnly);
    fileIso.write( sys.fromUnicode( content, "ISO-8859-15" ) );
    fileIso.close();

	var util:FLUtil = new FLUtil();
	MessageBox.information(util.translate("scripts", "Generado fichero de Cuaderno 34 en :\n\n" + this.child("ledFichero").text + "\n\n"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_establecerFichero()
{
	this.child("ledFichero").text = FileDialog.getSaveFileName("*.*");
}

/** \D Crea el texto de cabecera 1 del cliente ordenante
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraOrdenante1():String
{
	var util:FLUtil = new FLUtil();
	
	var date:Date = new Date();
	var fechaG = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);

	var fechaRemesa:Date = this.cursor().valueBuffer("fecha");
	var fechaE = flfactppal.iface.pub_cerosIzquierda(fechaRemesa.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(fechaRemesa.getMonth().toString(), 2) + fechaRemesa.getYear().toString().right(2);

	var codCuenta:String = this.cursor().valueBuffer("codCuenta");
	if(!codCuenta || codCuenta == "") {
		MessageBox.warning(util.translate("scripts", "Error al obtener la cuenta de cargo."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var cuenta:String = util.sqlSelect("cuentasbanco","cuenta","codcuenta = '" + codCuenta + "'");
	if(!cuenta)
		return false;
	var entidad:String = util.sqlSelect("cuentasbanco","ctaentidad","codcuenta = '" + codCuenta + "'");
	if(!entidad)
		return false;
	var oficina:String = util.sqlSelect("cuentasbanco","ctaagencia","codcuenta = '" + codCuenta + "'");
	if(!oficina)
		return false;
	var dc:String = util.calcularDC(entidad + oficina) + util.calcularDC(cuenta);
	if(!dc)
		return false;
	
	var reg:String = this.iface.zonaACabecera + this.iface.zonaBCabecera +this.iface.zonaCCabecera + this.iface.zonaDCabecera;
	// Zona E: (3 d�gitos/ NUM) N�mero de dato = 001.
	reg += "001";
	// Zona F: (36 d�gitos)
	// Zona F1: (6 d�gitos) Fecha de creaci�n del fichero (DDMMAA).
	reg += fechaG;
	// Zona F2: (6 d�gitos) Fecha de emisi�n de las �rdenes (DDMMAA).
	reg += fechaE;
	// Zona F3: (4 d�gitos) C�digo del banco ordenante (Num�rico-ceros izda.).
	reg += entidad;
	// Zona F4: (4 d�gitos) C�digo de oficina ordenante (Num�rico-ceros izda.).
	reg += oficina;
	// Zona F5: (10 d�gitos) C�digo de cuenta ordenante (Num�rico-ceros izda.).
	reg += cuenta;
	// Zona F6: (1 d�gitos) Detalle del cargo: 0 = Un s�lo apunte contable, 1 = Un apunte contable por Beneficiario
	reg += "1";
	// Zona F7: (3 d�gitos) Libre.
	reg += flfactppal.iface.pub_espaciosDerecha("", 3);
	// Zona F8: (2 d�gitos) DC. (D�gitos de dontrol de la cuenta de ordenante).
	reg += dc;
	// G: (7 d�gitos) Libre.
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto de cabecera 2 del cliente ordenante
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraOrdenante2():String
{
	var util:FLUtil = new FLUtil();
	
	var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
	nombre = nombre.toString().toUpperCase();
	if(nombre.length > 36)
		nombre = nombre.left(36);

	var reg:String = this.iface.zonaACabecera + this.iface.zonaBCabecera +this.iface.zonaCCabecera + this.iface.zonaDCabecera;
	// Zona E: (3 d�gitos/ NUM) N�mero de dato = 002.
	reg += "002";
	// Zona F: (36 d�gitos) Nombre del ordenante. Ajustado a la izquierda
	reg += flfactppal.iface.pub_espaciosDerecha(nombre, 36);
	// G: (7 d�gitos) Libre.
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto de cabecera 3 del cliente ordenante
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraOrdenante3():String
{
	var util:FLUtil = new FLUtil();
	
	var domicilio:String = flfactppal.iface.pub_valorDefectoEmpresa("direccion");
	domicilio = domicilio.toString().toUpperCase();
	if(domicilio.length > 36)
		domicilio = domicilio.left(36);

	var reg:String = this.iface.zonaACabecera + this.iface.zonaBCabecera +this.iface.zonaCCabecera + this.iface.zonaDCabecera;
	// Zona E: (3 d�gitos/ NUM) N�mero de dato = 002.
	reg += "003";
	// Zona F: (36 d�gitos) Domicilio del ordenante. Ajustado a la izquierda
	reg += flfactppal.iface.pub_espaciosDerecha(domicilio, 36);
	// G: (7 d�gitos) Libre.
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto de cabecera 4 del cliente ordenante
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraOrdenante4():String
{
	var util:FLUtil = new FLUtil();
	
	var ciudad:String = flfactppal.iface.pub_valorDefectoEmpresa("ciudad");
	ciudad = ciudad.toString().toUpperCase();
	if(ciudad.length > 36)
		ciudad = ciudad.left(36);

	var reg:String = this.iface.zonaACabecera + this.iface.zonaBCabecera +this.iface.zonaCCabecera + this.iface.zonaDCabecera;
	// Zona E: (3 d�gitos/ NUM) N�mero de dato = 004.
	reg += "004";
	// Zona F: (36 d�gitos) Plaza del ordenante. Ajustado a la izquierda
	reg += flfactppal.iface.pub_espaciosDerecha(ciudad, 36);
	// G: (7 d�gitos) Libre.
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto del primer registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroBeneficiario1(curRecibo:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var importe:Number = parseFloat(curRecibo.valueBuffer("importe"));
// 	importe = parseFloat(util.roundFieldValue(importe,"recibosprov","importe") * 100);
	importe = parseFloat(util.roundFieldValue(importe * 100,"recibosprov","importe"));
	this.iface.sumaImportes = parseFloat((parseFloat(this.iface.sumaImportes) + importe));
// 	if(importe < 0)
// 		importe = importe * -1;

	var gastos:String = curRecibo.valueBuffer("gastos");
	var opcionGastos:String;
	switch (gastos) {
		case "Ordenante" : {
			opcionGastos = "1";
			break;
		}
		case "Beneficiario" : {
			opcionGastos = "2";
			break;
		}
		default: {
			MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Gastos.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
			return false;
			break;
		}
	}
	
	var date:Date = curRecibo.valueBuffer("fecha");
	var fechaV = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);

	var reg:String = this.iface.zonaABeneficiario + this.iface.zonaBBeneficiario + this.iface.zonaCBeneficiario + this.iface.zonaDBeneficiario;

	// Zona E: N�mero de dato (3 d�gitos) = 010
	reg += "010";
	// Zona F: Datos del abono.
	// Zona F1: (12 d�gitos) Importe con dos posiciones decimales con c�ntimos a ceros (para pesetas) ajustados a la dcha. y relleno con ceros por la izda.
	reg += flfactppal.iface.pub_cerosIzquierda(importe, 12);

	if (this.iface.zonaBBeneficiario == "56") {
		var entidad:String = curRecibo.valueBuffer("ctaentidad"); 
		var oficina:String = curRecibo.valueBuffer("ctaagencia");
		var cuenta:String = curRecibo.valueBuffer("cuenta");
		// Zona F2: (4 d�gitos) C�digo de Banco Beneficiario, Num�rico y ajustado con ceros por la izda. (Obligatorio en Transferencias)
		reg += flfactppal.iface.pub_cerosIzquierda(entidad, 4);
		// Zona F3: (4 d�gitos) C�digo de oficina, num�rico con ceros por la Izda. (Obligatorio en Transferencias)
		reg += flfactppal.iface.pub_cerosIzquierda(oficina, 4);
		// Zona F4: (10 d�gitos) N�mero de Cta.,Num�rico con ceros por la Izda. (Obligatorio en Transferencias)
		reg += flfactppal.iface.pub_cerosIzquierda(cuenta, 10);
	}
	else {
		// Libre si no es Transferencia.
		reg += flfactppal.iface.pub_espaciosDerecha("", 18);
	}

	// Zona F5: (1 d�gito) Gastos 1/2 ....Ordenante/Beneficiario.
	reg += opcionGastos;
	// Zona F6: (1 d�gito) Conceptos de la orden 1=Nomina, 8=Pensi�n, 9=Otros conceptos
	reg += "9";
	// Zona F7: (1 d�gito) Signo del importe: (+ � espacio)/(-) post/negat. (No es Std) (En CSB, libre, rellenos a blancos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 2);

	if (this.iface.zonaBBeneficiario == "56") {
		var dc:String = curRecibo.valueBuffer("dc");
		// Zona F8: (2 d�gitos) D.C. (D�gitos de Control de la Cuenta). (Obligatorio en Transferencias)
		reg += flfactppal.iface.pub_cerosIzquierda(dc, 2);
	}
	else {
		// Libre si no es Transferencia.
		reg += flfactppal.iface.pub_espaciosDerecha("", 2);
	}

	// Zona G: (7 d�gitos) Fecha de vencimiento (DDMMAA)
	reg += flfactppal.iface.pub_espaciosDerecha(fechaV, 7);
	

	this.iface.sumaRegistros010++;
	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto del segundo registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroBeneficiario2(curRecibo:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var nombreProv:String = curRecibo.valueBuffer("nombreproveedor");
	if (!nombreProv || nombreProv == "") {
		MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Nombre del proveedor.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	nombreProv = nombreProv.toString().toUpperCase();
	nombreProv = nombreProv.left(36);

	var reg:String = this.iface.zonaABeneficiario + this.iface.zonaBBeneficiario + this.iface.zonaCBeneficiario + this.iface.zonaDBeneficiario;
	// Zona E: N�mero de dato (3 d�gitos) = 011
	reg += "011";
	// Zona F: Nombre del beneficiario. Ajustado a la izquierda, completado con blancos-
	reg += flfactppal.iface.pub_espaciosDerecha(nombreProv, 36)
	// Zona G: (7 d�gitos) Fecha del Concepto (DDMMAA) (No es Std) (En CSB, libre, rellenos a blancos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;	
	return reg;
}

/** \D Crea el texto del tercer registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroBeneficiario3(curRecibo:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var direccion:String = curRecibo.valueBuffer("direccion");
	if (!direccion || direccion == "") {
		MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Direcci�n.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	direccion = direccion.toString().toUpperCase();
	this.iface.restoDireccion = direccion.right(direccion.length - 36);
	direccion = direccion.left(36);

	var date:Date = curRecibo.valueBuffer("fecha");
	var fecha = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);
	
	var reg:String = this.iface.zonaABeneficiario + this.iface.zonaBBeneficiario + this.iface.zonaCBeneficiario + this.iface.zonaDBeneficiario;
	// Zona E: N�mero de dato (3 d�gitos) = 012
	reg += "012";
	// Zona F: Direccion del beneficiario. Ajustado a la izquierda, completado con blancos-
	reg += flfactppal.iface.pub_espaciosDerecha(direccion, 36)
	// Zona G: (7 d�gitos) Libre.
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);
	
	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto del cuarto registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroBeneficiario4(curRecibo:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	
	this.iface.restoDireccion = this.iface.restoDireccion.left(36);

	var reg:String = this.iface.zonaABeneficiario + this.iface.zonaBBeneficiario + this.iface.zonaCBeneficiario + this.iface.zonaDBeneficiario;
	// Zona E: N�mero de dato (3 d�gitos) = 013
	reg += "013";
	// Zona F: Resto de la direcci�n del beneficiario. Ajustado a la izquierda, completado con blancos-
	reg += flfactppal.iface.pub_espaciosDerecha(this.iface.restoDireccion, 36)
	// Zona G: (7 d�gitos) Libre.
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);
	
	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto del quinto registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroBeneficiario5(curRecibo:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var codPostal:String = curRecibo.valueBuffer("codpostal");
	if (!codPostal || codPostal == "") {
		MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: C�digo Postal.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	codPostal = codPostal.toString().toUpperCase();
	codPostal = codPostal.left(5);
	codPostal = flfactppal.iface.pub_espaciosDerecha(codPostal, 5);

	var ciudad:String = curRecibo.valueBuffer("ciudad");
	if (!ciudad || ciudad == "") {
		MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Ciudad.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	ciudad = ciudad.toString().toUpperCase();

	var aux:String = (codPostal + ciudad).left(36);

	var reg:String = this.iface.zonaABeneficiario + this.iface.zonaBBeneficiario + this.iface.zonaCBeneficiario + this.iface.zonaDBeneficiario;
	// Zona E: N�mero de dato (3 d�gitos) = 014
	reg += "014";
	// Zona F: (36 d�gitos) Codigo postal (5pos) y a continuaci�n la plaza del beneficiario ajustado a la izquierda relleno con blancos.
	reg += flfactppal.iface.pub_espaciosDerecha(aux, 36);
	// Zona G: Libre (7 d�gitos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto del sexto registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroBeneficiario6(curRecibo:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var provincia:String = curRecibo.valueBuffer("provincia");
	if (!provincia || provincia == "") {
		MessageBox.warning(util.translate("scripts", "El recibo %1 no tiene establecido el siguiente dato: Provincia.\nDebe editar y corregir el recibo antes de generar el fichero").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	provincia = provincia.toString().toUpperCase();
	provincia = provincia.left(36);

	var reg:String = this.iface.zonaABeneficiario + this.iface.zonaBBeneficiario + this.iface.zonaCBeneficiario + this.iface.zonaDBeneficiario;
	// Zona E: N�mero de dato (3 d�gitos) = 015
	reg += "015";
	// Zona F: (36 d�gitos) Provincia del beneficiario ajustado a la izquierda relleno con blancos.
	reg += flfactppal.iface.pub_espaciosDerecha(provincia, 36);
	// Zona G: Libre (7 d�gitos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;
	return reg;
}


/** \D Crea el texto del s�ptimo registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroBeneficiario7(curRecibo:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var observaciones:String = util.sqlSelect("facturasprov", "observaciones", "idfactura = '" + curRecibo.valueBuffer("idfactura") + "'");
	if (observaciones && observaciones != "") {
		observaciones = this.iface.eliminarCharRaros(observaciones);
	}
	if (observaciones.length > 36) {
		observaciones = observaciones.left(36);
	}
	observaciones = observaciones.toString().toUpperCase();
	
	var reg:String = this.iface.zonaABeneficiario + this.iface.zonaBBeneficiario + this.iface.zonaCBeneficiario + this.iface.zonaDBeneficiario;
	// Zona E: N�mero de dato (3 d�gitos) = 016
	reg += "016";
	// Zona F: (36 d�gitos) Concepto del documento
	reg += flfactppal.iface.pub_espaciosDerecha(observaciones, 36);
	// Zona G: Libre (7 d�gitos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;
	return reg;
}

/** \D Crea el texto del octavo registro de la cabecera del beneficiario
@param curRecibo: Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_registroBeneficiario8(curRecibo:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var observaciones:String = util.sqlSelect("facturasprov", "observaciones", "idfactura = '" + curRecibo.valueBuffer("idfactura") + "'");
	if (observaciones && observaciones != "") {
		observaciones = this.iface.eliminarCharRaros(observaciones);
	} else {
		observaciones = "";
	}
	if (observaciones.length > 36) {
		observaciones = observaciones.mid(36, 36);
	} else {
		observaciones = "";
	}
	observaciones = observaciones.toString().toUpperCase();
	
	var reg:String = this.iface.zonaABeneficiario + this.iface.zonaBBeneficiario + this.iface.zonaCBeneficiario + this.iface.zonaDBeneficiario;
	// Zona E: N�mero de dato (3 d�gitos) = 017
	reg += "017";
	// Zona F: (36 d�gitos) Concepto del documento
	reg += flfactppal.iface.pub_espaciosDerecha(observaciones, 36);
	// Zona G: Libre (7 d�gitos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	this.iface.sumaRegistros++;
	return reg;
}

function oficial_eliminarCharRaros(cadena:String):String
{
	var valor:String = "", caracter:String;
	for (var i:Number = 0; i < cadena.length; i++) {
		caracter = cadena.charAt(i);
		if (caracter != "\n" && caracter != "\t" && caracter != "\r") {
			valor += caracter;
		}
	}
	return valor;
}


/** \D Calcula el total del valor de recibos para el ordenante
@return Texto con el total para ser volcado a disco
\end */
function oficial_registroTotales():String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var reg:String = "";
	
	// Zona A: C�digo de registro (2 d�gitos) 08
	reg += "08";
	// Zona B: C�dgio de operaci�n (2 d�gitos) 56
	reg += "56";
	// Zona C: C�digo de ordenante como en la cabecera y los beneficiarios (10 d�gitos);
	reg += this.iface.zonaCCabecera
	// Zona D: Libre. (12 d�gitos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 12);
	// Zona E: Libre. (3 d�gitos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 3);
	// Zona F: Datos totales:
	// F1: Suma de los importes del soporte (12 d�gitos)
	reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaImportes, 12);
	// F2: (8 d�gitos) N�mero total de registros del beneficiario de tipo 010. (N�mero de �rdenes)
	reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaRegistros010, 8);
	// F3: (10 d�gitos) N�mero total de registros del archivo
	this.iface.sumaRegistros++;
	reg += flfactppal.iface.pub_cerosIzquierda(this.iface.sumaRegistros, 10);
	// F4: Libre. (6 d�gitos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 6);
	// G: Libre. (7 d�gitos)
	reg += flfactppal.iface.pub_espaciosDerecha("", 7);

	return reg;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
