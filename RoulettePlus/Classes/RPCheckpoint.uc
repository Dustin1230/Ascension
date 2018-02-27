class RPCheckpoint extends Actor;

struct TASCStorage
{
	var int perks[255];
	var array<int> state;
	var bool GunslingerState;
	var int XenocideCount;
	var int IncapTimer;
};

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

struct TSoldierStorage extends TASCStorage {
	var int SoldierID;
	var int RandomPerk;
	var array<int> RandomTree;
	var array<TStatStorage> StatStorage;
	var int SoldierSeed;
	var bool isNewType;
};

struct TAlienStorage extends TASCStorage {
	var int ActorNumber;
};

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
