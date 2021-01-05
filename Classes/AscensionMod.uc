class AscensionMod extends ASC_CoreMod;

function ModInit()
{	
	if(functionName == "DrawWeaponRangeLines")
	{
		if(functparas != "") 
		{
			m_kASC_ItemMod.DrawWeaponRangeLines(vector(functparas));
		}
		else
		{
			m_kASC_ItemMod.DrawWeaponRangeLines(vect(0,0,0));
		}
	}
	
	if(functionName == "IncapTimer")
	{
		ASCSetUnit(StrValue0());
		m_kASC_PerksMod.IncapTimer();
		m_kUnit = none;
	}

	if(functionName == "ActivateAmnesia")
	{
		m_kASC_PerksMod.ActivateAmnesia();
	}

	if(functionName == "ResetXenocideCount")
	{
		ASCSetUnit(StrValue0());
		m_kASC_PerksMod.ResetXenocideCount();
		m_kUnit == none;
	}

	if(functionName == "XenocideCount")
	{
		ASCSetUnit(StrValue0());
		m_kASC_PerksMod.XenocideCount();
		m_kUnit = none;
	}

	if(functionName == "ASCOnKill")
	{
		m_kASC_PerksMod.ASCOnKill(StrValue0(), StrValue1());
	}

	if(functionName == "WepSpec")
    {
    	arrStr = SplitString(functParas, "_", false);
    	m_kASC_PerksMod.WepSpecPerk(int(arrStr[0]), arrStr[1]);
    }
}
		

DefaultProperties
{
}