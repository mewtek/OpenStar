package;

import flixel.FlxState;

// State for initalizing the API, rebuilding asset cache,
// and downloading data for the broadcast state.
class InitializationState extends FlxState
{
	override public function create()
	{
		trace("CREATE STATE");
	}

	override public function update(elapsed)
	{
		super.update(elapsed);
	}
}
