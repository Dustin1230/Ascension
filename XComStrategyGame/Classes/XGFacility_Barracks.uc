class XGFacility_Barracks extends XGFacility
    hidecategories(Navigation)
    config(GameData)
    notplaceable;

struct Medal
{
    var string m_Name;
    var int m_eType;
    var XGTacticalGameCoreNativeBase.EPerkType m_eChosenPower;
    var int m_iAvailable;
    var int m_iUsed;
    var int m_iMissionsLeft;
};
	
var XComPerkManager m_kPerkManager;
var Medal m_arrMedals[7];
var XGFacility_Lockers m_kLockers;
var array<XGStrategySoldier> m_arrSoldiers;

function RandomizeStats(XGStrategySoldier kRecruit)
{
}

function int RollStat(XGStrategySoldier iLow, int iHigh, int iMultiple) {}

function XGStrategySoldier GetSoldierByID(int iID) {}

function bool NickNameMatch(XGStrategySoldier kSoldier) {}

function bool HasOTSUpgrade(int eUpgrade) {}