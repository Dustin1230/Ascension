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
	var float AoERange;
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

struct TRandStats
{
	var int iClass;
	var int HPPts;
	var int AimPts;
	var int DefPts;
	var int WillPts;
	var int MobPts;
	var int MaxPoints;
	var int MaxHP;
	var int MaxAim;
	var int MaxDef;
	var int MaxWill;
	var int MaxMob;
};

struct TMinStats
{
	var int iClass;
	var int HP;
	var int Aim;
	var int Def;
	var int Will;
	var int Mob;
};

struct TStatProgression
{
	var int iRank;
	var int Aim;
	var int Will;
	var int HP;
	var int Def;
	var int MinAim;
	var int RandAim;
	var int MinWill;
	var int RandWill;
	var int RandHP;
	var int RandDef;
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
var XGStrategySoldier m_kStratSoldier;
var config array<TSpecPerk> specPerk;
var config float m_fWepRngIcn;
var config bool bAMedalWait;
var config array<int> rookRandPerk;
var string m_strChangeRandPerk;
var localized string m_perkNames[255];
var localized string m_perkDesc[255];
//var MercenaryAscensionMutate m_kMerc;


function Mutate(String MutateString, PlayerController Sender) 
{
	local array<string> arrMutateStr;
	m_kSender = Sender;


	if(Left(MutateString, 8) == "ASCPerks") 
    {
		`Log("Mutate: ASCPerks");
		arrMutateStr = SplitString(MutateString, "_", false);
		if(arrMutateStr.Length > 4) 
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
	
	if(Left(MutateString, 14) == "ASCStatSetUnit")
	{
		`Log("Mutate: ASCSetUnit");
		arrMutateStr = SplitString(MutateString, "_", false);
		if(arrMutateStr.Length > 2)
		{
			ASCSetUnit(arrMutateStr[1] $ "_" $ arrMutateStr[2]);
		}
		else
		{
			ASCSetUnit(arrMutateStr[1]);
		}
	}
	
	if(Left(MutateString, 8) == "ASCStats") 
    {
		`Log("Mutate: ASCStats");
		arrMutateStr = SplitString(MutateString, "_", false);
		if(arrMutateStr.Length > 1) 
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
		ASCOnKill(arrMutateStr[1] $ "_" $ arrMutateStr[2], arrMutateStr[3] $ "_" $ arrMutateStr[4]);
	}

	if(Left(MutateString, 20) == "DrawWeaponRangeLines")
	{
		`Log("Mutate: DrawWeaponRangeLines");
		arrMutateStr = SplitString(MutateString, "_", false);
		if(arrMutateStr.Length > 1)
		{
			DrawWeaponRangeLines(vector(arrMutateStr[1]));
		}
		else
		{
			DrawWeaponRangeLines(vector("0.0,0.0,0.0"));
		}
	}

	if(Left(MutateString, 13) == "XenocideCount")
	{
		`Log("Mutate: XenocideCount");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCSetUnit(arrMutateStr[1] $ "_" $ arrMutateStr[2]);
		XenocideCount();
	}

	if(Left(MutateString, 18) == "ResetXenocideCount")
	{
		`Log("Mutate: ResetXenocideCount");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCSetUnit(arrMutateStr[1] $ "_" $ arrMutateStr[2]);
		ResetXenocideCount();
	}

	if(Left(MutateString, 10) == "IncapTimer")
	{
		`Log("Mutate: IncapTimer");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCSetUnit(arrMutateStr[1] $ "_" $ arrMutateStr[2]);
		IncapTimer();
	}

	if(Left(MutateString, 13) == "GiveAlienPerk")
	{
		`Log("Mutate: GiveAlienPerk");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCSetUnit(arrMutateStr[1] $ "_" $ arrMutateStr[2]);
		if(arrMutateStr.Length > 4)
		{
			ASCAlienGivePerk(int(arrMutateStr[3]), int(arrMutateStr[4]));
		}
		else
		{
			ASCAlienGivePerk(int(arrMutateStr[3]));
		}
		m_kUnit = none;
	}
	
	if(Left(MutateString, 12) == "AlienHasPerk")
	{
		`Log("Mutate: AlienHasPerk");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCSetUnit(arrMutateStr[1] $ "_" $ arrMutateStr[2]);
		ASCAlienHasPerk(int(arrMutateStr[3]));
		m_kUnit = none;
	}

	if(MutateString == "ActivateAmnesia")
	{
		`Log("Mutate: ActivateAmnesia");
		ActivateAmnesia();
	}

	if(Left(MutateString, 12) == "rookRandPerk")
	{
		`Log("Mutate: rookRandPerk");
		arrMutateStr = SplitString(MutateString, "_", false);
		GiveRandomPerk(int(arrMutateStr[1]));
	}

	if(MutateString == "CheckRandomPerk")
	{
		`Log("Mutate: CheckRandomPerk");
		arrMutateStr = SplitString(MutateString, "_", false);
		CheckRandomPerk(int(arrMutateStr[1]));
	}

	if(MutateString == "FlushAlienPerks")
	{
		`Log("Mutate: FlushAlienPerks");
		FlushAlienPerks();
	}

	if(Left(MutateString, 14) == "CurruptMessage")
	{
		`Log("Mutate: CurruptMessage");
		`Log("Mutate: MutateString=" @ MutateString);
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCSetUnit(arrMutateStr[1] $ "_" $ arrMutateStr[2]);
		CurruptMessage(arrMutateStr[3] $ "_" $ arrMutateStr[4]);
	}

	if(MutateString == "ASCAscensionVersion")
	{
		TAG().StrValue2 = "2";
	}

	
	/*if(Left(MutateString, 18) == "ASCPerkDescription")
	{
		`Log("Mutate: ASCPerkDescription");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCPerkDescription(int(arrMutateStr[1]));
	}
	
	if(Left(MutateString, 15) == "ASCLevelUpStats")
	{
		`Log("Mutate: ASCLevelUpStats");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCLevelUpStats(int(arrMutateStr[1]));
	}*/
	
	if(Left(MutateString, 11) == "TestPerkNum")
	{
		LogInternal(split(MutateString, "TestPerkNum ", true), 'TestPerkNum perkNum');
		LogInternal(PERKS().m_arrPerks[int(split(MutateString, "TestPerkNum ", true))].strName[0], 'TestPerkNum perkName');
		LogInternal(PERKS().m_arrPerks[int(split(MutateString, "TestPerkNum ", true))].strDescription[0], 'TestPerkNum perkDes');
	}
	
	/*if(MutateString == "TestRandSort")
	{
		ASCRandomiseStats(1);
	}*/

	
	if(PERKS() != None) 
    {
		if(PERKS().m_arrPerks.length < 174) 
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
    return XComHeadquartersGame(WorldInfo.Game).GetGameCore();   
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
	return XComGameReplicationInfo(WorldInfo.GRI);
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

function GiveRandomPerk(int SoldierID)
{
	local int perk;
	local XGStrategySoldier kSoldier;
	local TSoldierStorage SS;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	kSoldier = BARRACKS().GetSoldierByID(SoldierID);

	loop:
	perk = rookRandPerk[Rand(rookRandPerk.Length)];

	if(kSoldier.HasPerk(perk))
	{
		goto loop;
	}
	if((perk == 6 && kSoldier.HasPerk(16)) || (perk == 16 && kSoldier.HasPerk(6)))
	{
		goto loop;
	}
	if((perk == 10 && kSoldier.HasPerk(133)) || (perk == 133 && kSoldier.HasPerk(10)))
	{
		goto loop;
	}
	if((perk == 23 && kSoldier.HasPerk(54)) || (perk == 54 && kSoldier.HasPerk(23)))
	{
		goto loop;
	}
	if((perk == 126 && kSoldier.HasPerk(13)) || (perk == 13 && kSoldier.HasPerk(126)))
	{
		goto loop;
	}
	if((perk == 126 && kSoldier.HasPerk(26)) || (perk == 26 && kSoldier.HasPerk(126)))
	{
		goto loop;
	}
	if((perk == 51 && kSoldier.HasPerk(52)) || (perk == 52 && kSoldier.HasPerk(51)))
	{
		goto loop;
	}

	kSoldier.GivePerk(EPerkType(perk));

	SS.SoldierID = kSoldier.m_kSoldier.iID;
	SS.RandomPerk = perk;
	m_kASCCheckpoint.arrSoldierStorage.AddItem(SS);

}

function CheckRandomPerk(int perk)
{
	local TSoldierStorage SS;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	foreach m_kASCCheckpoint.arrSoldierStorage(SS)
	{
		if(SS.SoldierID == SOLDIER().m_kSoldier.iID)
		{
			break;
		}
	}
	if(SS.RandomPerk == perk)
	{
		changeDummyPerk(perk);
	}
}

function changeDummyPerk(int perk)
{
	local XComPerkManager kPerks;

	kPerks = BARRACKS().m_kPerkManager;

	lperk:
	kPerks.m_arrPerks[254].strImage = kPerks.m_arrPerks[perk].strImage;
	kPerks.m_arrPerks[254].strName[0] = kPerks.m_arrPerks[perk].strName[0];
	kPerks.m_arrPerks[254].strDescription[0] = "(" @ m_strChangeRandPerk @ ")" $ chr(10) $ kPerks.m_arrPerks[perk].strDescription[0];

	if(kPerks != PERKS())
    {
		kPerks = PERKS();
		goto lperk;
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

function FlushAlienPerks()
{
	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	m_kASCCheckpoint.arrAlienStorage.Length = 0;
	`Log("FlushedPerks");
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

/*function ASCLevelUpStats(optional int statsString)
{
    local int statOffense, statWill, statHealth, iBaseWillIncrease, iRandWillIncrease;

    local bool bRand;
    local int iStatProgression;

    bRand = SOLDIER().IsOptionEnabled(3);
    iStatProgression = 0;
    // End:0x48
    if(SOLDIER().m_iEnergy > 0)
    {
        iBaseWillIncrease = SOLDIER().m_iEnergy;
    }
    // End:0x5C
    else
    {
        iBaseWillIncrease = SOLDIER().GetClass();
    }
	
	
	if(SOLDIER().m_iEnergy != 8 || SOLDIER().m_iEnergy != 9)
	{
	
	
		// End:0x204 [Loop If]
		J0x5C:
		if(iStatProgression < class'XGTacticalGameCore'.default.SoldierStatProgression.Length)
		{
			// End:0x1F6
			if(class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].eClass == iBaseWillIncrease)
			{
				// End:0x1F6
				if(class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].eRank == ((statsString >> 8) & 255))
				{
					statWill = class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].iWill;
					statHealth = class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].iHP;
					statOffense = class'XGTacticalGameCore'.default.SoldierStatProgression[iStatProgression].iAim;
				}
			}
			++ iStatProgression;
			// [Loop Continue]
			goto J0x5C;
		}
		// End:0x2AF
		if(bRand)
		{
			statWill = Rand((statWill / 100) % 100) + ((statWill / 10000) % 10000);
			statHealth = PercentRoll(float(statHealth)) ? 1 : 0;                                                        
			statOffense = Rand((statOffense / 100) % 100) + ((statOffense / 10000) % 10000);
		}
		// End:0x316
		else
		{
			statWill = (statWill % 100) + Rand(class'XGTacticalGameCore'.default.iRandWillIncrease);
			statHealth = statHealth % 100;
			statOffense = statOffense % 100;
		}
    // End:0x46E
    if(!SOLDIER().IsOptionEnabled(4))
    {
        // End:0x46E
        if(statsString > 1)
        {
            // End:0x46E
            if(SOLDIER().m_iEnergy > 0)
            {
                iStatProgression = PERKS().GetPerkInTree(byte(SOLDIER().m_iEnergy + 4), ((statsString >> 8) & 255) - 0, statsString & 255, false);
                // End:0x3D9
                if((iStatProgression / 100) == 2)
                {
                    SOLDIER().m_kChar.aStats[3] -= 1;
                }
                // End:0x40F
                if((iStatProgression / 100) == 1)
                {
                    SOLDIER().m_kChar.aStats[3] += 1;
                }
                SOLDIER().m_kChar.aStats[1] += ((iStatProgression / 10) % 10);
                SOLDIER().m_kChar.aStats[7] += (iStatProgression % 10);
            }
        }
    }
    SOLDIER().m_kChar.aStats[0] += statHealth;
    SOLDIER().m_kChar.aStats[1] += statOffense;
    SOLDIER().m_kChar.aStats[7] += statWill;
	
	
	}
	else
	{
		if(statsString > 0)
		{
			m_kMerc.MercLevelupStat(statsString);
			//super.Mutate("MercLevelupStat_" $ statsString, m_kSender);
		}
		else
		{
			m_kMerc.MercLevelupStat();
			//super.Mutate("MercLevelupStat", m_kSender);
		}
	}
}

function ASCPerkDescription(int iCurrentView)
{
    local int iPerk, iRank;

    iPerk = SOLDIER().GetPerkInClassTree(SOLDIERUI().GetAbilityTreeBranch(), SOLDIERUI().GetAbilityTreeOption(), iCurrentView == 2);
	LogInternal("iPerk=" @ iPerk, 'ASCPerkDescription');
    // End:0x187
    if(((iCurrentView == 2) && SOLDIER().PerkLockedOut(iPerk, SOLDIERUI().GetAbilityTreeBranch(), iCurrentView == 2)) && !SOLDIER().HasPerk(iPerk))
    {
        // End:0x127
        if(iPerk == 73)
        {
            // End:0x127
            if((SOLDIER().m_kChar.aUpgrades[71] & 254) == 0)
            {
				TAG().StrValue2 = SOLDIERUI().m_strLockedPsiAbilityDescription;
                //return m_strLockedPsiAbilityDescription;
            }
        }
		// End:0x187
		if(!LABS().IsResearched(PERKS().GetPerkInTreePsi(iPerk | (1 << 8), 0)))
		{
			TAG().StrValue2 = SOLDIERUI().m_strLockedPsiAbilityDescription;
			//return m_strLockedPsiAbilityDescription;
		}
    }
	// End:0x3D4
	if(((iCurrentView != 2) && (SOLDIERUI().GetAbilityTreeBranch()) > 1) && !SOLDIERUI().IsOptionEnabled(4))
	{
		if(SOLDIER().m_iEnergy != 8 || SOLDIER().m_iEnergy != 9)
		{
			iRank = PERKS().GetPerkInTree(byte(SOLDIER().m_iEnergy + 4), (SOLDIERUI().GetAbilityTreeBranch()) - 0, SOLDIERUI().GetAbilityTreeOption(), false);
			TAG().IntValue0 = 0;
			// End:0x2EB
			if((iRank / 100) == 2)
			{
				TAG().IntValue0 = -1;
			}
			// End:0x320
			if((iRank / 100) == 1)
			{
				TAG().IntValue0 = 1;
			}
			TAG().IntValue1 = (iRank / 10) % 10;
			TAG().IntValue2 = iRank % 10;
			
			LogInternal("before output", 'ASCPerkDescription');
			
			TAG().StrValue2 =
			
			Left(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), InStr(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), ":") + 1) $ "(" @
			
			(TAG().IntValue1 != 0 ? class'UIStrategyComponent_SoldierStats'.default.m_strStatOffense $ ":" @ TAG().IntValue1 : "")
			
			$ (TAG().IntValue2 != 0 ? "," @ class'UIStrategyComponent_SoldierStats'.default.m_strStatWill $ ":" @ TAG().IntValue2 : "")
			
			$ (TAG().IntValue0 != 0 ? "," @ SOLDIERUI().m_strLabelMobility $ ":" @ TAG().IntValue0 : "")
			
			@ ")\\n" $ PERKS().GetBriefSummary(iPerk);
			
			//return class'XComLocalizer'.static.ExpandString(m_strLockedAbilityDescription) $ PERKS().GetBriefSummary(iPerk);
		}
		else
		{
			LogInternal("before merc", 'ASCPerkDescription');
			m_kMerc.MercPerkDescription();
			LogInternal("after merc", 'ASCPerkDescription');
			//super.Mutate("MercPerkDescription", m_kSender);
		}
	}
	// End:0x3FE
	else
	{
		TAG().StrValue2 = PERKS().GetBriefSummary(iPerk);
		//return PERKS().GetBriefSummary(iPerk);
	}  
}*/

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

function ASCRandomiseStats(int SoldierID, TRandStats RandData)
{
	local int I, J, iRand, iPos, pointsused;
	local array<int> list, weight, list2, weight2;
	local XGStrategySoldier kSoldier;
	
	kSoldier = BARRACKS().GetSoldierByID(SoldierID);

	J = 0;
	pointsused = 0;
	list.addItem(RandData.HPPts);
	list.addItem(RandData.AimPts);
	list.addItem(RandData.DefPts);
	list.addItem(RandData.WillPts);
	list.addItem(RandData.MobPts);

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
	
	loop:
	LogInternal("pointsused=" @ pointsused, 'RandStatsTest');
	if(pointsused < RandData.MaxPoints)
	{
		I = list[weight[weight.length - 1]] + 1;
		iPos = 0;
		
		for(J = 0; J < list.length; J ++)
		{
			iPos += ((list[J] * -1) + I);
		}
		
		iRand = Rand(iPos);
		iPos = 0;
		
		LogInternal("iRand=" @ iRand, 'RandStatsTest');
		
		weight2.length = 0;
		
		for(J = 0; J < weight.length; J ++)
		{
			for(I = 0; I < ((list[weight[J]] * -1) + list[weight[weight.length - 1]] + 1); I ++)
			{
				weight2.addItem(weight[J]);
			}
		}
		switch(weight2[iRand])
		{
			case 0:
				if(list[0] <= RandData.MaxPoints - pointsused && kSoldier.m_kChar.aStats[0] < RandData.MaxHP)
				{
					++ kSoldier.m_kChar.aStats[0];
					pointsused += list[0];
					LogInternal("HP=" @ string(kSoldier.m_kChar.aStats[0]), 'CountStatsTest');
				}
				break;
			case 1:
				if(list[1] <= RandData.MaxPoints - pointsused && kSoldier.m_kChar.aStats[1] < RandData.MaxAim)
				{
					++ kSoldier.m_kChar.aStats[1];
					pointsused += list[1];
					LogInternal("Aim=" @ string(kSoldier.m_kChar.aStats[1]), 'CountStatsTest');
				}
				break;
			case 2:
				if(list[2] <= RandData.MaxPoints - pointsused && kSoldier.m_kChar.aStats[2] < RandData.MaxDef)
				{
					++ kSoldier.m_kChar.aStats[2];
					pointsused += list[2];
					LogInternal("Def=" @ string(kSoldier.m_kChar.aStats[2]), 'CountStatsTest');
				}
				break;
			case 3:
				if(list[3] <= RandData.MaxPoints - pointsused && kSoldier.m_kChar.aStats[7] < RandData.MaxWill)
				{
					++ kSoldier.m_kChar.aStats[7];
					pointsused += list[3];
					LogInternal("Will=" @ string(kSoldier.m_kChar.aStats[7]), 'CountStatsTest');
				}
				break;
			case 4:
				if(list[4] <= RandData.MaxPoints - pointsused && kSoldier.m_kChar.aStats[3] < RandData.MaxMob)
				{
					++ kSoldier.m_kChar.aStats[3];
					pointsused += list[4];
					LogInternal("Mob=" @ string(kSoldier.m_kChar.aStats[3]), 'CountStatsTest');
				}
				break;
			default:
				break;
		}
		goto loop;
	}
	
}

function SetMinStats(int SoldierID, TMinStats MinData)
{
	local XGStrategySoldier kSoldier;
	
	kSoldier = BARRACKS().GetSoldierByID(SoldierID);
	
	kSoldier.m_kChar.aStats[0] = MinData.HP;
	kSoldier.m_kChar.aStats[1] = MinData.Aim;
	kSoldier.m_kChar.aStats[2] = MinData.Def;
	kSoldier.m_kChar.aStats[3] = MinData.Mob;
	kSoldier.m_kChar.aStats[7] = MinData.Will;
}

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
	local XGStrategySoldier Soldier;
	local ASCTStats EmptyStat;

	LogInternal("UnitName=" @ UnitName, 'ASCSetUnit');

	if(XComTacticalGame(XComGameInfo(WorldInfo.Game)) != none)
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
	else if(XComHeadquartersGame(XComGameInfo(WorldInfo.Game)) != none)
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
	m_kTotalStats = EmptyStat;
}

function expandPerkarray()
{
	local XComPerkManager kPerkMan;
	
	kPerkMan = BARRACKS().m_kPerkManager;
	
	stperkman:
	kPerkMan.m_arrPerks.Length = 255;
	
	LogInternal(String(kPerkMan), 'expandPerkarray');
	
	kPerkMan.BuildPerk(116, 0, "Evasion");
	kPerkMan.BuildPerk(80, 1, "Flying");
	kPerkMan.BuildPerk(83, 1, "Poisoned");
	kPerkMan.BuildPerk(84, 1, "Poisoned");
    kPerkMan.BuildPerk(85, 1, "Adrenal");
    kPerkMan.BuildPerk(76, 0, "ReinforcedArmor");

	
	kPerkMan.BuildPerk(173, 0, "Unknown");
	kPerkMan.m_arrPerks[173].strName[0] = m_perkNames[173];
	kPerkMan.m_arrPerks[173].strDescription[0] = m_perkDesc[173];
	
	kPerkMan.BuildPerk(174, 0, "RifleSuppression");
	kPerkMan.m_arrPerks[174].strName[0] = m_perkNames[174];
	kPerkMan.m_arrPerks[174].strDescription[0] = m_perkDesc[174];
	
	kPerkMan.BuildPerk(175, 0, "ExpandedStorage");
	kPerkMan.m_arrPerks[175].strName[0] = m_perkNames[175];
	kPerkMan.m_arrPerks[175].strDescription[0] = m_perkDesc[175];
	
	kPerkMan.BuildPerk(176, 0, "PoisonSpit");
	kPerkMan.m_arrPerks[176].strName[0] = m_perkNames[176];
	kPerkMan.m_arrPerks[176].strDescription[0] = m_perkDesc[176];
	
	kPerkMan.BuildPerk(177, 0, "Launch");
	kPerkMan.m_arrPerks[177].strName[0] = m_perkNames[177];
	kPerkMan.m_arrPerks[177].strDescription[0] = m_perkDesc[177];
	
	kPerkMan.BuildPerk(178, 0, "Bloodcall");
	kPerkMan.m_arrPerks[178].strName[0] = m_perkNames[178];
	kPerkMan.m_arrPerks[178].strDescription[0] = m_perkDesc[178];
	
	kPerkMan.BuildPerk(179, 0, "UrbanDefense");
	kPerkMan.m_arrPerks[179].strName[0] = m_perkNames[179];
	kPerkMan.m_arrPerks[179].strDescription[0] = m_perkDesc[179];
	
	kPerkMan.BuildPerk(180, 0, "Harden");
	kPerkMan.m_arrPerks[180].strName[0] = m_perkNames[180];
	kPerkMan.m_arrPerks[180].strDescription[0] = m_perkDesc[180];
	
	kPerkMan.BuildPerk(181, 0, "Intimidate");
	kPerkMan.m_arrPerks[181].strName[0] = m_perkNames[181];
	kPerkMan.m_arrPerks[181].strDescription[0] = m_perkDesc[181];
	
	kPerkMan.BuildPerk(189, 0, "Disoriented");
	kPerkMan.m_arrPerks[189].strName[0] = m_perkNames[189];
	kPerkMan.m_arrPerks[189].strDescription[0] = m_perkDesc[189];
	
	kPerkMan.BuildPerk(190, 0, "ReactivePupils");
	kPerkMan.m_arrPerks[190].strName[0] = m_perkNames[190];
	kPerkMan.m_arrPerks[190].strDescription[0] = m_perkDesc[190];
	
	kPerkMan.BuildPerk(191, 0, "Stun");
	kPerkMan.m_arrPerks[191].strName[0] = m_perkNames[191];
	kPerkMan.m_arrPerks[191].strDescription[0] = m_perkDesc[191];	
	
	kPerkMan.BuildPerk(192, 0, "Stun");
	kPerkMan.m_arrPerks[192].strName[0] = m_perkNames[192];
	kPerkMan.m_arrPerks[192].strDescription[0] = m_perkDesc[192];
	
	
	if(kPerkMan != PERKS())
    {
		kPerkMan = PERKS();
		goto stperkman;
	}
	
}

function Init()
{
	local ASCTStats Stat;
	
	Stat.Mob = 6;
	stat.CritChance = 11;

	buildConfigPerks();
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
						if(specPerk[I].iPerk[J] > 0)
						{
                    		SOLDIER().m_kChar.aUpgrades[specPerk[I].iPerk[J]] += 2;
                      		bFound = true;
                  			break;
						}
                	}
                	if(funct == "rem")
                	{
						if(specPerk[I].iPerk[J] > 0)
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
            }
          	if(bFound)
            {
              	break;
            }
        }
    }
}

function DrawWeaponRangeLines(Vector cursorLoc)
{
	local XGSquad kSquad;
	local XGUnit kTarget, ActiveUnit;
	local int I;
    local float fRadius;
	local XComTacticalController TacticalController;

	TacticalController = XComTacticalController(GetALocalPlayerController().ViewTarget.Owner);
	ActiveUnit = TacticalController.GetActiveUnit();
	kSquad = XComTacticalGRI(WorldInfo.GRI).m_kBattle.GetEnemyPlayer(ActiveUnit.GetPlayer()).GetSquad();

	if(m_fWepRngIcn > 0)
	{
		fRadius = m_fWepRngIcn * 64;
	}
	else
	{
		fRadius = 10.0 * 64;
	}

	if(!PRES().m_kTurnOverlay.IsShowingAlienTurn() && !PRES().m_kTurnOverlay.IsShowingOtherTurn() && !XComTacticalGRI(WorldInfo.GRI).m_kBattle.IsAlienTurn())
	{
		for(I = 0; I < kSquad.GetNumMembers(); I++)
		{
			kTarget = kSquad.GetMemberAt(I);
			if(!kTarget.IsMoving() && !kTarget.IsHiding() && kTarget.IsVisible() && kTarget.IsAliveAndWell())
			{
				if(VSize(cursorLoc - kTarget.GetPawn().Location) <= (float(ActiveUnit.GetInventory().GetActiveWeapon().m_kTWeapon.iRange) * 64 ))
				{
					kTarget.GetPawn().AttachRangeIndicator(fRadius, kTarget.m_kDiscMesh.StaticMesh);
				}
				else
				{
					kTarget.GetPawn().DetachRangeIndicator();
				}
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
	local TSoldierStorage SoldStor, SoldStor1;
	local bool bFound;
	local int I;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}
	
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
		if(int(TAG().StrValue2) > 0)
		{
			m_kUnit.m_aCurrentStats[7] += 1;
			m_kUnit.m_aCurrentStats[13] += 1;

			bFound = false;
			foreach m_kASCCheckpoint.arrSoldierStorage(SoldStor, I)
			{
				if(SoldStor.SoldierID == XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID)
				{
					++ m_kASCCheckpoint.arrSoldierStorage[I].XenocideCount;
					bFound = true;
					break;
				}
			}

			if(!bFound)
			{
				SoldStor1.SoldierID = XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID;
				SoldStor1.XenocideCount = 1;
				m_kASCCheckpoint.arrSoldierStorage.AddItem(SoldStor1);
			}
		}
	}
	m_kUnit = none;
}

function XenocideCount()
{
	local int Count;
	local bool bFound;
	local TSoldierStorage SoldStor;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	bFound = false;
	foreach m_kASCCheckpoint.arrSoldierStorage(SoldStor)
	{
		if(SoldStor.SoldierID == XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID)
		{
			Count = SoldStor.XenocideCount * 3;
			bFound = true;
			break;
		}
	}

	if(!bFound)
	{
		Count = 0;
	}

	TAG().IntValue2 = Count;
	m_kUnit = none;
}

function ResetXenocideCount()
{
	local TSoldierStorage SoldStor;
	local int I;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}
	
	foreach m_kASCCheckpoint.arrSoldierStorage(SoldStor, I)
	{
		if(SoldStor.SoldierID == XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID)
		{
			m_kASCCheckpoint.arrSoldierStorage[I].XenocideCount = 0;
			break;
		}
	}
	m_kUnit = none;
}

function ASCAlienHasPerk(int iPerk)
{
	local TAlienStorage AlienStor;
	local bool bFound;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	TAG().StrValue2 = "";
	bFound = False;
	foreach m_kASCCheckpoint.arrAlienStorage(AlienStor)
	{
		if(int(GetRightMost(String(m_kUnit))) == AlienStor.ActorNumber)
		{
			bFound = true;
			break;
		}
	}
	if(bFound)
	{
		TAG().StrValue1 = string(AlienStor.perks[iPerk]);
	}
	else
	{
		TAG().StrValue1 = "0";
	}
	LogInternal("StrValue1= " $ TAG().StrValue1, 'ASCAlienHasPerk');
}

function ASCAlienGivePerk(int iPerk, optional int Value)
{
	local TAlienStorage AlienStor, AlienStor1;
	local int I;
	local bool bFound;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	bFound = False;
	foreach m_kASCCheckpoint.arrAlienStorage(AlienStor, I)
	{
		if(int(GetRightMost(String(m_kUnit))) == AlienStor.ActorNumber)
		{
			bFound = true;
			if(Value > 0)
			{
				m_kASCCheckpoint.arrAlienStorage[I].perks[iPerk] += Value;
			}
			else
			{
				m_kASCCheckpoint.arrAlienStorage[I].perks[iPerk] += 1;
			}
			break;
		}
	}
	if(!bFound)
	{
		AlienStor1.ActorNumber = int(GetRightMost(String(m_kUnit)));
		if(Value > 0)
		{
			AlienStor1.perks[iPerk] += Value;
		}
		else
		{
			AlienStor1.perks[iPerk] += 1;
		}
		m_kASCCheckpoint.arrAlienStorage.AddItem(AlienStor1);
	}
}

function ASCAlienRemovePerk(int iPerk, optional int Value)
{
	local TAlienStorage AlienStor;
	local int I;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	foreach m_kASCCheckpoint.arrAlienStorage(AlienStor, I)
	{
		if(int(GetRightMost(String(m_kUnit))) == AlienStor.ActorNumber)
		{
			if(Value > 0 && Value >= AlienStor.perks[iPerk])
			{
				m_kASCCheckpoint.arrAlienStorage[I].perks[iPerk] -= Value;
			}
			else
			{
				m_kASCCheckpoint.arrAlienStorage[I].perks[iPerk] = 0;
			}
			break;
		}
	}
}

function IncapTimer()
{
	local TAlienStorage AlienStor, AlienStor1;
	local int I;
	local bool bFound;

	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	bFound = False;
	foreach m_kASCCheckpoint.arrAlienStorage(AlienStor, I)
	{
		if(int(GetRightMost(String(m_kUnit))) == AlienStor.ActorNumber)
		{

			if( ++ m_kASCCheckpoint.arrAlienStorage[I].IncapTimer == 2)
			{
				ASCAlienRemovePerk(192);
				m_kUnit.ApplyInventoryStatModifiers();
				m_kASCCheckpoint.arrAlienStorage[I].IncapTimer = 0;
			}
			bFound = true;
		}
	}
	if(!bFound)
	{
		AlienStor1.ActorNumber = int(GetRightMost(String(m_kUnit)));
		AlienStor1.IncapTimer = 1;
		m_kASCCheckpoint.arrAlienStorage.AddItem(AlienStor1);
	}
	m_kUnit = none;
}

function ActivateAmnesia()
{
	local int iCount;

	SOLDIER().ClearPerks(true);
	
	SOLDIER().m_arrRandomPerks.Length = 0;

	SOLDIER().m_kChar.aStats[0] = class'XGTacticalGameCore'.default.Characters[1].HP;
	SOLDIER().m_kChar.aStats[1] = class'XGTacticalGameCore'.default.Characters[1].Offense;
	SOLDIER().m_kChar.aStats[2] = class'XGTacticalGameCore'.default.Characters[1].Defense;
	SOLDIER().m_kChar.aStats[3] = class'XGTacticalGameCore'.default.Characters[1].Mobility;
	SOLDIER().m_kChar.aStats[7] = class'XGTacticalGameCore'.default.Characters[1].Will;

	BARRACKS().RandomizeStats(SOLDIER());

	if(SOLDIER().HasAnyMedal()) 
	{		
		if(bAMedalWait) 
		{
			BARRACKS().rollstat(SOLDIER(), 0, 0);
		}
		else
		{ 
			for(iCount = SOLDIER().MedalCount(); iCount > 0; iCount --)
			{		
				SOLDIER().m_arrMedals[iCount] = 0;
				BARRACKS().m_arrMedals[iCount].m_iUsed -= 1;
				BARRACKS().m_arrMedals[iCount].m_iAvailable += 1;
			}
		}
	}
}

function CurruptMessage(string strTarget)
{
	local XGUnit Unit, kTarget;
	local bool bPanic;
	local XComUIBroadcastWorldMessage kMessage;
	local string msgStr;
	local int CurruptWillTest, WillChance, UnitWill;

	foreach AllActors(class'XGUnit', Unit)
	{
		if(string(Unit) == strTarget)
		{
			kTarget = Unit;
			break;
		}
	}

	CurruptWillTest = (25 + ((kTarget.RecordMoraleLoss(6) / 4) * XGCharacter_Soldier(kTarget.GetCharacter()).m_kSoldier.iRank));
	UnitWill = m_kUnit.RecordMoraleLoss(7);
	WillChance = m_kUnit.WillTestChance(CurruptWillTest, UnitWill, false, false,, 50);

	LogInternal("CurruptWillTest= " $ string(CurruptWillTest) @ "//" @ "UnitWill= " $ string(UnitWill) @ "//" @ "WillChance= " $ string(WillChance), 'CurruptMessage');

	if(m_kUnit != none && kTarget != none && XGCharacter_Soldier(kTarget.GetCharacter()) != none)
	{
		bPanic = m_kUnit.PerformPanicTest(CurruptWillTest,, true, 8);

		if(bPanic)
		{
			msgStr = left(split(Class'XGTacticalGameCore'.default.m_aExpandedLocalizedStrings[6], "("), inStr(split(Class'XGTacticalGameCore'.default.m_aExpandedLocalizedStrings[6], "("), ")") + 1);
		}
		else
		{
			msgStr = left(split(Class'XGTacticalGameCore'.default.m_aExpandedLocalizedStrings[4], "("), inStr(split(Class'XGTacticalGameCore'.default.m_aExpandedLocalizedStrings[4], "("), ")") + 1);
		}

		XComTacticalGRI(WorldInfo.GRI).m_kBattle.m_kDesc.m_iDifficulty = 0;

		kMessage = XComPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).GetWorldMessenger().Message(PERKS().m_arrPerks[189].strName[0] @ string(100 - WillChance) $ "%" @ msgStr, kTarget.GetLocation(), bPanic ? 3 : 4,,, kTarget.m_eTeamVisibilityFlags,,,, Class'XComUIBroadcastWorldMessage_UnexpandedLocalizedString');

		if(kMessage != none)
		{
			XComUIBroadcastWorldMessage_UnexpandedLocalizedString(kMessage).Init_UnexpandedLocalizedString(0, kTarget.GetLocation(), bPanic ? 3 : 4, kTarget.m_eTeamVisibilityFlags);
		}

		XComTacticalGRI(WorldInfo.GRI).m_kBattle.m_kDesc.m_iDifficulty = XComGameReplicationInfo(WorldInfo.GRI).m_kGameCore.m_iDifficulty;
	}
}

function applyStats(optional int iStat) 
{
	LogInternal("m_kUnit=" @ string(m_kUnit), 'applyStats');
	LogInternal("m_kStratSoldier=" @ (m_kStratSoldier), 'applyStats');

	if(m_kUnit != none)
	{
		if(m_kUnit.GetCharacter().HasUpgrade(180))
		{
			m_kTotalStats.CritDmg += 2;
		}
		if(m_kUnit.GetCharacter().HasUpgrade(179))
		{
			m_kTotalStats.Def += 10;
		}
		ASCAlienHasPerk(192);
		if(int(TAG().StrValue1) > 0)
		{
			m_kTotalStats.Def -= 10;
			m_kTotalStats.fDR -= 1.0;
			m_kTotalStats.Mob -= FCeil(float(m_kUnit.GetCharacter().m_kChar.aStats[3]) * 0.25);
		}
		if(m_kUnit.GetCharacter().HasUpgrade(181) && m_kUnit.GetPossessedBy() != none)
		{
			m_kTotalStats.Aim -= FCeil(float(m_kUnit.GetCharacter().m_kChar.aStats[1]) * 0.6);
			m_kTotalStats.Mob -= FCeil(float(m_kUnit.GetCharacter().m_kChar.aStats[3]) * 0.5);
			m_kTotalStats.AoERange -= 1.0;
		}
	}
	else if(m_kStratSoldier != none)
	{
		if(m_kStratSoldier.HasPerk(180))
		{
			m_kTotalStats.CritDmg += 2;
		}
		if(m_kStratSoldier.HasPerk(179))
		{
			m_kTotalStats.Def += 10;
		}
	}

  	`Log("ApplyStats");
	switch(iStat)
	{
		case 1:
			TAG().strValue2 = string(m_kTotalStats.Dmg);
			break;
		case 2:
			TAG().strValue2 = string(m_kTotalStats.Aim);
			break;
		case 3:
			TAG().strValue2 = string(m_kTotalStats.CritChance);
      		`Log("CritChance(String)=" @ TAG().strValue2);
			break;
		case 4:
			TAG().strValue2 = string(m_kTotalStats.CritDmg);
			break;
		case 5:
			TAG().strValue2 = string(m_kTotalStats.Ammo);
			break;
		case 6:
			TAG().strValue2 = string(m_kTotalStats.HP);
			break;
		case 7:
			TAG().strValue2 = string(int(m_kTotalStats.fDR * 10));
			break;
		case 8:
			TAG().strValue2 = string(m_kTotalStats.Def);
			break;
		case 9:
			TAG().strValue2 = string(m_kTotalStats.Will);
			break;
		case 10:
			TAG().strValue2 = string(m_kTotalStats.Range);
			break;
		case 11:
			TAG().strValue2 = string(m_kTotalStats.Mob);
			break;
		case 12:
			TAG().StrValue2 = string(m_kTotalStats.AoERange);
			break;
		default:
			TAG().StrValue2 = string(m_kTotalStats.HP); 					// int(Left(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, InStr(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.Aim); 			// int(Left(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), inStr(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.Def);		 		// int(Left(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), inStr(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.Will); 			// int(Left(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), inStr(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.Ammo); 			// int(Left(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(int(m_kTotalStats.fDR * 10)); 	// int(Left(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.CritChance);	 	// int(Left(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_")));			
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.CritDmg);			// int(Left(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.Dmg);				// int(Left(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.Range); 			// int(Left(Split(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.AoERange);        // float(Left(Split(Split(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), inStr(Split(Split(Split(Split(Split(Split(Split(Split(Split(Split(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2, "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_", true), "_" true), "_")));
			TAG().StrValue2 $= "_" $ string(m_kTotalStats.Mob); 			// int(GetRightMost(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2));
			break;
	}
	m_kUnit = none;
	m_kStratSoldier = none;
}

defaultproperties 
{
	AmnesiaPerkName = "Amnesia"
	AmnesiaPerkDes = "Makes soldier forget all stats and perks and gives them a new perk tree to choose from. May Reduce some will."
	m_strChangeRandPerk = "<font color='#FF0000'>Random Rookie Perk will be Rerolled</font>"
}