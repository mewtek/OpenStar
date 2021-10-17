package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;

class Main extends Sprite
{
	// Settings for the OpenStar window.
	var gwidth:Int = 1920;
	var gheight:Int = 1080;
	var ginitState:Class<FlxState> = DebugMenu;
	var zoom:Int = 1;
	var framerate:Int = 60; // WE'RE RUNNING THE IS1 AT 60 FUCKING FPS!!! HOW DO YOU LIKE THAT, OBAMA!?
	var skipSplash:Bool = true;
	var startFullscreen:Bool = false;

	// Disable default HaxeFlixel volume control
	public function new()
	{
		super();
		addChild(new FlxGame(gwidth, gheight, ginitState, zoom, framerate, framerate, skipSplash, startFullscreen));
	}
}
