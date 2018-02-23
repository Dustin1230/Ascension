class MyGame extends FrameworkGame;

event InitGame(string Options, out string ErrorMessage)
{
	
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return Default.Class;
}

DefaultProperties
{
}