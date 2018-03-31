class RPCheckpoint extends Actor;

// Class used for saving new perks and various additions to the game using external code

// Storage of different variables for use with new perks
struct TASCStorage
{
	var int perks[255];
	var array<int> state;
	var bool GunslingerState;
	var int XenocideCount;
	var int IncapTimer;
};

// Storage of stats related to perkstats
struct TStatStorage
{
	var int aim;
	var int will;
	var int def;
	var int HP;
	var int mob;
	var float DR;
	var int perk;
};

// Storage of new variables related to soldiers
struct TSoldierStorage extends TASCStorage {
	var int SoldierID;
	var int RandomPerk;
	var array<int> RandomTree;
	var array<TStatStorage> StatStorage;
	var int SoldierSeed;
	var bool isNewType;
	var bool advServos;
};

// Storage of the alien "spawn" IDs - Aliens are not assigned IDs but are given a number when spawned on a map
struct TAlienStorage extends TASCStorage {
	var int ActorNumber;
};

// Link to exsiting game save system "CheckpointRecord"
struct CheckpointRecord
{
	var array<TSoldierStorage> arrSoldierStorage;
	var array<TAlienStorage> arrAlienStorage;
};

var array<TSoldierStorage> arrSoldierStorage;
var array<TAlienStorage> arrAlienStorage;

DefaultProperties
{
}
