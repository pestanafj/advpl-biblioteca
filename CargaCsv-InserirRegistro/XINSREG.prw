#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} U_xInsReg

	Fun��o para inser��o de registros em uma tabela do banco de dados
	
    @author     Fernanda Pestana
    @since      25/01/2024
    @version    1.0
	@params     cAlias  - Alias da Tabela
	            aHeader - array contendo o cabe�alho (nome dos campos)
				aDados  - array contendo dados a serem inseridos
/*/

User Function xInsReg(cAlias, aHeader, aDados)

	Local aArea := GetArea()

	Local i, j
	Local nCount := 0

	For i := 1 to Len(aDados)

		dbSelectArea(cAlias)
		dbSetOrder(1)
		dbGoTop()

		If !dbSeek(xFilial(cAlias)+aDados[i,1]+aDados[i,2])

			RecLock(cAlias, .T.)

			For j :=1 to Len(aHeader)
				cCampo := cAlias+"->"+aHeader[j]
				&cCampo := aDados[i][j]
			Next

			(cAlias)->(MsUnlock())

			nCount++

		Else
			Alert("N�o � poss�vel inserir registros com c�digos duplicados" + Chr(13)+Chr(10) + "Erro ao inserir registro"+aDados[i,2], "Erro")
		EndIf

		dbCloseArea()

	Next

	RestArea(aArea)

Return
