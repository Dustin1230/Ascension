class RPCheats extends XComHeadquartersCheatManager;

exec function RoulettePlusTest()
{
	`Log("Success");
}

exec function RerollRandomTree()
{
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;

	PC = XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

	kSoldierUI.m_kSoldier.AssignRandomPerks();
	kSoldierUI.SetActiveSoldier(kSoldierUI.m_kSoldier);
	kSoldierUI.UpdateDoll();
	kSoldierUI.UpdateView();

	kSoldierUI.m_kSoldier.onLoadoutChange();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierSummary.SetSoldier(kSoldierUI.m_kSoldier);
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.GetMgr().UpdateView();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.UpdateAbilityData();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.m_kSoldierHeader.UpdateData();
	XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.m_kSoldierStats.UpdateData();
}

DefaultProperties
{
}
