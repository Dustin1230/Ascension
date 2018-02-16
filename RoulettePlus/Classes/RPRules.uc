class RPRules extends object
	DependsOn(RoulettePlus)
	config(RPRules);

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
var config array <TPerkChance> PerkChance;