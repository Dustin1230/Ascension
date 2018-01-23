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
			
				TAG().StrValue2 =
			
				Left(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), InStr(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), ":") + 1) $ "(" @
			
				(TAG().IntValue1 != 0 ? class'UIStrategyComponent_SoldierStats'.default.m_strStatOffense @ TAG().IntValue1 : "")
			
				$ (TAG().IntValue2 != 0 ? "," @ class'UIStrategyComponent_SoldierStats'.default.m_strStatWill @ TAG().IntValue2 : "")
			
				$ (TAG().IntValue0 != 0 ? "," @ Left(SOLDIERUI().m_strLabelMobility, Len(SOLDIERUI().m_strLabelMobility) - 1) $ ":" @ TAG().IntValue0 : "")
			
				@ class'XComLocalizer'.static.ExpandString(")\\n") $ PERKS().GetBriefSummary(iPerk);
			
				//return class'XComLocalizer'.static.ExpandString(m_strLockedAbilityDescription) $ PERKS().GetBriefSummary(iPerk);
			}
			else
			{
				goto otherelse;
			}
		}
		else
		{
			LogInternal("before merc", 'ASCPerkDescription');
			MercPerkDescription();
			LogInternal("after merc", 'ASCPerkDescription');
			//super.Mutate("MercPerkDescription", m_kSender);
		}
	}
	// End:0x3FE
	else
	{		
		otherelse:
		TAG().StrValue2 = PERKS().GetBriefSummary(iPerk);
		//return PERKS().GetBriefSummary(iPerk);
	}  
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