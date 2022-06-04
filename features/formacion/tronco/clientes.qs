
/** @class_declaration formacion */
/////////////////////////////////////////////////////////////////
//// FORMACIÓN///////////////////////////////////////////////////
class formacion extends oficial {
	var datosAltaAlumno_:Array;
    function formacion( context ) { oficial ( context ); }
	function init() {
		return this.ctx.formacion_init();
	}
	function tbnAltaAlumno_clicked() {
		return this.ctx.formacion_tbnAltaAlumno_clicked();
	}
	function tbnAsociarAlumno_clicked() {
		return this.ctx.formacion_tbnAsociarAlumno_clicked();
	}
	function tbnQuitarAlumno_clicked() {
		return this.ctx.formacion_tbnQuitarAlumno_clicked();
	}
}
//// FORMACIÓN///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition formacion */
/////////////////////////////////////////////////////////////////
//// FORMACIÓN //////////////////////////////////////////////////
function formacion_init()
{
	this.iface.__init();
	connect(this.child("tbnAltaAlumno"), "clicked()", this, "iface.tbnAltaAlumno_clicked");
	connect(this.child("tbnAsociarAlumno"), "clicked()", this, "iface.tbnAsociarAlumno_clicked");
	connect(this.child("tbnQuitarAlumno"), "clicked()", this, "iface.tbnQuitarAlumno_clicked");
}

function formacion_tbnAltaAlumno_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.datosAltaAlumno_ = [];
	this.iface.datosAltaAlumno_["codcliente"] = cursor.valueBuffer("codcliente");
	this.iface.datosAltaAlumno_["nombre"] = cursor.valueBuffer("nombre");
	this.child("tdbAlumnos").insertRecord();
}

function formacion_tbnAsociarAlumno_clicked()
{
	var util = new FLUtil();
	var f = new FLFormSearchDB("fo_alumnos");
	var curAlumnos = f.cursor();
	var cursor = this.cursor();
	
	var codCliente:String = cursor.valueBuffer("codcliente");
	var filtro = "codcliente <> '" + codCliente + "' OR codcliente IS NULL";
	
	curAlumnos.setMainFilter(filtro);
	f.setMainWidget();
	var codAlumno = f.exec("codalumno");
	if (!codAlumno) {
		return;
	}
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("tdbAlumnos").cursor().commitBufferCursorRelation();
	}

	var codCliente = curAlumnos.valueBuffer("codcliente");
	if (codCliente) {
		var nombre = util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'");
		var res = MessageBox.warning(util.translate("scripts", "El alumno %1 ya está asociado al cliente %2 - %3.\n¿Desea reasignarlo?").arg(curAlumnos.valueBuffer("nombre")).arg(codCliente).arg(nombre), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return;
		}
	}
	if (!util.sqlUpdate("fo_alumnos", "codcliente", cursor.valueBuffer("codcliente"), "codalumno = '" + codAlumno + "'")) {
		return;
	}
	this.child("tdbAlumnos").refresh();
}

function formacion_tbnQuitarAlumno_clicked()
{
	var util = new FLUtil();
	var curAlumno = this.child("tdbAlumnos").cursor();
	var codAlumno = curAlumno.valueBuffer("codalumno");
	if (!codAlumno) {
		return;
	}
	var res = MessageBox.warning(util.translate("scripts", "Va a desvincular el alumno %1 del cliente acual.\n¿Está seguro?").arg(curAlumno.valueBuffer("nombre")), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}
	if (!util.sqlUpdate("fo_alumnos", "codcliente", "NULL", "codalumno = '" + codAlumno + "'")) {
		return;
	}
	this.child("tdbAlumnos").refresh();
}
//// FORMACIÓN //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
