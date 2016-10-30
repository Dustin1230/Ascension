class MercenaryAscensionMutate extends XComMutator
	config(Mercenary);

struct TMercRanks
{
	var int iPerk;
	var int iPay;
	var array <int> iStat;
};
	
var localized string m_strNoCashForMercs; 
var localized string m_strHireMercs;
var localized array<string> arrStrMercMNicks;
var localized array<string> arrStrMercFNicks;
var localized array<string> arrStrNotMercMNicks;
var localized array<string> arrStrNotMercFNicks;
var localized string m_strMercClassName;
var localized string m_strNotMercClassName;
var config int m_iCostHireMerc;
var config float m_fNotMerc;
var config int m_iMercPay;
var config array<TMercRanks> MercPerks;
/*var array<int> NotMercStartPerks; 
var array<int> NotMercPool1;
var array<int> NotMercPool2;
var array<int> NotMercPool3;*/
var config int MercArmorTint;
var int NotMercArmorTint;
var config int MercHelmet;
var int NotMercHelmet;
var config int MercArmorDeco;
var int NotMercArmorDeco;
var config int MercMainWeapon;
var int NotMercMainWeapon;
var config array<TRandStats> RandStats;
var config array<TMinStats> MinStats;
var config array<TStatProgression> MercStatProgression;
var PlayerController m_kSender;
var localized string m_strSalaryDescription;
var config string MercDesColor;
var localized string m_strMercDescription; 
var localized string m_strMercSalary;
var config array<TMercRanks> FuryPerks;
var config array<TStatProgression> FuryStatProgression;
var config float m_fFuryChance;
  
function Mutate(string MutateString, PlayerController Sender) 
{
  	local array<string> arrMutateStr;
	local XComMod Mod;
	
	m_kSender = Sender;
  
  	if(MutateString == "MercMainMenu")
	{
		LogInternal("Mutate: Mercenary");
    	SetMercMainMenuVars();
    }
	if(MutateString == "MercUpdateHiring")
    {
		LogInternal("Mutate: Mercenary");
    	SetMercUpdateHiringVars();
    }
	if(Left(MutateString, 14) == "MercCreateSold")
    {
		LogInternal("Mutate: Mercenary");
      	arrMutateStr = SplitString(MutateString, "_", false);
    	SetMercCreateSoldVars(int(arrMutateStr[1]));
    }
	if(Left(MutateString, 13) == "MercGetPerkCT")
    {
		LogInternal("Mutate: Mercenary");
    	arrMutateStr = SplitString(MutateString, "_", false);
      	MercGetPerkCT(int(arrMutateStr[1]));
    }
	if(MutateString == "GetMercPerks")
    {
		LogInternal("Mutate: Mercenary");
    	//NotMercPerks();
    }
	if(Left(MutateString, 11) == "MercGetNick")
    {
		LogInternal("Mutate: Mercenary");
    	arrMutateStr = SplitString(MutateString, "_", false);
      	MercNicknames(int(arrMutateStr[1]));
    }
	if(Left(MutateString, 13) == "MercGetSalary")
	{
		LogInternal("Mutate: Mercenary");
		arrMutateStr = SplitString(MutateString, "_", false);
		SetMercSalary(int(arrMutateStr[1]));
	}
	if(MutateString == "GetAllMercPay")
	{
		LogInternal("Mutate: Mercenary");
		TotalMercSalary();
	}
	if(Left(MutateString, 15) == "MercLevelupStat")
	{
		LogInternal("Mutate: Mercenary");
		if(len(MutateString) > 15)
		{
			arrMutateStr = SplitString(MutateString, "_", false);
			MercLevelupStat(int(arrMutateStr[1]));	
		}
		else
		{
			MercLevelupStat();
		}
	}
	if(MutateString == "MercPerkDescription")
	{
		LogInternal("Mutate: Mercenary");
		MercPerkDescription();
	}
	
	if(Left(MutateString, 18) == "ASCPerkDescription")
	{
		LogInternal("Mutate: ASCPerkDescription");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCPerkDescription(int(arrMutateStr[1]));
	}
	
	if(Left(MutateString, 15) == "ASCLevelUpStats")
	{
		LogInternal("Mutate: ASCLevelUpStats");
		arrMutateStr = SplitString(MutateString, "_", false);
		ASCLevelUpStats(int(arrMutateStr[1]));
	}

	if(MutateString == "SingleMercSalary")
	{
		LogInternal("Mutate: SingleMercSalary");
		SingleMercSalary();
	}

	if(MutateString == "ActivateAmnesia")
	{
		ActivateAmnesia();
	}

	if(Left(MutateString, 14) == "FuryCreateSold")
    {
		LogInternal("Mutate: Mercenary");
      	arrMutateStr = SplitString(MutateString, "_", false);
    	SetFuryCreateSoldVars(int(arrMutateStr[1]));
    }

	if(Left(MutateString, 11) == "MercSetFury")
	{
		LogInternal("Mutate: Mercenary");
      	arrMutateStr = SplitString(MutateString, "_", false);
    	FuryPrereqs(int(arrMutateStr[1]));
	}
	
	if(MutateString ~= "TestMod")
	{
		XComGameinfo(WorldInfo.Game).ModStartMatch();
		Foreach XComGameInfo(WorldInfo.Game).Mods(Mod)
		{
			LogInternal(Mod, 'XComMods');
			
			if(string(Mod) == "MyMod_0")
			{
				Mod.StartMatch();
			}
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

function XGFacility_CyberneticsLab CYBERNETICSLAB()
{
	return BARRACKS().m_kCyberneticsLab;
}

function SetMercMainMenuVars()
{
	TAG().strValue2 = m_strNoCashForMercs;
  	TAG().strValue2 $= "_" $ m_strHireMercs;
  	TAG().strValue2 $= "_" $ string(m_iCostHireMerc);
}

function SetMercUpdateHiringVars()
{	
  	TAG().strValue2 = m_strHireMercs;
  	TAG().strValue2 $= "_" $ string(m_iCostHireMerc); 
}

function int GetHighestUsedMedal()
{
	local int I, J;

	J = -1;
	for(I = 0; I < 7; I++)
	{
		if(BARRACKS().m_arrMedals[I].m_iUsed > 0)
		{
			LogInternal("I=" @ I, 'GetHighestUsedMedal');
			LogInternal("I used=" @ BARRACKS().m_arrMedals[I].m_iUsed, 'GetHighestUsedMedal');
			++ J;
		}
	}
	LogInternal("J finished at:" @ J, 'GetHighestUsedMedal');
	return J;
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

function SetMercCreateSoldVars(int SoldierID)
{
  	local XGStrategySoldier kSoldier;
	local TInventory kNewLoadout;
	local int I, newRank;
  
    kSoldier = BARRACKS().GetSoldierByID(SoldierID);
	kNewLoadout = kSoldier.m_kChar.kInventory;

	//if(m_kAscensionMutate == none)
	//{
	//	createactor();
	//}

	switch(GetHighestUsedMedal())
	{
		case 0:
			newRank = Rand(1) + BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
			break;
		case 1:
			newRank = Rand(2) + BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
			break;
		case 2:
			newRank = Rand(3) + BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
			break;
		case 3:
			newRank = Rand(4) + BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
			break;
		case 4:
			if(BARRACKS().HasOTSUpgrade(9))
			{
				newRank = Rand(1) + 4;
			}
			else
			{
				newRank = Rand(BARRACKS().HasOTSUpgrade(8) ? 2 : 3) + BARRACKS().HasOTSUpgrade(8) ? 3 : 2;
			}
			break;
		default:
			newRank = BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
			break;
	}

	kSoldier.m_kSoldier.iXP = TACTICAL().GetXPRequired(newRank);
	lvlloop:
	if(kSoldier.IsReadyToLevelUp())
	{
		kSoldier.LevelUp();
		goto lvlloop;
	}
  
    if(!PercentRoll(0.0))	
    {
        kSoldier.m_iEnergy = 8;
		kSoldier.m_kSoldier.kClass.eWeaponType = 5;
		kSoldier.m_kSoldier.kClass.strName = m_strMercClassName;
		TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 0, MercMainWeapon);
		TACTICAL().TInventoryLargeItemsSetItem(kSoldier.m_kBackedUpLoadout, 0, MercMainWeapon);
		
		for(I = 0; I < MinStats.Length; I++)
		{
			if(MinStats[I].iClass == 8)
			{
				SetMinStats(SoldierID, MinStats[I]);
				break;
			}
		}
		
		for(I = 0; I < RandStats.Length; I++)
		{
			if(RandStats[I].iClass == 8)
			{
				ASCRandomiseStats(SoldierID, RandStats[I]);
				break;
			}
		}
		
      	if(MercArmorTint >= 1)
        {
      		kSoldier.m_kSoldier.kAppearance.iArmorTint = MercArmorTint;
        }
      	if(MercHelmet >= 1)
        {
        	kSoldier.m_kSoldier.kAppearance.iHaircut = MercHelmet;
        }
      	if(MercArmorDeco >= 1)
        {
         	kSoldier.m_kSoldier.kAppearance.iArmorDeco = MercArmorDeco; 
        }
    }
    else
    {
        kSoldier.m_iEnergy = 9;
		kSoldier.m_kSoldier.kClass.eWeaponType = 5;
		kSoldier.m_kSoldier.kClass.strName = m_strNotMercClassName;
		TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 0, NotMercMainWeapon);
		TACTICAL().TInventoryLargeItemsSetItem(kSoldier.m_kBackedUpLoadout, 0, NotMercMainWeapon);
		LOCKERS().ApplySoldierLoadout(kSoldier, kNewLoadout);
		
		for(I = 0; I < MinStats.Length; I++)
		{
			if(MinStats[I].iClass == 9)
			{
				SetMinStats(SoldierID, MinStats[I]);
				break;
			}
		}
		
		for(I = 0; I < RandStats.Length; I++)
		{
			if(RandStats[I].iClass == 9)
			{
				ASCRandomiseStats(SoldierID, RandStats[I]);
				break;
			}
		}
		
      	if(NotMercArmorTint >= 1)
        {
      		kSoldier.m_kSoldier.kAppearance.iArmorTint = NotMercArmorTint;
        }
      	if(NotMercHelmet >= 1)
        {
        	kSoldier.m_kSoldier.kAppearance.iHaircut = NotMercHelmet;
        }
      	if(NotMercArmorDeco >= 1)
        {
         	kSoldier.m_kSoldier.kAppearance.iArmorDeco = NotMercArmorDeco;
        }
    }

	if(kSoldier.GetRank() >= 3)
	{
		MercNicknames(SoldierID);
	}
	
	LOCKERS().ApplySoldierLoadout(kSoldier, kNewLoadout);
	kSoldier.OnLoadoutChange();
	MercGetPerkCT(SoldierID);
}

function ASCLevelUpStats(optional int statsString)
{
    local int statOffense, statWill, statHealth, iBaseWillIncrease;

    local bool bRand;
    local int iStatProgression;

	
	//if(m_kAscensionMutate == none)
	//{
	//	createactor();
	//}

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
	
	
	if(!(SOLDIER().m_iEnergy == 7 || SOLDIER().m_iEnergy == 8 || SOLDIER().m_iEnergy == 9))
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
		MercLevelupStat(statsString);
		//super.Mutate("MercLevelupStat_" $ statsString, m_kSender);
	}
}

function MercLevelupStat(optional int statsString)
{
	local int statOffense, statWill, statHealth, statDefence, I, pos;	
	local bool bRand;
	local array<TStatProgression> kStatProgression;
	
	//if(m_kAscensionMutate == none)
	//{
	//	createactor();
	//}

	if(SOLDIER().m_iEnergy == 7)
	{
		kStatProgression = FuryStatProgression;
	}
	if(SOLDIER().m_iEnergy == 8)
	{
		kStatProgression = MercStatProgression;
	}

	bRand = SOLDIER().IsOptionEnabled(3);

	pos = ((statsString >> 8) & 255) == 0 ? 0 : ((((statsString >> 8) & 255) - 1) * 3) + statsString & 255;

	for(I = 0; I < kStatProgression.Length; I++)
	{
		if(kStatProgression[I].iRank == ((statsString >> 8) & 255))
		{
			if(bRand)
			{
				statWill = Rand(kStatProgression[I].RandWill) + kStatProgression[I].MinWill;
				statHealth = PercentRoll(float(kStatProgression[I].RandHP)) ? 1 : 0;
				statOffense = Rand(kStatProgression[I].RandAim) + kStatProgression[I].MinAim;
				statDefence = PercentRoll(float(kStatProgression[I].RandDef)) ? 1 : 0;
			}
			else
			{
				statWill = kStatProgression[I].Will + Rand(class'XGTacticalGameCore'.default.iRandWillIncrease);
				statHealth = kStatProgression[I].HP;
				statOffense = kStatProgression[I].Aim;
				statDefence = kStatProgression[I].Def;
			}
		}
	}
	
	if(!SOLDIER().IsOptionEnabled(4))
    {
        // End:0x46E
        if(statsString > 1)
        {
            // End:0x46E
            if(SOLDIER().m_iEnergy > 0)
            {
				for(I = 0; I < 5; I++)
				{
					if(MercPerks[pos].iStat[I] != 0)
					{
						switch(I)
						{
							case 0:
								SOLDIER().m_kChar.aStats[1] + MercPerks[pos].iStat[I];
								break;
							case 1:
								SOLDIER().m_kChar.aStats[7] + MercPerks[pos].iStat[I];
								break;
							case 2:
								if(MercPerks[pos].iStat[I] == -1)
								{
									SOLDIER().m_kChar.aStats[3] -= 1;
								}
								if(MercPerks[pos].iStat[I] == 1)
								{
									SOLDIER().m_kChar.aStats[3] += 1;
								}
								break;
							case 3:
								if(MercPerks[pos].iStat[I] == -1)
								{
									SOLDIER().m_kChar.aStats[13] -= 1;
								}
								if(MercPerks[pos].iStat[I] == 1)
								{
									SOLDIER().m_kChar.aStats[13] += 1;
								}
								break;
							case 4:
								if(MercPerks[pos].iStat[I] == -1)
								{
									SOLDIER().m_kChar.aStats[12] -= 1;
								}
								if(MercPerks[pos].iStat[I] == 1)
								{
									SOLDIER().m_kChar.aStats[12] += 1;
								}
								break;
							default:
								break;
						}
					}
				}
            }
        }
    }
	LogInternal("HP" @ statHealth, 'MercLevelupStat');
	LogInternal("Aim" @ statOffense, 'MercLevelupStat');
	LogInternal("Def" @ statDefence, 'MercLevelupStat');
	LogInternal("Will" @ statWill, 'MercLevelupStat');
    SOLDIER().m_kChar.aStats[0] += statHealth;
    SOLDIER().m_kChar.aStats[1] += statOffense;
    SOLDIER().m_kChar.aStats[2] += statDefence;
    SOLDIER().m_kChar.aStats[7] += statWill;
	LogInternal("End of MercLevelupStat");
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
		if(!(SOLDIER().m_iEnergy == 7 || SOLDIER().m_iEnergy == 8 || SOLDIER().m_iEnergy == 9))
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

function MercPerkDescription()
{
	local int aim, will, mob, critch, dmg, iPerk, pay, pos;
	local string costcolor;
	local bool bFtC;
	local array<TMercRanks> kPerks;

	if(SOLDIER().m_iEnergy == 7)
	{
		kPerks = FuryPerks;
	}
	if(SOLDIER().m_iEnergy == 8)
	{
		kPerks = MercPerks;
	}

	pos = SOLDIERUI().GetAbilityTreeBranch() == 0 ? 0 : (((SOLDIERUI().GetAbilityTreeBranch() - 1) * 3) + SOLDIERUI().GetAbilityTreeOption());
	
	bFtC = SOLDIER().HasPerk(178);

	LogInternal("MercPerkDes Branch: " $ SOLDIERUI().GetAbilityTreeBranch());
	LogInternal("MercPerkDes Option: " $ SOLDIERUI().GetAbilityTreeOption());
	LogInternal("MercPerkDes Pos?: " $ pos);
	LogInternal("MercPerkDes perk: " $ kPerks[pos].iPerk);
	LogInternal("MercPerkDes title: " $ PERKS().m_arrPerks[kPerks[pos].iPerk].strName[0]);

	pay = kPerks[pos].iPay;
	aim = kPerks[pos].iStat[0];
	will = kPerks[pos].iStat[1];
	if(kPerks[pos].iStat[2] == -1)
	{
		mob = -1;
	}
	else
	{
		if(kPerks[pos].iStat[2] == 1)
		{
			mob = 1;
		}
		else
		{
			mob = 0;
		}
	}
	if(kPerks[pos].iStat[3] == -1)
	{
		critch = -1;
	}
	else
	{
		if(kPerks[pos].iStat[3] == 1)
		{
			critch = 1;
		}
		else
		{
			critch = 0;
		}
	}
	if(kPerks[pos].iStat[4] == -1)
	{
		dmg = -1;
	}
	else
	{
		if(kPerks[pos].iStat[4] == 1)
		{
			dmg = 1;
		}
		else
		{
			dmg = 0;
		}
	}
	
	iPerk = kPerks[pos].iPerk;

	if(pos == 1 && SOLDIER().m_iEnergy == 8)
	{
		if(!SOLDIER().HasPerk(kPerks[pos].iPerk))
		{
			TAG().StrValue2 = "<font color='" $ MercDesColor $ "'>" $ m_strMercDescription $ "</font>";
		}
		else
		{
			TAG().StrValue2 = PERKS().GetBriefSummary(iPerk);
		}
	}
	else
	{
		if(bFtC)
		{
			costcolor = "'#FFA500'>";
		}
		else
		{
			costcolor = "'#FF0000'>";
		}
	
		TAG().StrValue2 = 
	
		Left(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), InStr(class'XComLocalizer'.static.ExpandString(SOLDIERUI().m_strLockedAbilityDescription), ":") + 1) $ "(" @
	
		(aim != 0 ? class'UIStrategyComponent_SoldierStats'.default.m_strStatOffense @ aim : "")
			
		$ (will != 0 ? "," @ class'UIStrategyComponent_SoldierStats'.default.m_strStatWill @ will : "")
	
		$ (mob != 0 ? "," @ Left(SOLDIERUI().m_strLabelMobility, Len(SOLDIERUI().m_strLabelMobility) - 1) $ ":" @ mob : "")
	
		$ (critch != 0 ? "," @ class'UIItemCards'.default.m_strBaseCriticalDamageLabel @ critch : "")
	
		$ (dmg != 0 ? "," @ class'UIItemCards'.default.m_strDamageLabel @ dmg : "")

		@ ")"
	
		$ (pay != 0 ? class'XComLocalizer'.static.ExpandString("\\n") $ "<font color=" $ costcolor $ m_strSalaryDescription @ class'XGScreenMgr'.static.ConvertCashToString( bFtC ? pay / 2 : pay ) $ "</font>" : "")
	
		@ class'XComLocalizer'.static.ExpandString("\\n") $ PERKS().GetBriefSummary(iPerk);

	}
		
}

function TotalMercSalary()
{
	local XGStrategySoldier kSoldier;
	local int totalCost, mercCost, basePay, I, Pay;
	local bool bFtC;

	totalCost = 0;
	mercCost = 0;
	foreach BARRACKS().m_arrSoldiers(kSoldier)
	{
		if(kSoldier.m_iEnergy == 8)
		{
			bFtC = kSoldier.HasPerk(178);
			if(bFtC)
			{
				basePay = 0;
			}
			else
			{
				basePay = m_iMercPay;
			}
			for(I = 0; I < MercPerks.Length; I++)
			{
				LogInternal("SalaryCounterI= " $ I);
				if(MercPerks[I].iPay > 0)
				{
					if(kSoldier.HasPerk(MercPerks[I].iPerk))
					{
						if(bFtC)
						{
							Pay = (MercPerks[I].iPay / 2);
							LogInternal("Pay2= " $ Pay);
						}
						else
						{
							Pay = MercPerks[I].iPay;
							LogInternal("Pay1= " $ Pay);
						}
						mercCost += Pay;
						LogInternal("mercCost= " $ mercCost);
					}
				}
			}
			mercCost += basePay;
		}
	}
	totalCost += mercCost;
	LogInternal("totalCost= " $ totalCost);
	TAG().StrValue1 = string(totalCost);
}

function SetMercSalary(int MercClass)
{
	local XGStrategySoldier kSoldier;
	local int totalCost, basePay, I, Pay, iCount;
	local bool bFtC;
	
	iCount = 0;
	totalCost = 0;
	TAG().StrValue2 = "";

	foreach BARRACKS().m_arrSoldiers(kSoldier)
	{
		if(kSoldier.m_iEnergy == MercClass)
		{
			++ iCount;

			bFtC = kSoldier.HasPerk(178);
			if(bFtC)
			{
				basePay = 0;
			}
			else
			{
				basePay = m_iMercPay;
			}
			for(I = 0; I < MercPerks.Length; I++)
			{
				LogInternal("MercSalaryI= " $ I);
				if(MercPerks[I].iPay > 0)
				{
					if(kSoldier.HasPerk(MercPerks[I].iPerk))
					{
						if(bFtC)
						{
							Pay = (MercPerks[I].iPay / 2);
							LogInternal("MercPay2= " $ Pay);
						}
						else
						{
							Pay = MercPerks[I].iPay;
							LogInternal("MercPay1= " $ Pay);
						}
						totalCost += Pay;
					}
				}
			}
			totalCost += basePay;
			LogInternal("MercTotal= " $ totalCost);
			TAG().StrValue2 = ((MercClass == 8) ? m_strMercClassName : ((MercClass == 9) ? m_strNotMercClassName : "MercFuryMEC")) @ "x" @ string(iCount) $ "_-" $ class'XGScreenMgr'.static.ConvertCashToString(totalCost);
		}
	}
}

function SingleMercSalary()
{
	local int I, total;
	local bool bFtC;
	local string costcolor;

	bFtC = SOLDIER().HasPerk(178);
	
	if(bFtC)
	{
		total = 0;
		costcolor = "#0000FF'>";
	}
	else
	{
		total = m_iMercPay;
		costcolor = "#FF0000'>";
	}

	for(I = 0; I < MercPerks.Length; I++)
	{
		if(MercPerks[I].iPay > 0)
		{
			if(SOLDIER().HasPerk(MercPerks[I].iPerk))
			{
				if(bFtC)
				{
					total += MercPerks[I].iPay / 2;
				}
				else
				{
					total += MercPerks[I].iPay;
				}
			}
		}
	}
	TAG().StrValue2 = chr(9) /*$ "<font color'" $ costcolor*/ $ m_strMercSalary @ class'XGScreenMgr'.static.ConvertCashToString(total) /*$ "</font>"*/;
}

/*function NotMercPerks()
{
	local XGStrategySoldier kSoldier;
  	local int Branch;
    local int Option;
  	local int I;
  	local int perk;
  
	kSoldier = XGSoldierUI(XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).GetMgr(class'XGSoldierUI',,, true)).m_kSoldier;
  	Branch = kSoldier.GetAbilityTreeBranch();
  	Option = kSoldier.GetAbilityTreeOption();
  	
  	for(I = 0; I < 2; I++)
    {
      	setperk:
		if(Branch == 1)
		{
			perk = NotMercStartPerks[Rand(3)];
		}
      	if(Branch < 6 && Branch > 1)
        {
  			perk = NotMercPool1[Rand(NotMercPool1.Length)];
        }
      	if(Branch == 6)
        {
          	perk = NotMercPool2[Rand(NotMercPool2.Length)];
        }
      	if(Branch == 7)
        {
          	perk = NotMercPool3[Rand(NotMercPool3.Length)];
        }
      	if(kSoldier.m_arrRandomPerks.find(EPerkType(perk)) != -1)
        {
         	goto setperk; 
        }
    	else
        {
        	kSoldier.m_arrRandomPerks[((Branch - 1) * 3) + I] = EPerkType(perk);
        }
    }
  	kSoldier.GivePerk(kSoldier.m_arrRandomPerks[Option + ((Branch - 1) * 3)]);
}*/

function MercGetPerkCT(int SoldierID)
{
  	local XGStrategySoldier kSoldier;
  	local int I;
  
  	kSoldier = BARRACKS().GetSoldierByID(SoldierID);
	
	LogInternal("MercGetPerkCT");
  
  	if(kSoldier.m_iEnergy == 7)
	{
		for(I = 0; I < FuryPerks.Length; I++)
		{
			kSoldier.m_arrRandomPerks.additem(EPerkType(FuryPerks[I].iPerk));
		}
	}
	
	if(kSoldier.m_iEnergy == 8)
	{
		for(I = 0; I < MercPerks.Length; I++)
		{
			kSoldier.m_arrRandomPerks.additem(EPerkType(MercPerks[I].iPerk));
		}
	}
	
  	/*if(kSoldier.m_iEnergy == 9)
	{
		for(I = 0; I < 21; I++)
		{
    		kSoldier.m_arrRandomPerks.additem(EPerkType(46));
		}
	}*/
}
  
function MercNicknames(int SoldierID)
{
 	local XGStrategySoldier kSoldier;
  	local int iCounter;
  
  	kSoldier = BARRACKS().GetSoldierByID(SoldierID);
	iCounter = 20;
  	
  	newnick:
  	if(kSoldier.m_kSoldier.kAppearance.iGender == 1)
    {
      	if(kSoldier.m_iEnergy == 8)
        {
          	kSoldier.m_kSoldier.strNickName = arrStrMercMNicks[Rand(arrStrMercMNicks.Length)];
          	if((BARRACKS().NickNameMatch(kSoldier)) && iCounter > 0)
            {
              	-- iCounter;
            	goto newnick;
            }
        }
        if(kSoldier.m_iEnergy == 9)
        {
          	kSoldier.m_kSoldier.strNickName = arrStrNotMercMNicks[Rand(arrStrNotMercMNicks.Length)];
          	if((BARRACKS().NickNameMatch(kSoldier)) && iCounter > 0)
            {
              	-- iCounter;
            	goto newnick;
            }
        }
    }
  	if(kSoldier.m_kSoldier.kAppearance.iGender == 2)
    {
      	if(kSoldier.m_iEnergy == 8)
        {
          	kSoldier.m_kSoldier.strNickName = arrStrMercFNicks[Rand(arrStrMercFNicks.Length)];
          	if((BARRACKS().NickNameMatch(kSoldier)) && iCounter > 0)
            {
              	-- iCounter;
            	goto newnick;
            }
        }
        if(kSoldier.m_iEnergy == 9)
        {
          	kSoldier.m_kSoldier.strNickName = arrStrNotMercFNicks[Rand(arrStrNotMercFNicks.Length)];
          	if((BARRACKS().NickNameMatch(kSoldier)) && iCounter > 0)
            {
              	-- iCounter;
            	goto newnick;
            }
        }
    }
}

function ActivateAmnesia()
{
	local int I;

	if(SOLDIER().m_iEnergy == 8)
	{
		LogInternal("Mutate: Merc, ActivateAmnesia");

		for(I = 0; I < MinStats.Length; I++)
		{
			if(MinStats[I].iClass == 8)
			{
				SetMinStats(SOLDIER().m_kSoldier.iID, MinStats[I]);
				break;
			}
		}
		
		for(I = 0; I < RandStats.Length; I++)
		{
			if(RandStats[I].iClass == 8)
			{
				ASCRandomiseStats(SOLDIER().m_kSoldier.iID, RandStats[I]);
				break;
			}
		}
		MercGetPerkCT(SOLDIER().m_kSoldier.iID);
	}
}

function FuryPrereqs(int iNum)
{
	if(LABS().IsResearched(60) && HQ().HasFacility(22))
    {
    	if(((HQ().GetResource(0)) >= (CYBERNETICSLAB().m_iModCashCost * 0.75)) && (HQ().GetResource(7)) >= CYBERNETICSLAB().m_iModMeldCost)
        {
    		FuryPopUp(iNum);
        }
    }
}

function FuryPopUp(int iNum, optional bool bForce)
{
	local TDialogueBoxData kDialog;
    local bool bMakeFury;
    local int I;
  
  	bMakeFury = bForce;
      
    for(I = 0; (!(bMakeFury) || (I < iNum)); I++)
    {
      	bMakeFury = PercentRoll(m_fFuryChance);
    }

    if(bMakeFury)
    {
    	kDialog.eType = 0;
    	kDialog.strTitle = "ATTENTION: Recruitment opportunity" $ chr(10) $ chr(10) $ "This will cost:" $ class'UIUtilities'.static.GetHTMLColoredText(class'XGScreenMgr'.static.ConvertCashToString(CYBERNETICSLAB().m_iModCashCost * 0.75), 6) $ "&" $ class'UIUtilities'.static.InjectHTMLImage("meld_orange", 32, 26, -5) $ class'UIUtilities'.static.GetHTMLColoredText(string(CYBERNETICSLAB().m_iModMeldCost), 12);
        kDialog.strText = "While scouting for potential Mercenaries we have come across a unique individual.  Though they have not been so fortunate in battle they have a strong background in combat and might be a suitable candidate for our new MEC program. Would you like to hire and augment them or find a standard mercenary Commander?";
    	kDialog.strAccept = "Augment";
    	kDialog.strCancel = "Mercenary";
    	kDialog.fnCallback = FuryPopUpCallback;
      	XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).m_kSoldierPromote.SetInputState(0);
		XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).UIRaiseDialog(kDialog);
    }
  	else
    {
      	TAG().IntValue2 = 1;
    }
}

function FuryPopUpCallback(EUIAction eAction)
{
  	if(eAction == 2)
    {
    	FuryPopUp(0, true);
    }
	if(eAction == 1)
    {
    	TAG().IntValue2 = 1;
    }
	if(eAction == 0)
    {
    	TAG().IntValue2 = 2;
    	HQ().AddResource(0, -(CYBERNETICSLAB().m_iModCashCost * 0.75));
        HQ().AddResource(7, -CYBERNETICSLAB().m_iModMeldCost);
    }
        
    XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).m_kSoldierPromote.SetInputState(1);
    //return;    
}


function SetFuryCreateSoldVars(int SoldierID)
{
  	local XGStrategySoldier kSoldier;
	local TCyberneticsLabPatient kPatient;
	local int I, newRank;
  	local TMinStats MinData;
  
    kSoldier = BARRACKS().GetSoldierByID(SoldierID);
	kSoldier.m_iEnergy = 7;
  
  	MinData.Hp = 1;
    MinData.Aim = 25;
    MinData.Def = -15;
    MinData.Mob = 5;
    MinData.Will = 25;
  
    SetMinStats(SoldierID, MinData);
  
	//kNewLoadout = kSoldier.m_kChar.kInventory;
	//kNewLoadout.iArmor = 192;

	//if(m_kAscensionMutate == none)
	//{
	//	createactor();
	//}

	if(kSoldier.m_kChar.eClass == 6)
    {
		switch(GetHighestUsedMedal())
		{
			case 0:
				newRank = Rand(1) + BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
				break;
			case 1:
				newRank = Rand(2) + BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
				break;
			case 2:
				newRank = Rand(3) + BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
				break;
			case 3:
				newRank = Rand(4) + BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
				break;
			case 4:
				if(BARRACKS().HasOTSUpgrade(9))
				{
					newRank = Rand(1) + 4;
				}
				else
				{
					newRank = Rand(BARRACKS().HasOTSUpgrade(8) ? 2 : 3) + BARRACKS().HasOTSUpgrade(8) ? 3 : 2;
				}
				break;
			default:
				newRank = BARRACKS().HasOTSUpgrade(8) ? 2 : 1;
				break;
		}

		kSoldier.m_kSoldier.iXP = TACTICAL().GetXPRequired(newRank);
		lvlloop:
		if(kSoldier.IsReadyToLevelUp())
		{
			kSoldier.LevelUp();
			goto lvlloop;
		}
		
		for(I = 0; I < MinStats.Length; I++)
		{
			if(MinStats[I].iClass == 7)
			{
				SetMinStats(SoldierID, MinStats[I]);
				break;
			}
		}
    
		if(kSoldier.GetRank() >= 3)
		{
			MercNicknames(SoldierID);
		}
	
		MercGetPerkCT(SoldierID);
    }
	else
    {
    	kPatient.m_kSoldier = kSoldier;
        kPatient.m_iHoursLeft = ((CYBERNETICSLAB().m_iModDays * 24) * 0.75);
        kPatient.m_kSoldier.m_iTurnsOut = kPatient.m_iHoursLeft;
        kPatient.m_kSoldier.SetStatus(5);
        CYBERNETICSLAB().m_arrPatients.AddItem(kPatient);
        BARRACKS().ReorderRanks();
        XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).UINarrative(xcomnarrativemoment'MECaugment_Confirmed');
    }
    	
}


// Decompiled with UE Explorer.
defaultproperties
{
    NotMercArmorTint=24
    NotMercHelmet=-1
    NotMercArmorDeco=76
    NotMercMainWeapon=231
}

