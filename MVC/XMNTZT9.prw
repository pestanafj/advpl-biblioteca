#INCLUDE "PROTHEUS.CH"
#INCLUDE "FwMVCDef.CH"

/*/{Protheus.doc} U_xMntZT9
	Cadastro MVC Aprovadores da Manutenção (ZT9)
    @author     Fernanda Pestana
    @since      03/10/2024
    @version    1.0
/*/
/*-------------------- Inicio da Rotina MVC-------------------------------------------------------*/
User Function xMntZT9()
	Local aArea := GetArea()
	Local oBrowse := FwMBrowse():New()
	Local cFunBkp := FunName()
	
	SetFunName("xMntZT9")
	
	oBrowse:setAlias('ZT9')
	oBrowse:SetDescription("Aprovadores da Manutenção")
	oBrowse:Activate()

	SetFunName(cFunBkp)
	RestArea(aArea)

Return

Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE 'Incluir'       ACTION 'VIEWDEF.xMntZT9'  OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'       ACTION 'VIEWDEF.xMntZT9'  OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'    ACTION 'VIEWDEF.xMntZT9'  OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'       ACTION 'VIEWDEF.xMntZT9'  OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Importar CSV'  ACTION 'VIEWDEF.xMntZT9'  OPERATION 3 ACCESS 0
Return aRotina

Static Function ModelDef()
	Local oStruZT9 := FWFormStruct(1, 'ZT9')
	Local oModel := MPFormModel():New("XMNTZT9M")

	oModel:AddFields('ZT9MASTER',, oStruZT9)
	oModel:SetPrimaryKey({'ZT9_USUARI'})
	oModel:SetDescription("Modelo Aprovadores Manutenção")
	oModel:GetModel('ZT9MASTER'):SetDescription("Dados dos Aprovadores da Manutenção")

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel('XMNTZT9')
	Local oStruZT9 := FWFormStruct(2, 'ZT9')
	
	Local oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('VIEW_ZT9', oStruZT9, 'ZT9MASTER')
	oView:CreateHorizontalBox('TELA', 100)
	oView:SetOwnerView('VIEW_ZT9', 'TELA')
Return oView

/*-------------------- Fim da Rotina MVC-------------------------------------------------------*/


/*/{Protheus.doc} U_GetUser

	Função utilizada para Inicilização dos
	campos de Usuario da Tabela ZT9

    @author     Fernanda Pestana
    @since      13/09/2024
    @version    1.0
/*/
User Function GetUser(idUser,nInfo)

	Local aArea := GetArea()
	Local aUser := {}
	Local cQuery := ""
	Local lRet  := ""

	cQuery := " SELECT USR.USR_ID,             " + CRLF
	cQuery += "     USR.USR_CODIGO,            " + CRLF
	cQuery += "     USR.USR_NOME               " + CRLF
	cQuery += " FROM SYS_USR AS USR            " + CRLF
	cQuery += " WHERE USR_ID = '" + idUser + "'"

	If Select("TMP") > 0
		dbSelectArea("TMP")
		dbCloseArea()
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP", .F., .T.)

	If !TMP->(Eof())
		aUser := {allTrim(USR_ID), allTrim(USR_CODIGO), allTrim(USR_NOME)}
		lRet := aUser[nInfo]
		TMP->(dbSkip())
	EndIf
	RestArea(aArea)

Return lRet

