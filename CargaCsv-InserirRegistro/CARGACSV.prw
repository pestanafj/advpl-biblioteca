
/*/{Protheus.doc} U_CargaCSV

	Função para importação de planilha CSV
	e grava log do resultado

    @author     Fernanda Pestana
    @since      25/01/2024
    @version    1.0
/*/
User Function CargaCSV()

	Local aDados	:= {}
	Local cDirD		:= "\temp\log\"
	Local cAlias    := 'ZT9'
	Local cFileLOG	:= cDirD + "Carga"+cAlias+"-"+ FWFWTimeStamp(1) +".log"
	Local aHeader, i

	Private ENTER 	 := CHR(13)+CHR(10)
	Private nHandle1 := 0
	Private nHandle2 := 0
	Private nOk		 := 0	// Total linhas processada
	Private nTotal	 := 0 	// Total de Linhas da planilha
	Private nNok	 := 0 	// Total de linhas Não processado

	nHandle1 := FCREATE(cFileLOG)

	if nHandle1 = -1
		Alert("Erro ao criar arquivo - ferror " + Str(Ferror()))
		Return
	Endif

	IniLOG()
	// Visualmente o desenvolvedor já consegue detectar que acabou a rotina, não vai seguir
	// FCREATE

	GravaLOG("Preparar para carregar Cabecalho e Dados")

	cDir := "\SYSTEM\"

	// cGetFile ( [ cMascara], [ cTitulo], [ nMascpadrao], [ cDirinicial], [ lSalvar], [ nOpcoes], [ lArvore], [ lKeepCase] )
	cArquivo := cGetFile("*.csv|*.csv","Selecao de Arquivos",0,cDir,.T.,GETF_LOCALHARD,.T.)

	nHandle2    := FT_FUSE(cArquivo)		// Está tentando abrir o arquivo escolhido

	// Se houver erro de abertura abandona processamento
	If nHandle2 == -1		// << menos 1 significa que não conseguiu abrir o arquivo....
		cTexto := "Erro de abertura : FERROR " + str(ferror() )
		MsgStop( cTexto , 4)
		GravaLOG( cTexto )
		FClose(nHandle2)
	EndIf

	lCabec	:= .T.
	aCabec := {}
	aDados := {}
	nLinha	:= 0
	nTotal	:= ft_flastrec() -1 // Total de Linhas com conteudo
	nOk		:= 0 				// Linhas processadas
	nNok	:= 0				// Linhas nao processadas


	While !FT_FEOF()
		// Retorna uma linha do arquivo aberto
		GravaLOG( "lendo linha no " + Str( nLinha++ ))

		cLine := FT_FReadLn()

		If lCabec == .T.
			lCabec:= .F.	// Le a primeira linha e desabilita cabelalho
			aAdd(aCabec, StrTokArr(cLine, ","))
		Else
			aAdd(aDados, StrTokArr(cLine, ","))
		Endif

		// Pula para próxima linha
		FT_FSKIP()
	End

	GravaLOG("Conseguiu carregar Cabecalho e Dados")

	aHeader := Array(  Len( aCabec[1] ) )

	For i := 1 to Len( aCabec [1])
		aHeader[ i] := aCabec[ 1, i ]
	Next

	U_xInsReg(cAlias, aHeader, aDados)

	If nOk	== 0 	// Não pocessou nada
		GravaLOG("Não pocessou nada")
	Else

		If _CopyFile( cArquivo, cDirD+"\processado\Carga"+cAlias+"-"+ FWFWTimeStamp(1) +".csv")
			GravaLOG("Moveu o arquivo para " + cDirD)
			MsgInfo("Arquivo CSV Importado com Sucesso!", "Fim da Execução")
		Else
			GravaLOG("Nao moveu o arquivo. Verifique as permissoes na pasta " + cDirD)
		Endif

	Endif

	FimLOG()

Return



Static Function IniLog()
	FWrite(nHandle1, REPLICATE("=",130) + ENTER,99)
	FWrite(nHandle1, "INICIO DO LOG"	+ ENTER,99)
	FWrite(nHandle1, REPLICATE("=",130) + ENTER,99)
Return

Static Function GravaLog( _cTEXTO )
	Local cTexto := ""

	cTexto += DtoC( Date() ) + " - "
	cTexto += Time() + " - "
	cTexto += _cTEXTO
	cTexto += ENTER

	FWrite(nHandle1, cTEXTO ,99)
Return( .T. )

Static Function FimLog()
	FWrite(nHandle1, REPLICATE("=",130) + ENTER,99)
	FWrite(nHandle1, "FIM DO LOG"		+ ENTER,99)
	FWrite(nHandle1, "Total de Linhas da planilha"  +str(nTotal)+ ENTER,99)
	FWrite(nHandle1, "Total linhas processadas" 	+str(nOk)	+ ENTER,99)
	FWrite(nHandle1, "Total linhas nao processadas" +str(nNok)	+ ENTER,99)
	FWrite(nHandle1, REPLICATE("=",130) + ENTER,99)

	FClose(nHandle1)

Return

