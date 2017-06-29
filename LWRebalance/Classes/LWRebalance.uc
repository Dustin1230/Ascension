class LWRebalance extends XComMod
	config(LWRebalance);

struct TLWPerkStats
{
	var EPerkType Perk;
	var int HP;
	var int aim;
	var int def;
	var int mob;
	var float DR;
	var int will;
	var int crit;
};

var config array<TLWPerkStats> PerkStats;
var config bool disableGrenadeEmUp;
var config int ExecutionerBonus;
var config int ExecutionerCritBonus;
var config int DGGDefBonus;
var config int DGGAimBonus;
var config int DeadeyeBonus;
var config int DisableShotBonus;
var config int FlushBonus;
var config int PlatStabAimBonus;
var config int PlatStabCritBonus;
var config int SmokeDefBonus;
var config int CombatDrugsCritBonus;
var config int CombatDrugsWillBonus;
var config int DenseSmokeDefBonus;
var config int LnLAmmoBonus;
var config int SnapshotAimPen;
var config int SnapshotRocketAimPen;
var config float SnapshotRocketDistance;
var config float SnapshotRocketScatter;
var config int FitHRocketAimBonus;
var config float ChittinBonus;
var config int ITZCritPen;
var config int ITZCritPenPerKill;
var config int ITZDmgPen;
var config int ITZDmgPenPerKill;
var config int FieldMedicFreeMedikits;
var config float SaaDRbonus;
var config int JetBootMobBonus;
var config float RepairServosHeal;
var config int KIStaticDmgBonus;
var config float KIDmgBonusPerWepDmg;
var config bool KIReqRnG;
var config float ShredDmgBonus;
var config int RTSAimBonus;
var config int RapidReactionAimBonus;
var config int SentinelOverwatchShots;
var config int OpportunistCritBonus;
var config int CoveringFireAimBonus;
var config int RfAAimBonus;
var config int ArcThrowerCooldown;
var config int MagPistolsAmmoBonus;
var config int MagPistolsCritBonus;
var config int LeUAimBonus;
var config float DamageControlDR;
var config int DamageControlTurns;
var config int UFOResearchBonus;
var LWRCheckpoint m_kLWRCheckpoint;

simulated function ModBridge MBridge()
{
	return ModBridge(XComGameInfo(Outer).Mods[0]);
}

simulated function StartMatch()
{
	local string functionName;
	local string functParas;

	functionName = MBridge().functionName;
	functParas = MBridge().functParas;

	LogInternal("StartMatch, functionName=" @ Chr(34) $ functionName $ Chr(34) @ "functParas=" @ Chr(34) $ functParas $ Chr(34), 'LWRebalance');

	if(functionName == "TestFunct")
	{
		if(functparas != "")
		{
			TestFunct(functParas);
		}
		else
		{
			TestFunct();
		}
	}

	if(functionName == "disableGrenadeEmUp")
	{
		MBridge().StrValue0("", true);
		if(disableGrenadeEmUp)
		{
			MBridge().StrValue0("true");
		}
	}

	if(functionName == "TestSave")
	{
		m_kLWRCheckpoint.test = "Success!";
	}
	
	if(functionName == "ModInit")
	{
		ModInit();
	}

	if(functionName == "DeadeyeBonus")
	{
		MBridge().IntValue0(DeadeyeBonus, true);
	}

	if(functionName == "ExecutionerBonus")
	{
		MBridge().IntValue0(ExecutionerBonus, true);
	}

	if(functionName == "ExecutionerCritBonus")
	{
		MBridge().IntValue0(ExecutionerCritBonus, true);
	}

	if(functionName == "DGGAimBonus")
	{
		MBridge().IntValue0(DGGAimBonus, true);
	}

	if(functionName == "DGGDefBonus")
	{
		MBridge().IntValue0(DGGDefBonus, true);
	}

	if(functionName == "SnapshotAimPen")
	{
		MBridge().IntValue0(SnapshotAimPen, true);
	}

	if(functionName == "DenseSmokeDefBonus")
	{
		MBridge().IntValue0(DenseSmokeDefBonus, true);
	}

	if(functionName == "SmokeDefBonus")
	{
		MBridge().IntValue0(SmokeDefBonus, true);
	}

	if(functionName == "CombatDrugsCritBonus")
	{
		MBridge().IntValue0(CombatDrugsCritBonus, true);
	}

	if(functionName == "RTSAimBonus")
	{
		MBridge().IntValue0(RTSAimBonus, true);
	}

	if(functionName == "RapidReactionAimBonus")
	{
		MBridge().IntValue0(RapidReactionAimBonus, true);
	}

	if(functionName == "SentinelOverwatchShots")
	{
		MBridge().IntValue0(SentinelOverwatchShots, true);
	}


	if(functionName == "CoveringFireAimBonus")
	{
		MBridge().IntValue0(CoveringFireAimBonus, true);
	}

	if(functionName == "RfAAimBonus")
	{
		MBridge().IntValue0(RfAAimBonus, true);
	}

	if(functionName == "OpportunistCritBonus")
	{
		MBridge().IntValue0(OpportunistCritBonus, true);
	}

	if(functionName == "DisableShotBonus")
	{
		MBridge().IntValue0(DisableShotBonus, true);
	}

	if(functionName == "FlushBonus")
	{
		MBridge().IntValue0(FlushBonus, true);
	}

	if(functionName == "PlatStabAimBonus")
	{
		MBridge().IntValue0(PlatStabAimBonus, true);
	}

	if(functionName == "PlatStabCritBonus")
	{
		MBridge().IntValue0(PlatStabCritBonus, true);
	}

	if(functionName == "MagPistolsCritBonus")
	{
		MBridge().IntValue0(MagPistolsCritBonus, true);
	}

	if(functionName == "MagPistolsAmmoBonus")
	{
		MBridge().IntValue0(MagPistolsAmmoBonus, true);
	}

	if(functionName == "ITZCritPen")
	{
		MBridge().IntValue0(ITZCritPen, true);
		MBridge().IntValue1(ITZCritPenPerKill <= 1 ? 1 : ITZCritPenPerKill, true);
	}

	if(functionName == "ITZDmgPen")
	{
		MBridge().IntValue0(ITZDmgPen, true);
		MBridge().IntValue1(ITZDmgPenPerKill <= 1 ? 1 : ITZDmgPenPerKill, true);
	}

	if(functionName == "LnLAmmoBonus")
	{
		MBridge().IntValue0(LnLAmmoBonus, true);
	}

	if(functionName == "KIBonusDmg")
	{
		MBridge().IntValue0(KIStaticDmgBonus, true);
		MBridge().IntValue1(int(KIDmgBonusPerWepDmg * 100.0), true);
		MBridge().IntValue2(KIReqRnG ? 1 : 0, true);
	}

	if(functionName == "DamageControlDR")
	{
		MBridge().IntValue0(int(DamageControlDR * 100.0), true);
	}

	if(functionName == "DamageControlTurns")
	{
		MBridge().IntValue0(DamageControlTurns, true);
	}

	if(functionName == "ChittinBonus")
	{
		MBridge().IntValue0(int(ChittinBonus * 100.0), true);
	}

	if(functionName == "SaaDRbonus")
	{
		MBridge().IntValue0(int(SaaDRbonus * 100.0), true);
	}

}

function ModInit()
{
	`Log("LWRebalance ModInit");
	m_kLWRCheckpoint = Actor(Outer).Spawn(class'LWRCheckpoint');
	MBridge().ModRecordActor("transport", class'LWRCheckpoint');
}

function HasBonus(TCharacter Unit)
{
	local int I;
	local TLWPerkStats totalstats;
	local array<int> arrInt;

	MBridge().arrInts(arrInt, true);

	for(I=0; I < PerkStats.Length; I++)
	{
		if((Unit.aUpgrades[int(PerkStats[I].Perk)] % 2) > 0)
		{
			totalstats.aim += PerkStats[I].aim;
			totalstats.def += PerkStats[I].def;
			totalstats.mob += PerkStats[I].mob;
			totalstats.DR += PerkStats[I].DR;
			totalstats.HP += PerkStats[I].HP;
			totalstats.will += PerkStats[I].will;
			totalstats.crit += PerkStats[I].crit;
		}
	}
	arrInt.AddItem(totalstats.aim);
	arrInt.AddItem(totalstats.def);
	arrInt.AddItem(totalstats.mob);
	arrInt.AddItem(int(totalstats.DR * 10));
	arrInt.AddItem(totalstats.HP);
	arrInt.AddItem(totalstats.will);
	arrInt.AddItem(totalstats.crit);

	MBridge().arrInts(arrInt);
}

function TestFunct(optional string optparas)
{
	`Log("Test successful, LWRebalance. parameter=" @ optparas);
}


DefaultProperties
{
}
