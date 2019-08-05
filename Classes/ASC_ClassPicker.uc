class ASC_ClassPicker extends ASC_SoldierMod
	config(ASC_Soldier);

struct TClassStats
{
	var int HPPts;
	var int DefPts;
	var int AimPts;
	var int MobPts;
	var int WillPts;
};

struct TPerkClassWeight
{
	var int iClass;
	var int Perk;
	var int Pts;
};

struct TClassNumWeight
{
	var int minDif;
	var int maxDif;
	var float fmaxGain;
	var float fminGain;
	var bool isMuliplier;
};

struct TClassRankWeight
{
	var int first;
	var int SecThruForth;
	var int others;
	var bool isWeightGroup;
};

var config array<TClassStats> m_kClassStats;
var config array<TPerkClassWeight> m_kPCWeight;
var config array<int> ClassesToCheck;
var array<int> ValidClasses;
var TClassNumWeight classNumWeight;
var TClassRankWeight classRankWeight;
var int storedSeed;
var int currentSeed;


function CreateSeed()
{
	storedseed = class'XComEngine'.static.GetARandomSeed();
	randloop0:
	if(Rand(3) == 0)
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
	randloop2_1:
	if(Rand(2) == 1)
	{
		storedseed = (storedseed >> 1) ^ class'XComEngine'.static.GetARandomSeed();
		goto randloop2_1;
	}
	randloop2_2:
	if(Rand(2) == 1)
	{
		storedseed = ((storedseed >> 2) ^ class'XComEngine'.static.GetCurrentTime() << 2) ^ storedseed;
		goto randloop2_2;
	}
	randloop2_3:
	if(Rand(2) == 1)
	{
		storedseed = ((storedseed << 1) ^ storedseed) ^ class'XComEngine'.static.GetARandomSeed();
		goto randloop2_3;
	}
	randloop3:
	if(Rand(2) == 1)
	{
		storedseed = storedseed ^ (Rand(2) == 1 ? 1 : -1) * Rand(100000000);
		goto randloop3;
	}
	if(Rand(10) == 0)
	{
		goto randloop0;
	}
	`log("storedseed=" @ string(storedseed));
}

function int SortA(int A, int B) {return A > B ? -1 : 0;}

function XComClassChooser(XGStrategySoldier Soldier)
{

	local TClassStats emptyClassStats, kClassStats, ClassStats;
	local int i, iNum, j, soldierSeed;
	local array<int> classPts, classNum, NumSorted, NumPos, classWgtPer, arrRandClassWgt, arrRandClassNum;
	local TPerkClassWeight kPCWeight;
	local XGStrategySoldier kSoldier;

	//loop through what all the stats are worth for each class from the config

	foreach m_kClassStats(kClassStats, i)
	{

		//if one of the enteries is blank or doesn't exist then skip it

		if(kClassStats == emptyClassStats)
		{
			continue;
		}

		//times each of the soldier's stats with the points that they are worth determined from the info collected from the config

		ClassStats.HPPts = kClassStats.HPPts * Soldier.m_kChar.aStats[0];
		ClassStats.DefPts = kClassStats.DefPts * Soldier.m_kChar.aStats[2];
		ClassStats.AimPts = kClassStats.AimPts * Soldier.m_kChar.aStats[1];
		ClassStats.MobPts = kClassStats.MobPts * Soldier.m_kChar.aStats[3];
		ClassStats.WillPts = kClassStats.WillPts * Soldier.m_kChar.aStats[7];

		//add all the points from the stats together and divide them by 5 for an average score from the stats

		classPts[i] = round((ClassStats.HPPts + ClassStats.DefPts + ClassStats.AimPts + ClassStats.MobPts + ClassStats.WillPts) / 5.0);
		ClassStats = emptyClassStats;

	}


	//loop through config entries and check if soldier has any perks listed and add points specified for the respective class

	foreach m_kPCWeight(kPCWeight)
	{
		if(kSoldier.HasPerk(kPCWeight.Perk))
		{
			classPts[kPCWeight.iClass] += kPCWeight.Pts;
		}
	}

	//loop through all the soldiers the in barracks that hold predetirmined classes and increment classNum on the entry that is the same as the class number

	foreach BARRACKS().m_arrSoldiers(kSoldier)
	{
		foreach ClassesToCheck(i)
		{
			if(kSoldier.m_iEnergy == i)
			{
				++classNum[kSoldier.m_iEnergy];
			}
		}
	}

	NumSorted = classNum;


	//loop through the NumSorted array and cull any entries that are blank or missing

	for(i=0; i < classNum.Length;i++)
	{
		if(NumSorted[i] == 0)
		{
			NumSorted.RemoveItem(0);
		}
	}


	//sort from lowest to highest then loop through NumSorted array to find the position of each entry in the classNum array and store it in NumPos for the benefit of finding the class number

	NumPos = SortAndStorePos(classNum, NumSorted);
	


	//set iNum to 0 then loop through classPts and store the highest value in iNum

	iNum = 0;
	for(i=0; i<classPts.Length; i++)
	{
		if(iNum < classPts[i])
		{
			iNum = classPts[i];
		}
	}
	

	//Compare each class amount number to the highest value see if the difference is within threshold and apply appropriate bonus points to class
	//if isMultiplier is set then bonus points is a multiplier of the highest previous class point value otherwise it is an amount between fminGain and fmaxGain depending on how close the difference is to minDif or maxDif

	for(i=0; i<NumSorted.Length; i++)
	{

		if((NumSorted[NumSorted.Length+1] - NumSorted[i]) >= classNumWeight.minDif)
		{
			if((NumSorted[NumSorted.Length+1] - NumSorted[i]) >= classNumWeight.maxDif)
			{
				if(classNumWeight.isMuliplier)
				{
					classPts[NumPos[i]] += iNum * classNumWeight.fmaxGain;
				}
				else
				{
					classPts[NumPos[i]] += classNumWeight.fmaxGain;
				}
			}
			else
			{
				if(classNumWeight.isMuliplier)
				{
					classPts[NumPos[i]] += iNum * (classNumWeight.fminGain + ((((NumSorted[NumSorted.Length+1] - NumSorted[i]) - classNumWeight.minDif) / classNumWeight.maxDif) * (classNumWeight.fmaxGain - classNumWeight.fminGain)));
				}
				else
				{
					classPts[NumPos[i]] += classNumWeight.fminGain + ((((NumSorted[NumSorted.Length+1] - NumSorted[i]) - classNumWeight.minDif) / classNumWeight.maxDif) * (classNumWeight.fmaxGain - classNumWeight.fminGain));
				}
			}
		}
	}



	/** 
	for(i=0; i<NumSorted.Length; i++)
	{
		classPts[NumPos[i]] += (i + 1) * round(float(classNumWeight.max - classNumWeight.min) / float(NumSorted.Length + 1)); 
	}
	*/



	//mirrors classPts into NumStored then cull blank entries before sorting form lowest to highest and stores original postions(class) in NumPos

	NumSorted = classPts;
	
	for(i=0; i<NumSorted.Length; i++)
	{
		if(NumSorted[i] == 0)
		{
			NumSorted.RemoveItem(0);
		}
	}

	NumPos = SortAndStorePos(classPts, NumSorted);


	//assign a percent number to each class based on it's rank in earlier point system

	if(classRankWeight.isWeightGroup)
	{
		iNum = classRankWeight.first + classRankWeight.SecThruForth + classRankWeight.others;
		for(i=NumSorted.Length; i>=0; i--)
		{
			if(i == NumSorted.Length)
			{
				classWgtPer[i] = round((float(classRankWeight.first) / float(iNum)) * 10.0);
			}
			else
			{
				if(i >= NumSorted.Length + 4)
				{
					classWgtPer[i] = round(((classRankWeight.SecThruForth / 3.0) / float(iNum)) * 10.0);
				}
				else
				{
					classWgtPer[i] = round(((classRankWeight.others / float(NumSorted.Length - 4)) / float(iNum)) * 10.0);
				}
			}
		}
	}
	else
	{
		iNum = classRankWeight.first + (classRankWeight.SecThruForth * 3) + (classRankWeight.others * (NumSorted.Length - 4));
		for(i=NumSorted.Length; i>=0; i--)
		{
			if(i == NumSorted.Length)
			{
				classWgtPer[i] = round((float(classRankWeight.first) / float(iNum)) * 10.0);
			}
			else
			{
				if(i >= NumSorted.Length + 4)
				{
					classWgtPer[i] = round((float(classRankWeight.SecThruForth) / float(iNum)) * 10.0);
				}
				else
				{
					classWgtPer[i] = round((float(classRankWeight.others) / float(iNum)) * 10.0);
				}
			}
		}
	}

	//create a seed for this specific soldier based only on it's ID

	soldierSeed = (kSoldier.m_kSoldier.iID * 100) ^ (kSoldier.m_kSoldier.iID * 10);
	soldierSeed = ((soldierSeed * 10) << 1) ^ (soldierSeed);
	soldierSeed = ((soldierSeed / 2) << 3) ^ (soldierSeed * 13);
	soldierSeed = (soldierSeed * 937) ^ (soldierSeed << 2);
	soldierSeed = ((soldierSeed ^ (soldierSeed >> 1)) / 2) ^ (soldierSeed / 2);

	//use created soldier seed with stored (campaign specific) seed

	soldierSeed = ((soldierSeed ^ storedSeed) + soldierSeed) ^ soldierSeed;

	//store current engine given seed to restore later

	currentSeed = class'XComEngine'.static.GetSyncSeed();
	
	//use stored (campaign specific) seed to randomise positions of classes and their percent weights in the array

	class'XComEngine'.static.SetRandomSeeds(storedSeed);
	arrRandClassWgt.Add(classWgtPer.Length);
	arrRandClassNum.add(classWgtPer.Length);
	for(i=0; i<classWgtPer.Length; i++)
	{
		iNum = class'XComEngine'.static.SyncRand(classWgtPer.Length + 1, "");
		arrRandClassWgt.InsertItem(iNum, classWgtPer[i]);
		arrRandClassNum.InsertItem(iNum, NumPos[i]);
		arrRandClassWgt.Remove(arrRandClassWgt.Find(0), 1);
		arrRandClassNum.Remove(arrRandClassNum.Find(0), 1);
	}

	//remove any blank entries

	if(arrRandClassNum.Find(0) != -1)
	{
		arrRandClassNum.RemoveItem(0);
		arrRandClassWgt.RemoveItem(0);
	}

	//use generated soldier+campaign seed to randomly detirmine which class to pick based on the percent weights given earlier

	class'XComEngine'.static.SetRandomSeeds(soldierSeed);

	iNum = class'XComEngine'.static.SyncRand(100, "");
	if(iNum > (100 - arrRandClassWgt[arrRandClassWgt.Length - 1]))
	{
		kSoldier.m_iEnergy = arrRandClassNum[arrRandClassWgt.Length - 1];
	}
	else
	{
		j = 0;

		for(i=0; i<arrRandClassNum.Length; i++)
		{
			j += arrRandClassNum[i];
			if(j >= iNum)
			{
				kSoldier.m_iEnergy = arrRandClassNum[i];
				break;
			}
		}
	}
	
}

function array<int> SortAndStorePos(array<int> arrOri, out array<int> arrSort)
{
	local int I, J;
	local array<int> arrOri2, arrPos;

	arrSort.Sort(SortA);
	arrOri2 = arrOri;

	for(I=0; I<arrSort.Length; I++)
	{
		if(I > 0)
		{
			if(arrSort[I] == arrSort[I-1])
			{
				++ J;
				arrOri2.RemoveItem(arrSort[I]);
				arrPos.AddItem(arrOri2.Find(arrSort[I]+1));
			}
			else
			{
				J = 0;
				arrOri2 = arrOri;
				arrPos.AddItem(arrOri.Find(arrSort[I]));
			}
		}
		else
		{
			arrPos.AddItem(arrOri.Find(arrSort[i]));
		}
	}

	return arrPos;

}

DefaultProperties
{
}
