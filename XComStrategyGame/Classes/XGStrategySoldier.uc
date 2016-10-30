class XGStrategySoldier extends XGStrategyActorNativeBase
	native
	notplaceable;
	
var TCharacter m_kChar;
var TSoldier m_kSoldier;
var int m_iEnergy;
var array<EPerkType> m_arrRandomPerks;
var int m_arrMedals[7];
var int m_iNumMissions;
var transient XComUnitPawn m_kPawn;
var TInventory m_kBackedUpLoadout;


function XGTacticalGameCoreData.ESoldierClass GetClass()
{
    return m_kChar.eClass;   
}

function string GetName(int eType) {}

function string GetStatusString() {}

function int GetStatusUIState() {}

function bool HasPerk(int iPerk)
{
    return (m_kChar.aUpgrades[iPerk] & 1) != 0;                
}

function XComPerkManager PERKS()
{
    return XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPerkTree;
    //return ReturnValue;    
}

function GivePerk(EPerkType Perk) {}

function EPerkType GetPerkInClassTree(int branch, int Option, optional bool bIsPsiTree) 
{
	return ReturnValue;
}

function bool PerkLockedOut(int Perk, int branch, optional bool isPsiPerk) 
{
	return ReturnValue;
}

function bool IsReadyToLevelUp() {}

function LevelUp(optional XGTacticalGameCoreData.ESoldierClass eClass, optional out string statsString) {}

function LevelUpStats(optional int statsString) {}

function AssignRandomPerks() {}

function int MedalCount() {}

function bool HasAnyMedal() {}

native function int GetRank();

function XComUnitPawn CreatePawn(optional name DestState) {}

function ClearPerks(optional bool bClearMedalPerks) {}

simulated function int GetAbilityTreeBranch() {}

simulated function int GetAbilityTreeOption() {}

function OnLoadoutChange() {}

function DestroyPawn() {}

native function int GetCurrentStat(const int iStat);

native function int GetMaxStat(const int iStat);

native function bool IsInjured();

function SetHQLocation(int iNewHQLocation, optional bool bForce, optional int SlotIdx, optional bool bForceNewPawn)
{
}