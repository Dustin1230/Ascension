class XGHeadQuarters extends XGStrategyActor
    notplaceable;
	
var XGFacility_Barracks m_kBarracks;
var XGFacility_Labs m_kLabs;
var XGFacility_Engineering m_kEngineering;


function XGFacility_Barracks GetBarracks() 
{
	return m_kBarracks;
}

function XGFacility CurrentFacility()
{
    return ReturnValue;    
}