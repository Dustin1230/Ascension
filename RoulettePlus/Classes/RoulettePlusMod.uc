class RoulettePlusMod extends ModBridge
	config(RoulettePlus);

	
struct TStaticPerks
{
	var string SPerk;
	var int Pos;
	var int iClass;
};

struct TSemiStatic
{
	var string SPerk;
	var int Pos;
	var int iClass;
};

struct TPerkStats
{
	var string Perk;
	var int Rank;
	var int Stats;
	var int Option;
	var int iClass;
	var int hp, mob, will, aim, def;
};

struct TPerkChance
{
	var string Perk;
	var int Rank;
	var float Chance;
	var string PerkC;
	var int iClass;
};

struct TRequiredPerk
{
	var array <string> Perk;
};

struct TAlias
{
	var string Perk;
	var array <string> Alias;
};

struct TAliasArr
{
	var array <string> Alias;
};

var array <string> arrPerk;
var array <TAliasArr> arrAlias;
var bool initdone;
var config string RPConfigVer;
var config array <TAlias> PerkAliases;
var config array <string> SniperPerks;
var config array <string> ScoutPerks;
var config array <string> RocketeerPerks;
var config array <string> GunnerPerks;
var config array <string> MedicPerks;
var config array <string> EngineerPerks;
var config array <string> AssaultPerks;	
var config array <string> InfantryPerks;
var config array <string> AllMECPerks;
var config array <string> AllBioPerks;
var config array <string> AllSoldierPerks;
var config array <string> JaegerPerks;
var config array <string> PathfinderPerks;
var config array <string> ArcherPerks;
var config array <string> GoliathPerks;
var config array <string> GuardianPerks;
var config array <string> ShogunPerks;
var config array <string> MarauderPerks;
var config array <string> ValkyriePerks;
var config array <string> IncompatiblePerks1;
var config array <string> IncompatiblePerks2;
var config array <string> ChainPerks1;
var config array <string> ChainPerks2;
var config array <string> ChoicePerks1;
var config array <string> ChoicePerks2;
var config array <string> MergePerk1;
var config array <string> MergePerk2;
var config array <int> MergePerkClass;
var config array <string> RequiredPerk1;
var config array <TRequiredPerk> RequiredPerk2;
var config array <int> RequiredPerkClass;
var config array <TStaticPerks> StaticPerks;
var config array <TSemiStatic> SemiStaticPerks;
var config array <TPerkStats> PerkStats;
var config array <TPerkChance> PerkChance;
var config bool IsMECRandom;
var config bool IsAugmentDiscounted;
var config float AugmentDiscount;
var config bool PoolPrioity;
var config string strMergePerkLabel;
var config string strMergePerkDes;
var config bool UseVanillaRolls;
var config int AmnesiaWillLossAmount;
var config int AmnesiaWillLossType;
var config string AmnesiaPerkName;
var config string AmnesiaPerkDes;
var config bool bAMedalWait;
var config bool MECxpLoss;
var config bool MECChops;
var config bool MECMedalWait;
var config bool SplitConfig;

simulated function StartMatch()
{

	local array<string> arrStr;

	if(functionName == "AssignPerks")
	{
		
	}
	
	if(functionName == "PerkStats")
	{

	}

	if(functionName == "PerkMerge")
	{

	}

	if(functionName == "AugmentDiscount")
	{
		arrStr = SplitString(functParas, "_", false);
		AugmentDiscount(int(arrStr[0]), int(arrStr[1]));
	}

	if(functionName == "AugmentRestriction")
	{
		AugmentRestriction();
	}

	if(functionName == "ModInit")
	{
		init();
	}
}


function XGSoldierUI SOLDIERUI()
{
	return XGSoldierUI(XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).GetMgr(class'XGSoldierUI',,, true));
}

function XGStrategySoldier SOLDIER()
{
	return SOLDIERUI().m_kSoldier;
}

function init()
{
	if(RPConfigVer == "")
	{
		SniperPerks = class'RoulettePlus'.default.SniperPerks;
		ScoutPerks = class'RoulettePlus'.default.ScoutPerks;
		RocketeerPerks = class'RoulettePlus'.default.RocketeerPerks;
		GunnerPerks = class'RoulettePlus'.default.GunnerPerks;
		MedicPerks = class'RoulettePlus'.default.MedicPerks;
		EngineerPerks = class'RoulettePlus'.default.EngineerPerks;
		AssaultPerks = class'RoulettePlus'.default.AssaultPerks;
		InfantryPerks = class'RoulettePlus'.default.InfantryPerks;
		AllMECPerks = class'RoulettePlus'.default.AllMECPerks;
		AllBioPerks = class'RoulettePlus'.default.AllBioPerks;
		AllSoldierPerks = class'RoulettePlus'.default.AllSoldierPerks;
		JaegerPerks = class'RoulettePlus'.default.JaegerPerks;
		PathfinderPerks = class'RoulettePlus'.default.PathfinderPerks;
		ArcherPerks = class'RoulettePlus'.default.ArcherPerks;
		GoliathPerks = class'RoulettePlus'.default.GoliathPerks;
		GuardianPerks = class'RoulettePlus'.default.GuardianPerks;
		ShogunPerks = class'RoulettePlus'.default.ShogunPerks;
		MarauderPerks = class'RoulettePlus'.default.MarauderPerks;
		ValkyriePerks = class'RoulettePlus'.default.ValkyriePerks;

		IncompatiblePerks1 = class'RoulettePlus'.default.IncompatiblePerks1;
		IncompatiblePerks2 = class'RoulettePlus'.default.IncompatiblePerks2;
		ChainPerks1 = class'RoulettePlus'.default.ChainPerks1;
		ChainPerks2 = class'RoulettePlus'.default.ChainPerks2;
		ChoicePerks1 = class'RoulettePlus'.default.ChoicePerks1;
		ChoicePerks2 = class'RoulettePlus'.default.ChoicePerks2;
		MergePerk1 = class'RoulettePlus'.default.MergePerk1;
		MergePerk2 = class'RoulettePlus'.default.MergePerk2;
		MergePerkClass = class'RoulettePlus'.default.MergePerkClass;
		RequiredPerk1 = class'RoulettePlus'.default.RequiredPerk1;
		RequiredPerk2 = class'RoulettePlus'.default.RequiredPerk2;
		RequiredPerkClass = class'RoulettePlus'.default.RequiredPerkClass;
		StaticPerks = class'RoulettePlus'.default.StaticPerks;
		SemiStaticPerks = class'RoulettePlus'.default.SemiStaticPerks;
		PerkStats = class'RoulettePlus'.default.PerkStats;
		PerkChance = class'RoulettePlus'.default.PerkChance;

		PerkAliases = class'RoulettePlus'.default.PerkAliases;
	}
	else if(SplitConfig)
	{
		SniperPerks = class'RPPools'.default.SniperPerks;
		ScoutPerks = class'RPPools'.default.ScoutPerks;
		RocketeerPerks = class'RPPools'.default.RocketeerPerks;
		GunnerPerks = class'RPPools'.default.GunnerPerks;
		MedicPerks = class'RPPools'.default.MedicPerks;
		EngineerPerks = class'RPPools'.default.EngineerPerks;
		AssaultPerks = class'RPPools'.default.AssaultPerks;
		InfantryPerks = class'RPPools'.default.InfantryPerks;
		AllMECPerks = class'RPPools'.default.AllMECPerks;
		AllBioPerks = class'RPPools'.default.AllBioPerks;
		AllSoldierPerks = class'RPPools'.default.AllSoldierPerks;
		JaegerPerks = class'RPPools'.default.JaegerPerks;
		PathfinderPerks = class'RPPools'.default.PathfinderPerks;
		ArcherPerks = class'RPPools'.default.ArcherPerks;
		GoliathPerks = class'RPPools'.default.GoliathPerks;
		GuardianPerks = class'RPPools'.default.GuardianPerks;
		ShogunPerks = class'RPPools'.default.ShogunPerks;
		MarauderPerks = class'RPPools'.default.MarauderPerks;
		ValkyriePerks = class'RPPools'.default.ValkyriePerks;

		IncompatiblePerks1 = class'RPRules'.default.IncompatiblePerks1;
		IncompatiblePerks2 = class'RPRules'.default.IncompatiblePerks2;
		ChainPerks1 = class'RPRules'.default.ChainPerks1;
		ChainPerks2 = class'RPRules'.default.ChainPerks2;
		ChoicePerks1 = class'RPRules'.default.ChoicePerks1;
		ChoicePerks2 = class'RPRules'.default.ChoicePerks2;
		MergePerk1 = class'RPRules'.default.MergePerk1;
		MergePerk2 = class'RPRules'.default.MergePerk2;
		MergePerkClass = class'RPRules'.default.MergePerkClass;
		RequiredPerk1 = class'RPRules'.default.RequiredPerk1;
		RequiredPerk2 = class'RPRules'.default.RequiredPerk2;
		RequiredPerkClass = class'RPRules'.default.RequiredPerkClass;
		StaticPerks = class'RPRules'.default.StaticPerks;
		SemiStaticPerks = class'RPRules'.default.SemiStaticPerks;
		PerkStats = class'RPRules'.default.PerkStats;
		PerkChance = class'RPRules'.default.PerkChance;

		PerkAliases = class'RPAliases'.default.PerkAliases;
	}
	
	createPerkArray();
}

function GetRandomPerk()
{

	local string Perk;
	local int I, J, K, opt, iClass;
	local EPerkType LPerk;
	local bool isMEC, bStatic;

	iClass = SOLDIER().m_iEnergy;

	SOLDIER().m_arrRandomPerks.Length = 0;

	isMEC = SOLDIER().GetClass() == 6;

	if(UseVanillaRolls)
	{
		StrValue1("UseVanillaRolls");
		return;
	}
	
	for(I=1; I<8; I++)
	{
		for(J=0; J<3; J++)
		{
			for(K=0; K<StaticPerks.Length; K++)
			{
				if( (iClass == StaticPerks[K].iClass) && (I == (StaticPerks[K].Pos + 2) / 3) )
				{
					opt = 0;
					if((StaticPerks[K].Pos + 2) % 3 == 0)
					{
						opt = 2;
					}
					if((StaticPerks[K].Pos + 2) % 3 == 1)
					{
						opt = 1;
					}
					
					if(J == opt)
					{
						Perk = StaticPerks[K].SPerk;
						bStatic = true;
						break;
					}
				}
			}

			if(!bStatic)
			{
				for(K=0; K<SemiStaticPerks.Length; K++)
				{
					if(I == (SemiStaticPerks[K].Pos + 2) / 3)
					{
						opt = 0;
						if((SemiStaticPerks[K].Pos + 2) / 3  == 0)
						{
							opt = 2;
						}
						if((SemiStaticPerks[K].Pos + 2) / 3 == 1)
						{
							opt = 1;
						}

						if(J == opt)
						{
							Perk = SemiStaticPerks[K].SPerk;
						}
					}
				}

				if(I == 1)
				{
					LPerk = 0;
					Perk = String(LPerk);
				}
				else
				{
					while(!CheckPerkRules(Perk))
					{
						Perk = GetPerkFromPool();
					}
				}
			}

			SOLDIER().m_arrRandomPerks.AddItem(SearchPerks(Perk));

		}
	}
}

function string GetPerkFromPool()
{

	local string perk;
	local int iClass;
	local bool isMEC;
	local array<string> arrPool;

	iClass = SOLDIER().m_iEnergy;
	isMEC = SOLDIER().GetClass() == 6;

	if(PoolPrioity == 2)
	{
		switch(iClass)
		{
			case 11:
				arrPool = NewPerkPool(SniperPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 21:
				arrPool = NewPerkPool(ScoutPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 12:
				arrPool = NewPerkPool(RocketeerPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 22:
				arrPool = NewPerkPool(GunnerPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 13:
				arrPool = NewPerkPool(MedicPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 23:
				arrPool = NewPerkPool(EngineerPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 14:
				arrPool = NewPerkPool(AssaultPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 24:
				arrPool = NewPerkPool(InfantryPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 31:
				arrPool = NewPerkPool(JaegerPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 41:
				arrPool = NewPerkPool(PathfinderPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 32:
				arrPool = NewPerkPool(ArcherPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 42:
				arrPool = NewPerkPool(GoliathPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 33:
				arrPool = NewPerkPool(GuardianPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 43:
				arrPool = NewPerkPool(ShogunPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 34:
				arrPool = NewPerkPool(MarauderPerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			case 44:
				arrPool = NewPerkPool(ValkyriePerks, isMEC);
				Perk = arrPool[Rand(arrPool.Length)];
				break;
			default:
				break;
		}
	
	}
	else 
	{
		if(PoolPrioity == 1)
		{
			perk = 	AllSoldierPerks[Rand(AllSoldierPerks.Length)];
			if(!CheckPerkRules(perk))
			{
				if(isMEC)
				{
					perk = AllMECPerk[Rand(AllMECPerks.Length)];
				}
				else
				{
					perk = AllBioPerks[Rand(AllBioPerks.Length)];
				}
			}
		}

		if(!CheckPerkRules(perk) || PoolPrioity == 0)
		{
			switch(iClass)
			{
				case 11:
					Perk = SniperPerks[Rand(SniperPerks.Length)];
					break;
				case 21:
					Perk = ScoutPerks[Rand(ScoutPerks.Length)];
					break;
				case 12:
					Perk = RocketeerPerks[Rand(RocketeerPerks.Length)];
					break;
				case 22:
					Perk = GunnerPerks[Rand(GunnerPerks.Length)];
					break;
				case 13:
					Perk = MedicPerks[Rand(MedicPerks.Length)];
					break;
				case 23:
					Perk = EngineerPerks[Rand(EngineerPerks.Length)];
					break;
				case 14:
					Perk = AssaultPerks[Rand(AssaultPerks.Length)];
					break;
				case 24:
					Perk = InfantryPerks[Rand(InfantryPerks.Length)];
					break;
				case 31:
					Perk = JaegerPerks[Rand(JaegerPerks.Length)];
					break;
				case 41:
					Perk = PathfinderPerks[Rand(PathfinderPerks.Length)];
					break;
				case 32:
					Perk = ArcherPerks[Rand(ArcherPerks.Length)];
					break;
				case 42:
					Perk = GoliathPerks[Rand(GoliathPerks.Length)];
					break;
				case 33:
					Perk = GuardianPerks[Rand(GuardianPerks.Length)];
					break;
				case 43:
					Perk = ShogunPerks[Rand(ShogunPerks.Length)];
					break;
				case 34:
					Perk = MarauderPerks[Rand(MarauderPerks.Length)];
					break;
				case 44:
					Perk = ValkyriePerks[Rand(ValkyriePerks.Length)];
					break;
				default:
					break;
			}
		
		}
	
		if(PoolPrioity == 0)
		{
			if(!CheckPerkRules(perk))
			{
				if(isMEC)
				{
					perk = AllMECPerks[Rand(AllMECPerks.Length)];
				}
				else
				{
					Perk = AllBioPerks[Rand(AllBioPerks.Length)];
				}
				if(!CheckPerkRules(Perk))
				{
					Perk = AllSoldierPerks[Rand(AllSoldierPerks.Length)];
				}
			}
		}	
	}
	
	Return Perk;		

}

function bool CheckPerkRules(string Perk)
{
	local int I, J, iPerk, Perk1, Perk2, iClass;
	local bool bFound;

	iPerk = SearchPerks(Perk);

	iClass = SOLDIER().m_iEnergy;

	if(Perk == string(EPerkType(0)))
	{
		return false;
	}

	if(iPerk > 255)
	{
		return false;
	}

	if(SOLDIER().m_arrRandomPerks.Find(iPerk) != -1)
	{
		return false;
	}
	if(SOLDIER().HasPerk(iPerk))
	{
		return false;
	}

	for(I=0; I<IncompatiblePerks1.Length; I++)
	{
		Perk1 = SearchPerks(IncomptiblePerks1[I]);
		Perk2 = SearchPerks(IncomptiblePerks2[I]);

		switch(Perk)
		{
			case IncompatiblePerks1[I]:
				if(SOLDIER().m_arrRandomPerks.Find(Perk2) != -1 || SOLDIER().HasPerk(Perk2))
				{
					return false;
				}
				break;
			case IncompatiblePerks2[I]:
				if(SOLDIER().m_arrRandomPerks.Find(Perk1) != -1 || SOLDIER().HasPerk(Perk1))
				{
					return false;
				}
				break;
			default:
				break;
		}

		for(I=0; ChainPerks1.Length; I++)
		{
			Perk1 = SearchPerks(ChainPerks1[I]);
			Perk2 = SearchPerks(ChainPerks2[I]);

			switch(SOLDIER().m_arrRandomPerks.Length % 3)
			{
				case 1:
					if(Perk == ChainPerks1[I] && Perk2 == SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-1])
					{
						return false;
					}
					if(Perk == ChainPerks2[I] && Perk1 == SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-1])
					{
						return false;
					}
					break;
				case 2:
					if(Perk == ChainPerk1[I] && ( Perk1 == SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-1] || Perk2 == SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-2] ))
					{
						return false;
					}
					if(Perk == ChainPerk2[I] && ( Perk1 == SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-1] || Perk1 == SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-2] ))
					{
						return false;
					}
					break;
				default:
					break;
			}
		}


		for(I=0; I<StaticPerks.Length; I++)
		{
			if(SOLDIER().m_iEnergy == StaticPerks[I].iClass && Perk == StaticPerks[I].SPerk)
			{
				return false;
			}
		}

		for(I=0; I<PerkChance.Length; I++)
		{
			if( (PerkChance[I].PerkC == string(0) || PerkChance[I].PerkC == Perk) && (
				(PerkChance[I].iClass == -1 || PerkChance[I].iClass == iClass) ) && (
				(PerkChance[I].Rank == -1 || PerkChance[I].Rank == (SOLDIER().m_arrRandomPerks.Length + 3) / 3) ) && (
				PercentRoll(PerkChance[I].chance) ))
			{
				return false;
			}
		}

		for(I=0; ChoicePerks1.Length; I++)
		{
			Perk1 = SearchPerks(ChoicePerks[I]);

			if(Perk == ChoicePerks1[I] && SOLDIER().m_arrRandomPerks(Perk2) != -1)
			{
				switch(SOLDIER().m_arrRandomPerks.Length % 3)
				{
					case 0:
						return false;
						break;
					case 1:
						if(Perk2 != SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-1])
						{
							return false;
						}
						break;
					case 2:
						if(Perk2 != SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-1] && Perk2 != SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks.Length-2])
						{
							return false;
						}
						break;
					default:
						break;
				}
			}
			if(Perk == ChoicePerks2[I] && SOLDIER().m_arrRandomPerks.Find(Perk1) != -1)
			{
				switch(SOLDIER().m_arrRandomPerks.Length % 3)
				{
					case 0:
						return false;
						break;
					case 1:
						if(Perk1 != SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks-1])
						{
							return false;
						}
						break;
					case 2:
						if(Perk1 != SOLDIER().m_arrRandomPerks[SOLDIER().m_arrRandomPerks-1] && Perk1 != SOLDIER().m_arrRandomPerks[SOLDIER.m_arrRandomPerks.Length-2])
						{
							return false;
						}
						break;
					default:
						break;
				}
			}

		}

		for(I=0; I<RequiredPerk1.Length; I++)
		{
			Perk1 = SearchPerks(RequiredPerk1[I]);
			bFound = false;
			if(arrPerk.Find(RequiredPerk1[I]) != -1)
			{
				for(J=0; J<RequiredPerk2[I].Perk.Length; J++)
				{
					Perk2 = SearchPerks(RequiredPerk2[I].Perk[J]);

					if(!SOLDIER().m_arrRandomPerks.Find(Perk2) && SOLDIER().m_arrRandomPerks.Find(Perk2) != -1 && ( ((SOLDIER().m_arrRandomPerks.Find(Perk2) + 3) / 3 != (SOLDIER().m_arrRandomPerks.Length + 3) / 3) ))
					{
						bFound = true;
						break;
					}

				}

				if(!bFound)
				{
					 return false;
				}
			}
		}

		for(I=0; MergePerk1.Length; I++)
		{
			Perk1 = SearchPerks(MergePerk1[I]);
			Perk2 = SearchPerks(MergePerk2[I]);

			if( (MergePerkClass[I] == iClass) && (Perk == MergePerk2[I]) && ( (SOLDIER().m_arrRandomPerks.Find(Perk1) != -1) || (SOLDIER().HasPerk(Perk1)) ))
			{
				return false;
			}
		}

	}

	return true;

}

function int SearchPerks(string sPerk)
{

	local TAlias lAlias;

	if(arrPerk.Find(sPerk) != -1)
	{
		return arrPerk.Find(sPerk);
	}
	else
	{
		foreach arrAlias(lAlias)
		{
			if(lAlias.Alias.Find(sPerk) != -1)
			{
				return lAlias.Alias.Find(sPerk);
			}
		}
	}
}

function array<string> NewPerkPool(array<string> OldPerkPool, bool isMEC)
{

	local array<string> NewPerkPool, AppendedPool;
	local int i;

	for(i=0; i<OldPerkPool.Length; i++)
	{
		AppendedPool.AddItem(OldPerkPool[i]);
	}

	for(i=0; i<AllSoldierPerks.Length; i++)
	{
		AppendedPool.AddItem(AllSoldierPerk[i]);
	}

	if(isMEC)
	{
		for(i=0; i<AllMECPerks.Length; i++)
		{
			AppendedPool.AddItem(AllMECPerks[i]);
		}
	}
	else
	{
		for(i=0; i<AllBioPerks.Length; i++)
		{
			AppendedPool.AddItem(AllBioPerks[i]);
		}
	}

	NewPerkPool.Add(AppendedPool.Length);
	for(i=0; i<OldPerkPool.Length; i++)
	{
		NewPerkPool.InsertItem(Rand(AppendedPool.Length), AppendedPool[i]);
		NewPerkPool.RemoveItem("");
	}
	
	for(i=0; i<NewPerkPool.Length; i++)
	{
		if(NewPerkPool[i] == "")
		{
			NewPerkPool.Remove(i, 1);
		}
	}

	return NewPerkPool;

}

function OldPerkStats(int Pos)
{

	local ESoldierClass iClass;
	local int I, opt, will, hp, mob, def, aim, perk, hpmob, PerkS;
	local XComPerkManager kPerkMan;
	local string mPerk;
	local bool isRank1;
	local TPerkStats lPerkS;
	local object perktree;

	perktree = SOLDIER().m_arrRandomPerks;

	kPerkMan = SOLDIER().PERKS();

	/** 
	for(I=0; I<SOLDIER().m_arrRandomPerks.Length; I++)
	{
		`Log("RandomPerks=" @ string(SOLDIER().m_arrRandomPerks[I]));
	}
	*/

	isRank1 = ((pos + 2) / 3) == 1;
	  
	foreach MergePerk1(mPerk, I)
	{
		perk = SearchPerks(mPerk);

		if( (isRank1 && kPerkMan.GetPerkInTree(SOLDIER.GetClass(), 1, (pos - 1)) == perk) || ( (MergePerkClass[I] == -1 || MergePerkClass[I] == SOLDIER().m_iEnergy) && SOLDIER().m_arrRandomPerks[Pos-1] == perk ) )
		{
			SOLDIER().m_arrRandomPerks[2] = 100;
			SOLDIER().m_arrRandomPerks[21] = SearchPerks(MergePerk2[I]);	
		}
		else
		{
			SOLDIER().m_arrRandomPerks[2] = 0;
			SOLDIER().m_arrRandomPerks[21] = 0;
		}
	}

	opt = (((Pos + 2) % 3) + 1);
	if(opt == 1)
	{
		opt = 3;
	}
	else if(opt == 3)
	{
		opt = 1;
	}

	if(isRank1 && SOLDIER().GetClass() != 6)
	{
		iClass = SOLDIER().GetClass();
	}
	else
	{
		iClass = SOLDIER().m_iEnergy;
	}

	foreach PerkStats(lPerkS)
	{
		mob = 0;
		will = 0;
		hp = 0;
		def = 0;
		aim = 0;
		hpmob = 0;

		if(lPerkS.Stats > 0)
		{
			if(lPerkS.Stats / 100 == 1)
			{
				mob = 1;
			}
			if(lPerkS.Stats / 100 == 2)
			{
				mob = -1;
			}
			aim = (lPerkS.Stats % 100) / 10;
			will = lPerkS.Stats % 10;
		}
		else
		{
			if(10 > lPerkS.aim && lPerkS.aim > 0)
			{
				aim = lPerkS.aim;
			}

			if(10 > lPerkS.will && lPerkS.will > 0)
			{
				will = lPerkS.will;
			}

			if(2 > lPerkS.mob && lPerkS.mob > -2)
			{
				mob = lPerkS.mob;
			}
		}

		if(2 > lPerkS.hp && lPerkS.hp > -2)
		{
			hp = lPerkS.hp;
		}

		if(6 > lPerkS.def && lPerkS.def > -5)
		{
			def = lPerkS.def;
		}

		if((hp == 0) && (mob == 1))
		{
			hpmob = 1;
		}
		if((hp == 1) && (mob == 0))
		{
			hpmob = 2;
		}
		if((hp == 1) && (mob == 1))
		{
			hpmob = 3;
		}
		if((hp == -1) && (mob == 1))
		{
			hpmob = 4;
		}
		if((hp == 1) && (mob == -1))
		{
			hpmob = 5;
		}
		if((hp == 0) && (mob == -1))
		{
			hpmob = 6;
		}
		if((hp == -1) && (mob == 0))
		{
			hpmob = 7;
		}
		if((hp == -1) && (mob == -1))
		{
			hpmob = 8;
		}

		if(def < 0)
		{
			def += 5;
		}
		else if(def > 0)
		{
			def += 4;
		}

		
		if( (lPerkS.Option == opt) && (
			(isRank1) && (SOLDIER().GetClass() == lPerkS.iClass) && (lPerkS.Rank == 1) || (
			(lPerkS.Option != -1) && (lPerkS.Rank == (Pos + 2) / 3) ) ) )
		{
			OldAddstats(aim, will, hpmob, def);
		}
		else if( (lPerkS.Rank == (Pos + 2) / 3) && ( (lPerkS.iClass == -1) || (lPerkS.iClass == iClass) ) )
		{
			PerkS = SearchPerks(lPerkS.Perk);

			if(SOLDIER().m_arrRandomPerks[pos-1] == PerkS)
			{
				Oldaddstats(aim, will, hpmob, def);
			}

		}
		else
		{
			OldAddstats(0, 0, 0, 0);
		}

	}
			

}

function OldAddstats(int aim, int will, int hpmob, int def)
{
	if(SOLDIER().m_arrRandomPerks[2] / 100 == 1)
	{
		SOLDIER().m_arrRandomPerks[2] = 100 + (aim * 10) + will;
	}
	else
	{
		SOLDIER().m_arrRandomPerks[2] = (aim * 10) + will;
	}

	if(SOLDIER().m_arrRandomPerks[1] / 100 == 1)
	{
		SOLDIER().m_arrRandomPerks[1] = 100 + (hpmob * 10) + def;
	}
	else
	{
		SOLDIER().m_arrRandomPerks[1] = (hpmob * 10) + def;
	}
}

function PerkMerge(int Perk)
{

	local int I, Perk1, Perk2;
	local string mPerk;

	if(SOLDIER().HasPerk(Perk))
	{
		foreach MergePerk1(mPerk, I)
		{
			Perk1 = SearchPerks(mPerk);
			Perk1 = SearchPerks(MergePerk2[I]);

			if( ( (MergePerkClass[I] == -1) || (MergePerkClass[I] == SOLDIER.m_iEnergy) ) || (SOLDIERUI().GetAbilityTreeBranch() == 1) )
			{
				if(Perk1 == Perk)
				{
					SOLDIER().GivePerk(Perk2);
				}
			}



		}

	}

}

function AugmentDiscount(int cashcost, int meldcost)
{
	if(IsAugmentDiscounted)
	{
		IntValue0(cashcost * (AugmentDiscount / 100.00), true);
		IntValue1(meldcost * (AugmentDiscount / 100.00), true);
	}
	else
	{
		IntValue0(cashcost, true);
		IntValue1(meldcost, true);
	}
}

function createPerkArray()
{
	local int I, J, IAlias;
	local EPerkType EPerk;

	for(I=0; I<172; I++)
	{
		EPerk = EPerkType(I);
		arrPerk.AddItem(string(EPerk));
	}

	IAlias = 0;
	for(I=0; I<PerkAliases.Length; I++)
	{
		if(IAlias < PerkAliases[I].Alias.Length)
		{
			IAlias = PerkAliases[I].Alias.Length;
		}
	}

	arrAlias.add(IAlias);

	for(I=0; I<IAlias; I++)
	{
		arrAlias[I].Alias.add(255);
	}

	for(I=0; I<PerkAliases.Length; I++)
	{
		for(J=0; J<PerkAliases[I].Alias.Length; J++)
		{
			if(int(PerkAliases[I].Perk) > 0)
			{
				arrAlias[J].Alias[int(PerkAliases[I].Perk)] = PerkAliases[I].Alias[J];
			}
			else
			{
				if(arrPerk.Find(PerkAliases[I].Perk) != -1)
				{
					arrAlias[J].Alias[arrPerk.Find(PerkAliases[I].Perk)] = PerkAliases[I].Alias[J];
				}
			}
		}
	}
}

function AugmentRestriction()
{
	if(MECxpLoss)
	{
		StrValue0("true");
	}
	else
	{
		StrValue0("false");
	}

	if(MECChops)
	{
		StrValue1("true");
	}
	else
	{
		StrValue1("false");
	}

	if(MECMedalWait)
	{
		StrValue2("true");
	}
	else
	{
		StrValue2("false");
	}
}		

DefaultProperties
{
}
