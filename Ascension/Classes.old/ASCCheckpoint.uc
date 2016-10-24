Class ASCCheckpoint extends Actor;

struct TASCStorage {
	var int perks[255];
	var array<int> state;
	var bool GunslingerState;
};

struct TSoldierStorage extends TASCStorage {
	var int SoldierID;
};

struct TAlienStorage extends TASCStorage {
	var int ActorNumber;
};

struct CheckpointRecord
{
	var array <TSoldierStorage> arrSoldierStorage;
	var array <int> iFndryComplete;
	var array <int> iRsrchComplete;
};

var array <TSoldierStorage> arrSoldierStorage;
var array <int> iFndryComplete;
var array <int> iRsrchComplete;

function GivePerkASC(int kSoldierID, int perk, optional int value) {

	local int I;
	local bool bFound;
	
	I = 0;
	stsperk:
	if(I < arrSoldierStorage.Length) {
		if(kSoldierID == arrSoldierStorage[I].SoldierID) {
			bFound = true;
			arrSoldierStorage[I].perks[perk] += value;
			LogInternal("ASCPerks:" @ "Perk #" $ perk @ "was given value" @ value);
		}
		++ I;
		goto stsperk;
	}
	
	if(!bFound) {
		arrSoldierStorage.add(1);
		arrSoldierStorage[arrSoldierStorage.Length - 1].SoldierID = kSoldierID;
		arrSoldierStorage[arrSoldierStorage.Length - 1].perks[perk] = value;
	}

}

function HasPerkASC(int kSoldierID, int perk) {

	local int I;
	local XGParamTag kTag;
	
	kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
	
	kTag.StrValue2 = "0";
	I = 0;
	sthsperk:
	if(I < arrSoldierStorage.Length) {
		if(kSoldierID == arrSoldierStorage[I].SoldierID) {
			if(arrSoldierStorage[I].perks[perk] > 0) {
				kTag.StrValue2 = string(arrSoldierStorage[I].perks[perk]);
				LogInternal("ASCPerks:" @ "Soldier #" $ kSoldierID @ "has perk #" $ perk @ "at value" @ arrSoldierStorage[I].perks[perk]);
			}
		}
		++ I;
		goto sthsperk;
	}

}

function RemovePerkASC(int kSoldierID, int perk, optional int value) {

	local int I;
	
	I = 0;
	stsperk:
	if(I < arrSoldierStorage.Length) {
		if(kSoldierID == arrSoldierStorage[I].SoldierID) {
			if(arrSoldierStorage[I].perks[perk] > 0) {
				arrSoldierStorage[I].perks[perk] -= value;
			}
		}
		++ I;
		goto stsperk;
	}
}

function XGFacility_Engineering ENGINEERING()
{
	return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kEngineering;
	//return ReturnValue;    
}

function XGFacility_Labs LABS()
{
	return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kLabs;
	//return ReturnValue;    
}

function CompletedProject()
{
	iFndryComplete = ENGINEERING().m_arrFoundryHistory;
	iRsrchComplete = LABS().m_arrResearched;
}
