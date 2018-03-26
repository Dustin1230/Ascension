class RPPerksMod extends RoulettePlusMod
	config(RPMisc);

// Structure used for new perks, not used
struct ASCTPerkInfo
{
	var string ID;
    var int PerkNumSlot;
    var string name;
	var string Description;
    var string IconID;
	
};

// Structure for information related to the Weapon Specialist Perk
struct TSpecPerk
{
  	var int iItem;
  	var array<int> iClass;
  	var array<int> iPerk;
};

var config array<ASCTPerkInfo> PerkInfo;
var config int AmnesiaWillLossAmount;
var config int AmnesiaWillLossType;
var string AmnesiaPerkName;
var string AmnesiaPerkDes;
var config bool bAMedalWait;
var config array<TSpecPerk> specPerk;
var XGUnit m_kUnit;
var XGStrategySoldier m_kStratSoldier;
var RoulettePlusMod m_kRPlus;
var localized string m_perkNames[255];
var localized string m_perkDesc[255];

// Functions used to access/check parts of the game code
function bool isStrategy()
{
	return XComHeadquartersGame(XComGameInfo(WORLDINFO().Game)) != none;
}

function bool isTactical()
{
	return XComTacticalGame(XComGameInfo(WORLDINFO().Game)) != none;
}

function XGFacility_Labs LABS()
{
    return XComHeadquartersGame(WORLDINFO().Game).GetGameCore().GetHQ().m_kLabs; 
}

function XGFacility_Barracks BARRACKS()
{
    return XComHeadquartersGame(WORLDINFO().Game).GetGameCore().GetHQ().m_kBarracks;
}

function XComPerkManager PERKS()
{
    return XComGameReplicationInfo(WORLDINFO().GRI).m_kPerkTree;   
}

function XGParamTag TAG()
{
	return XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
}

// Part of the new XComModBridge system to decide which functions to access based on ModBridge calls
simulated function StartMatch()
{
	local array<string> arrStr;
	local XGStrategySoldier kSold;

	if(functionName == "ModInit")
	{
		m_kRPlus = RoulettePlusMod(Mods("RoulettePlus.RoulettePlusMod"));
		m_kRPCheckpoint = m_kRPlus.m_kRPCheckpoint;
		PerkStats = m_kRPlus.PerkStats;
		arrAlias = m_kRPlus.arrAlias;
		arrPerk = m_kRPlus.arrPerk;
		MergePerk1 = m_kRPlus.MergePerk1;
		MergePerk2 = m_kRPlus.MergePerk2;
		expandPerkarray();
	}

	if(functionName == "GHPD_Overwrite")
	{
		`logd(`ShowVar(SOLDIERUI().GetAbilityTreeBranch()) $ ", " $ `ShowVar(SOLDIERUI().GetAbilityTreeOption()) $ ", pos:'" $ ((SOLDIERUI().GetAbilityTreeBranch() - 1) * 3) + SOLDIERUI().GetAbilityTreeOption());
		`logd(`ShowVar(SOLDIERUI().m_kSoldier.m_kChar.eClass));
		ASCSetUnit(StrValue0());

		if(m_kStratSoldier != none)
			kSold = m_kStratSoldier;
		else
			kSold = SOLDIER();

		if(kSold.IsOptionEnabled(4))
			ASCPerkDescription();

		m_kStratSoldier = none;
	}

	if(functionName == "SetAdvServos")
	{
		GetSoldier(StrValue0());
		SetAdvServos();
		m_kSold = none;
	}

	if(functionName == "ASIM")
	{
		ASCSetUnit(StrValue0());
	}
	if(functionName == "GSIM")
	{
		arrStr = SplitString(functParas);

		ModifyStats(int(arrStr[0]), int(arrStr[1]));
		m_kUnit = none;
	}

	if(functionName == "CheckSoldierStates")
	{
		ASCSetUnit(StrValue0());
		CheckSoldierStates();
		m_kUnit = none;
		m_kStratSoldier = none;
	}

	if(functionName == "ResetSoldierStates")
	{
		ASCSetUnit(StrValue0());
		ResetSoldierStates();
		m_kUnit = none;
		m_kStratSoldier = none;
	}
	
	if(functionName == "SetSoldierStates")
	{
		ASCSetUnit(StrValue0());
		SetSoldierStates(functparas);
		m_kUnit = none;
		m_kStratSoldier = none;
	}

	// Not related to Flush perk
	if(functionName == "FlushAlienPerks")
	{
		FlushAlienPerks();
	}
	
	if(functionName == "ASCPerkDescription")
	{
		ASCPerkDescription();
	}
	
	if(functionName == "ASCPerks") 
    {
		arrStr = SplitString(functparas, "_", false);

		ASCSetUnit(arrStr[0]);

		if(arrStr.Length > 3) 
        {
			ASCPerks(arrStr[1], int(arrStr[2]), int(arrStr[3]));
		}
		else 
        {
			ASCPerks(arrStr[1], int(arrStr[2]));
		}
		m_kUnit = none;
		m_kStratSoldier = none;
	}

	if(functionName == "CurruptMessage")
	{
		ASCSetUnit(StrValue0());
		CurruptMessage(StrValue1());
	}

	if(functionName == "AlienHasPerk")
	{
		ASCSetUnit(StrValue0());
		ASCAlienHasPerk(int(functParas));
		m_kUnit = none;
	}

	if(functionName == "GiveAlienPerk")
	{
		ASCSetUnit(StrValue0());

		arrStr = SplitString(functParas, "_", false);

		if(arrStr.Length > 1)
		{
			ASCAlienGivePerk(int(arrStr[0]), int(arrStr[1]));
		}
		else
		{
			ASCAlienGivePerk(int(arrStr[0]));
		}
		m_kUnit = none;
	}

	if(functionName == "IncapTimer")
	{
		ASCSetUnit(StrValue0());
		IncapTimer();
		m_kUnit = none;
	}

	if(functionName == "ActivateAmnesia")
	{
		ActivateAmnesia();
	}

	if(functionName == "ResetXenocideCount")
	{
		ASCSetUnit(StrValue0());
		ResetXenocideCount();
		m_kUnit = none;
	}

	if(functionName == "XenocideCount")
	{
		ASCSetUnit(StrValue0());
		XenocideCount();
		m_kUnit = none;
	}

	if(functionName == "ASCOnKill")
	{
		ASCOnKill(StrValue0(), StrValue1());
	}

	if(functionName == "WepSpec")
    {
    	arrStr = SplitString(functParas, "_", false);
    	WepSpecPerk(int(arrStr[0]), arrStr[1]);
    }
}

// Function to grab the spawn name of a soldier and checks for Strategy/Tactical to set appropriate variable to be used in other functions
function ASCSetUnit(string UnitName)
{
	local XGUnit Unit;
	local XGStrategySoldier Soldier;

	if(isTactical())
	{
		foreach WORLDINFO().AllActors(class'XGUnit', Unit)
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
		foreach WORLDINFO().AllActors(class'XGStrategySoldier', Soldier)
		{
			if(string(Soldier) == UnitName)
			{
				break;
			}
		}
		m_kStratSoldier = Soldier;
	}
}

function SetAdvServos()
{
	if(m_kRPCheckpoint.arrSoldierStorage.Length > 0 || FindSoldierInStorage(, m_kSold) == -1)
		CreateSoldierStor(m_kSold);

	m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(, m_kSold)].advServos = true;
}

function ModifyStats(int iStat, int iEquippedWeapon)
{
	local int soldID;

	soldID = XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID;

	if(iStat == 3)
	{
		if(m_kRPCheckpoint.arrSoldierStorage.Length > 0) 
		{
			if(FindSoldierInStorage(soldID) != -1)
			{
				if(m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(soldID)].advServos)
					IntValue0(IntValue0() + 4, true);
			}
		}
	}
}

// Clears all aliens' perks
function FlushAlienPerks()
{

	m_kRPCheckpoint.arrAlienStorage.Length = 0;
}

// Allows editing of perk descriptions on the Ability Screen
function ASCPerkDescription()
{
    local int iPerk, iPos, Perk1, Perk2, I;
	local string Output, mPerk;
	local XGStrategySoldier kSold;
	local TStatStorage StatsStor;

	if(m_kStratSoldier != none)
		kSold = m_kStratSoldier;
	else
		kSold = SOLDIER();
	
	`Logd("ASCPerkDescription");

	`Logd("kSold= " $ string(kSold));

	if(SOLDIERUI().m_iCurrentView != 2)
	{
		iPos = ((SOLDIERUI().GetAbilityTreeBranch() - 1) * 3) + SOLDIERUI().GetAbilityTreeOption();

		if(isSoldierNewType(kSold) && SOLDIERUI().GetAbilityTreeBranch() != 1)
		{
			`Logd("IsNewType");

			iPerk = NewRandomTree(kSold, -1)[iPos];

			`Logd("iPerk= " $ string(iPerk));
			
			StatsStor = GetPerkStats(kSold, iPos);
		}
		else
		{
			if(kSold.m_arrRandomPerks.Length > 0)
				iPerk = kSold.m_arrRandomPerks[iPos];
			else
				iPerk = 0;

			if(SOLDIERUI().GetAbilityTreeBranch() == 1)
				iPerk = kSold.PERKS().GetPerkInTree(kSold.GetClass() == 6 ? byte(kSold.m_iEnergy) : kSold.GetClass(), 1, SOLDIERUI().GetAbilityTreeOption(), false);
			
			OldPerkStats(iPos, true);
			StatsStor.aim = arrInts()[0];
			StatsStor.will = arrInts()[1];
			StatsStor.hp = arrInts()[2];
			StatsStor.mob = arrInts()[3];
			StatsStor.def = arrInts()[4];
			
			foreach m_kRPlus.MergePerk1(mPerk, I)
			{
				Perk1 = super.SearchPerks(mPerk);
				Perk2 = super.SearchPerks(MergePerk2[I]);
				
				if( (m_kRPlus.MergePerkClass[I] == -1) || (SOLDIERUI().GetAbilityTreeBranch() == 1) ? (m_kRPlus.MergePerkClass[I] == kSold.GetClass()) : (m_kRPlus.MergePerkClass[I] == kSold.m_iEnergy) )
				{
					if(Perk1 == iPerk)
					{
						StatsStor.perk = Perk2;
						break;
					}
				}
			}
		}

		if((!m_kRPlus.bHideEmptyStatStr || StatsStor.def != 0 || StatsStor.HP != 0 || StatsStor.mob != 0 || StatsStor.will != 0 || StatsStor.aim != 0) && iPerk != 46)
		{
			Output =  Left(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), InStr(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), ":") + 1) $ "( ";
			Output $= (StatsStor.aim != 0 ? (class'UIStrategyComponent_SoldierStats'.default.m_strStatOffense @ StatsStor.aim) : "");
			Output $= (StatsStor.will != 0 ? ((StatsStor.aim != 0 ? ", " : "") $ class'UIStrategyComponent_SoldierStats'.default.m_strStatWill @ StatsStor.will) : "");
			Output $= (StatsStor.mob != 0 ? (((StatsStor.will != 0 || StatsStor.aim != 0) ? ", " : "") $ Left(SOLDIERUI().m_strLabelMobility, Len(SOLDIERUI().m_strLabelMobility) - 1) $ ":" @ StatsStor.mob) : "");
			Output $= (StatsStor.HP != 0 ? (((StatsStor.mob != 0 || StatsStor.will != 0 || StatsStor.aim != 0) ? ", " : "") $ class'UIStrategyComponent_SoldierStats'.default.m_strStatHealth @ StatsStor.HP) : "");
			Output $= (StatsStor.def != 0 ? (((StatsStor.HP != 0 || StatsStor.mob != 0 || StatsStor.will != 0 || StatsStor.aim != 0) ? ", " : "") $ class'UIStrategyComponent_SoldierStats'.default.m_strStatDefense @ StatsStor.def) : "") @ ")";
			Output $= class'XComLocalizer'.static.ExpandString("\\n");
		}
		
		if(StatsStor.perk > 0)
			Output $= "<font color='" $ (m_kRPlus.strMergePerkColor != "" ? m_kRPlus.strMergePerkColor : "#5CD16C") $ "'>" $ m_kRPlus.strMergePerkLabel $ ":(" @ kSold.PERKS().GetPerkName(StatsStor.perk) @ ")</font>" $ class'XComLocalizer'.static.ExpandString("\\n");
		
		Output $= kSold.PERKS().GetBriefSummary(iPerk);
		
		if(StatsStor.perk > 0)
			Output $= class'XComLocalizer'.static.ExpandString("\\n") $ "<font color='" $ (m_kRPlus.strMergePerkColor != "" ? m_kRPlus.strMergePerkColor : "#5CD16C") $ "'>" $ m_kRPlus.strMergePerkDes $ ":(" @ kSold.PERKS().GetBriefSummary(StatsStor.perk) @ ")</font>";
		
			
		StrValue0("True");
		StrValue1(Output, true);
	}
}

// Checks for, Adds, or Removes new perks(perks not from Long War)
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
		for(I=0; I<m_kRPCheckpoint.arrSoldierStorage.Length; I++)
		{
			if(SID == m_kRPCheckpoint.arrSoldierStorage[I].SoldierID)
			{
				if(m_kRPCheckpoint.arrSoldierStorage[I].perks[perk] > 0)
				{
					IntValue0(m_kRPCheckpoint.arrSoldierStorage[I].perks[perk], true);
				}
			}
				
		}
		
	}

	if(funct == "GivePerk")
    {
		bFound = false;
		IntValue0(0, true);
		for(I=0; I<m_kRPCheckpoint.arrSoldierStorage.Length; I++)
		{
			if(SID == m_kRPCheckpoint.arrSoldierStorage[I].SoldierID)
			{
				if(m_kRPCheckpoint.arrSoldierStorage[I].perks[perk] > 0)
				{
					bFound = true;
					m_kRPCheckpoint.arrSoldierStorage[I].perks[perk] += value;
				}
			}
		}

		if(!bFound)
		{
			m_kRPCheckpoint.arrSoldierStorage.Add(1);
			m_kRPCheckpoint.arrSoldierStorage[m_kRPCheckpoint.arrSoldierStorage.Length-1].SoldierID = SID;
			m_kRPCheckpoint.arrSoldierStorage[m_kRPCheckpoint.arrSoldierStorage.Length-1].perks[perk] = value;
		}
		
	}
	if(funct == "RemovePerk")
    {
		IntValue0(0, true);
		for(I=0; I<m_kRPCheckpoint.arrSoldierStorage.Length; I++)
		{
			if(SID == m_kRPCheckpoint.arrSoldierStorage[I].SoldierID)
			{
				if(m_kRPCheckpoint.arrSoldierStorage[I].perks[perk] > 0)
				{
					m_kRPCheckpoint.arrSoldierStorage[I].perks[perk] -= value;
				}
			}
		}
	}
}

// This is where the magic happens, increases the number of perks that can be allowed in the game(increases size of array in PerkManager)
function expandPerkarray()
{
	local XComPerkManager kPerkMan;
	
	if(IsStrategy())
		kPerkMan = BARRACKS().m_kPerkManager;
	else if(IsTactical())
		kPerkMan = PERKS();
	else
		return;	

	stperkman:
	kPerkMan.m_arrPerks.Length = 255;
	
	LogInternal(String(kPerkMan), 'expandPerkarray');
	
	kPerkMan.BuildPerk(116, 0, "Evasion");								// Changing icons for existing perks
	kPerkMan.BuildPerk(80, 1, "Flying");
	kPerkMan.BuildPerk(83, 1, "Poisoned");
	kPerkMan.BuildPerk(84, 1, "Poisoned");
    kPerkMan.BuildPerk(85, 1, "Adrenal");
    kPerkMan.BuildPerk(76, 0, "ReinforcedArmor");

	
	kPerkMan.BuildPerk(173, 0, "Unknown");								// Assigns the icon
	kPerkMan.m_arrPerks[173].strName[0] = m_perkNames[173];				// Assigns the name from a localized file
	kPerkMan.m_arrPerks[173].strDescription[0] = m_perkDesc[173];		// assigns the description from a localized file
	
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

// Assigns and removes perks based on item(s) equipeed to a soldier
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

// Does things when a soldier or enemy is killed
function ASCOnKill(string Unit, string Victim)
{
	local XGUnit kUnit, kVictim;
	local TSoldierStorage SoldStor, SoldStor1;
	local bool bFound;
	local int I;
	
	foreach WORLDINFO().AllActors(Class'XGUnit', kUnit)
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
		if(IntValue0() > 0)
		{
			m_kUnit.m_aCurrentStats[7] += 1;
			m_kUnit.m_aCurrentStats[13] += 1;

			bFound = false;
			foreach m_kRPCheckpoint.arrSoldierStorage(SoldStor, I)
			{
				if(SoldStor.SoldierID == XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID)
				{
					++ m_kRPCheckpoint.arrSoldierStorage[I].XenocideCount;
					bFound = true;
					break;
				}
			}

			if(!bFound)
			{
				SoldStor1.SoldierID = XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID;
				SoldStor1.XenocideCount = 1;
				m_kRPCheckpoint.arrSoldierStorage.AddItem(SoldStor1);
			}
		}
	}
	m_kUnit = none;
}

// Counter to keep track of kills for Xenocide perk
function XenocideCount()
{
	local int Count;
	local bool bFound;
	local TSoldierStorage SoldStor;
	
	bFound = false;
	foreach m_kRPCheckpoint.arrSoldierStorage(SoldStor)
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

// Resets the Xenocide count for each soldier
function ResetXenocideCount()
{
	local TSoldierStorage SoldStor;
	local int I;
	
	foreach m_kRPCheckpoint.arrSoldierStorage(SoldStor, I)
	{
		if(SoldStor.SoldierID == XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID)
		{
			m_kRPCheckpoint.arrSoldierStorage[I].XenocideCount = 0;
			break;
		}
	}
	m_kUnit = none;
}

// Checks if an alien has a perk
function ASCAlienHasPerk(int iPerk)
{

	local TAlienStorage AlienStor;
	local bool bFound;

	IntValue2(0,  true);
	bFound = False;
	foreach m_kRPCheckpoint.arrAlienStorage(AlienStor)
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

// Assigns new perks to aliens
function ASCAlienGivePerk(int iPerk, optional int Value)
{
	local TAlienStorage AlienStor, AlienStor1;
	local int I;
	local bool bFound;

	bFound = False;
	foreach m_kRPCheckpoint.arrAlienStorage(AlienStor, I)
	{
		if(int(GetRightMost(String(m_kUnit))) == AlienStor.ActorNumber)
		{
			bFound = true;
			if(Value > 0)
			{
				m_kRPCheckpoint.arrAlienStorage[I].perks[iPerk] += Value;
			}
			else
			{
				m_kRPCheckpoint.arrAlienStorage[I].perks[iPerk] += 1;
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
		m_kRPCheckpoint.arrAlienStorage.AddItem(AlienStor1);
	}
}

// Removes a perk from an alien
function ASCAlienRemovePerk(int iPerk, optional int Value)
{
	local TAlienStorage AlienStor;
	local int I;

	foreach m_kRPCheckpoint.arrAlienStorage(AlienStor, I)
	{
		if(int(GetRightMost(String(m_kUnit))) == AlienStor.ActorNumber)
		{
			if(Value > 0 && Value >= AlienStor.perks[iPerk])
			{
				m_kRPCheckpoint.arrAlienStorage[I].perks[iPerk] -= Value;
			}
			else
			{
				m_kRPCheckpoint.arrAlienStorage[I].perks[iPerk] = 0;
			}
			break;
		}
	}
}

// Counter for how long Incapacitation affects an enemy
function IncapTimer()
{
	local TAlienStorage AlienStor, AlienStor1;
	local int I;
	local bool bFound;

	bFound = False;
	foreach m_kRPCheckpoint.arrAlienStorage(AlienStor, I)
	{
		if(int(GetRightMost(String(m_kUnit))) == AlienStor.ActorNumber)
		{

			if( ++ m_kRPCheckpoint.arrAlienStorage[I].IncapTimer == 2)
			{
				ASCAlienRemovePerk(192);
				m_kUnit.ApplyInventoryStatModifiers();
				m_kRPCheckpoint.arrAlienStorage[I].IncapTimer = 0;
			}
			bFound = true;
		}
	}
	if(!bFound)
	{
		AlienStor1.ActorNumber = int(GetRightMost(String(m_kUnit)));
		AlienStor1.IncapTimer = 1;
		m_kRPCheckpoint.arrAlienStorage.AddItem(AlienStor1);
	}
	m_kUnit = none;
}

// Function to reset perks, stats, and other bonuses from leveling up(also removes starting rookie perk)
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

// Set/Reset/Check SoldierStates set flags to let the game know if something has happened to a specific soldier
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

	foreach m_kRPCheckpoint.arrSoldierStorage(SS, I)
	{
		if(SS.SoldierID == SID)
		{
			if(sstate == "Gunslinger")
			{
				m_kRPCheckpoint.arrSoldierStorage[I].GunslingerState = true;
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
		SID = m_kStratSoldier.m_kSoldier.iID;
	}
	else
	{
		SID = XGCharacter_Soldier(m_kUnit.GetCharacter()).m_kSoldier.iID;
	}

	foreach m_kRPCheckpoint.arrSoldierStorage(SS, I)
	{
		if(SS.SoldierID == SID)
		{
			m_kRPCheckpoint.arrSoldierStorage[I].GunslingerState = false;
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

	foreach m_kRPCheckpoint.arrSoldierStorage(SS)
	{
		if(SS.SoldierID == SID)
		{
			LogInternal("Gunslinger:" @ string(SS.GunslingerState), 'CheckSoldierStates');
			valStrValue1 = SS.GunslingerState ? "true" : "false";
			break;
		}
	}
}

// Messages that appears to let the player know if Corrupt failed or succeeded
function CurruptMessage(string strTarget)
{
	local XGUnit Unit, kTarget;
	local bool bPanic;
	local XComUIBroadcastWorldMessage kMessage;
	local string msgStr;
	local int CurruptWillTest, WillChance, UnitWill;

	foreach WORLDINFO().AllActors(class'XGUnit', Unit)
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

		XComTacticalGRI(WORLDINFO().GRI).m_kBattle.m_kDesc.m_iDifficulty = 0;

		kMessage = XComPresentationLayer(XComPlayerController(WORLDINFO().GetALocalPlayerController()).m_Pres).GetWorldMessenger().Message(PERKS().m_arrPerks[189].strName[0] @ string(100 - WillChance) $ "%" @ msgStr, kTarget.GetLocation(), bPanic ? 3 : 4,,, kTarget.m_eTeamVisibilityFlags,,,, Class'XComUIBroadcastWorldMessage_UnexpandedLocalizedString');

		if(kMessage != none)
		{
			XComUIBroadcastWorldMessage_UnexpandedLocalizedString(kMessage).Init_UnexpandedLocalizedString(0, kTarget.GetLocation(), bPanic ? 3 : 4, kTarget.m_eTeamVisibilityFlags);
		}

		XComTacticalGRI(WORLDINFO().GRI).m_kBattle.m_kDesc.m_iDifficulty = XComGameReplicationInfo(WORLDINFO().GRI).m_kGameCore.m_iDifficulty;
	}
}