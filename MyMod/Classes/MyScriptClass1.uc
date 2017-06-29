class MyScriptClass1 extends XComMod;

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
	`Log("Test successful, MyScript. parameter=" @ optparas);
}

DefaultProperties
{
}
