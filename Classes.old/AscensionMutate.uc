Class AscensionMutate extends XComMutator
	config(Ascension);

struct ASCTPerkInfo
{
	var string ID;
    var int PerkNumSlot;
    var string name;
	var string Description;
    var string IconID;
	
};

struct ASCTAffects
{
	var string ID;
	var bool bEnemy;
	var bool bSoldier;
	var bool bVIP;
	var bool bCiv;
	var int SoldierState;
};

struct ASCTCover
{
	var string ID;
	var bool bSelf;
	var bool bTarget;
	var int iSelfFlank;
	var int iTargetFlank;
	var int TypeCoverS;
	var int TypeCoverT;
};

struct ASCTRequirements
{
	var string ID;
	var bool bRange;
	var bool bLOS;
    var bool bAllies;
	var bool bEnemies;
    var bool bCivilian;
	var bool bHasMoved;
  	var bool bTCover;
  	var int RangeReq;
	var int AllyReq;
	var int EnemyReq;
	var int CivReq;
	var float fHPPercent;
	//research, foundry and OTS
	//Perk
};

struct ASCTStats
{
	var string ID;
  	var int HP;
	var int Def;
	var float fDR;
	var int Aim;
	var int Mob;
	var int Will;
	var int Dmg;
	var int CritChance;
	var int CritDmg;
	var int Range;
	var int Ammo;
};

struct ASCTBehaviour
{
	var string ID;
	var bool bAddCharges;
	var float fXPIncrease;
	var int numShots;
	var int numActions;
	var int exploDmg;
	var int consumableRadius;
	var bool bPanic;
	var int iBasePanic;
	var bool bIncCasterWill;
	var bool bTempStat;
	var int iTurnsTempStat;
	var int iIsReaction;
	var int NumUses;
	var bool bMultUses;
};

struct ASCTConfigPerks
{
	var string ID;
	var ASCTPerkInfo Info;
	var ASCTAffects Affects;
	var ASCTRequirements Req;
	var ASCTStats Stats;
	var ASCTBehaviour Beh;
};

struct TSpecPerk
{
  	var int iItem;
  	var array<int> iClass;
  	var array<int> iPerk;
};


var array<int> SoldierState;
var config array<ASCTPerkInfo> PerkInfo;
var config array<ASCTAffects> Affects;
var config array<ASCTStats> Stats;
var config array<ASCTRequirements> Req;
var config array<ASCTBehaviour> Beh;
var array<ASCTConfigPerks> m_kConfigPerks;
var PlayerController m_kSender;
var string AmnesiaPerkName;
var string AmnesiaPerkDes;
var ASCCheckpoint m_kASCCheckpoint;
var ASCTStats m_kTotalStats;
var XGUnit m_kUnit;
var config array<TSpecPerk> specPerk;


function Mutate(String MutateString, PlayerController Sender) 
{
	local XComPerkManager kPerkMan;
	local array<string> arrMutateStr;
	
	kPerkMan = XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPerkTree;
	m_kSender = Sender;


	if(Left(MutateString, 8) == "ASCPerks") 
	{
		`Log("Mutate: ASCPerks");
		arrMutateStr = SplitString(MutateString, "_", false);
		if(arrMutateStr[4] != "") 
        {
			ASCPerks(arrMutateStr[1], int(arrMutateStr[2]), int(arrMutateStr[3]), int(arrMutateStr[4]));
		}
		else 
        {
			ASCPerks(arrMutateStr[1], int(arrMutateStr[2]), int(arrMutateStr[3]));
		}
	}
	
	if(MutateString == "ASCInit")
	{
		`Log("Mutate: Ascension");
		Init();
	}
	
	if(Left(MutateString, 10) == "ASCSetUnit")
	{
		`Log("Mutate: ASCSetUnit");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCSetUnit(arrMutateStr[1]);
	}
	
	if(Left(MutateString, 8) == "ASCStats") 
	{
		`Log("Mutate: ASCStats");
		arrMutateStr = SplitString(MutateString, "_", false);
		if(int(arrMutateStr[1]) > 0) 
		{
			applyStats(int(arrMutateStr[1]));
		}
		else
		{
			applyStats();
		}
	}
	
	if(Left(MutateString, 7) == "WepSpec")
	{
    		`Log("Mutate: WeaponSpecialistPerk");
    		arrMutateStr = SplitString(MutateString, "_", false);
    		WepSpecPerk(int(arrMutateStr[1]), arrMutateStr[2]);
	}
	
	if(Left(MutateString, 18) == "ResetSoldierStates")
	{
		`Log("Mutate: ResetSoldierStates");
		arrMutateStr = SplitString(MutateString, "_", false);
		ResetSoldierStates(int(arrMutateStr[1]));
	}
	
	if(Left(MutateString, 18) == "CheckSoldierStates")
	{
		`Log("Mutate: CheckSoldierStates");
		arrMutateStr = SplitString(MutateString, "_", false);
		CheckSoldierStates(int(arrMutateStr[1]));
	}
	
	if(Left(MutateString, 16) == "SetSoldierStates")
	{
		`Log("Mutate: SetSoldierStates");
		arrMutateStr = SplitString(MutateString, "_", false);
		SetSoldierStates(int(arrMutateStr[1]), arrMutateStr[2]);
	}
	
	if(Left(MutateString, 9) == "ASCOnKill")
	{
		`Log("Mutate: ASCOnKill");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCOnKill(arrMutateStr[1], arrMutateStr[2]);
	}
	
	if(Left(MutateString, 11) == "TestPerkNum")
	{
		LogInternal(split(MutateString, "TestPerkNum ", true), 'TestPerkNum perkNum');
		LogInternal(kPerkMan.m_arrPerks[int(split(MutateString, "TestPerkNum ", true))].strName[0], 'TestPerkNum perkName');
		LogInternal(kPerkMan.m_arrPerks[int(split(MutateString, "TestPerkNum ", true))].strDescription[0], 'TestPerkNum perkDes');
	}

	
	if(kPerkMan != None) 
	{
		if(kPerkMan.m_arrPerks.length < 174) 
        {
			expandPerkarray();
		}
	}
	
	super.Mutate(MutateString, Sender);
}

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

function XGTacticalGameCore TACTICAL()
{
    return XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kGameCore;
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
}

function ResetSoldierStates(int SID)
{
	local TSoldierStorage SS;
	local int I;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}
	
	foreach m_kASCCheckpoint.arrSoldierStorage(SS, I)
	{
		if(SS.SoldierID == SID)
		{
			m_kASCCheckpoint.arrSoldierStorage[I].GunslingerState = false;
			break;
		}
	}
	
}

function CheckSoldierStates(int SID)
{
	local TSoldierStorage SS;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}
	
	foreach m_kASCCheckpoint.arrSoldierStorage(SS)
	{
		if(SS.SoldierID == SID)
		{
			LogInternal("Gunslinger:" @ string(SS.GunslingerState), 'CheckSoldierStates');
			TAG().StrValue1 = SS.GunslingerState ? "true" : "false";
			break;
		}
	}
}

function SetSoldierStates(int SID, string state)
{
	local TSoldierStorage SS;
	local int I;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}
	
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

function int SortA(int A, int B) {return A < B ? -1 : 0;}

/*function ASCRandomiseStats(int iClass)
{
	local int I, J, iRand, iPos, pointsused;
	local array<int> list, weight, list2, weight2;

	J = 0;
	list.addItem(HPPts);
	list.addItem(AimPts);
	list.addItem(DefPts);
	list.addItem(WillPts);
	list.addItem(MobPts);

	weight = list;
	list2 = list;
	weight.sort(SortA);
	weight2 = weight;
	foreach weight(iRand, I)
	{
		if(I > 0)
		{
			if(iRand == weight2[I - 1])
			{
				++ J;
				list2.remove(list2.find(iRand), 1);
				weight[I] = list2.find(iRand) + J;
			}
			else
			{
				J = 0;
				list2 = list;
				weight[I] = list.find(iRand);
			}
		}
		else
		{
			weight[I] = list.find(iRand);
		}
	}
	
	:loop
	if(pointsused < maxpoints)
	{
		I = list[weight[weight.length - 1]] + 1;
		iPos = 0;
		
		for(J = 0; J < list.length; J ++)
		{
			iPos += ((list[J] * -1) + I);
		}
		
		iRand = Rand(iPos + list.length - 1);
		ipos = 0;
		
		for(J = 0; J < weight.length; J ++)
		{
			for(I = 0; I < ((list[weight[J]] * -1) + list[weight[weight.length - 1]]); I ++)
			{
				if(iRand == iPos + I)
				{
					switch(J)
					{
						case 0:
							if(list[0] < maxpoints - pointsused)
							{
								addhp
								pointsused += list[0];
							}
							break;
						case 1:
							if(list[1] < maxpoints - pointsused)
							{
								addaim
								pointsused += list[1];
							}
							break;
						case 2:
							if(list[2] < maxpoints - pointsused)
							{
								adddef
								pointsused += list[2];
							}
							break;
						case 3:
							if(list[3] < maxpoints - pointsused)
							{
								addwill
								pointsused += list[3];
							}
							break;
						case 4:
							if(list[4] < maxpoints - pointsused)
							{
								addmob
								pointsused += list[4];
							}
							break;
						default:
							break;
					}
				}
			}
			iPos += I + 1;
		}
		goto loop;
	}
	
}*/

function ASCPerks(string funct, int SID, int perk, optional int value = 1)
{

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}


	if(funct == "HasPerk")
	{
		m_kASCCheckpoint.HasPerkASC(SID, perk);
	}
	if(funct == "GivePerk")
	{
		m_kASCCheckpoint.GivePerkASC(SID, perk, value);
	}
	if(funct == "RemovePerk")
	{
		m_kASCCheckpoint.RemovePerkASC(SID, perk, value);
	}
}

function ASCSetUnit(string UnitName)
{
	local XGUnit Unit;
	
	foreach AllActors(class'XGUnit', Unit)
	{
		if(string(Unit) == UnitName)
		{
			break;
		}
	}
	m_kUnit = Unit;

}

function expandPerkarray()
{
	
	local XComPerkManager kPerkMan;
	
	kPerkMan = BARRACKS().m_kPerkManager;
	
	stperkman:
	kPerkMan.m_arrPerks.Length = 255;
	
	LogInternal(String(kPerkMan), 'expandPerkarray');
	
	kPerkMan.BuildPerk(116, 0, "Evasion");
	
	kPerkMan.BuildPerk(124, 0, "Sentinel"); 
	
	kPerkMan.BuildPerk(173, 0, "Unknown");
	kPerkMan.m_arrPerks[173].strName[0] = AmnesiaPerkName;
	kPerkMan.m_arrPerks[173].strDescription[0] = AmnesiaPerkDes;
	
	kPerkMan.BuildPerk(174, 0, "RifleSuppression");
	kPerkMan.m_arrPerks[174].strName[0] = "Weapon Specialist";
	kPerkMan.m_arrPerks[174].strDescription[0] = "Allows the unit to receive an additional perk based off the weapon, armor, and items they bring into a mission.";
	
	kPerkMan.BuildPerk(175, 0, "ExpandedStorage");
	kPerkMan.m_arrPerks[175].strName[0] = "Item Jack";
	kPerkMan.m_arrPerks[175].strDescription[0] = "GunslingerTest";
	
	kPerkMan.BuildPerk(176, 0, "SentinelModule");
	kPerkMan.m_arrPerks[176].strName[0] = "Gun-Slinger";
	kPerkMan.m_arrPerks[176].strDescription[0] = "Increases the pistol ammo by 1, first pistol shot requires no action and additional pistol shots cost 1 action.";
	
	kPerkMan.BuildPerk(177, 0, "StarWill");
	kPerkMan.m_arrPerks[177].strName[0] = "This is the Life";
	kPerkMan.m_arrPerks[177].strDescription[0] = "Reduces fatigue to 0 at the cost of increasing length injuries by 50%.";
	
	kPerkMan.BuildPerk(178, 0, "StarHire");
	kPerkMan.m_arrPerks[178].strName[0] = "For the Cause";
	kPerkMan.m_arrPerks[178].strDescription[0] = "Removes initial monthly cost of Mercenary soldiers and reduces monthly cost of future cost perks by 50%.";
	
	kPerkMan.BuildPerk(179, 0, "UrbanDefense");
	kPerkMan.m_arrPerks[179].strName[0] = "You Ain't Nothin'";
	kPerkMan.m_arrPerks[179].strDescription[0] = "Adds a flat 10 to defense and also reduces the chance to be hit with a critical by 50%.";
	
	kPerkMan.BuildPerk(180, 0, "HonorTerror");
	kPerkMan.m_arrPerks[180].strName[0] = "Xenocide";
	kPerkMan.m_arrPerks[180].strDescription[0] = "With every kill the unit gains +1 Will & Crit Chance for the rest of the mission. Also increases Crit Damage by 2.";
	
	kPerkMan.BuildPerk(181, 0, "Intimidate");
	kPerkMan.m_arrPerks[181].strName[0] = "Wrath";
	kPerkMan.m_arrPerks[181].strDescription[0] = "If the Fury is Mind Controlled they receive a penalty to Aim and Mobility.";
	
	kPerkMan.BuildPerk(189, 0, "Disoriented");
	kPerkMan.m_arrPerks[189].strName[0] = "Currupt";
	kPerkMan.m_arrPerks[189].strDescription[0] = "When an enemy unit uses a psi attack against the Fury they suffer a panic check.";
	
	kPerkMan.BuildPerk(190, 0, "ReactivePupils");
	kPerkMan.m_arrPerks[190].strName[0] = "Weakpoint Analysis";
	kPerkMan.m_arrPerks[190].strDescription[0] = "+10 aim, +10 crit and 1 DR piercing on mechanical units. (WIP)";
	
	kPerkMan.BuildPerk(191, 0, "Stun");
	kPerkMan.m_arrPerks[191].strName[0] = "Incapacitation";
	kPerkMan.m_arrPerks[191].strDescription[0] = "Uncovered or flanked enemies that are hit by primary fire suffer a mobility, defense and DR penalty.";
	
	
	if(kPerkMan != XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPerkTree)
	{
		kPerkMan = XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPerkTree;
		goto stperkman;
	}
	
}

function Init()
{
	local ASCTStats Stat;
	
	Stat.Mob = 6;
	stat.CritChance = 11;

	buildConfigPerks();
	
	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}
	m_kASCCheckpoint.CompletedProject();
	
	gatherTotalStats(Stat);
	applyStats(3);
}

function WepSpecPerk(int iItemType, string funct)
{
	local int I, J;
  	local bool bFound;

	for(I = 0; I < specPerk.length; I ++)
	{
		if(iItemType == specPerk[I].iItem)
		{
			for(J = 0; J < specPerk[I].iClass.length; J ++)
			{
				bFound = false;
				if(specPerk[I].iClass[J] == -1 || specPerk[I].iClass[J] == SOLDIER().m_iEnergy)
				{
					if(funct == "add")
					{
						SOLDIER().m_kChar.aUpgrades[specPerk[I].iPerk[J]] += 2;
						bFound = true;
						break;
					}
					if(funct == "rem")
					{
						if(SOLDIER().m_kChar.aUpgrades[specPerk[I].iPerk[J]] > 1)
						{
							SOLDIER().m_kChar.aUpgrades[specPerk[I].iPerk[J]] -= 2;
							bFound = true;
							break;
						}
					}
				}
			}
			if(bFound)
			{
				break;
			}
		}
	}
}

function buildConfigPerks()
{
	local ASCTConfigPerks configPerk, kConfigPerks;
	local int I;
	
	foreach PerkInfo(configPerk.Info)
	{
		if(configPerk.info.PerkNumSlot > 223 || configPerk.info.PerkNumSlot < 255)
		{
			`Log("BuildConfig");
			for(I=0; m_kConfigPerks[I].ID != ""; I++)
			{
				`Log("The value of I is " $ I );
			}
		  
		  
			/*I = 0;
			loop:
			if(m_kConfigPerks[I].ID != "")
			{
				++ I;
				goto loop;
			}
			`Log("The value of I is " $ I );*/
			
			m_kConfigPerks.add(1);
		
			kConfigPerks.Info = configPerk.Info;
			kConfigPerks.ID = configPerk.Info.ID;
		
			foreach Affects(configPerk.Affects)
			{
				`Log("Affects");
				`Log("AffectsSS= " $ configPerk.Affects.SoldierState);
				if(kConfigPerks.ID == configPerk.Affects.ID)
				{
					kConfigPerks.Affects = configPerk.Affects;
				}
			}
			
			foreach Stats(configPerk.Stats)
			{
				if(kConfigPerks.ID == configPerk.Stats.ID)
				{
					kConfigPerks.Stats = configPerk.Stats;
				}
			}
			
			foreach Req(configPerk.Req)
			{
				if(kConfigPerks.ID == configPerk.Req.ID)
				{
					kConfigPerks.Req = configPerk.Req;
				}
			}
			
			foreach Stats(configPerk.Stats)
			{
				`Log("ConfigStats Aim=" @ configPerk.Stats.Aim);
			
				if(kConfigPerks.ID == configPerk.Stats.ID)
				{
					kConfigPerks.Stats = configPerk.Stats;
				}
			}
			
			foreach Beh(configPerk.Beh)
			{
				if(kConfigPerks.ID == configPerk.Beh.ID)
				{
					kConfigPerks.Beh = configPerk.Beh; 
				}
			}
			
			m_kConfigPerks[I] = kConfigPerks;
			`Log("ConfigPerks");
			`Log("ConfigPerks Aim=" @ m_kConfigPerks[I].Stats.Aim);
		}
	}
}

function gatherTotalStats(ASCTStats kStats)
{
	`Log("TotalStats");
  	m_kTotalStats.Dmg += kStats.Dmg;
	m_kTotalStats.Aim += kStats.Aim; 
	m_kTotalStats.CritChance += kStats.CritChance;
	m_kTotalStats.CritDmg += kStats.CritDmg;
	m_kTotalStats.Ammo += kStats.Ammo;
	m_kTotalStats.HP += kStats.HP;
	m_kTotalStats.fDR += kStats.fDR;
	m_kTotalStats.Def += kStats.Def;
	m_kTotalStats.Will += kStats.Will;
	m_kTotalStats.Range += kStats.Range;
	m_kTotalStats.Mob += kStats.Mob;
  	`Log("Mobility=" @ m_kTotalStats.Mob);
}

function ASCOnKill(string Unit, string Victim)
{
	local XGUnit kUnit, kVictim;
	
	foreach AllActors(Class'XGUnit', kUnit)
	{
		if(string(kUnit) == Victim)
		{
			kVictim = kUnit;
		}
		if(string(kUnit) == Unit)
		{
			m_kUnit = kUnit;
		}
	}
	
	if(XGCharacter_Soldier(m_kUnit.GetCharacter()) != none)
	{
		ASCPerks("HasPerk", XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID, 180);
		if(int(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2) > 0)
		{
			m_kUnit.m_aCurrentStats[7] += 1;
			m_kUnit.m_aCurrentStats[13] += 1;
		}
	}
}


function applyStats(optional int iStat) 
{
	local XGParamTag kTag;
	
	kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

  	`Log("ApplyStats");
	switch(iStat)
	{
		case 1:
			kTag.strValue2 = string(m_kTotalStats.Dmg);
			break;
		case 2:
			kTag.strValue2 = string(m_kTotalStats.Aim);
			break;
		case 3:
			kTag.strValue2 = string(m_kTotalStats.CritChance);
      		`Log("CritChance(String)=" @ kTag.strValue2);
			break;
		case 4:
			kTag.strValue2 = string(m_kTotalStats.CritDmg);
			break;
		case 5:
			kTag.strValue2 = string(m_kTotalStats.Ammo);
			break;
		case 6:
			kTag.strValue2 = string(m_kTotalStats.HP);
			break;
		case 7:
			kTag.strValue2 = string(int(m_kTotalStats.fDR * 10));
			break;
		case 8:
			kTag.strValue2 = string(m_kTotalStats.Def);
			break;
		case 9:
			kTag.strValue2 = string(m_kTotalStats.Will);
			break;
		case 10:
			kTag.strValue2 = string(m_kTotalStats.Range);
			break;
		case 11:
			kTag.strValue2 = string(m_kTotalStats.Mob);
			break;
		default:
			kTag.StrValue2 = string(m_kTotalStats.HP); 						// int(Left(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, InStr(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_")));
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.Aim); 				// int(Left(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), inStr(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_")));
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.Def);		 		// int(Left(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), inStr(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_")));
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.Will); 			// int(Left(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), inStr(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_")));
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.Ammo); 			// int(Left(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_")));
			kTag.StrValue2 $= "_" $ string(int(m_kTotalStats.fDR * 10)); 	// int(Left(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_")));
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.CritChance);	 	// int(Left(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_")));			
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.CritDmg);			// int(Left(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_")));
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.Dmg);				// int(Left(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_")));
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.Range); 			// int(Left(Split(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_")));
			kTag.StrValue2 $= "_" $ string(m_kTotalStats.Mob); 				// int(GetRightMost(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2));
			break;
	}

	
}