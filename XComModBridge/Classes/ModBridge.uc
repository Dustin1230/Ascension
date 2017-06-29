Class ModBridge extends XComMod
 config(ModBridge);

var string valStrValue0;
var string valStrValue1;
var string valStrValue2;
var int valIntValue0;
var int valIntValue1;
var int valIntValue2;
var array<string> valArrStr;
var array<int> valArrInt;
var string functionName;
var string functParas;
var config bool verboseLog;
var string ModInitError;

simulated function array<XComMod> ModArray()
{
	return XComGameInfo(Outer).Mods;
}


simulated function StartMatch()
{
	local XComMod Mod;

	functionName = "ModInit";



	if(verboseLog)
	{
		LogInternal("Start ModInit", 'ModBridge');
	}

	foreach XComGameInfo(Outer).Mods(Mod)
	{
		if(Mod != self)
		{
			if(verboseLog)
			{
				LogInternal(string(Mod) @ "ModInit attempt", 'ModBridge');
			}
			ModInitError = "";
			Mod.StartMatch();
			if(ModInitError != "")
			{
				LogInternal(string(Mod) $ ", ModInitError=" @ Chr(34) $ ModInitError $ Chr(34), 'ModBridge');
			}
			else
			{
				if(verboseLog)
				{
					LogInternal(string(Mod) @ "ModInit Successful", 'ModBridge');
				}
			}
		}
	}

	if(verboseLog)
	{
		LogInternal("Overwrite Checkpoint classes", 'ModBridge');
	}
	XComGameInfo(Outer).TacticalSaveGameClass = class'Mod_Checkpoint_TacticalGame';
	XComGameInfo(Outer).TransportSaveGameClass = class'Mod_Checkpoint_StrategyTransport';

	if(XComHeadquartersGame(XComGameInfo(Outer)) != none)
	{
		if(verboseLog)
		{
			LogInternal("StrategyGame Detected, Checkpoint class overwrite", 'ModBridge');
		}
		XComGameInfo(Outer).StrategySaveGameClass = class'Mod_Checkpoint_StrategyGame';
	}



	if(verboseLog)
	{
		LogInternal("End of StartMatch", 'ModBridge');
	}

	functionName = "";
}

function ModError(string Error)
{
	LogInternal("ModError=" @ Error, 'ModBridge');
}

function ModRecordActor(string Checkpoint, class<Actor> ActorClasstoRecord)
{
	if(Checkpoint ~= "Tactical")
	{
		if(verboseLog)
		{
			LogInternal("Adding Actor Class" @ Chr(34) $ string(ActorClasstoRecord) $ Chr(34) @ "to TacticalGame Checkpoint", 'ModBridge');
		}
		class'Mod_Checkpoint_TacticalGame'.default.ActorClassesToRecord.AddItem(ActorClasstoRecord);
	}

	if(Checkpoint ~= "Transport")
	{
		if(verboseLog)
		{
			LogInternal("Adding Actor Class" @ Chr(34) $ string(ActorClasstoRecord) $ Chr(34) @ "to StrategyTransport Checkpoint", 'ModBridge');
		}
		class'Mod_Checkpoint_StrategyTransport'.default.ActorClassesToRecord.AddItem(ActorClasstoRecord);
	}
	if(Checkpoint ~= "Strategy")
	{
		if(verboseLog)
		{
			LogInternal("Adding Actor Class" @ Chr(34) $ string(ActorClasstoRecord) $ Chr(34) @ "to StrategyGame Checkpoint", 'ModBridge');
		}
		class'Mod_Checkpoint_StrategyGame'.default.ActorClassesToRecord.AddItem(ActorClasstoRecord);
	}
}

function string StrValue0(optional string str, optional bool bForce)
{
	if(str == "" && !bForce)
	{
		if(verboseLog)
		{
			LogInternal("return StrValue0=" @ Chr(34) $ valStrValue0 $ Chr(34), 'ModBridge');
		}
		return valStrValue0;
	}
	else
	{
		if(verboseLog)
		{
			LogInternal("store StrValue0=" @ Chr(34) $ str $ Chr(34) $ ", bForce=" @ string(bForce), 'ModBridge');
		}
		valStrValue0 = str;
		return "";
	}
}

function string StrValue1(optional string str, optional bool bForce)
{
	if(str == "" && !bForce)
	{
		if(verboseLog)
		{
			LogInternal("return StrValue1=" @ Chr(34) $ valStrValue1 $ Chr(34), 'ModBridge');
		}
		return valStrValue1;
	}
	else
	{
		if(verboseLog)
		{
			LogInternal("store StrValue1=" @ Chr(34) $ str $ Chr(34) $ ", bForce=" @ string(bForce), 'ModBridge');
		}
		valStrValue1 = str;
		return "";
	}
}

function string StrValue2(optional string str, optional bool bForce)
{
	if(str == "" && !bForce)
	{
		if(verboseLog)
		{
			LogInternal("return StrValue2=" @ Chr(34) $ valStrValue2 $ Chr(34), 'ModBridge');
		}
		return valStrValue2;
	}
	else
	{
		if(verboseLog)
		{
			LogInternal("store StrValue2=" @ Chr(34) $ str $ Chr(34) $ ", bForce=" @ string(bForce), 'ModBridge');
		}
		valStrValue2 = str;
		return "";
	}
}

function int IntValue0(optional int I = -1, optional bool bForce)
{
	if((I == 0 || I == -1) && !bForce)
	{
		if(verboseLog)
		{
			LogInternal("return IntValue0=" @ Chr(34) $ string(valIntValue0) $ Chr(34), 'ModBridge');
		}
		return valIntValue0;
	}
	else
	{
		if(verboseLog)
		{
			LogInternal("store IntValue0=" @ Chr(34) $ string(I) $ Chr(34) $ ", bForce=" @ string(bForce), 'ModBridge');
		}
		valIntValue0 = I;
		return 0;
	}
}

function int IntValue1(optional int I = -1, optional bool bForce)
{
	if((I == 0 || I == -1) && !bForce)
	{
		if(verboseLog)
		{
			LogInternal("return IntValue1=" @ Chr(34) $ string(valIntValue1) $ Chr(34), 'ModBridge');
		}
		return valIntValue1;
	}
	else
	{
		if(verboseLog)
		{
			LogInternal("store IntValue1=" @ Chr(34) $ string(I) $ Chr(34) $ ", bForce=" @ string(bForce), 'ModBridge');
		}
		valIntValue1 = I;
		return 0;
	}
}

function int IntValue2(optional int I = -1, optional bool bForce)
{
	if((I == 0 || I == -1) && !bForce)
	{
		if(verboseLog)
		{
			LogInternal("return IntValue2=" @ Chr(34) $ string(valIntValue2) $ Chr(34), 'ModBridge');
		}
		return valIntValue2;
	}
	else
	{
		if(verboseLog)
		{
			LogInternal("store IntValue2=" @ Chr(34) $ string(I) $ Chr(34) $ ", bForce=" @ string(bForce), 'ModBridge');
		}
		valIntValue2 = I;
		return 0;
	}
}

function array<string> arrStrings(optional array<string> arrStr, optional bool bForce)
{

	local string sArray;

	if(arrStr.Length == 0 && !bForce)
	{
		if(verboseLog)
		{
			JoinArray(valArrStr, sArray);
			LogInternal("return arrStrings=" @ Chr(34) $ sArray $ Chr(34), 'ModBridge');
		}
		return valArrStr;
	}
	else
	{
		if(verboseLog)
		{
			JoinArray(arrStr, sArray);
			LogInternal("store arrStrings=" @ Chr(34) $ sArray $ Chr(34) $ ", bForce=" @ string(bForce), 'ModBridge');
		}
		valArrStr = arrStr;
		arrStr.Length = 0;
		return arrStr;
	}

}

function array<int> arrInts(optional array<int> arrInt, optional bool bForce)
{

	local int I;
	local string sArray;

	if(arrInt.Length == 0 && !bForce)
	{
		if(verboseLog)
		{
			for(I=0; I < valArrInt.Length; I++)
			{
				if(sArray != "")
				{
					sArray $= ",";
				}
				sArray $= string(valArrInt[I]);
			}
			LogInternal("return arrInts=" @ Chr(34) $ sArray $ Chr(34), 'ModBridge');
		}
		return valArrInt;
	}
	else
	{
		if(verboseLog)
		{
			for(I=0; I < arrInt.Length; I++)
			{
				if(sArray != "")
				{
					sArray $= ",";
				}
				sArray $= string(arrInt[I]);
			}
			LogInternal("store arrInts=" @ Chr(34) $ sArray $ Chr(34) $ ", bForce=" @ string(bForce), 'ModBridge');
		}
		valArrInt = arrInt;
		arrInt.Length = 0;
		return arrInt;
	}
}


function XComMod Mods(string ModName, optional string funtName, optional string paras)
{
	if(verboseLog)
	{
		LogInternal("funtName=" @ Chr(34) $ funtName $ Chr(34) $ ", paras=" @ Chr(34) $ paras $ Chr(34), 'ModBridge');
	}

	if(ModName == "")
	{
		LogInternal("Error, ModName not specified", 'ModBridge');
		return returnvalue;
	}

	if(verboseLog && (int(ModName) > 0))
	{
		LogInternal("Mod number" @ ModName @ "is" @ Chr(34) $ XComGameInfo(outer).ModNames[int(ModName)] $ Chr(34), 'ModBridge');
	}
	else
	{
		
		if(XComGameInfo(outer).ModNames.Find(ModName) == -1)
		{
			LogInternal("Error, ModName" @ Chr(34) $ ModName $ Chr(34) @ "not found", 'ModBridge');
			return returnvalue;
		}

		if(verboseLog)
		{
			LogInternal("Mod" @ Chr(34) $ ModName $ Chr(34) @ "is mod number" @ string(XComGameInfo(outer).ModNames.Find(ModName)), 'ModBridge');
		}

		if(!(funtName == " " || funtName == ""))
		{
			functionName = funtName;
			functParas = paras;
			XComGameInfo(outer).Mods[XComGameInfo(outer).ModNames.Find(ModName)].StartMatch();
		}
		else
		{
			if(verboseLog)
			{
				LogInternal("Return Mod," @ Chr(34) $ string(XComGameInfo(outer).Mods[XComGameInfo(outer).ModNames.Find(ModName)]), 'ModBridge');
			}
			return XComGameInfo(outer).Mods[XComGameInfo(outer).ModNames.Find(ModName)];
		}
	}

}