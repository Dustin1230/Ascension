class ASC_SoldierMod extends AscensionMod
	config(ASC_Soldier);
	
// Different Bio/MEC stats that can be added to or removed from
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

// Used for the Randomized stats function used when a soldier/mercenary is first hired
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

// Defines the minimum stats each class can have, their "base stats"
struct TMinStats
{
	var int iClass;
	var int HP;
	var int Aim;
	var int Def;
	var int Will;
	var int Mob;
};

// Used in conjunction with promotions of soldiers
struct TStatProgression
{
	var int iClass;
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

struct TSoldTree
{
	var string iClass;
	var int iPerk[7];
};

struct TSoldPerkStats
{
	var string iClass;
	var int iVal[21];
};

// starting stat assignment Variables
var config array<ASCTStats> Stats;
var ASCTStats m_kTotalStats;
var config TRandStats RandStats;
var config array<TMinStats> MinStats;
// Variables used with Rookie Random Perk System
var config array<int> rookRandPerk;
var string m_strChangeRandPerk;

// Bio Stat Progression
var config array<TStatProgression> StatProgression;
var config array<TSoldTree> SoldTree;
var config array<TSoldPerkStats> PerkAim;
var config array<TSoldPerkStats> PerkWill;
var config array<TSoldPerkStats> PerkMob;
var config array<TSoldPerkStats> PerkCrit;
var config array<TSoldPerkStats> PerkDmg;

function SoldierInit()
{
	m_kASC_ClassPicker = ASC_ClassPicker(CreateASCObj("Ascension.ASC_ClassPicker"));
}

// Assigns a random perk to rookies and new mercenary type units(currently excludes Fury and other MEC Classes)
function GiveRandomPerk()
{
	local int perk;
	local XGStrategySoldier kSoldier;
	local TSoldierStorage SS;
	
	kSoldier = m_kStratSoldier;	//BARRACKS().GetSoldierByID(SoldierID);

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

// function to check if the random perk already exists in unit's class tree
function CheckRandomPerk(int perk)
{
	local TSoldierStorage SS;
	
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

// used to allow the perk to remain in the class tree but not be selectable
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

function SoldLevelupStat(optional int statsString)
{
	local int statOffense, statWill, statHealth, statDefence, statMobility, soldClass, I, pos;	
	local bool bRand;
	local array<TStatProgression> kStatProgression;
	local array<TMercRanks> kPerks;
	local TSoldPerkStats kVal;
	
	if(SOLDIER().m_iEnergy > 0 && SOLDIER().m_iEnergy < 20)
	{
		kStatProgression = StatProgression;
		soldClass = SOLDIER().m_iEnergy;
	}
	else
	{
		soldClass = SOLDIER().GetClass();
	}
		
	bRand = SOLDIER().IsOptionEnabled(3);

	pos = ((statsString >> 8) & 255) == 0 ? 0 : ((((statsString >> 8) & 255) - 1) * 3) + statsString & 255;

	for(I = 0; I < kStatProgression.Length; I++)
	{
		if(kStatProgression[I].iClass == soldClass)
		{
			if(kStatProgression[I].iRank == ((statsString >> 8) & 255))
			{
				if(bRand)
				{
					statWill = Rand(kStatProgression[I].RandWill) + kStatProgression[I].MinWill;
					statHealth = PercentRoll(float(kStatProgression[I].RandHP)) ? 1 : 0;
					statOffense = Rand(kStatProgression[I].RandAim) + kStatProgression[I].MinAim;
					statDefence = PercentRoll(float(kStatProgression[I].RandDef)) ? 1 : 0;
					statMobility = PercentRoll(float(kStatProgression[I].RandMob)) ? 1 : 0;
				}
				else
				{
					statWill = kStatProgression[I].Will + Rand(class'XGTacticalGameCore'.default.iRandWillIncrease);
					statHealth = kStatProgression[I].HP;
					statOffense = kStatProgression[I].Aim;
					statDefence = kStatProgression[I].Def;
					statMobility = kStatProgression[I].Mob;
				}
			}
		}
	}
	
	if(!SOLDIER().IsOptionEnabled(4))
	{
		if(statsString > 1)
		{
			foreach PerkAim(kVal)
			{
				if(kVal.iClass == soldClass)
				{
					for(I = 0; I < 21; I++)
					{
						if(kVal.iVal[I] == pos)
						{
							SOLDIER().m_kChar.aStats[1] += kVal.iVal[I];
						}
					}
				}
			}
			foreach PerkWill(kVal)
			{
				if(kVal.iClass == soldClass)
				{
					for(I = 0; I < 21; I++)
					{
						if(kVal.iVal[I] == pos)
						{
							SOLDIER().m_kChar.aStats[1] += kVal.iVal[I];
						}
					}
				}
			}
			foreach PerkMob(kVal)
			{
				if(kVal.iClass == soldClass)
				{
					for(I = 0; I < 21; I++)
					{
						if(kVal.iVal[I] == pos)
						{
							SOLDIER().m_kChar.aStats[1] += kVal.iVal[I];
						}
					}
				}
			}
			foreach PerkCrit(kVal)
			{
				if(kVal.iClass == soldClass)
				{
					for(I = 0; I < 21; I++)
					{
						if(kVal.iVal[I] == pos)
						{
							SOLDIER().m_kChar.aStats[1] += kVal.iVal[I];
						}
					}
				}
			}
			foreach PerkDmg(kVal)
			{
				if(kVal.iClass == soldClass)
				{
					for(I = 0; I < 21; I++)
					{
						if(kVal.iVal[I] == pos)
						{
							SOLDIER().m_kChar.aStats[1] += kVal.iVal[I];
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
	LogInternal("Mob" @ statMobility, 'MercLevelupStat');
    SOLDIER().m_kChar.aStats[0] += statHealth;
    SOLDIER().m_kChar.aStats[1] += statOffense;
    SOLDIER().m_kChar.aStats[2] += statDefence;
    SOLDIER().m_kChar.aStats[3] += statMobility;
	SOLDIER().m_kChar.aStats[7] += statWill;
	LogInternal("End of MercLevelupStat");
}

function SoldGetPerkCT()
{
  	local XGStrategySoldier kSoldier;
	local TSoldTree kTree;
  	local int I;
  
  	kSoldier = m_kStratSoldier;
	
	LogInternal("MercGetPerkCT");
	
	for(I = 0; I < 7; I++)
	{
		foreach SoldTree(kTree)
		{
			if(kTree.iClass == kSoldier.m_iEnergy)
			{
				kSoldier.m_arrRandomPerks.additem(kTree.iPerk[I]);
			}
		}
	}
}

function GetRookieRandomStats()
{
	SetMinStats(MinStats);
	ASCRandomiseStats(RandStats);
}

function ASCRandomiseStats(TRandStats RandData)
{
	local int I, J, iRand, iPos, pointsused;
	local array<int> list, weight, list2, weight2;
	local XGStrategySoldier kSoldier;
	
	kSoldier = m_kStratSoldier;

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

function SetMinStats(TMinStats MinData)
{
	local XGStrategySoldier kSoldier;
	
	kSoldier = m_kStratSoldier;
	
	kSoldier.m_kChar.aStats[0] = MinData.HP;
	kSoldier.m_kChar.aStats[1] = MinData.Aim;
	kSoldier.m_kChar.aStats[2] = MinData.Def;
	kSoldier.m_kChar.aStats[3] = MinData.Mob;
	kSoldier.m_kChar.aStats[7] = MinData.Will;
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

function applyStats(optional int iStat) 
{
	local array<int> arrInt;
	
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
			intValue0(m_kTotalStats.Dmg, true);
			break;
		case 2:
			intValue0(m_kTotalStats.Aim, true);
			break;
		case 3:
			intValue0(m_kTotalStats.CritChance, true);
      		`Log("CritChance(String)=" @ intValue0());
			break;
		case 4:
			intValue0(m_kTotalStats.CritDmg, true);
			break;
		case 5:
			intValue0(m_kTotalStats.Ammo, true);
			break;
		case 6:
			intValue0(m_kTotalStats.HP, true);
			break;
		case 7:
			intValue0(int(m_kTotalStats.fDR * 10), true);
			break;
		case 8:
			intValue0(m_kTotalStats.Def, true);
			break;
		case 9:
			intValue0(m_kTotalStats.Will, true);
			break;
		case 10:
			intValue0(m_kTotalStats.Range, true);
			break;
		case 11:
			intValue0(m_kTotalStats.Mob, true);
			break;
		case 12:
			intValue0(m_kTotalStats.AoERange, true);
			break;
		default:
			arrInt.additem(m_kTotalStats.HP);
			arrInt.additem(m_kTotalStats.Aim);
			arrInt.additem(m_kTotalStats.Def);
			arrInt.additem(m_kTotalStats.Will);
			arrInt.additem(m_kTotalStats.Ammo);
			arrInt.additem(int(m_kTotalStats.fDR * 10));
			arrInt.additem(m_kTotalStats.CritChance);
			arrInt.additem(m_kTotalStats.CritDmg);
			arrInt.additem(m_kTotalStats.Dmg);
			arrInt.additem(m_kTotalStats.Range);
			arrInt.additem(m_kTotalStats.AoERange);
			arrInt.additem(m_kTotalStats.Mob);
			arrInts(arrInt);
			break;
	}
	m_kUnit = none;
	m_kStratSoldier = none;
}