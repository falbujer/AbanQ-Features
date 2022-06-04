
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GR�FICAS /////////////////////////////////////////////
class artesG extends prod {
	function artesG( context ) { prod ( context ); }
	function init() {
		this.ctx.artesG_init();
	}
}
//// ARTES GR�FICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GR�FICAS /////////////////////////////////////////////
function artesG_init()
{
	this.iface.__init();
	
	var campos:Array = ["estado", "codorden", "nombrecliente", "fecha", "fechaentrega", "descripcion"];
	this.iface.tdbRecords.setOrderCols(campos);
	
	var cmbBoxSearch = this.child("comboBoxFieldToSearch");
	cmbBoxSearch.currentItem = cmbBoxSearch.count - 1;

	this.iface.tdbRecords.refresh();	
}
//// ARTES GR�FICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
