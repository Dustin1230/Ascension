class MyMod extends XComMod within ModBridge
	config(MyMod);

struct TStruct
{
	var array<int> iVal;
};

var config TStruct Test;

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

	if(functionName == "TMenuTest")
	{
		TMenuTest();
	}

	if(functionName == "WithinTest")
	{
		WithinTest();
	}

}

function TestFunct(optional string optparas)
{
	`Log("Test successful, MyMod. parameter=" @ optparas);
}

function WithinTest()
{
	StrValue0("Test");
	`Log("StrValue0()=" @ StrValue0());
}

function TMenuTest()
{
	local TTableMenuOption kOption;

	kOption.arrStrings.AddItem("Test");
	`Log("kOption.arrStrings[0]=" @ kOption.arrStrings[0]);

	valTMenu.arrCategories[0] = 27;
	`Log("before change ModBridge.TMenu.arrCategories[0]=" @ string(TMenu().arrCategories[0]));

	TMenu(, true);
	TMenu().arrOptions.AddItem(kOption);
	`Log("after change ModBridge.TMenu.arrOptions[0].arrStrings[0]=" @ TMenu().arrOptions[0].arrStrings[0]);
	`Log("after change ModBridge.TMenu.arrCategories[0]=" @ string(TMenu().arrCategories[0]));
}

DefaultProperties
{
}
