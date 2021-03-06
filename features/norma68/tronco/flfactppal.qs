
/** @class_declaration norma68 */
/////////////////////////////////////////////////////////////////
//// NORMA 68 ///////////////////////////////////////////////////
class norma68 extends oficial {
	function norma68( context ) { oficial ( context ); }
	function espaciosIzquierda(texto:String, totalLongitud:Number):String {
		return this.ctx.norma68_espaciosIzquierda(texto, totalLongitud);
	}
}
//// NORMA 68 ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubNorma68 */
/////////////////////////////////////////////////////////////////
//// PUB NORMA 68 ///////////////////////////////////////////////
class pubNorma68 extends ifaceCtx {
	function pubNorma68( context ) { ifaceCtx( context ); }
	function pub_espaciosIzquierda(texto:String, totalLongitud:Number):String {
		return this.espaciosIzquierda(texto, totalLongitud);
	}
}
//// PUB NORMA 68 ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition norma68 */
/////////////////////////////////////////////////////////////////
//// NORMA 68 ///////////////////////////////////////////////////
function norma68_espaciosIzquierda(texto:String, totalLongitud:Number):String
{
	var ret:String = "";
	var numEspacios:Number = totalLongitud - texto.length;
	while (numEspacios > 0) {
		ret += " ";
		 numEspacios --;
	}

	ret += texto.toString();

	return ret;
}
//// NORMA 68 ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
