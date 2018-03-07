class RoulettePlusMod extends XComMod Within ModBridge
	DependsOn(RoulettePlus)
	DependsOn(RPCheckpoint)
	config(RoulettePlus);


var array <string> arrPerk;
var array <TAliasArr> arrAlias;
var config float RPConfigVer;
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
var config int PoolPrioity;
var config string strMergePerkLabel;
var config string strMergePerkDes;
var config bool UseVanillaRolls;
var config bool MECxpLoss;
var config bool MECChops;
var config bool MECMedalWait;
var config bool SplitConfig;
var RPPerksMod m_kRPPerksMod;
var RPCheckPoint m_kRPCheckpoint;
var XGStrategySoldier m_kSold;


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


simulated function StartMatch()
{

	local array<string> arrStr;

	if(functionName == "AssignRandomPerks_Overwrite")
	{
		GetSoldier(StrValue0());
		if(UseVanillaRolls)
			VanRandPerks();
		else
			GetRandomPerks();
	}
	
	if(functionName == "PerkStats")
	{
		if(isSoldierNewType(SOLDIER()))
		{
			NewPerkStats(int(functParas));
		}
		else
		{
			OldPerkStats(int(functParas));
		}
	}

	if(functionName == "PerkMerge")
	{
		PerkMerge(int(functParas));
	}

	if(functionName == "AugmentDiscount")
	{
		arrStr = SplitString(functParas, "_", false);
		applyAugmentDiscount(int(arrStr[0]), int(arrStr[1]));
	}

	if(functionName == "AugmentRestriction")
	{
		AugmentRestriction();
	}

	if(functionName == "SetSoldier")
	{
		GetSoldier(functparas);
	}

	if(functionName == "ModInit")
	{
		init();
	}

	m_kRPPerksMod.StartMatch();

}

function init()
{
	local bool CC, MRA;

	ChooseConfig();

	m_kRPCheckpoint = WORLDINFO().Spawn(class'RPCheckpoint', PLAYERCONTROLLER());
	m_kRPPerksMod = new (outer) class'RPPerksMod';
	
	MRA = ModRecordActor("Transport", class'RPCheckpoint');
	
	createPerkArray();

	CC = CheckConfig();

	if(CC)
	{
		ModInitError = "Config has major error";
	}
	if(m_kRPCheckpoint == none)
	{
		if(ModInitError != "")
			ModInitError $= ", ";

		ModInitError $= "Checkpoint class not initalised";
	}
	if(m_kRPPerksMod == none)
	{
		if(ModInitError != "")
			ModInitError $= ", ";

		ModInitError $= "PerkMod class not initalised";
	}
	if(arrPerk.Length == 0)
	{
		if(ModInitError != "")
			ModInitError $= ", ";

		ModInitError $= "Perk array not initalised";
	}
	if(arrAlias.Length == 0)
	{
		if(ModInitError != "")
			ModInitError $= ", ";

		ModInitError $= "Alias array not initalised";
	}
	if(!MRA)
	{
		if(ModInitError != "")
			ModInitError $= ", ";

		ModInitError $= "adding Checkpoint class to CheckpointRecord failed";
	}
	if(ModInitError != "")
		ModInitError $= ".";
}

function ChooseConfig()
{

	if(RPConfigVer < 2.0)
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
		RequiredPerk1 = class'RoulettePlus'.default.RequiredPerk1;
		RequiredPerk2 = class'RoulettePlus'.default.RequiredPerk2;
		RequiredPerkClass = class'RoulettePlus'.default.RequiredPerkClass;
		StaticPerks = class'RoulettePlus'.default.StaticPerks;
		SemiStaticPerks = class'RoulettePlus'.default.SemiStaticPerks;
		PerkChance = class'RoulettePlus'.default.PerkChance;

		PerkAliases = class'RoulettePlus'.default.PerkAliases;
		PerkStats = class'RoulettePlus'.default.PerkStats;
		MergePerk1 = class'RoulettePlus'.default.MergePerk1;
		MergePerk2 = class'RoulettePlus'.default.MergePerk2;
		MergePerkClass = class'RoulettePlus'.default.MergePerkClass;
		
		IsMECRandom = class'RoulettePlus'.default.IsMECRandom;
		IsAugmentDiscounted = class'RoulettePlus'.default.IsAugmentDiscounted;
		AugmentDiscount = class'RoulettePlus'.default.AugmentDiscount;
		PoolPrioity = class'RoulettePlus'.default.PoolPrioity;
		strMergePerkLabel = class'RoulettePlus'.default.strMergePerkLabel;
		strMergePerkDes = class'RoulettePlus'.default.strMergePerkDes;
		UseVanillaRolls = class'RoulettePlus'.default.UseVanillaRolls;
		MECxpLoss = class'RoulettePlus'.default.MECxpLoss;
		MECChops = class'RoulettePlus'.default.MECChops;
		MECMedalWait = class'RoulettePlus'.default.MECMedalWait;

		
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
		RequiredPerk1 = class'RPRules'.default.RequiredPerk1;
		RequiredPerk2 = class'RPRules'.default.RequiredPerk2;
		RequiredPerkClass = class'RPRules'.default.RequiredPerkClass;
		StaticPerks = class'RPRules'.default.StaticPerks;
		SemiStaticPerks = class'RPRules'.default.SemiStaticPerks;
		PerkChance = class'RPRules'.default.PerkChance;

		PerkAliases = class'RPMisc'.default.PerkAliases;
		PerkStats = class'RPMisc'.default.PerkStats;
		MergePerk1 = class'RPMisc'.default.MergePerk1;
		MergePerk2 = class'RPMisc'.default.MergePerk2;
		MergePerkClass = class'RPMisc'.default.MergePerkClass;
	}
}

function bool CheckConfig()
{
	local int biopools, otherpools, rules, misc, settings;
	local TStaticPerks blankstatic;
	local TSemiStatic blanksemi;
	local TPerkChance blankchance;
	local TAlias blankalias;
	local TPerkStats blankstats;

	if(SniperPerks[0] == "")
		++ biopools;

	if(ScoutPerks[0] == "")
		++ biopools;
	
	if(RocketeerPerks[0] == "")
		++ biopools;

	if(GunnerPerks[0] == "")
		++ biopools;

	if(MedicPerks[0] == "")
		++ biopools;

	if(EngineerPerks[0] == "")
		++ biopools;

	if(AssaultPerks[0] == "")
		++ biopools;

	if(InfantryPerks[0] == "")
		++ biopools;

	if(AllMECPerks[0] == "")
		++ otherpools;

	if(AllBioPerks[0] == "")
		++ otherpools;

	if(AllSoldierPerks[0] == "")
		++ otherpools;

	if(JaegerPerks[0] == "")
		++ otherpools;

	if(PathfinderPerks[0] == "")
		++ otherpools;

	if(ArcherPerks[0] == "")
		++ otherpools;

	if(GoliathPerks[0] == "")
		++ otherpools;

	if(GuardianPerks[0] == "")
		++ otherpools;

	if(ShogunPerks[0] == "")
		++ otherpools;

	if(MarauderPerks[0] == "")
		++ otherpools;

	if(ValkyriePerks[0] == "")
		++ otherpools;




	if(IncompatiblePerks1[0] == "")
		++ rules;

	if(ChainPerks1[0] == "")
		++ rules;

	if(ChoicePerks1[0] == "")
		++ rules;

	if(RequiredPerk1[0] == "")
		++ rules;

	if(StaticPerks[0] == blankstatic)
		++ rules;

	if(SemiStaticPerks[0] == blanksemi)
		++ rules;

	if(PerkChance[0] == blankchance)
		++ rules;



	if(PerkAliases[0] == blankalias)
		++ misc;

	if(PerkStats[0] == blankstats)
		++ misc;

	if(MergePerk1[0] == "")
		++ misc;



	if(!IsMECRandom)
		++ settings;

	if(!IsAugmentDiscounted)
		++ settings;

	if(!UseVanillaRolls)
		++ settings;

	if(!MECxpLoss)
		++ settings;

	if(!MECChops)
		++ settings;

	if(!MECMedalWait)
		++ settings;

	if(!SplitConfig)
		++ settings;

	if(PoolPrioity == 0)
		++ settings;




	if(strMergePerkLabel == "" && strMergePerkDes == "")
	{
		ModError("Strings for MergePerk display not found");
		if(settings == 8)
			ModError("No settings have been found in config");
	}
	else if(strMergePerkLabel == "")
	{
		ModError("String for MergePerk label not found");
	}
	else if(strMergePerkDes == "")
	{
		ModError("String for merged perk description label not found");
	}
	else if(settings == 8)
		ModError("No settings seem to have been set in config");



	if(misc == 3)
		ModError("No misc found in config");


	if(rules == 7)
	{
		ModError("No rules found in config");
	}
	else if(rules > 2)
		ModError("Some rules are missing in config");


	if(otherpools == 11)
		ModError("No secondary perk pools found in config");


	if(biopools == 8)
	{
		if(AllBioPerks[0] == "" && AllSoldierPerks[0] == "")
			ModError("All main perk pools and both main encompassing pools missing in config");
		else
			ModError("No main perk pools found in config");
	}
	else if(biopools > 0)
	{
		if(AllBioPerks[0] == "" && AllSoldierPerks[0] == "")
			ModError(string(biopools) @ "main perk pools and both main encompassing pools missing in config");

		else
			ModError(string(biopools) @ "main perk pools missing in config");
	}

	if(biopools > 0 && otherpools > 10)
		return true;


	return false;

}





function VanRandPerks()
{
	
}	

function GetRandomPerks()
{

	local string Perk;
	local int I, J, K, opt, iClass;
	local bool isMEC, bStatic;
	local XGStrategySoldier kSold;

	if(m_kSold != none)
	{
		kSold = m_kSold;
	}
	else
	{
		kSold = SOLDIER();
	}

	iClass = kSold.m_iEnergy;

	kSold.m_arrRandomPerks.Length = 0;

	isMEC = kSold.GetClass() == 6;

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
						if((SemiStaticPerks[K].Pos + 2) / 3 == 0)
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
					Perk = String(EPerkType(0));
				}
				else
				{
					while(!CheckPerkRules(Perk))
					{
						Perk = GetPerkFromPool();
					}
				}
			}


			addPerkToTree(kSold, SearchPerks(Perk));
			//kSold.m_arrRandomPerks.AddItem(SearchPerks(Perk));

		}
	}
	CreatePerkStats();
	
	m_kSold = none;
}

function string GetPerkFromPool()
{

	local string perk;
	local int iClass;
	local bool isMEC;
	local array<string> arrPool;
	local XGStrategySoldier kSold;

	if(m_kSold != none)
	{
		kSold = m_kSold;
	}
	else
	{
		kSold = SOLDIER();
	}

	iClass = kSold.m_iEnergy;
	isMEC = kSold.GetClass() == 6;

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
					perk = AllMECPerks[Rand(AllMECPerks.Length)];
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
	local array<int> PerkTree;
	local XGStrategySoldier kSold;

	if(m_kSold != none)
	{
		kSold = m_kSold;
	}
	else
	{
		kSold = SOLDIER();
	}

	iPerk = SearchPerks(Perk);

	iClass = kSold.m_iEnergy;

	if(isSoldierNewType(kSold))
	{
		PerkTree = NewRandomTree(kSold, -1);
	}
	else
	{
		PerkTree = OldPerkTree(kSold);
	}

	if(Perk == string(EPerkType(0)))
	{
		return false;
	}

	if(iPerk > 255)
	{
		return false;
	}

	if(PerkTree.Find(iPerk) != -1)
	{
		return false;
	}
	if(kSold.HasPerk(iPerk))
	{
		return false;
	}

	for(I=0; I<IncompatiblePerks1.Length; I++)
	{
		Perk1 = SearchPerks(IncompatiblePerks1[I]);
		Perk2 = SearchPerks(IncompatiblePerks2[I]);

		switch(Perk)
		{
			case IncompatiblePerks1[I]:
				if(PerkTree.Find(Perk2) != -1 || kSold.HasPerk(Perk2))
				{
					return false;
				}
				break;
			case IncompatiblePerks2[I]:
				if(PerkTree.Find(Perk1) != -1 || kSold.HasPerk(Perk1))
				{
					return false;
				}
				break;
			default:
				break;
		}

		for(I=0; I<ChainPerks1.Length; I++)
		{
			Perk1 = SearchPerks(ChainPerks1[I]);
			Perk2 = SearchPerks(ChainPerks2[I]);

			switch(PerkTree.Length % 3)
			{
				case 1:
					if(Perk == ChainPerks1[I] && Perk2 == PerkTree[PerkTree.Length-1])
					{
						return false;
					}
					if(Perk == ChainPerks2[I] && Perk1 == PerkTree[PerkTree.Length-1])
					{
						return false;
					}
					break;
				case 2:
					if(Perk == ChainPerks1[I] && ( Perk1 == PerkTree[PerkTree.Length-1] || Perk2 == PerkTree[PerkTree.Length-2] ))
					{
						return false;
					}
					if(Perk == ChainPerks2[I] && ( Perk1 == PerkTree[PerkTree.Length-1] || Perk1 == PerkTree[PerkTree.Length-2] ))
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
			if(kSold.m_iEnergy == StaticPerks[I].iClass && Perk == StaticPerks[I].SPerk)
			{
				return false;
			}
		}

		for(I=0; I<PerkChance.Length; I++)
		{
			if( (PerkChance[I].PerkC == string(0) || PerkChance[I].PerkC == Perk) && (
				(PerkChance[I].iClass == -1 || PerkChance[I].iClass == iClass) ) && (
				(PerkChance[I].Rank == -1 || PerkChance[I].Rank == (PerkTree.Length + 3) / 3) ) && (
				PercentRoll(PerkChance[I].chance) ))
			{
				return false;
			}
		}
		for(I=0; I<ChoicePerks1.Length; I++)
		{
			Perk1 = SearchPerks(ChoicePerks1[I]);

			if(Perk == ChoicePerks1[I] && PerkTree.Find(Perk2) != -1)
			{
				switch(PerkTree.Length % 3)
				{
					case 0:
						return false;
						break;
					case 1:
						if(Perk2 != PerkTree[PerkTree.Length-1])
						{
							return false;
						}
						break;
					case 2:
						if(Perk2 != PerkTree[PerkTree.Length-1] && Perk2 != PerkTree[PerkTree.Length-2])
						{
							return false;
						}
						break;
					default:
						break;
				}
			}
			if(Perk == ChoicePerks2[I] && PerkTree.Find(Perk1) != -1)
			{
				switch(PerkTree.Length % 3)
				{
					case 0:
						return false;
						break;
					case 1:
						if(Perk1 != PerkTree[PerkTree.Length-1])
						{
							return false;
						}
						break;
					case 2:
						if(Perk1 != PerkTree[PerkTree.Length-1] && Perk1 != PerkTree[PerkTree.Length-2])
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

					if(!SOLDIER().HasPerk(Perk2) && PerkTree.Find(Perk2) != -1 && ( ((PerkTree.Find(Perk2) + 3) / 3 != (PerkTree.Length + 3) / 3) ))
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

		for(I=0; I<MergePerk1.Length; I++)
		{
			Perk1 = SearchPerks(MergePerk1[I]);
			Perk2 = SearchPerks(MergePerk2[I]);

			if( (MergePerkClass[I] == iClass) && (Perk == MergePerk2[I]) && ( (PerkTree.Find(Perk1) != -1) || (kSold.HasPerk(Perk1)) ))
			{
				return false;
			}
		}

	}

	return true;

}

function int SearchPerks(string sPerk)
{

	local TAliasArr lAlias;

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
		AppendedPool.AddItem(AllSoldierPerks[i]);
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

function CreatePerkStats()
{

	local int opt, PerkS, iClass, Pos, mPerk, I;	
	local string sPerk;
	local bool isRank1;
	local TPerkStats lPerkS;
	local array<int> perktree;
	local XGStrategySoldier kSold;
	local TStatStorage Stats;

	if(m_kSold != none)
	{
		kSold = m_kSold;
	}
	else
	{
		kSold = SOLDIER();
	}

	perktree = NewRandomTree(kSold, -1);

	foreach PerkStats(lPerkS)
	{

		for(Pos=0; Pos<21; Pos++)
		{
			opt = (((Pos + 2) % 3) + 1);
			if(opt == 1)
			{
				opt = 3;
			}
			else if(opt == 3)
			{
				opt = 1;
			}

			isRank1 = ((pos + 2) / 3) == 1;

			if(isRank1 && kSold.GetClass() != 6)
			{
				iClass = kSold.GetClass();
			}
			else
			{
				iClass = kSold.m_iEnergy;
			}

			foreach MergePerk1(sPerk, I)
			{
				mPerk = 0;
				if(SearchPerks(sPerk) == perktree[pos-1])
				{
					if(MergePerkClass[I] == -1 || MergePerkClass[I] == iClass)
					{
						mPerk = SearchPerks(MergePerk2[I]);
						break;
					}
				}
			}
					

			PerkS = -1;
			if( (lPerkS.Rank == (Pos + 2) / 3) && ( (lPerkS.iClass == -1) || (lPerkS.iClass == iClass) ) )
			{
				PerkS = SearchPerks(lPerkS.Perk);
			}

			if( (lPerkS.Option == opt) && (
				(isRank1) && (kSold.GetClass() == lPerkS.iClass) && (lPerkS.Rank == 1) || (
				lPerkS.Rank == (Pos + 2) / 3 ) ) )
			{
				Stats = MakePerkStats(lPerkS.hp, lPerkS.aim, lPerkS.def, lPerkS.mob, lPerkS.will, mPerk);
				addPerkStats(kSold, Stats);
			}
			else if( PerkS > -1 && perktree[pos-1] == PerkS)
			{
				Stats = MakePerkStats(lPerkS.hp, lPerkS.aim, lPerkS.def, lPerkS.mob, lPerkS.will, mPerk);
				addPerkStats(kSold, Stats);
			}
			else
			{
				Stats = MakePerkStats(0, 0, 0, 0, 0, mPerk);
				addPerkStats(kSold, Stats);
			}

		}
	}

}

function NewPerkStats(int Pos)
{
	
	local TStatStorage PStats;
	local XGStrategySoldier kSold;

	if(m_kSold != none)
	{
		kSold = m_kSold;
	}
	else
	{
		kSold = SOLDIER();
	}


	PStats = GetPerkStats(kSold, Pos);

	kSold.m_kChar.aStats[eStat_HP] += PStats.HP;
	kSold.m_kChar.aStats[eStat_Offense] += PStats.aim;
	kSold.m_kChar.aStats[eStat_Defense] += PStats.def;
	kSold.m_kChar.aStats[eStat_Will] += PStats.aim;
	kSold.m_kChar.aStats[eStat_Mobility] += PStats.mob;


	m_kSold = none;

}

function array<int> OldPerkTree(XGStrategySoldier Sold)
{

	local int I;
	local array<int> arrInts;

	for(I=0; I<Sold.m_arrRandomPerks.Length; I++)
	{
		arrInts.AddItem(Sold.m_arrRandomPerks[I]);
	}
	return arrInts;
}

function OldPerkStats(int Pos)
{
	
	local int I, opt, will, hp, mob, def, aim, perk, hpmob, PerkS, iClass;
	local XComPerkManager kPerkMan;
	local string mPerk;
	local bool isRank1;
	local TPerkStats lPerkS;
	local array<int> perktree;
	local XGStrategySoldier kSold;

	if(m_kSold != none)
	{
		kSold = m_kSold;
	}
	else
	{
		kSold = SOLDIER();
	}

	perktree = OldPerkTree(kSold);

	kPerkMan = kSold.PERKS();

	/** 
	for(I=0; I<kSold.m_arrRandomPerks.Length; I++)
	{
		`Log("RandomPerks=" @ string(kSold.m_arrRandomPerks[I]));
	}
	*/

	isRank1 = ((pos + 2) / 3) == 1;
	  
	foreach MergePerk1(mPerk, I)
	{
		perk = SearchPerks(mPerk);

		if( (isRank1 && kPerkMan.GetPerkInTree(SOLDIER().GetClass(), 1, (pos - 1)) == perk) || ( (MergePerkClass[I] == -1 || MergePerkClass[I] == kSold.m_iEnergy) && kSold.m_arrRandomPerks[Pos-1] == perk ) )
		{
			kSold.m_arrRandomPerks[2] = 100;
			kSold.m_arrRandomPerks[21] = EPerkType(SearchPerks(MergePerk2[I]));	
		}
		else
		{
			kSold.m_arrRandomPerks[2] = 0;
			kSold.m_arrRandomPerks[21] = 0;
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

	if(isRank1 && kSold.GetClass() != 6)
	{
		iClass = kSold.GetClass();
	}
	else
	{
		iClass = kSold.m_iEnergy;
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
			(isRank1) && (kSold.GetClass() == lPerkS.iClass) && (lPerkS.Rank == 1) || (
			(lPerkS.Option != -1) && (lPerkS.Rank == (Pos + 2) / 3) ) ) )
		{
			OldAddstats(aim, will, hpmob, def);
		}
		else if( (lPerkS.Rank == (Pos + 2) / 3) && ( (lPerkS.iClass == -1) || (lPerkS.iClass == iClass) ) )
		{
			PerkS = SearchPerks(lPerkS.Perk);

			if(perktree[pos-1] == PerkS)
			{
				OldAddstats(aim, will, hpmob, def);
			}

		}
		else
		{
			OldAddstats(0, 0, 0, 0);
		}

	}
	
	m_kSold = none;

}

function OldAddstats(int aim, int will, int hpmob, int def)
{

	local XGStrategySoldier kSold;

	if(m_kSold != none)
	{
		kSold = m_kSold;
	}
	else
	{
		kSold = SOLDIER();
	}

	if(kSold.m_arrRandomPerks[2] / 100 == 1)
	{
		kSold.m_arrRandomPerks[2] = EPerkType(100 + (aim * 10) + will);
	}
	else
	{
		kSold.m_arrRandomPerks[2] = EPerkType((aim * 10) + will);
	}

	if(kSold.m_arrRandomPerks[1] / 100 == 1)
	{
		kSold.m_arrRandomPerks[1] = EPerkType(100 + (hpmob * 10) + def);
	}
	else
	{
		kSold.m_arrRandomPerks[1] = EPerkType((hpmob * 10) + def);
	}
}

function int FindSoldierInStorage(int SoldierID)
{
	
	local TSoldierStorage SoldStor;
	local int I;

	foreach m_kRPCheckpoint.arrSoldierStorage(SoldStor, I)
	{
		if(SoldStor.SoldierID == SoldierID)
		{
			return I;
		}
	}
}

function bool isSoldierNewType(XGStrategySoldier Soldier)
{
	return m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(Soldier.m_kSoldier.iID)].isNewType;
}

function array<int> NewRandomTree(XGStrategySoldier kSold, int position, optional int value)
{

	local array<int> arrInts;

	if(position == -2)
	{
		arrInts[0] = m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(kSold.m_kSoldier.iID)].RandomTree.Length;
		return arrInts;
	}
	else if(position == -1)
	{
		return m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(kSold.m_kSoldier.iID)].RandomTree;
	}
	else
	{
		m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(kSold.m_kSoldier.iID)].RandomTree[position] = value;
		return returnvalue;
	}
}

function TStatStorage GetPerkStats(XGStrategySoldier kSold, int index)
{
	return m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(kSold.m_kSoldier.iID)].StatStorage[index];
}

function TStatStorage MakePerkStats(int HP, int aim, int def, int mob, int will, int mPerk)
{
	
	local TStatStorage stats;

	stats.HP = HP;
	stats.aim = aim;
	stats.def = def;
	stats.mob = mob;
	stats.will = will;
	stats.perk = mPerk;

	return stats;
}

function addPerkStats(XGStrategySoldier kSold, TStatStorage Stats)
{
	m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(kSold.m_kSoldier.iID)].StatStorage.AddItem(Stats);
}

function addPerkToTree(XGStrategySoldier kSold, int perk)
{
	m_kRPCheckpoint.arrSoldierStorage[FindSoldierInStorage(kSold.m_kSoldier.iID)].RandomTree.AddItem(perk);
}

function PerkMerge(int Perk)
{

	local int I, Perk1, Perk2;
	local array<int> perktree;
	local string mPerk;
	local XGStrategySoldier kSold;

	if(m_kSold != none)
	{
		kSold = m_kSold;
	}
	else
	{
		kSold = SOLDIER();
	}

	if(kSold.HasPerk(Perk))
	{
		if(IsSoldierNewType(kSold))
		{
			perktree = NewRandomTree(kSold, -1);

			for(I=0; I<perktree.Length; I++)
			{
				if(perktree[I] == Perk && GetPerkStats(kSold, I).perk > 0)
				{
					kSold.GivePerk(GetPerkStats(kSold, I).perk);
				}
			}
		}
		else
		{
			foreach MergePerk1(mPerk, I)
			{
				Perk1 = SearchPerks(mPerk);
				Perk2 = SearchPerks(MergePerk2[I]);

				if( ( (MergePerkClass[I] == -1) || (MergePerkClass[I] == SOLDIER().m_iEnergy) ) || (SOLDIERUI().GetAbilityTreeBranch() == 1) )
				{
					if(Perk1 == Perk)
					{
						kSold.GivePerk(Perk2);
					}
				}
			}

		}

	}

	m_kSold = none;

}

function applyAugmentDiscount(int cashcost, int meldcost)
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

function GetSoldier(string soldstr)
{

	local XGStrategySoldier Soldier;

	foreach WORLDINFO().AllActors(class'XGStrategySoldier', Soldier)
	{
		if(string(Soldier) == soldstr)
		{
			break;
		}
	}
	m_kSold = Soldier;
}

DefaultProperties
{
}
