class Mod_Checkpoint_StrategyTransport extends Checkpoint_StrategyTransport;

function addActorClass(class<Actor> ActorClassToRecord)
{
	ActorClassesToRecord.AddItem(ActorClassToRecord);
}

DefaultProperties
{
}
