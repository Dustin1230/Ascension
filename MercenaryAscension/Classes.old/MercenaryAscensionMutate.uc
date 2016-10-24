class MercenaryAscensionMutate extends XComMutator
	config(Mercenary);

struct TMercRanks
{
	var int iPerk;
	var int iPay;
	var array <int> iStat;
};
	
var localized string m_strNoCashForMercs; 
var localized string m_strHireMercs;
var localized array<string> arrStrMercMNicks;
var localized array<string> arrStrMercFNicks;
var localized array<string> arrStrNotMercMNicks;
var localized array<string> arrStrNotMercFNicks;
var localized string m_strMercClassName;
var localized string m_strNotMercClassName;
var config int m_iCostHireMerc;
var config float m_fNotMerc;
var config int m_iMercPay;
var config array<TMercRanks> MercPerks;
var array<int> NotMercStartPerks; 
var array<int> NotMercPool1;
var array<int> NotMercPool2;
var array<int> NotMercPool3;
var config int MercArmorTint;
var int NotMercArmorTint;
var config int MercHelmet;
var int NotMercHelmet;
var config int MercArmorDeco;
var int NotMercArmorDeco;
var config int MercMainWeapon;
var int NotMercMainWeapon;
  
function Mutate(string MutateString, PlayerController Sender)
{
  	local array<string> arrMutateStr;
	local XComMod Mod;
  
	`Log("Mutate: Mercenary");
  	if(MutateString == "MercMainMenu")
	{
		SetMercMainMenuVars();
	}
		if(MutateString == "MercUpdateHiring")
	{
		SetMercUpdateHiringVars();
	}
		if(Left(MutateString, 14) == "MercCreateSold")
	{
		arrMutateStr = SplitString(MutateString, "_", false);
		SetMercCreateSoldVars(int(arrMutateStr[1]));
	}
		if(Left(MutateString, 13) == "MercGetPerkCT")
	{
		arrMutateStr = SplitString(MutateString, "_", false);
		MercGetPerkCT(int(arrMutateStr[1]));
	}
		if(MutateString == "GetMercPerks")
	{
		NotMercPerks();
	}
		if(Left(MutateString, 11) == "MercGetNick")
	{
		arrMutateStr = SplitString(MutateString, "_", false);
		MercNicknames(int(arrMutateStr[1]));
	}
	if(Left(MutateString, 13) == "MercGetSalary")
	{
		arrMutateStr = SplitString(MutateString, "_", false);
		SetMercSalary(int(arrMutateStr[1]));
	}
	if(MutateString == "GetAllMercPay")
	{
		TotalMercSalary();
	}
	
	
	if(MutateString ~= "TestMod")
	{
		XComGameinfo(WorldInfo.Game).ModStartMatch();
		Foreach XComGameInfo(WorldInfo.Game).Mods(Mod)
		{
			LogInternal(Mod, 'XComMods');
			
			if(string(Mod) == "MyMod_0")
			{
				Mod.StartMatch();
			}
		}
	}
	super.Mutate(MutateString, Sender);
}

function XGSoldierUI SOLDIERUI()
{
	return XGSoldierUI(XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).GetMgr(class'XGSoldierUI',,, true));
}

function XGStrategySoldier SOLDIER()
{
	return SOLDIERUI().m_kSoldier;
}

function TSoldier SOLDIERT()
{
	return SOLDIER().m_kSoldier;
}

function XGParamTag TAG()
{
	return XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
}

function XGStrategy STRATEGY()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore();   
}

function XGHeadQuarters HQ()
{
    return STRATEGY().GetHQ();   
}

function XGFacility_Barracks BARRACKS()
{
 	return HQ().m_kBarracks;
}

function XGFacility_Lockers LOCKERS()
{
 	return BARRACKS().m_kLockers;
}

function XGTacticalGameCore TACTICAL()
{
    return XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kGameCore;
}

function SetMercMainMenuVars()
{
	TAG().strValue2 = m_strNoCashForMercs;
  	TAG().strValue2 $= "_" $ m_strHireMercs;
  	TAG().strValue2 $= "_" $ string(m_iCostHireMerc);
}

function SetMercUpdateHiringVars()
{	
  	TAG().strValue2 = m_strHireMercs;
  	TAG().strValue2 $= "_" $ string(m_iCostHireMerc); 
}

function bool PercentRoll(float percent)
{
	if(RandRange(0.99991, 100.99991) * (100.00 / (101.00 - percent)) > 99.99)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function SetMercCreateSoldVars(int SoldierID)
{
  	local XGStrategySoldier kSoldier;
	local TInventory kNewLoadout; 
  
	kSoldier = BARRACKS().GetSoldierByID(SoldierID);
  
	if(!PercentRoll(0.0))	
	{
		kSoldier.m_iEnergy = 8;
		kSoldier.m_kSoldier.kClass.eWeaponType = 5;
		kSoldier.m_kSoldier.kClass.strName = m_strMercClassName;
		TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 0, MercMainWeapon);
		TACTICAL().TInventoryLargeItemsSetItem(kSoldier.m_kBackedUpLoadout, 0, MercMainWeapon);
		LOCKERS().ApplySoldierLoadout(kSoldier, kNewLoadout);
		//Mutate("ASCRandomiseStats" $ "_" $ string(kSoldier.m_iEnergy));
		if(MercArmorTint >= 1)
		{
			kSoldier.m_kSoldier.kAppearance.iArmorTint = MercArmorTint;
		}
		if(MercHelmet >= 1)
		{
			kSoldier.m_kSoldier.kAppearance.iHaircut = MercHelmet;
		}
		if(MercArmorDeco >= 1)
		{
			kSoldier.m_kSoldier.kAppearance.iArmorDeco = MercArmorDeco; 
		}
		kSoldier.OnLoadoutChange();
	}
	else
	{
		kSoldier.m_iEnergy = 9;
		kSoldier.m_kSoldier.kClass.eWeaponType = 5;
		kSoldier.m_kSoldier.kClass.strName = m_strNotMercClassName;
		TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 0, NotMercMainWeapon);
		TACTICAL().TInventoryLargeItemsSetItem(kSoldier.m_kBackedUpLoadout, 0, NotMercMainWeapon);
		LOCKERS().ApplySoldierLoadout(kSoldier, kNewLoadout);
		if(MercArmorTint >= 1)
		{
			kSoldier.m_kSoldier.kAppearance.iArmorTint = NotMercArmorTint;
		}
			if(MercHelmet >= 1)
		{
			kSoldier.m_kSoldier.kAppearance.iHaircut = NotMercHelmet;
		}
		if(MercArmorDeco >= 1)
		{
			kSoldier.m_kSoldier.kAppearance.iArmorDeco = NotMercArmorDeco;
		}
		kSoldier.OnLoadoutChange();
	}
}

function TotalMercSalary()
{
	local XGStrategySoldier kSoldier;
	local XGParamTag kTag;
	local int totalCost, mercCost, basePay, I, Pay;
	
	kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
	
	basePay = m_iMercPay;
	totalCost = 0;
	mercCost = 0;
	foreach BARRACKS().m_arrSoldiers(kSoldier)
	{
		if(kSoldier.m_iEnergy == 8)
		{
			if(kSoldier.HasPerk(178))
			{
				basePay = 0;
			}
			for(I = 0; I < MercPerks.Length; I++)
			{
				`Log("SalaryCounterI= " $ I);
				if(MercPerks[I].iPay > 0)
				{
					if(kSoldier.HasPerk(MercPerks[I].iPerk))
					{
						Pay = MercPerks[I].iPay;
						`Log("Pay1= " $ Pay);
						if(kSoldier.HasPerk(178))
						{
							Pay = (MercPerks[I].iPay / 2);
							`Log("Pay2= " $ Pay);
						}
						mercCost += Pay;
						`Log("mercCost= " $ mercCost);
					}
				}
			}
			mercCost += basePay;
		}
	}
	totalCost += mercCost;
	`Log("totalCost= " $ totalCost);
	kTag.StrValue1 = string(totalCost);
}

function SetMercSalary(int MercClass)
{
	local XGStrategySoldier kSoldier;
	local int totalCost, basePay, I, Pay, iCount;
	
	iCount = 0;
	totalCost = 0;
	TAG().StrValue2 = "";
	foreach BARRACKS().m_arrSoldiers(kSoldier)
	{
		if(kSoldier.m_iEnergy == MercClass)
		{
			++ iCount;
			basePay = m_iMercPay;
			if(kSoldier.HasPerk(178))
			{
				basePay = 0;
			}
			for(I = 0; I < MercPerks.Length; I++)
			{
				`Log("MercSalaryI= " $ I);
				if(MercPerks[I].iPay > 0)
				{
					if(kSoldier.HasPerk(MercPerks[I].iPerk))
					{
						Pay = MercPerks[I].iPay;
						`Log("MercPay1= " $ Pay);
						if(kSoldier.HasPerk(178))
						{
							Pay = (MercPerks[I].iPay / 2);
							`Log("MercPay2= " $ Pay);
						}
						totalCost += Pay;
					}
				}
			}
			totalCost += basePay;
			`Log("MercTotal= " $ totalCost);
			TAG().StrValue2 = ((MercClass == 8) ? m_strMercClassName : ((MercClass == 9) ? m_strNotMercClassName : "MercFuryMEC")) @ "x" @ string(iCount) $ "_-" $ class'XGScreenMgr'.static.ConvertCashToString(totalCost);
		}
	}
}

function NotMercPerks()
{
	local XGStrategySoldier kSoldier;
  	local int Branch;
	local int Option;
  	local int I;
  	local int perk;
  
	kSoldier = XGSoldierUI(XComHQPresentationLayer(XComPlayerController(GetALocalPlayerController()).m_Pres).GetMgr(class'XGSoldierUI',,, true)).m_kSoldier;
  	Branch = kSoldier.GetAbilityTreeBranch();
  	Option = kSoldier.GetAbilityTreeOption();
  	
  	for(I = 0; I < 2; I++)
	{
		setperk:
		if(Branch == 1)
		{
			perk = NotMercStartPerks[Rand(3)];
		}
		if(Branch < 6 && Branch > 1)
		{
  			perk = NotMercPool1[Rand(NotMercPool1.Length)];
		}
		if(Branch == 6)
		{
			perk = NotMercPool2[Rand(NotMercPool2.Length)];
		}
		if(Branch == 7)
		{
			perk = NotMercPool3[Rand(NotMercPool3.Length)];
		}
		if(kSoldier.m_arrRandomPerks.find(EPerkType(perk)) != -1)
		{
			goto setperk; 
		}
		else
		{
			kSoldier.m_arrRandomPerks[((Branch - 1) * 3) + I] = EPerkType(perk);
		}
	}
  	kSoldier.GivePerk(kSoldier.m_arrRandomPerks[Option + ((Branch - 1) * 3)]);
}

function MercGetPerkCT(int SoldierID)
{
  	local XGStrategySoldier kSoldier;
  	local int I;
  
  	kSoldier = BARRACKS().GetSoldierByID(SoldierID);
  
  	if(kSoldier.m_iEnergy == 8)
	{
		for(I = 0; I < MercPerks.Length; I++)
		{
			kSoldier.m_arrRandomPerks.additem(EPerkType(MercPerks[I].iPerk));
		}
	}
  	if(kSoldier.m_iEnergy == 9)
	{
		for(I = 0; I < 21; I++)
		{
			kSoldier.m_arrRandomPerks.additem(EPerkType(46));
		}
	}
}
  
function MercNicknames(int SoldierID)
{
 	local XGStrategySoldier kSoldier;
  	local int iCounter;
  
  	kSoldier = BARRACKS().GetSoldierByID(SoldierID);
	iCounter = 20;
  	
  	newnick:
  	if(kSoldier.m_kSoldier.kAppearance.iGender == 1)
	{
		if(kSoldier.m_iEnergy == 8)
		{
			kSoldier.m_kSoldier.strNickName = arrStrMercMNicks[Rand(arrStrMercMNicks.Length)];
			if((BARRACKS().NickNameMatch(kSoldier)) && iCounter > 0)
			{
				-- iCounter;
				goto newnick;
			}
		}
		if(kSoldier.m_iEnergy == 9)
		{
			kSoldier.m_kSoldier.strNickName = arrStrNotMercMNicks[Rand(arrStrNotMercMNicks.Length)];
			if((BARRACKS().NickNameMatch(kSoldier)) && iCounter > 0)
			{
				-- iCounter;
				goto newnick;
			}
		}
	}
  	if(kSoldier.m_kSoldier.kAppearance.iGender == 2)
	{
		if(kSoldier.m_iEnergy == 8)
 		{
			kSoldier.m_kSoldier.strNickName = arrStrMercFNicks[Rand(arrStrMercFNicks.Length)];
			if((BARRACKS().NickNameMatch(kSoldier)) && iCounter > 0)
			{
				-- iCounter;
				goto newnick;
			}
		}
		if(kSoldier.m_iEnergy == 9)
		{
			kSoldier.m_kSoldier.strNickName = arrStrNotMercFNicks[Rand(arrStrNotMercFNicks.Length)];
			if((BARRACKS().NickNameMatch(kSoldier)) && iCounter > 0)
			{
				-- iCounter;
				goto newnick;
			}
		}
	}
}

defaultproperties 
{
	NotMercMainWeapon = 231
	NotMercArmorTint = 24
	NotMercHelmet = -1
	NotMercArmorDeco = 76
}