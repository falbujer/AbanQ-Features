/***************************************************************************
                 co_mastermodelo320.qs  -  description
                             -------------------
    begin                : jue mar 12 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function presTelematica() {
		return this.ctx.oficial_presTelematica();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
	connect (this.child("toolButtonAeat"), "clicked()", this, "iface.presTelematica()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza el informe asociado al modelo 320 seleccionado
\end */
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor();
	var nombreInforme:String = cursor.action();
	flcontmode.iface.pub_lanzar(cursor, nombreInforme, nombreInforme + ".id=" + cursor.valueBuffer( "id" ) );
}

/** \D Genera un fichero para realizar la presentaci�n telem�tica del modelo 320
\end */
function oficial_presTelematica()
{
	var util:FLUtil = new FLUtil();
	MessageBox.information(util.translate("scripts", "No es posible realizar la presentaci�n telem�tica del modelo 320"), MessageBox.Ok, MessageBox.NoButton);
	return false;

/*	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid())
		return;
	
	var nombreFichero:String = FileDialog.getSaveFileName("*.*");
	if (!nombreFichero)
		return;
		
	var file:Object = new File(nombreFichero);
	file.open(File.WriteOnly);

	file.write("300"); // Modelo
	file.write("01"); // P�gina
	file.write(" "); // Indicador de p�gina complementaria
	file.write(cursor.valueBuffer("idtipodec")); // Tipo de declaraci�n
	
	// C�digo de administraci�n
	var temp:String = cursor.valueBuffer("codadmon");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "C�digo de administraci�n"), 5))
		return false;
	file.write(flfactppal.iface.pub_cerosIzquierda(temp, 5)); 
	
	// CIF
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("cifnif");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "CIF"), 9))
		return false;
	file.write(temp); 
	
	// Letras etiqueta
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("letraseti");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Letras etiqueta"), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Apellidos o raz�n social
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("apellidosrs");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Apellidos o raz�n social"), 30))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 30)); 
	
	// Nombre
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("nombre");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Nombre"), 15))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 15)); 
	
	// Tipo de v�a
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("codtipovia");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Tipo de v�a"), 2))
		return false;
	file.write(temp); 
	
	// Nombre de v�a
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("nombrevia");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Nombre de la v�a"), 17))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 17)); 
	
	// N�mero de la v�a
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("numero");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "N�mero de la v�a"), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Escalera
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("escalera");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Escalera"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Piso
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("piso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Piso"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Puerta
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("puerta");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Puerta"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// C�digo postal
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("codpos");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "C�digo postal"), 5))
		return false;
	file.write(flfactppal.iface.pub_cerosIzquierda(temp, 5)); 
	
	// Municipio
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("municipio");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Municipio"), 20))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 20)); 
	
	// Provincia
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("provincia");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Provincia"), 15))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 15)); 
	
	// Telefono
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("telefono");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Tel�fono"), 9))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 9)); 
	
	// Ejercicio
	temp = cursor.valueBuffer("fechainicio");
	file.write(temp.toString().left(4)); 
	
	// Per�odo
	temp = cursor.valueBuffer("periodo");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Per�odo"), 2))
		return false;
	file.write(temp); 
	
	// Base imponible [01]
	temp = cursor.valueBuffer("baseimponiblerg1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % [02]
	temp = cursor.valueBuffer("tiporg1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2)); 
	
	// Cuota [03]
	temp = cursor.valueBuffer("cuotarg1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible [04]
	temp = cursor.valueBuffer("baseimponiblerg2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % [05]
	temp = cursor.valueBuffer("tiporg2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2)); 
	
	// Cuota  [06]
	temp = cursor.valueBuffer("cuotarg2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible [07]
	temp = cursor.valueBuffer("baseimponiblerg3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % [08]
	temp = cursor.valueBuffer("tiporg3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2)); 
	
	// Cuota [09]
	temp = cursor.valueBuffer("cuotarg3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible recargo equivalencia [10]
	temp = cursor.valueBuffer("baseimponiblere1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % recargo equivalencia [11]
	temp = cursor.valueBuffer("tipore1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2)); 
	
	// Cuota recargo equivalencia [12]
	temp = cursor.valueBuffer("cuotare1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible recargo equivalencia [13]
	temp = cursor.valueBuffer("baseimponiblere2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % recargo equivalencia [14]
	temp = cursor.valueBuffer("tipore2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2)); 
	
	// Cuota recargo equivalencia [15]
	temp = cursor.valueBuffer("cuotare2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible recargo equivalencia [16]
	temp = cursor.valueBuffer("baseimponiblere3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % recargo equivalencia [17]
	temp = cursor.valueBuffer("tipore3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2)); 
	
	// Cuota recargo equivalencia [18]
	temp = cursor.valueBuffer("cuotare3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible por adquisiciones intracomunitarias [19]
	temp = cursor.valueBuffer("baseimponibleai");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Cuota por adquisiciones intracomunitarias [20]
	temp = cursor.valueBuffer("cuotaai");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA Devengado: Cuota total (03 + 06 + 09 + 12 + 15 + 18 + 20) [21]
	temp = cursor.valueBuffer("cuotadevtotal");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible por cuotas soportadas en operaciones interiores [22]
	temp = cursor.valueBuffer("cuotadedoi");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible por cuotas satisfechas en las importaciones [23]
	temp = cursor.valueBuffer("cuotadedim");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible en adquisiciones intracomunitarias [24]
	temp = cursor.valueBuffer("cuotadedai");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible: Cuota por compensaciones en el r�gimen especial de agricultura, ganader�a y pesca [25]
	temp = cursor.valueBuffer("cuotacomre");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible: Cuota por regularizaci�n de inversiones [26]
	temp = cursor.valueBuffer("cuotaregin");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible: Total a deducir (22 + 23 + 24 + 25 + 26) [27]
	temp = cursor.valueBuffer("cuotadedtotal");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Diferencia (27 - 21) [28]
	temp = cursor.valueBuffer("cuotadif");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Porcentaje atribuible a la administraci�n del estado [29]
	temp = cursor.valueBuffer("porcuotaestado");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2)); 
	
	// Cuota atribuible a la administraci�n del estado (30 x 29) [30]
	temp = cursor.valueBuffer("cuotaestado");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Cuota por compensaci�n de ejercicios anteriores [31]
	temp = cursor.valueBuffer("cuotaanterior");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Cuota por entregas intracomunitarias [32]
	temp = cursor.valueBuffer("entregasi");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Cuota exclusiva para sujetos pasivos que tributan conjuntamente a la administraci�n del estado y a las Diplomaturas Formales. Resultado de la Regularizaci�n anual [33]
	temp = cursor.valueBuffer("sujetospasivos");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Resultado (30 - 31 + 33) [34]
	temp = cursor.valueBuffer("cuotaresultado");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Importe a compensar en caso de que la casilla 34 resulte negativa [34][C]
	temp = cursor.valueBuffer("impcompensar");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Importe a devolver [D]
	temp = cursor.valueBuffer("imported");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Devoluci�n c�digo cuenta cliente - entidad
	temp = cursor.valueBuffer("ctaentidaddev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devoluci�n: Entidad"), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Devoluci�n c�digo cuenta cliente - Oficina
	temp = cursor.valueBuffer("ctaagenciadev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devoluci�n: Oficina "), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Devoluci�n c�digo cuenta cliente - DC
	temp = cursor.valueBuffer("dcdev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devoluci�n: D�gito de control"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Devoluci�n c�digo cuenta cliente - N�mero de cuenta
	temp = cursor.valueBuffer("cuentadev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devoluci�n: N� cuenta"), 10))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 10)); 
	
	// Forma de pago - en efectivo
	if (cursor.valueBuffer("pagoefectivo"))
		temp = "X";
	else
		temp = " ";
	file.write(temp); 
	
	// Forma de pago - adeudo en cuenta
	if (cursor.valueBuffer("pagocuenta"))
		temp = "X";
	else
		temp = " ";
	file.write(temp); 
	
	// Importe a ingresar [I]
	temp = cursor.valueBuffer("importei");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Ingreso c�digo cuenta cliente - entidad
	temp = cursor.valueBuffer("ctaentidadingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Entidad"), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Ingreso c�digo cuenta cliente - Oficina
	temp = cursor.valueBuffer("ctaagenciaingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Oficina "), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Ingreso c�digo cuenta cliente - DC
	temp = cursor.valueBuffer("dcingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: D�gito de control"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Ingreso c�digo cuenta cliente - N�mero de cuenta
	temp = cursor.valueBuffer("cuentaingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: N� cuenta"), 10))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 10)); 
	
	// Persona de contacto
	temp = cursor.valueBuffer("personacontacto");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Persona de contacto"), 100))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 100)); 
	
	// Telefono
	temp = cursor.valueBuffer("telefono");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Telefono de contacto"), 9))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 9)); 
	
	// Observaciones
	temp = cursor.valueBuffer("observaciones");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Observaciones"), 350))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 350)); 
	
	// Fecha de la firma
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Fecha firma"), 19))
		return false;
	file.write(flfactppal.iface.pub_cerosIzquierda(temp.getDate(), 2));
	file.write(flfactppal.iface.pub_espaciosDerecha(flcontmode.iface.pub_mesPorIndice(temp.getMonth()), 10));
	file.write(flfactppal.iface.pub_cerosIzquierda(temp.getYear(), 4));
	
	// Fin de registro
	temp = "\n";
	file.write(temp);
	
	file.close();

	MessageBox.information(util.translate("scripts", "Generado fichero en :\n\n" + nombreFichero + "\n\n"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
*/
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
