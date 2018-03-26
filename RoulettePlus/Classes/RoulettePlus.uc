Class RoulettePlus extends XComMutator
	config(RoulettePlus);

// Deprecated: Old version of RoulettePlus, used for compatibility of older INI files for previous TRP versions
struct TStaticPerks
{
	var string SPerk;
	var int Pos;
	var int iClass;
};

struct TSemiStatic
{
	var string SPerk;
	var string Pos;
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
var config int AmnesiaWillLossAmount;
var config int AmnesiaWillLossType;
var config string AmnesiaPerkName;
var config string AmnesiaPerkDes;
var config bool bAMedalWait;
var config bool MECxpLoss;
var config bool MECChops;
var config bool MECMedalWait;

DefaultProperties
{
}