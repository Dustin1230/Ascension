Class ModBridge extends XComMod
 config(ModBridge);

Struct TMBMods
{
	var array<ModBridge> arrMBMods;
	var array<XComMod> arrXCMods;
	var array<string> ModNames;
};

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
var string ModInitError;
var TMBMods MBMods;
var config bool verboseLog;
var config array<string> ModList;

static function class TCHECKPOINT()
{
	return class'Mod_Checkpoint_TacticalGame';
}

static function class STCHECKPOINT()
{
	return class'Mod_Checkpoint_StrategyTransport';
}

static function class SCHECKPOINT()
{
	return class'Mod_Checkpoint_StrategyGame';
}


simulated function StartMatch()
{
	local XComMod Mod;

	functionName = "ModInit";

	AssignMods();

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

	/** 
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
	}*/
}

function AssignMods()
{

	local class<XComMod> Mod;
	local XComMod XMod;
	local string ModName;
	local int i;
	local bool bFound;

	`Log("Started AssignMods", verboseLog, 'ModBridge');

	foreach ModList(ModName, i)
	{
		Mod = class<XComMod>(DynamicLoadObject(ModName, class'Class'));
		XMod = new (self) Mod;
		if(ModBridge(XMod) != none)
		{
			`Log(Chr(34) $ ModName $ Chr(34) @ "detected as Child of ModBridge, adding to modlist", verboseLog, 'ModBridge');
			MBMods.arrMBMods[i] = ModBridge(XMod);
			MBMods.arrXCMods[i] = none;
			MBMods.ModNames[i] = "ModBridge|" $ ModName;
		}
		else
		{
			`Log( "adding" @ Chr(34) $ ModName $ Chr(34) @ "to modlist as XComMod", verboseLog, 'ModBridge');
			MBMods.arrMBMods[i] = none;
			MBMods.arrXCMods[i] = XMod;
			MBMods.ModNames[i] = "XComMod|" $ ModName;
		}
	}

	for(i=0; i<XComGameInfo(outer).ModNames.Length; i++)
	{
		ModName = XComGameInfo(outer).ModNames[i];
		`Log(ModName);
		bFound = false;
		foreach XComGameInfo(outer).Mods(XMod)
		{
			if(ModName == (string(XMod.Class.GetPackageName()) $ "." $ string(XMod.Class)))
			{
				bFound = true;
				break;
			}
		}

		if(!bFound)
		{
			`Log("removing" @ Chr(34) $ ModName $ Chr(34) @ "from XComGameInfo.ModNames", verboseLog, 'ModBridge');
			XComGameInfo(outer).ModNames.Remove(i, 1);
			-- i;
		}

	}

	`Log("End of AssignMods", verboseLog, 'ModBridge');

}

function ModsStartMatch()
{

	local string Mod;
	local int i;

	foreach MBMods.ModNames(Mod, i)
	{
		if(InStr(Mod, "ModBridge|") != -1)
		{
			`Log("Executing StartMatch function in" @ Chr(34) $ Mod $ Chr(34), verboseLog, 'ModBridge');
			MBMods.arrMBMods[i].StartMatch();
		}
		else if(InStr(Mod, "XComMod|") != -1)
		{
			`Log("Executing StartMatch function in" @ Chr(34) $ Mod $ Chr(34), verboseLog, 'ModBridge');
			MBMods.arrXCMods[i].StartMatch();
		}
	}

	for(i=1; i<XComGameInfo(outer).Mods.Length; I++)
	{
		`Log("Executing StartMatch function in" @ Chr(34) $ "XComGameInfo|" $ XComGameInfo(outer).ModNames[i] $ Chr(34), verboseLog, 'ModBridge');
		XComGameInfo(outer).Mods[i].StartMatch();
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
					sArray $= ", ";
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
					sArray $= ", ";
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

	local int i;
	local string mod;
	local bool bFound;

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
		if(int(ModName) > MBMods.ModNames.Length)
		{
			mod = "XComGameInfo|" $ XComGameInfo(Outer).ModNames[int(ModName)-MBMods.ModNames.Length];
		}
		else
		{
			mod = MBMods.ModNames[int(ModName)];
		}
		`Log("Mod number" @ ModName @ "is" @ Chr(34) $ mod $ Chr(34), true, 'ModBridge');
	}
	else
	{
		if(ModName == "AllMods")
		{
			bFound = true;
		}
		else
		{
			foreach MBMods.ModNames(mod)
			{
				if(InStr(mod, ModName) != -1)
				{
					bFound = true;
					break;
				}
			}
		}

		if(!bFound)
		{
			if(XComGameInfo(outer).ModNames.Find(ModName) != -1)
			{
				bFound = true;
			}
		}

		if(!bFound)
		{
			`Log("Error, ModName" @ Chr(34) $ ModName $ Chr(34) @ "not found", true, 'ModBridge');
			return returnvalue;
		}

		if(verboseLog && ModName != "AllMods")
		{
			bFound = false;
			foreach MBMods.ModNames(mod, i)
			{
				if(InStr(mod, ModName) != -1)
				{
					bFound = true;
					break;
				}
			}
			if(!bFound)
			{
				i = XComGameInfo(outer).ModNames.Find(ModName) + MBMods.ModNames.Length;
			}

			`Log("Mod" @ Chr(34) $ ModName $ Chr(34) @ "is mod number" @ string(i), true, 'ModBridge');
		}

		if(!(funtName == " " || funtName == ""))
		{
			functionName = funtName;
			functParas = paras;
			if(ModName == "AllMods")
			{
				`Log("Looping over all Mods", verboseLog, 'ModBridge');
				ModsStartMatch();
			}
			else
			{
				bFound = false;
				foreach MBMods.ModNames(mod, i)
				{
					if(InStr(mod, ModName) != -1)
					{
						bFound = true;
						`Log("Executing" @ Chr(34) $ ModName $ Chr(34) $ ".StartMatch()", verboseLog, 'ModBridge');
						if(InStr(mod, "ModBridge|") != -1)
						{
							MBMods.arrMBMods[i].StartMatch();
							break;
						}
						else if(InStr(mod, "XComMod|") != -1)
						{
							MBMods.arrXCMods[i].StartMatch();
							break;
						}
					}
				}
				if(!bFound)
				{
					if(XComGameInfo(outer).ModNames.Find(ModName) != -1)
					{
						`Log("Executing" @ Chr(34) $ "XComGameInfo|" $ ModName $ Chr(34) $ ".StartMatch()", verboseLog, 'ModBridge');
						XComGameInfo(outer).Mods[XComGameInfo(outer).ModNames.Find(ModName)].StartMatch();
					}
				}
			}
			//XComGameInfo(outer).Mods[XComGameInfo(outer).ModNames.Find(ModName)].StartMatch();
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