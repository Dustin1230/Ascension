class MyMod extends XComMod
	config(MyMod);

struct TStruct
{
	var array<int> iVal;
};

var config TStruct Test;

simulated function StartMatch()
{
	local string functionName;
	local string functParas;

	functionName = ModBridge(XComGameInfo(Outer).Mods[0]).functionName;
	functParas = ModBridge(XComGameInfo(Outer).Mods[0]).functParas;

	if(functionName == "TestFunct")
	{
		if(functparas != "")
		{
			TestFunct(functParas);
		}
		else
		{
			TestFunct();
		}
	}

}

function TestFunct(optional string optparas)
{
	`Log("Test successful, MyMod. parameter=" @ optparas);
}
DefaultProperties
{
}
