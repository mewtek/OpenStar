package;

import panels.CurrentConditions.CurrentConditions;
import panels.LocalForcast.LocalForecast;
import panels.TheWeekAhead.TheWeekAhead;
import panels.AirQuality.AirQuality;
import panels.Almanac.Almanac;
import APIHandler.CCVARS;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.system.debug.watch.Tracker;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class PresentationState extends FlxState
{
	private var OS_DEBUG:Bool;
	private var activeAlert:Bool;

	// Generic Graphics
	private var BG:FlxSprite;
	private var titleBorder:FlxSprite;

	// Sounds
	private var LOCALVOCAL_CC:FlxSound; // Current Condition narration
	private var LOCALVOCAL_TMP:FlxSound; // Temperature narration
	private var LOCALVOCAL_INTRO:FlxSound; // CC Intro
	private var music_playlist:Array<String>; // String array of every music file in assets/music/

	private var LDL:LowerDisplayLine;

	// Panels
	private var CC_PANEL:CurrentConditions;
	private var TWA_PANEL:TheWeekAhead;
	private var LF_PANEL:LocalForecast;


	private var Timers:ThunderStorm;

	override public function create():Void
	{

		FlxG.mouse.visible = false;
		FlxG.autoPause = false; // Disable the program pausing when the window is out of focus
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeDownKeys = null;
		FlxG.sound.volumeUpKeys = null;
		bgColor = 0x0047bb;

		// get information from IBM
		APIHandler.getLocalForecast();
		APIHandler.getCC();

		// Create generic graphics

		if (FlxG.save.data.OS_DEBUG)
		{
			FlxG.debugger.drawDebug = true;
			// vv Basically the WeatherSTAR 4000 BG gradient, a bit easier to see draw boxes with
			BG = FlxGradient.createGradientFlxSprite(1920, 1080, [FlxColor.fromString('0x1d0255'), FlxColor.fromString('0xba5c13')], 1, 90);
			add(BG);
		}
		else
		{
			BG = new FlxSprite().loadGraphic('assets/images/Backgrounds/Background-Normal.png');
			BG.screenCenter();
			BG.antialiasing = false;
			add(BG);
		}

		titleBorder = new FlxSprite().loadGraphic('assets/images/titles/title-parts/TITLE_BORDER.png');
		titleBorder.scale.set(0.65, 0.65);
        titleBorder.updateHitbox();
        titleBorder.setPosition(140, -18);       
        add(titleBorder);


		// Create timers
		Timers = new ThunderStorm();
		add(Timers);


		// makeMusicPL();

		// if (FlxG.sound.music == null)
		// {
		// 	FlxG.sound.playMusic(Resources.music(HelpfulFunctions.fromArray(music_playlist)), 0.8, false);
		// 	FlxG.sound.music.persist = false;
		// }

		// Add Panels

		CC_PANEL = new CurrentConditions();
		add(CC_PANEL);

		TWA_PANEL = new TheWeekAhead();
		// add(TWA_PANEL);

		LF_PANEL = new LocalForecast();
		// add(LF_PANEL);

		// Narrations

		if (FlxG.save.data.localVocal)
		{
			LOCALVOCAL_INTRO = FlxG.sound.load(Resources.narration("CC_INTRO1", null), 1.0, false, null, false, false, null, () -> LOCALVOCAL_TMP.play());
			LOCALVOCAL_TMP = FlxG.sound.load(Resources.narration('${APIHandler._CCVARS.temperature}', "temperatures"), 1.0, false, null, false, false, null,
				() -> LOCALVOCAL_CC.play());
			LOCALVOCAL_CC = FlxG.sound.load(Resources.narration('${APIHandler._CCVARS.ccIconCode}', "conditions"));

			new FlxTimer().start(0.2, timer -> LOCALVOCAL_INTRO.play());
		}


		LDL = new LowerDisplayLine(FlxColor.TRANSPARENT);
		openSubState(LDL);
	}

	function makeMusicPL():Array<String>
	{
		music_playlist = [];

		trace(FileSystem.readDirectory('assets/music'));

		for (i in 0...FileSystem.readDirectory('assets/music').length)
		{
			var filename:String = FileSystem.readDirectory('assets/music')[i];

			if (filename.endsWith('ogg'))
				music_playlist.push(FileSystem.readDirectory('assets/music')[i]);
			else
				trace('SKIPPING OVER ${FileSystem.readDirectory('assets/music')[i]} -- NOT A .OGG FILE');
		}

		trace(music_playlist);
		return music_playlist;

	}

	function finish()
	{
		// TODO
	}

	// Everything in this function will be called every frame
	// Remember to destroy your timers!
	override public function update(elapsed):Void
	{
		// // Lower audio when any of the local vocals are playing
		// if (LOCALVOCAL_INTRO.playing || LOCALVOCAL_TMP.playing || LOCALVOCAL_CC.playing && FlxG.sound.music != null)
		// 	FlxG.sound.music.volume = 0.1;
		// else
		// 	FlxG.sound.music.volume = 0.8;


		if(Timers.CC)
		{
			CC_PANEL.fadeIn();
			trace("FADING IN CC");
			
			if(CC_PANEL.fadedIn)
				Timers.CC = false;
		}

		if(Timers.RC)
		{
			CC_PANEL.fadeOut();

			if(CC_PANEL.fadedOut)
				Timers.RC = false;
		}

		super.update(elapsed);
	}
}
