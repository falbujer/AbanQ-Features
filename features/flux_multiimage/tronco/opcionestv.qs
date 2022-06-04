
/** @class_declaration fluxMultiimagen */
/////////////////////////////////////////////////////////////////
//// FLUX MULTIIMAGEN /////////////////////////////////////////////////
class fluxMultiimagen extends oficial {
    function fluxMultiimagen( context ) { oficial ( context ); }
    function init() {	this.ctx.fluxMultiimagen_init(); }
	function cambiarPassword() {
		this.ctx.fluxMultiimagen_cambiarPassword();
	}
}
//// FLUX MULTIIMAGEN /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxMultiimagen */
//////////////////////////////////////////////////////////////////
//// FLUX MULTIIMAGEN //////////////////////////////////////////////////

function fluxMultiimagen_init() 
{
	this.iface.__init();
	connect( this.child( "pbnCambiarPassword"), "clicked()", this, "iface.cambiarPassword");
}

function fluxMultiimagen_cambiarPassword()
{
	var util:FLUtil = new FLUtil;
	
	var res = MessageBox.information(util.translate("scripts", "Esta acci�n no podr� deshacerse. �Est� seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return;
	
	var password:String = Input.getText( "Nuevo password:" );
	
	if (!password)
		return;
	
	if (password.length < 6) {
		MessageBox.critical(util.translate("scripts", "El password debe tener al menos 6 d�gitos"), MessageBox.Ok);	
		return;
	}
	
	password = util.sha1(password);
	this.cursor().setValueBuffer("managerpass", password.toLowerCase());
}

//// FLUX MULTIIMAGEN //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////