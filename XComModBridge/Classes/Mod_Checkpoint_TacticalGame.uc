class Mod_Checkpoint_TacticalGame extends Checkpoint_TacticalGame;

function addActorClass(class<Actor> ActorClassToRecord)
{
	ActorClassesToRecord.AddItem(ActorClassToRecord);
}

DefaultProperties
{
}
