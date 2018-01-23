class ASC_ItemMod extends AscensionMod
	config(Items);

var config float m_fWepRngIcn;

function DrawWeaponRangeLines(Vector cursorLoc)
{
	local XGSquad kSquad;
	local XGUnit kTarget, ActiveUnit;
	local int I;
    local float fRadius;
	local XComTacticalController TacticalController;

	TacticalController = XComTacticalController(GetALocalPlayerController().ViewTarget.Owner);
	ActiveUnit = TacticalController.GetActiveUnit();
	kSquad = XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kBattle.GetEnemyPlayer(ActiveUnit.GetPlayer()).GetSquad();

	if(m_fWepRngIcn > 0)
	{
		fRadius = m_fWepRngIcn * 64;
	}
	else
	{
		fRadius = 10.0 * 64;
	}

	if(!PRES().m_kTurnOverlay.IsShowingAlienTurn() && !PRES().m_kTurnOverlay.IsShowingOtherTurn() && !XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kBattle.IsAlienTurn())
	{
		for(I = 0; I < kSquad.GetNumMembers(); I++)
		{
			kTarget = kSquad.GetMemberAt(I);
			if(!kTarget.IsMoving() && !kTarget.IsHiding() && kTarget.IsVisible() && kTarget.IsAliveAndWell())
			{
				/*if(VSize(cursorLoc - kTarget.GetPawn().Location) <= (float(ActiveUnit.GetInventory().GetActiveWeapon().m_kTWeapon.iRange) * 64 ))
				{
					kTarget.GetPawn().AttachRangeIndicator(fRadius, kTarget.m_kDiscMesh.StaticMesh);
				}*/
				if(kTarget.m_kCharacter.HasUpgrade(40) && (kTarget.m_arrCloseCombatShots.Find(ActiveUnit) == -1))
				{
					kTarget.GetPawn().AttachRangeIndicator(6.0 * 128, kTarget.m_kSightRing.StaticMesh);
				}
				else
				{
					kTarget.GetPawn().DetachRangeIndicator();
				}
			}
		}
	}
}