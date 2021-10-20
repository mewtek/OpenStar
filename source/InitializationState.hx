package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.BackgroundWorker;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import sys.FileSystem;

// State for initalizing the API, rebuilding asset cache,
// and downloading data for the broadcast state.
class InitializationState extends FlxState
{
	override public function create()
	{
		bgColor = FlxColor.WHITE;
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		trace("CREATE STATE");

		// Actual initalization stuff
		APIHandler.apiSetup(); // TODO: Add a check to see if a 200 is returned so we don't crash
		// APIHanler.getMap();

		var NOTICETEXT:FlxText;
		NOTICETEXT = new FlxText(0, FlxG.height - 250, 900, "OpenStar is starting.\nPress D to enter the configuration menu.");
		NOTICETEXT.setFormat(Resources.font('interstate-bold'), 30, FlxColor.BLACK, CENTER);
		NOTICETEXT.antialiasing = true;
		NOTICETEXT.screenCenter(X);
		add(NOTICETEXT);

		var LDL_LOADING:FlxSprite = new FlxSprite();
		LDL_LOADING.makeGraphic(1920, 172, FlxColor.BLACK);
		LDL_LOADING.screenCenter(X);
		LDL_LOADING.setPosition(0, FlxG.height - 165);
		add(LDL_LOADING);

		var OSLOGO:FlxSprite = new FlxSprite();
		var HXLOGO:FlxSprite = new FlxSprite();
		var FLXLOGO:FlxSprite = new FlxSprite();
		var OFLLOGO:FlxSprite = new FlxSprite();

		OSLOGO.loadGraphic(Resources.graphic('Logos', 'openstar_logo'));
		OSLOGO.scale.x = 0.4;
		OSLOGO.scale.y = 0.4;
		OSLOGO.updateHitbox();
		OSLOGO.screenCenter(XY);
		OSLOGO.antialiasing = true;
		add(OSLOGO);

		HXLOGO.loadGraphic(Resources.graphic('Logos', 'haxe'));
		HXLOGO.setPosition(0, 10);
		HXLOGO.antialiasing = true;
		add(HXLOGO);

		FLXLOGO.loadGraphic(Resources.graphic('Logos', 'haxeflixel'));
		FLXLOGO.setPosition(0, 80);
		FLXLOGO.screenCenter(X);
		FLXLOGO.antialiasing = true;
		add(FLXLOGO);

		OFLLOGO.loadGraphic(Resources.graphic('Logos', 'openfl'));
		OFLLOGO.setPosition(1400, 25);
		OFLLOGO.antialiasing = true;
		add(OFLLOGO);

		// give a 7 second delay before we launch into the presentation engine.
		new FlxTimer().start(7, timer -> FlxG.switchState(new PresentationState()));
	}

	override public function update(elapsed)
	{
		if (FlxG.keys.pressed.D)
			FlxG.switchState(new DebugMenu());

		super.update(elapsed);
	}
}
