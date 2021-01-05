class ASC_CoreMod extends ModBridgeMod
	config(Ascension);
	
var ASCCheckpoint m_kASCCheckpoint;

var ASC_PerksMod m_kASC_PerksMod;
var ASC_SoldierMod m_kASC_SoldierMod;
var ASC_ItemMod m_kASC_ItemMod;
var ASC_MercenariesMod m_kASC_MercenariesMod;

var XGStrategySoldier m_kStratSoldier;
//var ASCTStats m_kTotalStats;
var XGUnit m_kUnit;

var localized string m_perkNames[255];
var localized string m_perkDesc[255];


function WorldInfo WORLDINFO()
{
	return class'Engine'.static.GetCurrentWorldInfo();
}

function PlayerController PLAYERCONTROLLER()
{
	return WORLDINFO().GetALocalPlayerController();
}

function XGSoldierUI SOLDIERUI()
{
	return XGSoldierUI(XComHQPresentationLayer(XComPlayerController(PLAYERCONTROLLER()).m_Pres).GetMgr(class'XGSoldierUI',,, true));
}

function XGStrategySoldier SOLDIER()
{
	return SOLDIERUI().m_kSoldier;
}

function TSoldier SOLDIERT()
{
	return SOLDIER().m_kSoldier;
}

function XGParamTag TAG()
{
	return XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
}

function XGStrategy STRATEGY()
{
    return XComHeadquartersGame(WORLDINFO().Game).GetGameCore();   
}

function XGHeadQuarters HQ()
{
    return STRATEGY().GetHQ();   
}

function XGFacility_Barracks BARRACKS()
{
 	return HQ().m_kBarracks;
}

function XGFacility_Lockers LOCKERS()
{
 	return BARRACKS().m_kLockers;
}

function XComGameReplicationInfo GRI()
{
	return XComGameReplicationInfo(WORLDINFO().GRI);
}

function XGTacticalGameCore TACTICAL()
{
    return GRI().m_kGameCore;
}

function XComPerkManager PERKS()
{
    return GRI().m_kPerkTree;   
}

function XGFacility_Labs LABS()
{
	return HQ().m_kLabs;
}

function XComPresentationLayer PRES()
{
	return XComPresentationLayer(XComPlayerController(PLAYERCONTROLLER()).m_Pres);
}

function bool isStrategy()
{
	return XComHeadquartersGame(XComGameInfo(WORLDINFO().Game)) != none;
}

function bool isTactical()
{
	return XComTacticalGame(XComGameInfo(WORLDINFO().Game)) != none;
}

simulated function StartMatch()
{
	//local string functionName;
	//local string functParas;
	local array<string> arrStr;
	
	LogInternal("StartMatch, functionName=" @ Chr(34) $ functionName $ Chr(34) @ "functParas=" @ Chr(34) $ functParas $ Chr(34), 'AscensionCore');
	
	if(functionName == "ModInit")
	{
		ModInit();
	}
	
	if(functionName == "CheckSoldierStates")
	{
		ASCSetUnit(StrValue0());
		m_kASC_PerksMod.CheckSoldierStates();
		m_kUnit = none;
		m_kStratSoldier = none;
	}
	
	if(functionName == "ResetSoldierStates")
	{
		ASCSetUnit(StrValue0());
		m_kASC_PerksMod.ResetSoldierStates();
		m_kUnit = none;
		m_kStratSoldier = none;
	}
	
	if(functionName == "SetSoldierStates")
	{
		ASCSetUnit(StrValue0());
		m_kASC_PerksMod.SetSoldierStates(functparas);
		m_kUnit = none;
		m_kStratSoldier = none;
	}
	
	if(functionName == "GiveRandomPerk")
	{
		ASCSetUnit(functparas);
		m_kASC_SoldierMod.GiveRandomPerk();
		m_kUnit = none;
		m_kStratSoldier = none;
	}
	
	if(functionName == "CheckRandomPerk")
	{
		m_kASC_SoldierMod.CheckRandomPerk(int(functparas));
	}
	
	if(functionName == "SoldLevelupStat")
	{
		if(functparas != "")
		{
			m_kASC_SoldierMod.SoldLevelupStat(int(functparas));	
		}
		else
		{
			m_kASC_SoldierMod.SoldLevelupStat();
		}
	}
	
	if(functionName == "SoldGetPerkCT")
    {
		ASCSetUnit(functparas);
		m_kASC_SoldierMod.SoldGetPerkCT();
		m_kUnit = none;
		m_kStratSoldier = none;
    }
	
	if(functionName == "ASCRandomiseStats")
	{
		ASCSetUnit(functparas);
		m_kASC_SoldierMod.GetRookieRandomStats();
		m_kUnit = none;
		m_kStratSoldier = none;
	}
	
	if(functionName == "ASCStats") 
    {
		if(functparas != "") 
		{
			m_kASC_SoldierMod.applyStats(int(functparas));
		}
		else
		{
			m_kASC_SoldierMod.applyStats();
		}
	}

	if(functionName == "FlushAlienPerks")
	{
		m_kASC_PerksMod.FlushAlienPerks();
	}
	
	if(functionName == "ASCPerkDescription")
	{
		m_kASC_PerksMod.ASCPerkDescription(int(functparas));
	}
	
	if(functionName == "ASCPerks") 
    {
		arrStr = SplitString(functparas, "_", false);

		ASCSetUnit(arrStr[0]);

		if(arrStr.Length > 3) 
        {
			m_kASC_PerksMod.ASCPerks(arrStr[1], int(arrStr[2]), int(arrStr[3]));
		}
		else 
        {
			m_kASC_PerksMod.ASCPerks(arrStr[1], int(arrStr[2]));
		}
		m_kUnit = none;
		m_kStratSoldier = none;
	}

	if(functionName == "CurruptMessage")
	{
		ASCSetUnit(StrValue0());
		m_kASC_PerksMod.CurruptMessage(StrValue1());
	}

	if(functionNamme == "AlienHasPerk")
	{
		ASCSetUnit(StrValue0());
		m_kASC_PerksMod.ASCAlienHasPerk(int(functParas));
		m_kUnit = none;
	}

	if(functionName == "GiveAlienPerk")
	{
		ASCSetUnit(StrValue0());

		arrStr = SplitSting(functParas, "_", false);

		if(arrStr.Length > 1)
		{
			m_kASC_PerksMod.ASCAlienGivePerk(int(arrStr[0]), int(arrStr[1]));
		}
		else
		{
			m_kASC_PerksMod.ASCAlienGivePerk(int(arrStr[0]));
		}
		m_kUnit = none;
	}

}

function ModInit()
{
	CreateActor();
	m_kASC_PerksMod = ASC_PerksMod(CreateASCObj("Ascension.ASC_PerksMod"));
	m_kASC_SoldierMod = ASC_SoldierMod(CreateASCObj("Ascension.ASC_SoldierMod"));
	m_kASC_ItemMod = ASC_ItemMod(CreateASCObj("Ascension.ASC_ItemMod"));
	m_kASC_MercenariesMod = ASC_MercenariesMod(CreateASCObj("Ascension.ASC_MercenariesMod"));
	m_kASC_PerksMod.expandPerkarray();
	m_kASC_SoldierMod.SoldierInit();
	ModRecordActor("Transport",  class'ASCCheckpoint');
}

function AscensionMod CreateASCObj(string classname)
{
    local class<AscensionMod> ModClass;
	
	ModClass = class<AscensionMod>(Spawn(DynamicLoadObject(classname, class'Class'), PLAYERCONTROLLER));
	return new (self) ModClass;
}

function CreateActor()
{
    local bool foundActor;
    local ASCCheckpoint asc;

    foundActor = false;
    foreach AllActors(class'ASCCheckpoint', asc)
    {
        foundActor = true;
        m_kASCCheckpoint = asc;
        break;        
    }    
    if(!foundActor)
    {
        m_kASCCheckpoint = WORLDINFO().Spawn(class'ASCCheckpoint', PLAYERCONTROLLER());
    }
	//m_kMerc = Spawn(class'MercenaryAscensionMutate', m_kSender);
}

function ASCSetUnit(string UnitName)
{
	local XGUnit Unit;
	local XGStrategySoldier Soldier;
	//local ASCTStats EmptyStat;

	LogInternal("UnitName=" @ UnitName, 'ASCSetUnit');

	if(isTactical())
	{
		foreach AllActors(class'XGUnit', Unit)
		{
			if(string(Unit) == UnitName)
			{
				break;
			}
		}
		m_kUnit = Unit;
	}
	else if(isStrategy())
	{
		foreach AllActors(class'XGStrategySoldier', Soldier)
		{
			if(string(Soldier) == UnitName)
			{
				break;
			}
		}
		m_kStratSoldier = Soldier;
	}
	//m_kTotalStats = EmptyStat;
}

function bool PercentRoll(float percent, optional bool isSynced)
{
	if(isSynced)
	{
		if(((class'XComEngine'.static.SyncFRand("") * 100.00) + 1.0) * (100.00 / (101.00 - percent)) > 99.99)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		if(RandRange(0.99991, 100.99991) * (100.00 / (101.00 - percent)) > 99.99)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}

function int SortA(int A, int B) {return A > B ? -1 : 0;}
