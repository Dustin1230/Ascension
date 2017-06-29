Class RoulettePlus extends XComMutator
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
var int ASCVer;
var bool initdone;
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


function Mutate(String MutateString, PlayerController Sender) 
{

	if (MutateString == "AssignRandomPerksRPlus")
	{
		`Log("Mutate: AssignRandomPerksRPlus");
		AssignRandomPerksPlus();
	}
	
	if (Left(MutateString, 14) == "PerkStatsRPlus" )
	{
		`Log("Mutate: PerkStatsRPlus");
		PerkStatsPlus(int(Split(MutateString, "PerkStatsRPlus", true)));
	}
	
	if (Left(MutateString, 14) == "PerkMergeRPlus")
	{
		`Log("Mutate: PerkMergeRPlus");	
		PerkMergePlus(int(Split(MutateString, "PerkMergeRPlus", true)));
	}
	
	if (Left(MutateString, 20) == "AugmentDiscountRPlus" )
	{
		`Log("Mutate: AugmentDiscountRPlus");
		AugmentDiscountPlus(int(Left(Split(MutateString, "AugmentDiscountRPlus", true), InStr(Split(MutateString, "AugmentDiscountRPlus", true), "_"))), int(Split(Split(MutateString, "AugmentDiscountRPlus", true), "_", true)));
	}
	
	if (MutateString == "AugmentRestrictionRPlus")
	{
		`Log("Mutate: AugmentRestrictionRPlus");
		AugmentRestriction();
	}
	
	
	if(arrPerk.Length == 0)
	{
		createPerkArray();
	}

	if(!initdone)
	{
		init();
	}
	
	super.Mutate(MutateString, Sender);
}

function init()
{

	TAG().StrValue2 = "-1";
	super.Mutate("ASCAscensionVersion", GetALocalPlayerController());
	ASCVer = int(TAG().StrValue2);

	if(SplitConfig)
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

	initdone = true;

}

function XGParamTag TAG()
{
	return XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
}

function XGSoldierUI SOLDIERUI()
{
	return XGSoldierUI(XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).GetMgr(class'XGSoldierUI',,, true));
}

function AssignRandomPerksPlus()
{
	local ESoldierClass kClass;
    local string Perk;
    local int I, J, K, amnum;
	local int opt;
	local EPerkType LPerk;

	kClass = ESoldierClass(byte(SOLDIERUI().m_kSoldier.m_iEnergy));
	
	amnum = SOLDIERUI().m_kSoldier.m_arrRandomPerks[22];
    SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length = 0;
	
	if(UseVanillaRolls)
	{
	
		TAG().StrValue1 = "UseVanillaRolls";
		goto end;
	}
    I = 1;
	if(kClass > 0)
	{
		J0x42:
		// End:0x1FA [Loop If]
		if(I < 8)
		{
			J = 0;
			J0x5D:
			// End:0x1EC [Loop If]
			if(J < 3)
			{
				if(kClass > 30)
				{
					if(!IsMECRandom)
					{
						if(J == 1)
						{
							LPerk = 100;
							Perk = string(LPerk);
						}
						else
						{
							LPerk = 0;
							Perk = string(LPerk);
						}
					}
					else
					{
						goto J0x60;
					}
				}
				else
				{
					J0x60:
					K = 0;
					J0x62:
					if(K < StaticPerks.Length)
					{
						if(kClass == ESoldierClass(StaticPerks[K].iClass))
						{
							if(I == ((StaticPerks[K].Pos + 2) / 3))
							{
								opt = 0;
								if(((StaticPerks[K].Pos + 2) % 3) == 0){
									opt = 2;
								}
								if(((StaticPerks[K].Pos + 2) % 3) == 1){
									opt = 1;
								}
								if(J == opt)
								{
									//`Log("I= " $ String(I));
									//`Log("J= " $ String(J));
									Perk = StaticPerks[K].SPerk;
									goto J0x6A;
								}
							}
						}
						++ K;
						goto J0x62;
					}
					
					K = 0;
					J0x77:
					if(K < SemiStaticPerks.Length)
					{
						if(kClass == ESoldierClass(SemiStaticPerks[K].iClass))
						{
							if(I == ((SemiStaticPerks[K].Pos + 2) / 3))
							{
								opt = 0;
								if(((SemiStaticPerks[K].Pos + 2) % 3) == 0){
									opt = 2;
								}
								if(((SemiStaticPerks[K].Pos + 2) % 3) == 1){
									opt = 1;
								}
								if(J == opt)
								{
									Perk = SemiStaticPerks[K].SPerk;
								}
							}
						}
						++ K;
						goto J0x77;
					}
					
					if(I == 1)
					{
						LPerk = 0;
						Perk = String(LPerk);
					}
					else
					{
						J0x17E:
						// End:0x1C6 [Loop If]
						if(!IsRandomPerkValidToAddPlus(Perk))
						{
							Perk = GetRandomPerkPlus(kClass);
						
							// [Loop Continue]
							goto J0x17E;
						}
					}
				}
				J0x6A:
				if(arrPerk.Find(Perk) != -1)
				{
					SOLDIERUI().m_kSoldier.m_arrRandomPerks.AddItem(EPerkType(arrPerk.Find(Perk)));
				}
				else
				{
					K = 0;
					findloop:
					if(K < arrAlias.Length)
					{
						if(arrAlias[K].Alias.Find(Perk) != -1)
						{
							SOLDIERUI().m_kSoldier.m_arrRandomPerks.AddItem(EPerkType(arrAlias[K].Alias.Find(Perk)));
							goto endfind;
						}
						++ K;
						goto findloop;
					}
					endfind:
					
				}
				++ J;
				// [Loop Continue]
				goto J0x5D;
			}
			++ I;
			// [Loop Continue]
			goto J0x42;
		}
	}
	end:
	
	SOLDIERUI().m_kSoldier.m_arrRandomPerks[22] = EPerkType(amnum);
}

function bool IsRandomPerkValidToAddPlus(string Perk)
{
	local int I, J, K, iPerk;
	local EPerkType EPerk, Perk1, Perk2;

	TAG().StrValue2 = "-1";
	super.Mutate("ASCAscensionVersion", GetALocalPlayerController());
	ASCVer = int(TAG().StrValue2);

	if(arrPerk.Find(Perk) != -1)
	{
		EPerk = EPerkType(arrPerk.Find(Perk));
	}
	else
	{
		K = 0;
		findloop:
		if(K < arrAlias.Length)
		{
			if(arrAlias[K].Alias.Find(Perk) != -1)
			{
				EPerk = EPerkType(arrAlias[K].Alias.Find(Perk));
				iPerk = arrAlias[K].Alias.Find(Perk);
				goto endfind;
			}
			++ K;
			goto findloop;
		}
		endfind:
	}
	if(Perk == String(EPerkType(0)))
	{
        return false;
    }

	if(!(0 < ASCVer && ASCVer < 3))
	{
		if(iPerk > 171)
		{
			return false;
		}
	}

    if(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Find(EPerk) != -1)
	{
        return false;
    }
    if(SOLDIERUI().m_kSoldier.HasPerk(EPerk))
	{
        return false;
    }
	I = 0;
	J0x42:
	if(I < IncompatiblePerks1.Length)
	{
		
		if(arrPerk.Find(IncompatiblePerks1[I]) != -1)
		{
			Perk1 = EPerkType(arrPerk.Find(IncompatiblePerks1[I]));
		}
		else
		{
			K = 0;
			findloop1:
			if(K < arrAlias.Length)
			{
				if(arrAlias[K].Alias.Find(IncompatiblePerks1[I]) != -1)
				{
					Perk1 = EPerkType(arrAlias[K].Alias.Find(IncompatiblePerks1[I]));
					goto endfind1;
				}
				++ K;
				goto findloop1;
			}
			endfind1:
		}
		
		if(arrPerk.Find(IncompatiblePerks2[I]) != -1)
		{
			Perk2 = EPerkType(arrPerk.Find(IncompatiblePerks2[I]));
		}
		else
		{
			K = 0;
			findloop2:
			if(K < arrAlias.Length)
			{
				if(arrAlias[K].Alias.Find(IncompatiblePerks2[I]) != -1)
				{
					Perk2 = EPerkType(arrAlias[K].Alias.Find(IncompatiblePerks2[I]));
					goto endfind2;
				}
				++ K;
				goto findloop2;
			}
		endfind2:
		}
		
		switch(Perk)
		{
			case IncompatiblePerks1[I]:
				if(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Find(Perk2) != -1 || SOLDIERUI().m_kSoldier.HasPerk(Perk2))
				{
					return false;
				}
				break;
			case IncompatiblePerks2[I]:
				if(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Find(Perk1) != -1 || SOLDIERUI().m_kSoldier.HasPerk(Perk1))
				{
					return false;
				}
				break;
			default:
				break;
		}
		++ I;
		goto J0x42;
	}
	I = 0;
	J0x17E:
	if(I < ChainPerks1.Length)
	{
	
		if(arrPerk.Find(ChainPerks1[I]) != -1)
		{
			Perk1 = EPerkType(arrPerk.Find(ChainPerks1[I]));
		}
		else
		{
			K = 0;
		    findloop3:
		    if(K < arrAlias.Length)
			{
		    	if(arrAlias[K].Alias.Find(ChainPerks1[I]) != -1)
				{
		    		Perk1 = EPerkType(arrAlias[K].Alias.Find(ChainPerks1[I]));
		    		goto endfind3;
		    	}
		    	++ K;
		    	goto findloop3;
		    }
		    endfind3:
		}
		
		if(arrPerk.Find(ChainPerks2[I]) != -1)
		{
			Perk2 = EPerkType(arrPerk.Find(ChainPerks2[I]));
		}
		else
		{
			K = 0;
		    findloop4:
		    if(K < arrAlias.Length)
			{
		    	if(arrAlias[K].Alias.Find(ChainPerks2[I]) != -1)
				{
		    		Perk2 = EPerkType(arrAlias[K].Alias.Find(ChainPerks2[I]));
		    		goto endfind4;
		    	}
		    	++ K;
		    	goto findloop4;
		    }
		    endfind4:
		}	

		switch((SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length) % 3)
		{
			case 1:
				if((Perk == ChainPerks1[I]) && Perk2 == SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 1)])
				{
					return false;
				}
				if((Perk == ChainPerks2[I]) && Perk1 == SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 1)])
				{
					return false;
				}
			case 2:
				if((Perk == ChainPerks1[I]) && ((Perk2 == SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 1)]) || (Perk2 == SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 2)])))
				{
					return false;
				}
				if((Perk == ChainPerks2[I]) && ((Perk1 == SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 1)]) || (Perk1 == SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 2)])))
				{
					return false;
				}
			default:
				break;
		}
		++ I;
		goto J0x17E;
	}
	I = 0;
	J0x183:
	if(I < StaticPerks.Length)
	{
		if(SOLDIERUI().m_kSoldier.m_iEnergy == StaticPerks[I].iClass)
		{
			if(Perk == StaticPerks[I].SPerk)
			{
				return false;
			}
		}
		++ I;
		goto J0x183;
	}
	I = 0;
	J0x18A:
	if(I < PerkChance.Length)
	{
		if(PerkChance[I].PerkC == string(0) || PerkChance[I].PerkC == string(EPerk))
		{
			if(PerkChance[I].iClass == -1 || PerkChance[I].iClass == SOLDIERUI().m_kSoldier.m_iEnergy)
			{
				if(PerkChance[I].Rank == -1 || ((SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length + 3) / 3) == PerkChance[I].Rank )
				{
					if(!((RandRange(0.9999, 100.0001) * (100.00 / (101.00 - PerkChance[I].Chance))) > 99.99))
					{
						return false;
					}
				}
			}
		}
		++ I;
		goto J0x18A;
	}
	I = 0;
	J0x120:
	if(I < ChoicePerks1.Length)
	{
	
		if(arrPerk.Find(ChoicePerks1[I]) != -1)
		{
			Perk1 = EPerkType(arrPerk.Find(ChoicePerks1[I]));
		}
		else
		{
			K = 0;
		    findloop5:
		    if(K < arrAlias.Length)
			{
		    	if(arrAlias[K].Alias.Find(ChoicePerks1[I]) != -1)
				{
		    		Perk1 = EPerkType(arrAlias[K].Alias.Find(ChoicePerks1[I]));
		    		goto endfind5;
		    	}
		    	++ K;
		    	goto findloop5;
		    }
			endfind5:
		}
		
		if(arrPerk.Find(ChoicePerks2[I]) != -1)
		{
			Perk2 = EPerkType(arrPerk.Find(ChoicePerks2[I]));
		}
		else
		{
			K = 0;
		    findloop6:
		    if(K < arrAlias.Length)
			{
		    	if(arrAlias[K].Alias.Find(ChoicePerks2[I]) != -1)
				{
		    		Perk2 = EPerkType(arrAlias[K].Alias.Find(ChoicePerks2[I]));
		    		goto endfind6;
		    	}
		    	++ K;
		    	goto findloop6;
		    }
		    endfind6:
		}
		
		if(Perk == ChoicePerks1[I] && SOLDIERUI().m_kSoldier.m_arrRandomPerks.Find(Perk2) != -1)
		{
			switch(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length % 3)
			{
				case 0:
					return false;
				case 1:
					if(Perk2 != SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 1)])
					{
						return false;
					}
				case 2:
					if(Perk2 != SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 1)] && (Perk2 != SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 2)]))
					{
						return false;
					}
				default:
					break;
			}
		}
		if(Perk == ChoicePerks2[I] && SOLDIERUI().m_kSoldier.m_arrRandomPerks.Find(Perk1) != -1)
		{
			switch(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length % 3)
			{
				case 0:
					return false;
				case 1:
					if(Perk1 != SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 1)])
					{
						return false;
					}
				case 2:
					if(Perk1 != SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 1)] && (Perk1 != SOLDIERUI().m_kSoldier.m_arrRandomPerks[(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length - 2)]))
					{
						return false;
					}
				default:
					break;
			}
		}
		++ I;
		goto J0x120;
	}
	I = 0;
	J0x128:
	if(I < RequiredPerk1.Length)
	{
	
		if(arrPerk.Find(RequiredPerk1[I]) != -1)
		{
			Perk1 = EPerkType(arrPerk.Find(RequiredPerk1[I]));
		}
		else
		{
			K = 0;
		    findloop7:
		    if(K < arrAlias.Length)
			{
		    	if(arrAlias[K].Alias.Find(RequiredPerk1[I]) != -1)
				{
		    		Perk1 = EPerkType(arrAlias[K].Alias.Find(RequiredPerk1[I]));
		    		goto endfind7;
		    	}
		    	++ K;
		    	goto findloop7;
			}
			endfind7:
		}
	
		if(RequiredPerkClass[I] == -1 || RequiredPerkClass[I] == SOLDIERUI().m_kSoldier.m_iEnergy)
		{
			if(Perk == RequiredPerk1[I])
			{
				J = 0;
				Jplus:
				if(J < RequiredPerk2[I].Perk.Length){
				
					if(arrPerk.Find(RequiredPerk2[I].perk[J]) != -1)
					{
						Perk2 = EPerkType(arrPerk.Find(RequiredPerk2[I].perk[J]));
					}
					else
					{
						K = 0;
					    findloop8:
					    if(K < arrAlias.Length)
						{
					    	if(arrAlias[K].Alias.Find(RequiredPerk2[I].perk[J]) != -1)
							{
					    		Perk2 = EPerkType(arrAlias[K].Alias.Find(RequiredPerk2[I].perk[J]));
					    		goto endfind8;
					    	}
					    	++ K;
					    	goto findloop8;
						}
					    endfind8:
					}
					
					if(!(SOLDIERUI().m_kSoldier.HasPerk(Perk2)))
					{
						if(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Find(Perk2) != -1 && (((SOLDIERUI().m_kSoldier.m_arrRandomPerks.Find(Perk2) + 3) / 3) != ((SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length + 3) / 3) )  )
						{
							goto endJ;
						}
					}
					else
					{
						goto endJ;
					}
					++ J;
					goto Jplus;
				}
				else
				{
					return false;
				}
				endJ:
			}
		}
		++ I;
		goto J0x128;
	}
	I = 0;
	J0x12D:
	if(I < MergePerk1.Length)
	{
	
		if(arrPerk.Find(MergePerk1[I]) != -1)
		{
			Perk1 = EPerkType(arrPerk.Find(MergePerk1[I]));
		}
		else
		{
			K = 0;
		    findloop9:
		    if(K < arrAlias.Length)
			{
		    	if(arrAlias[K].Alias.Find(MergePerk1[I]) != -1)
				{
		    		Perk1 = EPerkType(arrAlias[K].Alias.Find(MergePerk1[I]));
		    		goto endfind9;
		    	}
		    	++ K;
		    	goto findloop9;
			}
			endfind9:
		}
		
		
		if(arrPerk.Find(MergePerk2[I]) != -1)
		{
			Perk2 = EPerkType(arrPerk.Find(MergePerk2[I]));
		}
		else
		{
			K = 0;
			findloop0:
			if(K < arrAlias.Length)
			{
				if(arrAlias[K].Alias.Find(MergePerk2[I]) != -1)
				{
					Perk2 = EPerkType(arrAlias[K].Alias.Find(MergePerk2[I]));
					goto endfind0;
				}
				++ K;
				goto findloop0;
			}
			endfind0:
		}	

		if(MergePerkClass[I] == SOLDIERUI().m_kSoldier.m_iEnergy)
		{
			if(Perk == MergePerk2[I])
			{
				if(SOLDIERUI().m_kSoldier.m_arrRandomPerks.Find(Perk1) != -1 || (SOLDIERUI().m_kSoldier.HasPerk(Perk1)) )
				{
					return false;
				}
			}
		}
		++ I;
		goto J0x12D;
	}
    return true;
}

function string GetRandomPerkPlus(ESoldierClass kClass)
{

    local string Perk;
	
	if(PoolPrioity)
	{
		Perk = AllSoldierPerks[Rand(AllSoldierPerks.Length)];			
		if(!IsRandomPerkValidToAddPlus(Perk))
		{
			if(kClass > 30)
			{
				Perk = AllMECPerks[Rand(AllMECPerks.Length)];				
			}
			else
			{
				Perk = AllBioPerks[Rand(AllBioPerks.Length)];
			}
			if(!IsRandomPerkValidToAddPlus(Perk))
			{
				goto J0x42;
			}
		}
	}
	else
	{
		J0x42:
		switch(kClass)
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
	
	if(!PoolPrioity)
	{
		if(!IsRandomPerkValidToAddPlus(Perk))
		{
			if(kClass > 30)
			{
				Perk = AllMECPerks[Rand(AllMECPerks.Length)];				
			}
			else
			{
				Perk = AllBioPerks[Rand(AllBioPerks.Length)];
			}
			if(!IsRandomPerkValidToAddPlus(Perk))
			{
				Perk = AllSoldierPerks[Rand(AllSoldierPerks.Length)];
			}
		}
	}	
	Return Perk;
}

function PerkStatsPlus(int Pos)
{
	local ESoldierClass kClass;
	local int I, K, opt, will, hp, mob, def, aim, hpmob;
	local XComPerkManager kPerkMan;
	local EPerkType PerkS, EPerk;

	TAG().StrValue2 = strMergePerkLabel $ "_" $ strMergePerkDes;
	kPerkMan = SOLDIERUI().m_kSoldier.PERKS();
	
	/*if(SOLDIERUI().m_kSoldier.HasPerk(180))
	{
		amnesiaperk();
	}*/
	
	I = 0;
	perknumtest:
	if(I < SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length)
	{
		LogInternal("RandomPerks= " $ string(SOLDIERUI().m_kSoldier.m_arrRandomPerks[I]));
		++ I;
		goto perknumtest;
	}
	
	I = 0;
	J0x190:
	if(I < MergePerk1.Length)
	{
	
		if(arrPerk.Find(MergePerk1[I]) != -1)
		{
			EPerk = EPerkType(arrPerk.Find(MergePerk1[I]));
		}
		else
		{
			K = 0;
			findloop:
			if(K < arrAlias.Length)
			{
				if(arrAlias[K].Alias.Find(MergePerk1[I]) != -1)
				{
					EPerk = EPerkType(arrAlias[K].Alias.Find(MergePerk1[I]));
					goto endfind;
				}
				++ K;
				goto findloop;
			}
			endfind:
		}
		
		if(((pos + 2) / 3) == 1)
		{
			if(kPerkMan.GetPerkInTree(SOLDIERUI().m_kSoldier.GetClass(), 1, (pos - 1)) == EPerk)
			{
				goto m;
			}
		}
		if(MergePerkClass[I] == -1 || MergePerkClass[I] == SOLDIERUI().m_kSoldier.m_iEnergy)
		{

		
			if(SOLDIERUI().m_kSoldier.m_arrRandomPerks[Pos - 1] == EPerk)
			{
				m:
				SOLDIERUI().m_kSoldier.m_arrRandomPerks[2] = EPerkType(100);
				
				if(arrPerk.Find(MergePerk2[I]) != -1)
				{
					SOLDIERUI().m_kSoldier.m_arrRandomPerks[21] = EPerkType(arrPerk.Find(MergePerk2[I]));
				}
				else
				{
					K = 0;
					findloop1:
					if(K < arrAlias.Length)
					{
						if(arrAlias[K].Alias.Find(MergePerk2[I]) != -1)
						{
							SOLDIERUI().m_kSoldier.m_arrRandomPerks[21] = EPerkType(arrAlias[K].Alias.Find(MergePerk2[I]));
							goto endfind1;
						}
						++ K;
						goto findloop1;
					}
					endfind1:
				}
				goto J0x192;
			}
			else
			{
				goto J0x191;
			}
		}
		else
		{
			J0x191:
			SOLDIERUI().m_kSoldier.m_arrRandomPerks[2] = EPerkType(0);
			SOLDIERUI().m_kSoldier.m_arrRandomPerks[21] = EPerkType(0);
		}
		++ I;
		goto J0x190;
	}
	
	J0x192:

	opt = (((Pos + 2) % 3) + 1);
	if(opt == 1)
	{
		opt = 3;
	}
	else
	{
		if(opt == 3)
		{
			opt = 1;
		}
	}
	//`Log("Pos= " $ String(Pos));
	//`Log("Rank= " $ String((Pos + 2) / 3));
	//`Log("Option= " $ String(opt));
	if((((Pos + 2) / 3) == 1) && SOLDIERUI().m_kSoldier.m_iEnergy < 30)
	{
		kClass = SOLDIERUI().m_kSoldier.GetClass();
	}
	else
	{
		kClass = ESoldierClass(byte(SOLDIERUI().m_kSoldier.m_iEnergy));
	}
	//`Log("Class= " $ String(kClass));
	
	I = 0;
	J0x02:
	if(I < PerkStats.Length)
	{
		mob = 0;
		will = 0;
		hp = 0;
		def = 0;
		aim = 0;
		hpmob = 0;
		if(PerkStats[I].Stats > 0)
		{
			if(PerkStats[I].Stats / 100 == 1)
			{
				mob = 1;
			}
			if(PerkStats[I].Stats / 100 == 2)
			{
				mob = -1;
			}
			aim = (PerkStats[I].Stats % 100) / 10;
			will = PerkStats[I].Stats % 10;
		}
		else
		{
			if(10 > PerkStats[I].aim && PerkStats[I].aim > 0)
			{
				aim = PerkStats[I].aim;
			}
			if(10 > PerkStats[I].will && PerkStats[I].will > 0)
			{
				will = PerkStats[I].will;
			}
			if(2 > PerkStats[I].mob && PerkStats[I].mob > -2)
			{
				mob = PerkStats[I].mob;
			}
		}
		if(2 > PerkStats[I].hp && PerkStats[I].hp > -2)
		{
			hp = PerkStats[I].hp;
		}
		if(6 > PerkStats[I].def && PerkStats[I].def > -5)
		{
			def = PerkStats[I].def;
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
		else
		{
			if(def > 0)
			{
				def += 4;
			}
		}
		if(PerkStats[I].Rank != -1)
		{
			if(((Pos + 2) / 3) == 1)
			{
				if(SOLDIERUI().m_kSoldier.GetClass() == PerkStats[I].iClass)
				{
					if(PerkStats[I].Rank == 1)
					{
					
						if(opt == PerkStats[I].Option)
						{
							goto ps;
						}
						goto nps;
					}
				}
			}
			
			if(PerkStats[I].Option != -1)
			{
				//`Log("iClass= " $ String(ESoldierClass(PerkStats[I].iClass)));
				if(ESoldierClass(PerkStats[I].iClass) == kClass)
				{
					//`Log("PerkStats.Rank= " $ String(PerkStats[I].Rank));
					//`Log("Pos.Rank= " $ String((Pos + 2) / 3));
					//`Log("Rank=Pos?: " $ String(PerkStats[I].Rank == ((Pos + 2) / 3)));
					if(PerkStats[I].Rank == ((Pos + 2) / 3))
					{
						//`Log("Opt=Pos?: " $ String(PerkStats[I].Option == opt));
						if(PerkStats[I].Option == opt)
						{
							if((int(SOLDIERUI().m_kSoldier.m_arrRandomPerks[2]) / 100) == 1)
							{
								SOLDIERUI().m_kSoldier.m_arrRandomPerks[2] = EPerkType(100 + (aim * 10) + will);
							}
							else
							{
								SOLDIERUI().m_kSoldier.m_arrRandomPerks[2] = EPerkType((aim * 10) + will);
							}
							if((int(SOLDIERUI().m_kSoldier.m_arrRandomPerks[1]) / 100) == 1)
							{
								SOLDIERUI().m_kSoldier.m_arrRandomPerks[1] = EPerkType(100 + (hpmob * 10) + def);
							}
							else
							{
								SOLDIERUI().m_kSoldier.m_arrRandomPerks[1] = EPerkType((hpmob * 10) + def);
							}
							goto J0x70;
						}
					}
				}
			}
			else
			{
				if(PerkStats[I].Rank == ((Pos + 2) / 3))
				{
					goto J0x42;
				}
			}
		}
		else
		{
			J0x42:
			if(PerkStats[I].iClass != -1)
			{
				if(ESoldierClass(PerkStats[I].iClass) == kClass)
				{
					goto J0x5D;
				}
			}
			if(PerkStats[I].iClass == -1)
			{
				J0x5D:
				
				if(arrPerk.Find(PerkStats[I].Perk) != -1)
				{
					PerkS = EPerkType(arrPerk.Find(PerkStats[I].Perk));
				}
				else
				{
					K = 0;
					findloop2:
					if(K < arrAlias.Length)
					{
						if(arrAlias[K].Alias.Find(PerkStats[I].Perk) != -1)
						{
							PerkS = EPerkType(arrAlias[K].Alias.Find(PerkStats[I].Perk));
							goto endfind2;
						}
						++ K;
						goto findloop2;
					}
					endfind2:
				}
				
				
				if(SOLDIERUI().m_kSoldier.m_arrRandomPerks[Pos - 1] == PerkS)
				{
					ps:
					if((int(SOLDIERUI().m_kSoldier.m_arrRandomPerks[2]) / 100) == 1)
					{
						SOLDIERUI().m_kSoldier.m_arrRandomPerks[2] = EPerkType(100 + (aim * 10) + will);
					}
					else
					{
						SOLDIERUI().m_kSoldier.m_arrRandomPerks[2] = EPerkType((aim * 10) + will);
					}
					if((int(SOLDIERUI().m_kSoldier.m_arrRandomPerks[1]) / 100) == 1)
					{
						SOLDIERUI().m_kSoldier.m_arrRandomPerks[1] = EPerkType(100 + (hpmob * 10) + def);
					}
					else
					{
						SOLDIERUI().m_kSoldier.m_arrRandomPerks[1] = EPerkType((hpmob * 10) + def);
					}
					goto J0x70;
				}
				else
				{
					nps:
					if((int(SOLDIERUI().m_kSoldier.m_arrRandomPerks[2]) / 100) == 1)
					{
						SOLDIERUI().m_kSoldier.m_arrRandomPerks[2] = EPerkType(100);
					}
					else
					{
						SOLDIERUI().m_kSoldier.m_arrRandomPerks[2] = EPerkType(0);
					}
					if((int(SOLDIERUI().m_kSoldier.m_arrRandomPerks[1]) / 100) == 1)
					{
						SOLDIERUI().m_kSoldier.m_arrRandomPerks[1] = EPerkType(100);
					}
					else
					{
						SOLDIERUI().m_kSoldier.m_arrRandomPerks[1] = EPerkType(0);
					}
				}
			}
		}
		++ I;
		goto J0x02;
	}
	J0x70:
	//`Log("exit Stat= " $ String(Int(SOLDIERUI().m_kSoldier.m_arrRandomPerks[0])));
}

function PerkMergePlus(int Perk)
{
	local int I, K;
	local EPerkType Perk1, Perk2;
	
	if(SOLDIERUI().m_kSoldier.HasPerk(EPerkType(Perk)))
	{
		I = 0;
		J0x02:
		if(I < MergePerk1.Length)
		{
		
			if(arrPerk.Find(MergePerk1[I]) != -1)
			{
		    	Perk1 = EPerkType(arrPerk.Find(MergePerk1[I]));
		    }
		    else
			{
		    	K = 0;
		    	findloop1:
		    	if(K < arrAlias.Length)
				{
		    		if(arrAlias[K].Alias.Find(MergePerk1[I]) != -1)
					{
		    			Perk1 = EPerkType(arrAlias[K].Alias.Find(MergePerk1[I]));
		    			goto endfind1;
		    		}
		    		++ K;
		    		goto findloop1;
		    	}
		    	endfind1:
		    }
		
		
			if(arrPerk.Find(MergePerk2[I]) != -1)
			{
		    	Perk2 = EPerkType(arrPerk.Find(MergePerk2[I]));
		    }
		    else
			{
		    	K = 0;
		    	findloop2:
		    	if(K < arrAlias.Length)
				{
		    		if(arrAlias[K].Alias.Find(MergePerk2[I]) != -1)
					{
		    			Perk2 = EPerkType(arrAlias[K].Alias.Find(MergePerk2[I]));
		    			goto endfind2;
		    		}
		    		++ K;
		    		goto findloop2;
		    	}
		    	endfind2:
		    }
		
			if(SOLDIERUI().GetAbilityTreeBranch() == 1)
			{
				goto gmperk;
			}
		
			if((MergePerkClass[I] == -1) || (MergePerkClass[I] == SOLDIERUI().m_kSoldier.m_iEnergy))
			{
				gmperk:
				if(Perk1 == Perk)
				{
					SOLDIERUI().m_kSoldier.GivePerk(Perk2);
				}
			}
			++ I;
			goto J0x02;
		}
	}
}

function AugmentDiscountPlus(int cashcost, int meldcost)
{
	if(IsAugmentDiscounted)
	{
		TAG().StrValue2 = string(int(cashcost * (AugmentDiscount / 100.00))) $ "_" $ string(int(meldcost * (AugmentDiscount / 100.00)));
	}
	else
	{
		TAG().StrValue2 = string(cashcost) $ "_" $ string(meldcost);
	}
	//`Log("AugmentDiscount" @ "cashcost:" @ Left(TAG().StrValue2, InStr(TAG().StrValue2, "_")) $ ", meldcost:" @ split(TAG().StrValue2, "_", true));
}

function createPerkArray()
{
	local int I, J, IAlias;
	local EPerkType EPerk;

	I = 0;
	starr:
	if(I < 172)
	{
		EPerk = EPerkType(I);
		arrPerk.additem(string(EPerk));
		++ I;
		goto starr;
	}
	
	IAlias = 0;
	I = 0;
	ia:
	if(I < PerkAliases.Length)
	{
	
		if(IAlias < PerkAliases[I].Alias.Length)
		{
			IAlias = PerkAliases[I].Alias.Length;
		}
	
		++ I;
		goto ia;
	}
	
	arrAlias.add(IAlias);
	
	I = 0;
	starr1:
	if(I < IAlias)
	{
		
		if(0 < ASCVer && ASCVer < 3)
		{
			arrAlias[I].Alias.add(255);
		}
		else
		{
			arrAlias[I].Alias.add(171);
		}
		
		++ I;
		goto starr1;
	}
	
	I = 0;
	stalias:
	if(I < PerkAliases.Length)
	{
		J = 0;
		stalias2:
		if(J < PerkAliases[I].Alias.Length)
		{
			if(int(PerkAliases[I].Perk) > 0 )
			{
				arrAlias[J].Alias[int(PerkAliases[I].Perk)] = PerkAliases[I].Alias[J];
			}
			else
			{
				if(arrPerk.find(PerkAliases[I].Perk) != -1)
				{
					arrAlias[J].Alias[arrPerk.find(PerkAliases[I].Perk)] = PerkAliases[I].Alias[J];
				}
			}
			++ J;
			goto stalias2;
		}
		++ I;
		goto stalias;
	}
}




/*function amnesiaperk()
{
	local XGFacility_Barracks kBarracks;
	local int I, iCount, RandI, AmUsed;
	local float oRank;
	
	kBarracks = XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kBarracks;
	iCount = SOLDIERUI().m_kSoldier.MedalCount();
	
	LogInternal("RoulettePlus: entered Amnesia, starting ClearPerks");
	SOLDIERUI().m_kSoldier.ClearPerks(true);
	LogInternal("RoulettePlus: finished ClearPerks");
	
	if(!(SOLDIERUI().m_kSoldier.m_arrRandomPerks[22] > 0))
	{
		SOLDIERUI().m_kSoldier.m_arrRandomPerks[22] = 0;
	}
	
	SOLDIERUI().m_kSoldier.m_arrRandomPerks[22] = EPerkType(SOLDIERUI().m_kSoldier.m_arrRandomPerks[22] + 1);
	
	AmUsed = SOLDIERUI().m_kSoldier.m_arrRandomPerks[22];
	
	switch(SOLDIERUI().m_kSoldier.GetRank())
	{
		case 2:
			oRank = 1.9;
			break;
		case 3:
			oRank = 1.75;
			break;
		case 4:
			oRank = 1.6;
			break;
		case 5:
			oRank = 1.45;
			break;
		case 6:
			oRank = 1.3;
			break;
		case 7:
			oRank = 1.15;
			break;
		case 8:
			oRank = 1;
			break;
		default:
			oRank = 0;
			break;
	}
	
	SOLDIERUI().m_kSoldier.m_arrRandomPerks.Length = 0;
	SOLDIERUI().m_kSoldier.m_arrRandomPerks.add(24);
	
	SOLDIERUI().m_kSoldier.m_arrRandomPerks[22] = EPerkType(AmUsed);
	
	SOLDIERUI().m_kSoldier.m_kChar.aStats[0] = class'XGTacticalGameCore'.default.Characters[1].HP;
	SOLDIERUI().m_kSoldier.m_kChar.aStats[1] = class'XGTacticalGameCore'.default.Characters[1].Offense;
	SOLDIERUI().m_kSoldier.m_kChar.aStats[2] = class'XGTacticalGameCore'.default.Characters[1].Defense;
	SOLDIERUI().m_kSoldier.m_kChar.aStats[3] = class'XGTacticalGameCore'.default.Characters[1].Mobility;
	I = SOLDIERUI().m_kSoldier.m_kChar.aStats[7];
	SOLDIERUI().m_kSoldier.m_kChar.aStats[7] = class'XGTacticalGameCore'.default.Characters[1].Will;
	
	kBarracks.RandomizeStats(SOLDIERUI().m_kSoldier);
	
	switch(AmnesiaWillLossType)
	{
		case 0:
			break;
		case 1:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= AmnesiaWillLossAmount;
			break;
		case 2:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (AmnesiaWillLossAmount * SOLDIERUI().m_kSoldier.GetRank());
			break;
		case 3:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (AmnesiaWillLossAmount * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			break;
		case 4:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (AmnesiaWillLossAmount * SOLDIERUI().m_kSoldier.GetRank() * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			break;
		case 5:
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - (AmnesiaWillLossAmount) > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (I - class'XGTacticalGameCore'.default.Characters[1].Will - (AmnesiaWillLossAmount));
			}
			break;
		case 6:
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - (AmnesiaWillLossAmount * oRank) > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (I - class'XGTacticalGameCore'.default.Characters[1].Will - (AmnesiaWillLossAmount * oRank));
			}
			break;
		case 7:
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - AmnesiaWillLossAmount > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= ((I - class'XGTacticalGameCore'.default.Characters[1].Will - AmnesiaWillLossAmount) * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			}
			break;
		case 8:
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - (AmnesiaWillLossAmount * oRank) > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= ((I - class'XGTacticalGameCore'.default.Characters[1].Will - (AmnesiaWillLossAmount * oRank)) * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			}
			break;
		case 11:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= Rand(AmnesiaWillLossAmount + 1);
			break;
		case 12:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= Rand(AmnesiaWillLossAmount * SOLDIERUI().m_kSoldier.GetRank());
			break;
		case 13:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= Rand(AmnesiaWillLossAmount * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			break;
		case 14:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= Rand(AmnesiaWillLossAmount * SOLDIERUI().m_kSoldier.GetRank() * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			break;
		case 15:
			RandI = Rand(AmnesiaWillLossAmount + 1);
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - RandI > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (I - class'XGTacticalGameCore'.default.Characters[1].Will - RandI);
			}
			break;
		case 16:
			RandI = Rand(AmnesiaWillLossAmount + 1);
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - (RandI * oRank) > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (I - class'XGTacticalGameCore'.default.Characters[1].Will - (RandI * oRank));
			}
			break;
		case 17:
			RandI = Rand(AmnesiaWillLossAmount + 1);
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - RandI > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= ((I - class'XGTacticalGameCore'.default.Characters[1].Will - RandI) * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			}
			break;
		case 18:
			RandI = Rand(AmnesiaWillLossAmount + 1);
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - (RandI * oRank) > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= ((I - class'XGTacticalGameCore'.default.Characters[1].Will - (RandI * oRank)) * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			}
			break;
		case 22:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (Rand(AmnesiaWillLossAmount + 1) * SOLDIERUI().m_kSoldier.GetRank());
			break;
		case 23:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (Rand(AmnesiaWillLossAmount + 1) * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			break;
		case 24:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (Rand(AmnesiaWillLossAmount + 1) * SOLDIERUI().m_kSoldier.GetRank() * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			break;
		case 26:
			RandI = Rand((AmnesiaWillLossAmount + 1) * oRank);
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - RandI > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (I - class'XGTacticalGameCore'.default.Characters[1].Will - RandI);
			}
			break;
		case 32:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (Rand(AmnesiaWillLossAmount * SOLDIERUI().m_kSoldier.GetRank()) * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			break;
		case 33:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (Rand(AmnesiaWillLossAmount * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]) * SOLDIERUI().m_kSoldier.GetRank());
			break;
		case 36:
			RandI = Rand((AmnesiaWillLossAmount + 1) * oRank);
			if(I - class'XGTacticalGameCore'.default.Characters[1].Will - RandI > 0)
			{
				SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= ((I - class'XGTacticalGameCore'.default.Characters[1].Will - RandI) * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]);
			}
			break;
		case 42:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= Rand(SOLDIERUI().m_kSoldier.GetRank()) * AmnesiaWillLossAmount;
			break;
		case 43:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= (Rand(SOLDIERUI().m_kSoldier.GetRank() * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22]) * AmnesiaWillLossAmount);
			break;
		case 44:
			SOLDIERUI().m_kSoldier.m_kChar.aStats[7] -= Rand(SOLDIERUI().m_kSoldier.GetRank() * SOLDIERUI().m_kSoldier.m_arrRandomPerks[22] * AmnesiaWillLossAmount);
			break;
		default:
			break;
	}
	
	
	if(SOLDIERUI().m_kSoldier.HasAnyMedal())
	{
		
		if(bAMedalWait)
		{
			kBarracks.rollstat(SOLDIERUI().m_kSoldier, 0, 0);
		}
		else
		{ 
		
			stCount:
			if(iCount > 0)
			{
			
				SOLDIERUI().m_kSoldier.m_arrMedals[iCount] = 0;
				kBarracks.m_arrMedals[iCount].m_iUsed -= 1;
				kBarracks.m_arrMedals[iCount].m_iAvailable += 1;
				
				-- iCount;
				goto stCount;
			}
		}
		
	}
	
}
*/


function AugmentRestriction()
{
	TAG().StrValue2 = "";

	if(MECxpLoss)
	{
		TAG().StrValue2 = "1";
	}
	else
	{
		TAG().StrValue2 = "0";
	}
	if(MECChops)
	{
		TAG().StrValue2 $= "1";
	}
	else
	{
		TAG().StrValue2 $= "0";
	}
	if(MECMedalWait)
	{
		TAG().StrValue2 $= "1";
	}
	else
	{
		TAG().StrValue2 $= "0";
	}

}