
/** @class_declaration distEjer */
/////////////////////////////////////////////////////////////////
//// DISTIBUCI�N EJERCICIOS /////////////////////////////////////
class distEjer extends oficial {
	var conexionDA_;
	function distEjer( context ) { oficial ( context ); }
	function conectarDA() {
		return this.ctx.distEjer_conectarDA();
	}
	function conexionDA() {
		return this.ctx.distEjer_conexionDA();
	}
	function beforeCommit_albaranescli(curA) {
		return this.ctx.distEjer_beforeCommit_albaranescli(curA);
	}
	function controlBorradoAlbaranDist(curA) {
		return this.ctx.distEjer_controlBorradoAlbaranDist(curA);
	}
}
//// DISTIBUCI�N EJERCICIOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubDistEjer */
/////////////////////////////////////////////////////////////////
//// PUB DISTIBUCI�N EJERCICIOS /////////////////////////////////
class pubDistEjer extends ifaceCtx {
	function pubDistEjer( context ) { ifaceCtx ( context ); }
	function pub_conectarDA() {
		return this.conectarDA();
	}
	function pub_conexionDA() {
		return this.conexionDA();
	}
}
//// PUB DISTIBUCI�N EJERCICIOS /////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCI�N EJERCICIOS ////////////////////////////////////
function distEjer_conectarDA()
{
	debug("Conectando");
  var _i = this.iface;
	if (_i.conexionDA_) {
		return true;
	}
  var datosConexion: String = "";
  var nombreBD = _i.valorDefecto("basedatosda");
	if (nombreBD == "" || nombreBD == sys.nameBD()) { /// Conexi�n local
		_i.conexionDA_ = "CX_LOCAL";
		return true;
	}
  datosConexion += "\n" + sys.translate("Base de datos %1").arg(nombreBD);
  var host = _i.valorDefecto("servidorda");
  datosConexion += "\n" + sys.translate("Servidor %1").arg(host);
  var driver = _i.valorDefecto("driverda");
  datosConexion += "\n" + sys.translate("Driver %1").arg(driver);
  var puerto = _i.valorDefecto("puertoda");
  datosConexion += "\n" + sys.translate("Puerto %1").arg(puerto);
	var usuario = _i.valorDefecto("usuarioda");
  datosConexion += "\n" + sys.translate("Puerto %1").arg(puerto);
	var contrasena = _i.valorDefecto("contrasenada");
  
  if (!driver || !nombreBD || !host) {
    MessageBox.warning(sys.translate("Debe indicar los datos de conexi�n a la base de datos de distribuci�n de albaranes en la opci�n Configuraci�n de este m�dulo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var tipoDriver: String;
  if (sys.nameDriver().search("PSQL") > -1)
  {
    tipoDriver = "PostgreSQL";
  } else {
    tipoDriver = "MySQL";
  }
  var conexion = "CX_DA";
  if (!sys.addDatabase(driver, nombreBD, usuario, contrasena, host, puerto, conexion)) {
    MessageBox.warning(sys.translate("Error en la conexi�n:%1").arg(datosConexion), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug("OK " + conexion);
	_i.conexionDA_ = conexion;

  return true;
}

function distEjer_conexionDA()
{
	var _i = this.iface;
	return _i.conexionDA_ == "CX_LOCAL" ? "" : _i.conexionDA_;
}

function distEjer_beforeCommit_albaranescli(curA)
{
	var _i = this.iface;
	if (!_i.controlBorradoAlbaranDist(curA)) {
		return false;
	}
	if (!_i.__beforeCommit_albaranescli(curA)) {
		return false;
	}
	return true;
}

function distEjer_controlBorradoAlbaranDist(curA)
{
	if (curA.modeAccess() == curA.Del && curA.valueBuffer("idalbarancomp")) {
		sys.warnMsgBox(sys.translate("Este albar�n est� en raparto"));
		return false;
	}
	return true;
}
//// DISTRIBUCI�N EJERCICIOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
