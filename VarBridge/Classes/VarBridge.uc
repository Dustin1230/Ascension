Class VarBridge extends XcomMod;

var string valStrValue0;
var string valStrValue1;
var string valStrValue2;
var int valIntValue0;
var int valIntValue1;
var int valIntValue2;
var array<string> valArrStr;
var array<int> valArrInt;


simulated function StartMatch()
{
	`Log("MyMod: StartMatch");
}

function string StrValue0(optional string str, optional bool bForce)
{
	if(str == "" && !bForce)
	{
		return valStrValue0;
	}
	else
	{
		valStrValue0 = str;
		return "";
	}
}

function string StrValue1(optional string str, optional bool bForce)
{
	if(str == "" && !bForce)
	{
		return valStrValue1;
	}
	else
	{
		valStrValue1 = str;
		return "";
	}
}

function string StrValue2(optional string str, optional bool bForce)
{
	if(str == "" && !bForce)
	{
		return valStrValue2;
	}
	else
	{
		valStrValue2 = str;
		return "";
	}
}

function int IntValue0(optional int I = -1, optional bool bForce)
{
	if((I == 0 || I == -1) && !bForce)
	{
		return valIntValue0;
	}
	else
	{
		valIntValue0 = I;
		return 0;
	}
}

function int IntValue1(optional int I = -1, optional bool bForce)
{
	if((I == 0 || I == -1) && !bForce)
	{
		return valIntValue1;
	}
	else
	{
		valIntValue1 = I;
		return 0;
	}
}

function int IntValue2(optional int I = -1, optional bool bForce)
{
	if((I == 0 || I == -1) && !bForce)
	{
		return valIntValue2;
	}
	else
	{
		valIntValue2 = I;
		return 0;
	}
}

function array<string> arrStrings(optional array<string> arrStr, optional bool bForce)
{
	if(arrStr.Length == 0 && !bForce)
	{
		return valArrStr;
	}
	else
	{
		valArrStr = arrStr;
		return returnvalue;
	}

}

function array<int> arrInts(optional array<int> arrInt, optional bool bForce)
{
	if(arrInt.Length == 0 && !bForce)
	{
		return valArrInt;
	}
	else
	{
		valArrInt = arrInt;
		return returnvalue;
	}
}