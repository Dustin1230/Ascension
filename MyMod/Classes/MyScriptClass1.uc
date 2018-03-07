class MyScriptClass1 extends XComMod within ModBridge;

var int storedSeed;

simulated function StartMatch()
{

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

	if(functionName == "TestRandSeed")
	{
		TestRandSeed(functParas);
	}

	if(functionName == "GetCurrentTime")
	{
		loginternal("CurrentTime is:" @ string(class'XComEngine'.static.GetCurrentTime()));
	}

	if(functionName == "GetCurrentDeviceID")
	{
		loginternal("Current Device ID is:" @ string(XComEngine(class'Engine'.static.GetEngine()).GetCurrentDeviceID()));
	}
	if(functionName == "SeedCreationTest")
	{
		storedseed = class'XComEngine'.static.GetARandomSeed();
		storedseed = (storedseed >> 1) ^ class'XComEngine'.static.GetARandomSeed();
		storedseed = ((storedseed >> 2) ^ class'XComEngine'.static.GetCurrentTime() << 2) ^ storedseed;
		storedseed = ((storedseed >> 1) ^ class'XComEngine'.static.GetARandomSeed() >> 2) ^ class'XComEngine'.static.GetARandomSeed();
		storedseed = ((storedseed << 1) ^ storedseed) ^ class'XComEngine'.static.GetARandomSeed();
		randloop0:
		if(Rand(100) < 33)
		{
			storedseed = Rand(100000000);
			goto randloop0;
		}
		randloop1:
		if(Rand(2) == 1)
		{
			storedseed *= -1;
			goto randloop1;
		}
		randloop2:
		if(Rand(2) == 1)
		{
			storedseed = storedseed ^ class'XComEngine'.static.GetARandomSeed();
			goto randloop2;
		}
		randloop3:
		if(Rand(2) == 1)
		{
			storedseed = storedseed ^ (Rand(2) == 1 ? 1 : -1) * Rand(100000000);
			goto randloop3;
		}
		`log("storedseed=" @ string(storedseed));
	}

}

function TestRandSeed(string paras)
{
	
	local array<string> arrParasStr;
	local string str1, str2;
	arrParasStr = SplitString(paras, "_", false);

	if(paras == "getrandseed")
	{
		loginternal("random seed: " $ string(class'XComEngine'.static.GetARandomSeed()), 'TestRandSeed');
	}
	if(paras == "getlastseed")
	{
		loginternal("last seed: " $ string(class'XComEngine'.static.GetLastInitSeed()), 'TestRandSeed');
	}
	if(paras == "getcurseed")
	{
		loginternal("current seed: " $ string(class'XComEngine'.static.GetSyncSeed()), 'TestRandSeed');
	}
	if(paras == "displayrandseedstring")
	{
		loginternal("random seed string= " $ Chr(34) $ (string(Name) @ string(GetStateName())) @ string(GetFuncName()) $ Chr(34), 'TestRandSeed');
	}
	if(arrParasStr[0] == "getfrand")
	{
		if(arrParasStr[1] == "testrandseed")
		{
			loginternal("random float with TestRandSeed: " $ string(class'XComEngine'.static.SyncFRand("TestRandSeed")), 'TestRandSeed');
		}
		if(arrParasStr[1] == "default")
		{
			loginternal("random float with default: " $ string(class'XComEngine'.static.SyncFRand((string(Name) @ string(GetStateName())) @ string(GetFuncName()))), 'TestRandSeed');
		}
		if(arrParasStr[1] == "custom")
		{
			loginternal("random float with custom string: " $ string(class'XComEngine'.static.SyncFRand(arrParasStr[2])), 'TestRandSeed');
		}
	}
	if(arrParasStr[0] == "storeseed")
	{
		if(arrParasStr[1] == "randseed")
		{
			storedSeed = class'XComEngine'.static.GetARandomSeed();
			loginternal("stored random seed: " $ string(storedSeed), 'TestRandSeed');
		}
		if(arrParasStr[1] == "curseed")
		{
			storedSeed = class'XComEngine'.static.GetSyncSeed();
			loginternal("stored current seed: " $ string(storedSeed), 'TestRandSeed');
		}
		if(arrParasStr[1] == "lastseed")
		{
			storedSeed = class'XComEngine'.static.GetLastInitSeed();
			loginternal("stored last seed: " $ string(storedSeed), 'TestRandSeed');
		}
		if(arrParasStr[1] == "custom")
		{
			storedSeed = int(arrParasStr[2]);
			loginternal("stored custom seed: " $ string(storedSeed), 'TestRandSeed');
		}
	}
	if(arrParasStr[0] == "setseed")
	{
		if(arrParasStr[1] == "randseed")
		{
			class'XComEngine'.static.SetRandomSeeds(class'XComEngine'.static.GetARandomSeed());
			loginternal("set seed to random: " $ string(class'XComEngine'.static.GetSyncSeed()), 'TestRandSeed');
		}
		if(arrParasStr[1] == "lastseed")
		{
			class'XComEngine'.static.SetRandomSeeds(class'XComEngine'.static.GetLastInitSeed());
			loginternal("set seed to last: " $ string(class'XComEngine'.static.GetSyncSeed()), 'TestRandSeed');
		}
		if(arrParasStr[1] == "storedseed")
		{
			class'XComEngine'.static.SetRandomSeeds(storedSeed);
			loginternal("set seed to stored: " $ string(class'XComEngine'.static.GetSyncSeed()), 'TestRandSeed');
		}
		if(arrParasStr[1] == "custom")
		{
			class'XComEngine'.static.SetRandomSeeds(int(arrParasStr[2]));
			loginternal("set seed to custom: " $ string(class'XComEngine'.static.GetSyncSeed()), 'TestRandSeed');
		}
	}
	if(arrParasStr[0] == "getirand")
	{
		if(arrParasStr[2] == "testrandseed")
		{
			loginternal("random int max" @ arrParasStr[1] @ "with TestRandSeed: " $ string(class'XComEngine'.static.SyncRand(int(arrParasStr[1]), "TestRandSeed")), 'TestRandSeed');
		}
		if(arrParasStr[2] == "default")
		{
			loginternal("random int max" @ arrParasStr[1] @ "with default: " $ string(class'XComEngine'.static.SyncRand(int(arrParasStr[1]), (string(Name) @ string(GetStateName())) @ string(GetFuncName()))), 'TestRandSeed');
		}
		if(arrParasStr[2] == "custom")
		{
			loginternal("random int max" @ arrParasStr[1] @ "with custom string: " $ string(class'XComEngine'.static.SyncRand(int(arrParasStr[1]), arrParasStr[3])), 'TestRandSeed');
		}
	}
	if(arrParasStr[0] == "alterstoredseed")
	{
		if(arrParasStr[1] == "xor")
		{
			if(arrParasStr[2] == "cur")
			{
				str1 = string(storedseed);
				storedseed = storedseed ^ class'XComEngine'.static.GetSyncSeed();
				loginternal("xor'd stored seed:" @ str1 @ "into current seed:" @ string(class'XComEngine'.static.GetSyncSeed()) @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "random")
			{
				str1 = string(storedseed);
				str2 = string(class'XComEngine'.static.GetARandomSeed());
				storedseed = storedseed ^ int(str2);
				loginternal("xor'd stored seed:" @ str1 @ "into random seed:" @ str2 @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "time")
			{	
				str1 = string(storedseed);
				str2 = string(class'XComEngine'.static.GetCurrentTime());
				storedseed = storedseed ^ int(str2);
				loginternal("xor'd stored seed:" @ str1 @ "into current time:" @ str2 @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "devid")
			{
				str1 = string(storedseed);
				storedseed = storedseed ^ XComEngine(class'Engine'.static.GetEngine()).GetCurrentDeviceID();
				loginternal("xor'd stored seed:" @ str1 @ "into device ID:" @ string(XComEngine(class'Engine'.static.GetEngine()).GetCurrentDeviceID()) @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "custom")
			{
				str1 = string(storedseed);
				storedseed = storedseed ^ int(arrParasStr[3]);
				loginternal("xor'd stored seed:" @ str1 @ "into custom int:" @ arrParasStr[3] @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
		}
		if(arrParasStr[1] == "plus")
		{
			if(arrParasStr[2] == "cur")
			{
				str1 = string(storedseed);
				storedseed = storedseed + class'XComEngine'.static.GetSyncSeed();
				loginternal("plused stored seed:" @ str1 @ "into current seed:" @ string(class'XComEngine'.static.GetSyncSeed()) @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "random")
			{
				str1 = string(storedseed);
				str2 = string(class'XComEngine'.static.GetARandomSeed());
				storedseed = storedseed + int(str2);
				loginternal("plused stored seed:" @ str1 @ "into random seed:" @ str2 @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "time")
			{	
				str1 = string(storedseed);
				str2 = string(class'XComEngine'.static.GetCurrentTime());
				storedseed = storedseed + int(str2);
				loginternal("plused stored seed:" @ str1 @ "into current time:" @ str2 @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "devid")
			{
				str1 = string(storedseed);
				storedseed = storedseed + XComEngine(class'Engine'.static.GetEngine()).GetCurrentDeviceID();
				loginternal("plused stored seed:" @ str1 @ "into device ID:" @ string(XComEngine(class'Engine'.static.GetEngine()).GetCurrentDeviceID()) @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "custom")
			{
				str1 = string(storedseed);
				storedseed = storedseed + int(arrParasStr[3]);
				loginternal("plused stored seed:" @ str1 @ "into custom int:" @ arrParasStr[3] @ "with result:" @ string(storedseed), 'TestRandSeed');
			}	
		}
		if(arrParasStr[1] == "multi")
		{
			if(arrParasStr[2] == "cur")
			{
				str1 = string(storedseed);
				storedseed = storedseed * class'XComEngine'.static.GetSyncSeed();
				loginternal("multiplied stored seed:" @ str1 @ "into current seed:" @ string(class'XComEngine'.static.GetSyncSeed()) @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "random")
			{
				str1 = string(storedseed);
				str2 = string(class'XComEngine'.static.GetARandomSeed());
				storedseed = storedseed * int(str2);
				loginternal("multiplied stored seed:" @ str1 @ "into random seed:" @ str2 @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "time")
			{	
				str1 = string(storedseed);
				str2 = string(class'XComEngine'.static.GetCurrentTime());
				storedseed = storedseed * int(str2);
				loginternal("multiplied stored seed:" @ str1 @ "into current time:" @ str2 @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "devid")
			{
				str1 = string(storedseed);
				storedseed = storedseed * XComEngine(class'Engine'.static.GetEngine()).GetCurrentDeviceID();
				loginternal("multiplied stored seed:" @ str1 @ "into device ID:" @ string(XComEngine(class'Engine'.static.GetEngine()).GetCurrentDeviceID()) @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
			if(arrParasStr[2] == "custom")
			{
				str1 = string(storedseed);
				storedseed = storedseed * int(arrParasStr[3]);
				loginternal("multiplied stored seed:" @ str1 @ "into custom int:" @ arrParasStr[3] @ "with result:" @ string(storedseed), 'TestRandSeed');
			}
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
