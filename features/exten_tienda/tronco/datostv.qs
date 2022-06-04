
/** @class_declaration exTienda */
/////////////////////////////////////////////////////////////////
//// EXTENSION TIENDA //////////////////////////////////////
class exTienda extends fluxecPro {
	function exTienda( context ) { fluxecPro ( context ); }
	function init() { this.ctx.exTienda_init(); }
	function exportarTabla(tabla, nomTabla, tablaGeneral) {
		return this.ctx.exTienda_exportarTabla(tabla, nomTabla, tablaGeneral);
	}
}
//// EXTENSION TIENDA //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exTienda */
/////////////////////////////////////////////////////////////////
//// EXTENSION TIENDA //////////////////////////////////////
function exTienda_init() 
{
	this.iface.__init();

	this.iface.tablas = new Array(
		"idiomas",
		"infogeneral",
		"modulosweb",
		"noticias",
		"traducciones",
		"fabricantes",
		"faqs",

		"paises",
		"provincias",
								  
		"galeriasimagenes",
		"imagenes",
		"tarifas",
		"gruposclientes",
		"almacenes",
		"gruposatributos",
		"familias",
		"plazosenvio",
		"articulos",
		"atributos",
		"atributosart",
		"accesoriosart",
		"formasenvio",
		"pasarelaspago",
		"parametrospasarela",
		"formaspago",
		"opcionestv",
		"articulostarifas",

		"intervalospesos",
		"zonasventa",
		"zonasformasenvio",
		"zonasformaspago",
		"costesenvio",
		"codigosdescuento",
		"stocks",

		"clientes",
		"empresa";
		"lineasalbaranescli",
		"albaranescli",
		"lineasfacturascli",
		"facturascli"
	);
}

function exTienda_exportarTabla(tabla:String, nomTabla:String, tablaGeneral:Boolean)
{
	if (this.cursor().valueBuffer("exportardirecto"))
		return this.iface.__exportarTabla(tabla, nomTabla, tablaGeneral);
		
	var util:FLUtil = new FLUtil();

	var curLoc:FLSqlCursor = new FLSqlCursor(tabla);
  	var curRem:FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

	var campoClave:String = curLoc.primaryKey();
	var listaCampos:Array = this.iface.obtenerListaCampos(tabla);

	var valorClave;
	var paso:Number = 0;
	var exportados:Number = 0;
	var eliminados:Number = 0;

// 	curLoc.setForwardOnly(true);
// 	if (this.cursor().valueBuffer("subirtodo"))
// 	 	curLoc.select();
// 	else
// 	 	curLoc.select("modificado = true");
// 
// 	if (curLoc.size() == 0) 
// 		return 0;
// 		
// 	if (tabla == "clientes")
// 		curRem.setActivatedCheckIntegrity(false);

		var filtro = "";
	
	 
	switch(tabla) {
		case "clientes": {
			curRem.setActivatedCheckIntegrity(false);
			if (!this.cursor().valueBuffer("subirtodo"))
				filtro = "modificado = true";
			break;
		}
		case "lineasalbaranescli": {
			curRem.setActivatedCheckIntegrity(false);
			curRem.setActivatedCommitActions(false);
			if (!this.cursor().valueBuffer("subirtodo"))
				filtro = "(modificado = true or idalbaran in (select idalbaran from albaranescli where modificado = true))";
			
			if(filtro != "")
				filtro += " AND ";
			filtro += "idalbaran in (select idalbaran from albaranescli where codcliente in (select codcliente from clientes where clienteweb))";
			break;
		}
		case "facturascli":
		case "albaranescli": {
			curRem.setActivatedCheckIntegrity(false);
			curRem.setActivatedCommitActions(false);
			if (!this.cursor().valueBuffer("subirtodo"))
				filtro = "modificado = true";
			
			if(filtro != "")
				filtro += " AND ";
			filtro += "codcliente in (select codcliente from clientes where clienteweb)";
			break;
		}
		case "lineasfacturascli": {
			curRem.setActivatedCheckIntegrity(false);
			curRem.setActivatedCommitActions(false);
			if (!this.cursor().valueBuffer("subirtodo"))
				filtro = "(modificado = true or idfactura in (select idfactura from facturascli where modificado = true))";
			
			if(filtro != "")
				filtro += " AND ";
			filtro += "idfactura in (select idfactura from facturascli where codcliente in (select codcliente from clientes where clienteweb))";
			break;
		}
		default: {
			if (!this.cursor().valueBuffer("subirtodo"))
				filtro = "modificado = true";
			break;
		}
	}
	
	curLoc.setForwardOnly(true);
	curLoc.select(filtro);
	if (curLoc.size() == 0)
		return 0;
	
	util.createProgressDialog( util.translate( "scripts", "Exportando " ) + nomTabla, curLoc.size());
	util.setProgress(1);

 	while (curLoc.next()) {

		util.setProgress(paso++);

 		valorClave = curLoc.valueBuffer(campoClave);

		curRem.select(campoClave + " = '" + valorClave + "'");

		// Actualizacion (si toca)
		if (curRem.first()) {

			if (this.cursor().valueBuffer("subirtodo")) {
				curRem.setModeAccess(curRem.Edit);
			}
			else {
				if (curLoc.valueBuffer("modificado"))
					curRem.setModeAccess(curRem.Edit);
				else
					continue;
			}

		}
		else {
			curRem.setModeAccess(curRem.Insert);
		}

		curRem.refreshBuffer();

		// Bucle de campos
		for(var i = 0; i < listaCampos.length; i++) {
		
			campo = listaCampos[i];
		
			// excepciones
			if (tabla == "formaspago" && campo == "codcuenta")
				continue;
		
			if ((campo.left(11) == "idsubcuenta" || campo == "idprovincia") && !curLoc.valueBuffer(campo))
				curRem.setNull(campo);
			else			
				curRem.setValueBuffer(campo, curLoc.valueBuffer(campo));
		}

		// OK remoto
		if (curRem.commitBuffer() && !tablaGeneral) {

			// Actualizamos el local como no modificado
			curLoc.setModeAccess(curLoc.Edit);
			curLoc.refreshBuffer();
			curLoc.setValueBuffer("modificado", false);
			if (!curLoc.commitBuffer())
				debug(util.translate("scripts",	"Error al actualizar la tabla local %0 el código/id " ).arg(tabla) + valorClave);

			exportados++;
		}

		// Error
		else {
			debug(util.translate("scripts",	"Error al exportar en la tabla remota %0 el código/id " ).arg(tabla) + valorClave);
		}

	}

	util.destroyProgressDialog();

	return exportados;
}
//// EXTENSION TIENDA //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////