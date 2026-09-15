
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

user Function XINIFUNC()
    //Local aTables 		:= {"SA2","SA1","SB1","SB2","SB5","NNR","SC7","SD1","SD2","SDA","SF1","SF2","SB9","SDE","SC6","SM0","SD2","SF2","SWN",'SC5'}
    CFILANT:='01'
    MsApp():New('SIGAFAT')
    oApp:CreateEnv()

    //Seta o tema do Protheus (SUNSET = Vermelho; OCEAN = Azul)
    PtSetTheme("DARK")

    //Define o programa de inicialização
    oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",;
        {|| 	RpcSetEnv( "50", '01', "USRTOTVS04", "Trag3tta@totvs27!")/*, "FAT", ,aTables , , , , .T. )*/, }),;
        custom.sigacom.pedido.u_relatorio(461876),;
        Final("TERMINO NORMAL")}

    //Seta Atributos
    __lInternet := .T.
    lMsFinalAuto := .F.
    oApp:lMessageBar:= .T.
    oApp:cModDesc:= 'SIGAFAT'

    //Inicia a Janela
    oApp:Activate()
return

user Function XINILOC()
    //Local aTables 		:= {"SA2","SA1","SB1","SB2","SB5","NNR","SC7","SD1","SD2","SDA","SF1","SF2","SB9","SDE","SC6","SM0","SD2","SF2","SWN",'SC5'}
    CFILANT:='01'
    MsApp():New('SIGACOM')
    oApp:CreateEnv()

    //Seta o tema do Protheus (SUNSET = Vermelho; OCEAN = Azul)
    PtSetTheme("DARK")

    //Define o programa de inicialização
    oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",;
        {|| 	RpcSetEnv( "99", '01', "admin", "Protheus.1537")/*, "FAT", ,aTables , , , , .T. )*/, }),;
        custom.sigacom.pedido.u_relatorio(1),;
        Final("TERMINO NORMAL")}

    //Seta Atributos
    __lInternet := .T.
    lMsFinalAuto := .F.
    oApp:lMessageBar:= .T.
    oApp:cModDesc:= 'SIGACOM'

    //Inicia a Janela
    oApp:Activate()
return

// custom.sigactb.titan16.aprovacao.u_XMVCZ00(),;
