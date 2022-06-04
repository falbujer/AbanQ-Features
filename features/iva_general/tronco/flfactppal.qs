
/** @class_declaration ivaGeneral */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class ivaGeneral extends oficial {
	function ivaGeneral( context ) { oficial ( context ); }
	function valoresIniciales() {
		return this.ctx.ivaGeneral_valoresIniciales();
	}
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaGeneral */
/////////////////////////////////////////////////////////////////
//// IVA_GENERAL ////////////////////////////////////////////////
function ivaGeneral_valoresIniciales()
{
	this.iface.__valoresIniciales();
	
	var cursor:FLSqlCursor = new FLSqlCursor("empresa");
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("nombre", "InfoSiAL, S.L. - Creadores de FacturaLUX - http://www.infosial.com");
		setValueBuffer("cifnif", "B02352961");
		setValueBuffer("administrador", "FEDERICO ALBUJER ZORNOZA");
		setValueBuffer("direccion", "C/. SAN ANTONIO, 88");
		setValueBuffer("codejercicio", "0001");
		setValueBuffer("coddivisa", "EUR");
		setValueBuffer("codpago", "CONT");
		setValueBuffer("codserie", "A");
		setValueBuffer("codpostal", "02640");
		setValueBuffer("ciudad", "ALMANSA");
		setValueBuffer("provincia", "ALBACETE");
		setValueBuffer("telefono", "967 345 174");
		setValueBuffer("email", "mail@infosial.com");
		setValueBuffer("codpais", "ESP");
		setValueBuffer("codimpuesto", "IVA16");
		setValueBuffer("logo", "/* XPM */\n static char * minilogoinfosial_xpm[] = {\n \"125 43 392 2\",\n \"  	c None\",\n \". 	c #5172B6\",\n \"+ 	c #5D7CBB\",\n \"@ 	c #8CA2CF\",\n \"# 	c #93A7D2\",\n \"$ 	c #BAC7E2\",\n \"% 	c #FDFDFE\",\n \"& 	c #FCFCFE\",\n \"* 	c #FBFCFD\",\n \"= 	c #FCFDFE\",\n \"- 	c #FFFFFF\",\n \"; 	c #FEFEFE\",\n \"> 	c #CED7EA\",\n \", 	c #AABADB\",\n \"' 	c #5676B8\",\n \") 	c #6381BE\",\n \"! 	c #E1E7F2\",\n \"~ 	c #748FC5\",\n \"{ 	c #B9C6E1\",\n \"] 	c #738DC4\",\n \"^ 	c #B7C5E1\",\n \"/ 	c #F7F1ED\",\n \"( 	c #E1CABB\",\n \"_ 	c #E4CFC2\",\n \": 	c #FCFAF8\",\n \"< 	c #F1E6DE\",\n \"[ 	c #A76135\",\n \"} 	c #923C05\",\n \"| 	c #933E08\",\n \"1 	c #B57A55\",\n \"2 	c #FBF8F6\",\n \"3 	c #F2E8E1\",\n \"4 	c #D1AC95\",\n \"5 	c #D7B7A3\",\n \"6 	c #FAF6F4\",\n \"7 	c #B7C4E0\",\n \"8 	c #BC8866\",\n \"9 	c #903800\",\n \"0 	c #913A03\",\n \"a 	c #D5B49F\",\n \"b 	c #F5EDE8\",\n \"c 	c #A15627\",\n \"d 	c #903801\",\n \"e 	c #913902\",\n \"f 	c #B67C57\",\n \"g 	c #B5C1DC\",\n \"h 	c #AF6F47\",\n \"i 	c #C79A7E\",\n \"j 	c #D9BCA9\",\n \"k 	c #CCA48A\",\n \"l 	c #913A02\",\n \"m 	c #95400B\",\n \"n 	c #E2CBBC\",\n \"o 	c #E7D3C7\",\n \"p 	c #933E07\",\n \"q 	c #9C4E1C\",\n \"r 	c #556FAC\",\n \"s 	c #636182\",\n \"t 	c #64617F\",\n \"u 	c #576DA5\",\n \"v 	c #F9F5F2\",\n \"w 	c #C59779\",\n \"x 	c #A25829\",\n \"y 	c #A55E31\",\n \"z 	c #D4B29D\",\n \"A 	c #FEFDFC\",\n \"B 	c #FDFCFB\",\n \"C 	c #A45C2E\",\n \"D 	c #A9653A\",\n \"E 	c #E0C8B8\",\n \"F 	c #586BA1\",\n \"G 	c #834424\",\n \"H 	c #8F3903\",\n \"I 	c #8F3902\",\n \"J 	c #874019\",\n \"K 	c #5F658D\",\n \"L 	c #FEFDFD\",\n \"M 	c #F8F2EF\",\n \"N 	c #F9F4F1\",\n \"O 	c #FBF7F5\",\n \"P 	c #E8D5CA\",\n \"Q 	c #5370AF\",\n \"R 	c #616388\",\n \"S 	c #6E5863\",\n \"T 	c #715458\",\n \"U 	c #6A5B6E\",\n \"V 	c #566DA8\",\n \"W 	c #794D42\",\n \"X 	c #834426\",\n \"Y 	c #5271B2\",\n \"Z 	c #F4F6FB\",\n \"` 	c #DBE2F0\",\n \" .	c #CBD4E9\",\n \"..	c #C1CDE5\",\n \"+.	c #E0E6F2\",\n \"@.	c #F7F8FB\",\n \"#.	c #FDFEFE\",\n \"$.	c #E1C8B9\",\n \"%.	c #9B4C19\",\n \"&.	c #923B04\",\n \"*.	c #A3592B\",\n \"=.	c #EFE2DA\",\n \"-.	c #F4F6FA\",\n \";.	c #F6F8FB\",\n \">.	c #F5F7FB\",\n \",.	c #5271B3\",\n \"'.	c #5F658E\",\n \").	c #626284\",\n \"!.	c #616387\",\n \"~.	c #546FAD\",\n \"{.	c #5D6794\",\n \"].	c #824528\",\n \"^.	c #8E3905\",\n \"/.	c #626385\",\n \"(.	c #5470AE\",\n \"_.	c #E7ECF5\",\n \":.	c #95A9D3\",\n \"<.	c #5F7DBC\",\n \"[.	c #617FBD\",\n \"}.	c #A5B6DA\",\n \"|.	c #FCFAF9\",\n \"1.	c #AD6D44\",\n \"2.	c #C29273\",\n \"3.	c #C4CFE6\",\n \"4.	c #B1C0DF\",\n \"5.	c #758FC5\",\n \"6.	c #5B7ABA\",\n \"7.	c #546FAC\",\n \"8.	c #844322\",\n \"9.	c #8D3B09\",\n \"0.	c #5C6896\",\n \"a.	c #556EAA\",\n \"b.	c #87411B\",\n \"c.	c #8E3A07\",\n \"d.	c #7D4936\",\n \"e.	c #5370B1\",\n \"f.	c #D3DBEC\",\n \"g.	c #6582BE\",\n \"h.	c #5374B7\",\n \"i.	c #6B87C1\",\n \"j.	c #7C95C8\",\n \"k.	c #7D96C8\",\n \"l.	c #7992C7\",\n \"m.	c #6683BF\",\n \"n.	c #5273B7\",\n \"o.	c #A2B4D8\",\n \"p.	c #FEFEFF\",\n \"q.	c #AE6F46\",\n \"r.	c #C39375\",\n \"s.	c #8299CA\",\n \"t.	c #F9FAFC\",\n \"u.	c #6C5967\",\n \"v.	c #8D3A08\",\n \"w.	c #7D4A38\",\n \"x.	c #7A4C3F\",\n \"y.	c #5A6A9D\",\n \"z.	c #5D6792\",\n \"A.	c #8A3E12\",\n \"B.	c #8C3C0B\",\n \"C.	c #675E78\",\n \"D.	c #F0F3F9\",\n \"E.	c #708BC3\",\n \"F.	c #5978B9\",\n \"G.	c #B5C3E0\",\n \"H.	c #F1F4F9\",\n \"I.	c #ECF0F7\",\n \"J.	c #C6D1E7\",\n \"K.	c #E6EBF5\",\n \"L.	c #E2CABC\",\n \"M.	c #F0E4DD\",\n \"N.	c #E5EAF4\",\n \"O.	c #5273B6\",\n \"P.	c #5373B7\",\n \"Q.	c #D6DEEE\",\n \"R.	c #80472E\",\n \"S.	c #6B5A6C\",\n \"T.	c #5271B4\",\n \"U.	c #5172B5\",\n \"V.	c #596B9E\",\n \"W.	c #6C5968\",\n \"X.	c #5C6895\",\n \"Y.	c #C4D0E6\",\n \"Z.	c #9AADD4\",\n \"`.	c #FFFEFE\",\n \" +	c #F6EEEA\",\n \".+	c #ECDDD4\",\n \"++	c #F9F3F0\",\n \"@+	c #A7B8DA\",\n \"#+	c #5C7BBB\",\n \"$+	c #C5D0E7\",\n \"%+	c #5777B9\",\n \"&+	c #97AAD3\",\n \"*+	c #8C3C0C\",\n \"=+	c #596B9F\",\n \"-+	c #B6C4E0\",\n \";+	c #C0CCE4\",\n \">+	c #6C88C1\",\n \",+	c #7B94C8\",\n \"'+	c #F8F9FC\",\n \")+	c #7791C6\",\n \"!+	c #F7F8FC\",\n \"~+	c #6A5A6C\",\n \"{+	c #655F7C\",\n \"]+	c #576DA6\",\n \"^+	c #76504B\",\n \"/+	c #75504D\",\n \"(+	c #685D74\",\n \"_+	c #556EA9\",\n \":+	c #626386\",\n \"<+	c #8E3A06\",\n \"[+	c #8D3B08\",\n \"}+	c #6F565F\",\n \"|+	c #6B5A6A\",\n \"1+	c #794D43\",\n \"2+	c #725355\",\n \"3+	c #566EA9\",\n \"4+	c #BFCBE4\",\n \"5+	c #5272B6\",\n \"6+	c #8DA2CF\",\n \"7+	c #8199CA\",\n \"8+	c #6A86C1\",\n \"9+	c #CAD4E9\",\n \"0+	c #5575B8\",\n \"a+	c #B9C6E2\",\n \"b+	c #ACBCDC\",\n \"c+	c #774F49\",\n \"d+	c #636181\",\n \"e+	c #86411E\",\n \"f+	c #745150\",\n \"g+	c #774F48\",\n \"h+	c #8F3904\",\n \"i+	c #864525\",\n \"j+	c #814B35\",\n \"k+	c #874421\",\n \"l+	c #844321\",\n \"m+	c #64607E\",\n \"n+	c #E9EDF6\",\n \"o+	c #5475B7\",\n \"p+	c #9AADD5\",\n \"q+	c #EAEEF6\",\n \"r+	c #FEFFFF\",\n \"s+	c #8DA3CF\",\n \"t+	c #E4E9F4\",\n \"u+	c #75514F\",\n \"v+	c #8C3B0B\",\n \"w+	c #8B3D10\",\n \"x+	c #7D4A37\",\n \"y+	c #80472F\",\n \"z+	c #8D3C0B\",\n \"A+	c #6D667D\",\n \"B+	c #5E7AB6\",\n \"C+	c #5B7EC0\",\n \"D+	c #5E79B3\",\n \"E+	c #745D67\",\n \"F+	c #8C3B0A\",\n \"G+	c #665F7A\",\n \"H+	c #CBD5E9\",\n \"I+	c #6482BE\",\n \"J+	c #98ACD4\",\n \"K+	c #D4DCED\",\n \"L+	c #FBFCFE\",\n \"M+	c #8EA4D0\",\n \"N+	c #89A0CE\",\n \"O+	c #5877B9\",\n \"P+	c #DBE1F0\",\n \"Q+	c #893E14\",\n \"R+	c #7A4C3E\",\n \"S+	c #87401A\",\n \"T+	c #675E76\",\n \"U+	c #735354\",\n \"V+	c #8E3A05\",\n \"W+	c #76504A\",\n \"X+	c #64607F\",\n \"Y+	c #725458\",\n \"Z+	c #735F6A\",\n \"`+	c #5C7DBD\",\n \" @	c #7B544C\",\n \".@	c #883F17\",\n \"+@	c #576CA4\",\n \"@@	c #DAE0EF\",\n \"#@	c #BBC8E3\",\n \"$@	c #B0BFDE\",\n \"%@	c #D2DBEC\",\n \"&@	c #C9D3E8\",\n \"*@	c #5474B7\",\n \"=@	c #9DB0D6\",\n \"-@	c #85421F\",\n \";@	c #576CA5\",\n \">@	c #566EA8\",\n \",@	c #6A5B6F\",\n \"'@	c #8B3C0D\",\n \")@	c #596BA0\",\n \"!@	c #586CA2\",\n \"~@	c #5F78B1\",\n \"{@	c #666F97\",\n \"]@	c #6B5A6B\",\n \"^@	c #8FA4D0\",\n \"/@	c #6280BD\",\n \"(@	c #7891C6\",\n \"_@	c #E2E8F3\",\n \":@	c #FAFBFD\",\n \"<@	c #F0F2F9\",\n \"[@	c #6F5660\",\n \"}@	c #71555A\",\n \"|@	c #616489\",\n \"1@	c #65719C\",\n \"2@	c #7B4B3D\",\n \"3@	c #5272B4\",\n \"4@	c #F2F4F9\",\n \"5@	c #BAC8E2\",\n \"6@	c #EFF2F8\",\n \"7@	c #D4DDED\",\n \"8@	c #718CC3\",\n \"9@	c #A1B3D7\",\n \"0@	c #A1B3D8\",\n \"a@	c #6F8BC3\",\n \"b@	c #C0CCE5\",\n \"c@	c #6C5969\",\n \"d@	c #6E5761\",\n \"e@	c #725357\",\n \"f@	c #695C70\",\n \"g@	c #6D667F\",\n \"h@	c #5B7EBF\",\n \"i@	c #745E67\",\n \"j@	c #EDF0F7\",\n \"k@	c #829ACB\",\n \"l@	c #894119\",\n \"m@	c #65719D\",\n \"n@	c #696C8E\",\n \"o@	c #8C3D0F\",\n \"p@	c #824529\",\n \"q@	c #D0D9EB\",\n \"r@	c #F3F5FA\",\n \"s@	c #BCC9E3\",\n \"t@	c #BCC8E3\",\n \"u@	c #6885C0\",\n \"v@	c #636283\",\n \"w@	c #8D3C0C\",\n \"x@	c #7E5042\",\n \"y@	c #77595B\",\n \"z@	c #804E3B\",\n \"A@	c #8BA2CF\",\n \"B@	c #ABBBDC\",\n \"C@	c #A4B5D9\",\n \"D@	c #596A9E\",\n \"E@	c #8B3D0E\",\n \"F@	c #B3C2DF\",\n \"G@	c #A9BADB\",\n \"H@	c #E3E8F3\",\n \"I@	c #5878B9\",\n \"J@	c #6B88C1\",\n \"K@	c #784E46\",\n \"L@	c #CDD6EA\",\n \"M@	c #DAE1EF\",\n \"N@	c #F3F6FA\",\n \"O@	c #5E7CBB\",\n \"P@	c #607EBC\",\n \"Q@	c #E8ECF5\",\n \"R@	c #DCE3F0\",\n \"S@	c #859CCC\",\n \"T@	c #889ECD\",\n \"U@	c #5979BA\",\n \"V@	c #ECEFF7\",\n \"W@	c #8AA0CE\",\n \"X@	c #6D89C2\",\n \"Y@	c #7D96C9\",\n \"Z@	c #889FCD\",\n \"`@	c #839ACB\",\n \" #	c #5A699B\",\n \".#	c #7F4730\",\n \"+#	c #646181\",\n \"@#	c #5A7ABA\",\n \"##	c #DDE3F1\",\n \"$#	c #6481BE\",\n \"%#	c #F1F3F9\",\n \"&#	c #6A5B6D\",\n \"*#	c #70555C\",\n \"=#	c #6F5761\",\n \"-#	c #566DA6\",\n \";#	c #5E6690\",\n \">#	c #60658C\",\n \",#	c #6E5763\",\n \"'#	c #556FAB\",\n \")#	c #735353\",\n \"!#	c #7C4A39\",\n \"~#	c #7E4934\",\n \"{#	c #76504C\",\n \"]#	c #D3DCED\",\n \"^#	c #F9FAFD\",\n \"/#	c #F8FAFC\",\n \"(#	c #869DCC\",\n \"_#	c #E2E7F3\",\n \". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . \",\n \". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . \",\n \". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . \",\n \". . + @ # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # @ + . . \",\n \". . $ % & * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * = - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ; $ . . \",\n \". . > , ' . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ) ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ~ . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ^ - / ( _ : - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ^ < [ } | 1 2 - - - - 3 4 5 6 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 7 8 9 9 9 0 a - - - b c d e f ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . g h 9 9 9 9 i - - - j 9 9 9 d / - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ^ k l 9 9 m n - - - o p 9 9 q : - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . r s t u . . ^ v w x y z A - - - B k C D E - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . F G H I J K . ^ - L M v - - - - - - ; N O - - - - / P 2 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Q R S T U V . . . . . . . W 9 9 9 9 X Y ^ - - - - ; Z `  ...> +.@.#.- - - $.%.&.*.=.- - - - - - - - % -.-.-.& - - - - - - - - - ;.-.>.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . ,.'.).).!.~.. . . . . . . . . . . . . . . . . . . {.].9 9 9 ^./.. . . . . . . J 9 9 9 9 H (.^ - - - _.:.<.. . . . . [.}.& - |.1.9 9 9 2.- - - - - - - - 3.. . . 4.- - - - - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . . . . . . . . . . . . . . . . . a.b.9 9 9 9 c.K . . . . . . . d.9 9 9 9 b.e.^ - - f.g.. h.i.j.k.l.m.n.o.p.- : q.9 9 9 r.- - - - - - - - s.. . . 5.t.- - - - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . . . . . . . . . . . . . . . . . u.9 9 9 v.w.x.y.. . . . . . . z.A.9 9 B.C.. ^ - D.E.. F.G.H.p.- = I.J.K.- - - L.q 9 C M.- - - - - - - N.F.O.5.. P.Q.- - - - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . . . . . . . . . . . . . . . . . R.9 9 9 S.T.T.U.. . . . . . . . V.W.S X.U.. ^ - Y.P.. Z.; - - - - - - - - - - `. +.+++- - - - - - - - @+. #+$+%+. &+- - - - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . . . . . . . . . . . . . . . . . A.9 9 *+=+. . . . . . . . . . . . . . . . . ^ - -+. O.;+- - - - - - - - - - - - ;.-.>.- - - - - - - ;.>+. ,+'+)+. F.!+- - - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . ).~+~+{+,.]+U ^+/+(+_+. . . :+~+<+9 9 [+}+~+K . . . T.0.|+^+1+2+t 3+. . . . ^ - 4+5+. 6+* - - - - - - - - - - - 7+[.8+- - - - - - - 9+0+5+a+- b+. . $ - - - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . c+9 9 8.d+e+9 9 9 9 X =+. . x.9 9 9 9 9 9 9 f+. . ]+g+9.h+i+j+k+d l+m+T.. . ^ - n+m.. o+p+q+r+- - - - - - - - - 5.. 6.- - - - - - % s+. 6.D.- t+<.. l.% - - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 v+w+9 9 9 9 9 9 x+. . x.9 9 9 9 9 9 9 f+. V y+d z+A+B+C+D+E+H F+G+. . ^ - - H+6.. O.I+J+K+L+- - - - - - - 5.. 6.- - - - - - K.<.. M+- - p.N+. O+P+- - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 9 Q+R+S+9 9 9 <+0.. T+U+V+9 9 <+W+U+X+. Y+d 9 Z+C+C+C+C+`+ @9 .@+@. ^ - - - @@)+O.. . ' E.#@t.- - - - - 5.. 6.- - - - - - $@. . %@- - - &@*@. =@- - - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 -@;@. >@8.9 9 9 ,@. . . v+9 9 '@)@. . !@Q+9 9 ~@C+C+C+C+C+{@9 9 ]@. ^ - - - - % %@^@/@P.. . (@_@- - - - 5.. 6.- - - - - @.5.. E.t.- - - :@8+. m.<@- - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 [@. . . 2+9 9 9 }@. . . v+9 9 '@)@. . |@9 9 9 B+C+C+C+C+C+1@9 9 2@3@^ - - - - - - - 4@5@>+. . E.6@- - - 5.. 6.- - - - - 7@h.. 8@9@0@0@0@0@a@. n.b@- - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 c@. . . d@9 9 9 e@. . . v+9 9 '@)@. . f@9 9 9 g@C+C+C+C+h@i@9 9 ].Y ^ - - - - - - - - - j@j.. . $@- - - 5.. 6.- - - - p.:.. . . . . . . . . . . k@:@- - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 c@. . . d@9 9 9 e@. . . v+9 9 '@)@. . ]@9 9 9 l@m@C+C+C+n@o@9 9 p@Y ^ - - - - - - - - - - q@. . s+- - - 5.. 6.- - - - r@6.. >+a+s@s@s@s@s@t@u@. 6.! - - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 c@. . . d@9 9 9 e@. . . v+9 9 '@)@. . v@9 9 9 9 w@x@y@z@<+9 9 9 x.U.^ - - - - - - - - - - _@' . A@- - - 5.. 6.- - - - { . . b+- - - - - - - B@. . C@- - - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 c@. . . d@9 9 9 e@. . . v+9 9 '@)@. . D@E@9 9 9 9 9 9 9 9 9 9 9 f@. ^ - #.p.- - - - - - p.F@. . G@- - - 5.. 6.- - - p.)+. + H@- - - - - - - n+I@. J@-.- - - 5.. 6.- - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 c@. . . d@9 9 9 e@. . . v+9 9 '@)@. . ,.K@9 9 9 9 9 9 9 9 9 9 J +@. ^ - L@=@M@N@- - - D.$ O@. P@Q@- - - 5.. 6.- - - R@0+. S@= - - - - - - - & T@. . &@- - - 5.. U@V@V@V@V@V@V@V@V@6@p.- - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 c@. . . d@9 9 9 e@. . . v+9 9 '@)@. . . D@e+9 9 9 9 9 9 9 9 [+G+. . ^ #.W@. %+X@Y@6+7+8+O.. O@3.p.- - - 5.. 6.- - - =@. h...- - - - - - - - - J.O.. Z@p.- - 5.. O.g.g.g.g.g.g.g.g.`@:@- - > . . \",\n \". . > ] . . . . . . . . . . . . . 7.8.9 9 9.0.. . u+9 9 9 c@. . . d@9 9 9 e@. . . v+9 9 '@)@. . . .  #.#9 9 9 9 9 9 S++#T.. . ^ #.s@l.o+. . . . . @#6+##p.- - - - 5.. 6.- - 4@m.. $#H.- - - - - - - - - %#i.. 0+I.- - 5.. . . . . . . . . . ] t.- - > . . \",\n \". . > ] . . . . . . . . . . . . . e.&#*#*#=#-#. . v@*#*#*#;#. . . >#*#*#*#!.. . . d@*#*#,#'#. . . . . ,.!.)#!#~#{#G+~.. . . . ^ - - & D.]#;+s@b@Q.-.#.- - - - - - ^#'+'+- - p./#'+t.- - - - - - - - - - - ^#'+'+#.- - ^#'+'+'+'+'+'+'+'+'+'+^#- - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ^ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ^ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > ] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ^ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . > 5.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . a+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - > . . \",\n \". . H+G./@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@O@E._.- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - H+. . \",\n \". . (#P+_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#P+(#. . \",\n \". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . \",\n \". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . \",\n \". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . \"};\n ");
		commitBuffer();
	}
}

//// IVA_GENERAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
