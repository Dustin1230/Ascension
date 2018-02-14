class ASC_PerksMod extends AscensionMod
	config(Perks);

struct ASCTPerkInfo
{
	var string ID;
    var int PerkNumSlot;
    var string name;
	var string Description;
    var string IconID;
	
};

struct TSpecPerk
{
  	var int iItem;
  	var array<int> iClass;
  	var array<int> iPerk;
};

var config array<ASCTPerkInfo> PerkInfo;
var string AmnesiaPerkName;
var string AmnesiaPerkDes;
var config array<TSpecPerk> specPerk;

function FlushAlienPerks()
{
	if(m_kASCCheckpoint == none)
	{
		CreateActor();
	}

	m_kASCCheckpoint.arrAlienStorage.Length = 0;
	`Log("FlushedPerks");
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
				StrValue2(SOLDIERUI().m_strLockedPsiAbilityDescription);
                //return m_strLockedPsiAbilityDescription;
            }
        }
		// End:0x187
		if(!LABS().IsResearched(PERKS().GetPerkInTreePsi(iPerk | (1 << 8), 0)))
		{
			StrValue2(SOLDIERUI().m_strLockedPsiAbilityDescription);
			//return m_strLockedPsiAbilityDescription;
		}
    }
	// End:0x3D4
	if(((iCurrentView != 2) && !SOLDIERUI().IsOptionEnabled(4)))
	{
		if(!(SOLDIER().m_iEnergy == 26 || SOLDIER().m_iEnergy == 8 || SOLDIER().m_iEnergy == 9))
		{
			if((SOLDIERUI().GetAbilityTreeBranch()) > 1)
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
			
				StrValue2(
			
				Left(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), InStr(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), ":") + 1) $ "(" @
			
				(TAG().IntValue1 != 0 ? class'UIStrategyComponent_SoldierStats'.default.m_strStatOffense @ TAG().IntValue1 : "")
			
				$ (TAG().IntValue2 != 0 ? "," @ class'UIStrategyComponent_SoldierStats'.default.m_strStatWill @ TAG().IntValue2 : "")
			
				$ (TAG().IntValue0 != 0 ? "," @ Left(SOLDIERUI().m_strLabelMobility, Len(SOLDIERUI().m_strLabelMobility) - 1) $ ":" @ TAG().IntValue0 : "")
			
				@ class'XComLocalizer'.static.ExpandString(")\\n") $ PERKS().GetBriefSummary(iPerk)

				);
			
				//return class'XComLocalizer'.static.ExpandString(m_strLockedAbilityDescription) $ PERKS().GetBriefSummary(iPerk);
			}
			else
			{
				goto otherelse;
			}
		}
		else
		{
			if(m_kASC_MercenariesMod != none)
			{
				LogInternal("before merc", 'ASCPerkDescription');
				m_kASC_MercenariesMod.MercPerkDescription();
				LogInternal("after merc", 'ASCPerkDescription');
			}
			//super.Mutate("MercPerkDescription", m_kSender);
		}
	}
	// End:0x3FE
	else
	{		
		otherelse:
		StrValue2(PERKS().GetBriefSummary(iPerk));
		//return PERKS().GetBriefSummary(iPerk);
	}  
}

function ASCPerks(string funct, int perk, optional int value = 1)
{
	
	local int I, SID;
	local bool bFound;

	if(isStrategy())
	{
		SID = m_kStratSoldier.m_kSoldier.iID;
	}
	else
	{
		SID = XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID;
	}

	if(funct == "HasPerk")
    {
		IntValue0(0, true);
		for(I=0; I<m_kASCCheckpoint.arrSoldierStorage.Length; I++)
		{
			if(SID == m_kASCCheckpoint.arrSoldierStorage[I].SoldierID)
			{
				if(m_kASCCheckpoint.arrSoldierStorage[I].perks[perk] > 0)
				{
					IntValue0(m_kASCCheckpoint.arrSoldierStorage[I].perks[perk], true);
				}
			}
				
		}
		
	}

	if(funct == "GivePerk")
    {
		bFound = false;
		IntValue0(0, true);
		for(I=0; I<m_kASCCheckpoint.arrSoldierStorage.Length; I++)
		{
			if(SID == m_kASCCheckpoint.arrSoldierStorage[I].SoldierID)
			{
				if(m_kASCCheckpoint.arrSoldierStorage[I].perks[perk] > 0)
				{
					bFound = true;
					m_kASCCheckpoint.arrSoldierStorage[I].perks[perk] += value;
				}
			}
		}

		if(!bFound)
		{
			m_kASCCheckpoint.arrSoldierStorage.Add(1);
			m_kASCCheckpoint.arrSoldierStorage[m_kASCCheckpoint.arrSoldierStorage.Length-1].SoldierID = SID;
			m_kASCCheckpoint.arrSoldierStorage[m_kASCCheckpoint.arrSoldierStorage.Length-1].perks[perk] = value;
		}
		
	}
	if(funct == "RemovePerk")
    {
		IntValue0(0, true);
		for(I=0; I<m_kASCCheckpoint.arrSoldierStorage.Length; I++)
		{
			if(SID == m_kASCCheckpoint.arrSoldierStorage[I].SoldierID)
			{
				if(m_kASCCheckpoint.arrSoldierStorage[I].perks[perk] > 0)
				{
					m_kASCCheckpoint.arrSoldierStorage[I].perks[perk] -= value;
				}
			}
		}
	}
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

function ASCOnKill(string Unit, string Victim)
{
	local XGUnit kUnit, kVictim;
	local TSoldierStorage SoldStor, SoldStor1;
	local bool bFound;
	local int I;
	
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
	// Changed from TAG().IntValue2
	IntValue0(Count);
	m_kUnit = none;
}

function ResetXenocideCount()
{
	local TSoldierStorage SoldStor;
	local int I;
	
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
	// Changed from TAG().StrValue2 = "";
	IntValue2(0,  true);
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
		IntValue2(AlienStor.perks[iPerk], true);
	}
	else
	{
		IntValue2(0, true);
	}
	LogInternal("IntValue2= " $ IntValue2(), 'ASCAlienHasPerk');
}

function ASCAlienGivePerk(int iPerk, optional int Value)
{
	local TAlienStorage AlienStor, AlienStor1;
	local int I;
	local bool bFound;

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

function SetSoldierStates(string sstate)
{
	local TSoldierStorage SS;
	local int I, SID;

	if(isStrategy())
	{
		SID = m_kStratSoldier.m_kSoldier.iID;
	}
	else
	{
		SID = XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID;
	}

	foreach m_kASCCheckpoint.arrSoldierStorage(SS, I)
	{
		if(SS.SoldierID == SID)
		{
			if(sstate == "Gunslinger")
			{
				m_kASCCheckpoint.arrSoldierStorage[I].GunslingerState = true;
				break;
			}
		}
	}
}

function ResetSoldierStates()
{
	local TSoldierStorage SS;
	local int I, SID;

	if(isStrategy())
	{
		SID = m_kStratSoldier.m_kSoldier.iID
	}
	else
	{
		SID = XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID;
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


function CheckSoldierStates()
{
	local TSoldierStorage SS;
	local int SID;

	if(isStrategy())
	{
		SID = m_kStratSoldier.m_kSoldier.iID;
	}
	else
	{
		SID = XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID;
	}

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