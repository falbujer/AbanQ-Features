
/** @class_declaration docuInfosial */
/////////////////////////////////////////////////////////////////
//// DOCUINFOSIAL /////////////////////////////////////////////////
class docuInfosial extends oficial {
	var rutaWeb:String;
    function docuInfosial( context ) { oficial ( context ); }
    function init() { this.ctx.docuInfosial_init(); }
	function cambiarDirMotor() { return this.ctx.docuInfosial_cambiarDirMotor() ;}
}
//// DOCUINFOSIAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition docuInfosial */
/////////////////////////////////////////////////////////////////
//// DOCUINFOSIAL /////////////////////////////////////////////////

function docuInfosial_init() {
	
	var util:FLUtil = new FLUtil();
	
	this.child("lblDirMotor").text = util.readSettingEntry("scripts/fldocuppal/dirMotor");
	
	connect( this.child( "pbnCambiarDirMotor" ), "clicked()", this, "iface.cambiarDirMotor" );
	
	this.iface.__init();
}

function docuInfosial_cambiarDirMotor()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "RUTA AL MOTOR" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta err?nea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	this.child("lblDirMotor").text = ruta;
	util.writeSettingEntry("scripts/fldocuppal/dirMotor", ruta);
}

//// DOCUINFOSIAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////