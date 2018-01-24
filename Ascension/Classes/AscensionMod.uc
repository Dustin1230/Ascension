Class AscensionMod extends ModBridge
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

function XGSoldierUI SOLDIERUI()
{
	return XGSoldierUI(XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).GetMgr(class'XGSoldierUI',,, true));
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
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore();   
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
	return XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI);
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
	return XComPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres);
}

simulated function StartMatch()
{
	//local string functionName;
	//local string functParas;
	
	LogInternal("StartMatch, functionName=" @ Chr(34) $ functionName $ Chr(34) @ "functParas=" @ Chr(34) $ functParas $ Chr(34), 'AscensionCore');
	
	if(functionName == "ModInit")
	{
		//spawncode here
		ModRecordActor("Transport",  class'ASCCheckpoint');
		
		ModInit();
	}
	
	if(functionName == "CheckSoldierStates")
	{
		CheckSoldierStates(IntValue1());
	}
	
	if(functionName == "ResetSoldierStates")
	{
		ResetSoldierStates(IntValue1());
	}
	
	if(functionName == "SetSoldierStates")
	{
		SetSoldierStates(IntValue1(), functparas);
	}
	
	if(functionName == "GiveRandomPerk")
	{
		ASCSetUnit(functparas);
		m_kASC_SoldierMod.GiveRandomPerk();
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
    }
	
	if(functionName == "ASCRandomiseStats")
	{
		ASCSetUnit(functparas);
		m_kASC_SoldierMod.GetRookieRandomStats();
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
}

function ModInit()
{
	CreateActor()
	m_kASC_PerksMod = ASC_PerksMod(CreateASCObj("Ascension.ASC_PerksMod");
	m_kASC_SoldierMod = ASC_SoldierMod(CreateASCObj("Ascension.ASC_SoldierMod");
	m_kASC_ItemMod = ASC_ItemMod(CreateASCObj("Ascension.ASC_ItemMod");
	m_kASC_MercenariesMod = ASC_MercenariesMod(CreateASCObj("Ascension.ASC_MercenariesMod");
	m_kASC_PerkMod.expandPerkarray()
}

function AscensionMod CreateASCObj(string classname)
{
    local class<AscensionMod> ModClass;
	
	ModClass = class<AscensionMod>(DynamiceLoadObject(classname, class'Class'));
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
        m_kASCCheckpoint = Spawn(class'ASCCheckpoint', m_kSender);
    }
	//m_kMerc = Spawn(class'MercenaryAscensionMutate', m_kSender);
}

function CheckSoldierStates(int SID)
{
	local TSoldierStorage SS;

	foreach m_kASCCheckpoint.arrSoldierStorage(SS)
	{
		if(SS.SoldierID == SID)
		{
			LogInternal("Gunslinger:" @ string(SS.GunslingerState), 'CheckSoldierStates');
			valStrValue1 = SS.GunslingerState ? "true" : "false";
			break;
		}
	}
}

function ResetSoldierStates(int SID)
{
	local TSoldierStorage SS;
	local int I;

	foreach m_kASCCheckpoint.arrSoldierStorage(SS, I)
	{
		if(SS.SoldierID == SID)
		{
			m_kASCCheckpoint.arrSoldierStorage[I].GunslingerState = false;
			break;
		}
	}
}

function SetSoldierStates(int SID, string state)
{
	local TSoldierStorage SS;
	local int I;

	foreach m_kASCCheckpoint.arrSoldierStorage(SS, I)
	{
		if(SS.SoldierID == SID)
		{
			if(state == "Gunslinger")
			{
				m_kASCCheckpoint.arrSoldierStorage[I].GunslingerState = true;
				break;
			}
		}
	}
}

function ASCSetUnit(string UnitName)
{
	local XGUnit Unit;
	local XGStrategySoldier Soldier;
	//local ASCTStats EmptyStat;

	LogInternal("UnitName=" @ UnitName, 'ASCSetUnit');

	if(XComTacticalGame(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game)) != none)
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
	else if(XComHeadquartersGame(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game)) != none)
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

function bool PercentRoll(float percent)
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

function int SortA(int A, int B) {return A > B ? -1 : 0;}
