package;

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
import haxe.io.Path;
import lime.app.Future;
import lime.math.BGRA;
import lime.media.AudioBuffer;
import lime.utils.Resource;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class PresentationState extends FlxState
{
	private var OS_DEBUG:Bool;
	private var activeAlert:Bool;

	// Generic Graphics
	private var BG:FlxSprite;
	private var baroArrow:FlxSprite; // Genuinely thought this was a hilarious name for no reason
	private var aqArrow:FlxSprite;

	// Panels
	private var ccPanel:FlxSprite;
	private var lfPanel:FlxSprite;
	private var twaPanel:FlxSprite;
	private var noaaPanel:FlxSprite;

	// Panel Titles
	private var ccTitle:FlxSprite; // Current Conditions
	private var lfTitle:FlxSprite; // Local Forecast
	private var rrTitle:FlxSprite; // Regional Radar
	private var lrTitle:FlxSprite; // Local Radar
	private var drTitle:FlxSprite; // Satellite Radar (radar satellite)
	private var alTitle:FlxSprite; // Almanac
	private var twaTitle:FlxSprite; // The Week Ahead

	// Current condtitions panel
	private var CCTXT:FlxTypedGroup<FlxText>;

	private var ccIcon:FlxSprite;
	private var rhLabel:FlxText = new FlxText(828, 285, 'HUMIDITY');
	private var dpLabel:FlxText = new FlxText(668, 385, 450, 'DEW POINT');
	private var baroLabel:FlxText = new FlxText(668, 485, 450, 'PRESSURE');
	private var visLabel:FlxText = new FlxText(668, 585, 450, 'VISBILITY');
	private var wndLabel:FlxText = new FlxText(668, 685, 450, 'WIND');
	private var gustLabel:FlxText = new FlxText(668, 785, 450, 'GUSTS');

	private var cc_cityName:FlxText;
	private var condTxt:FlxText;
	private var tmpTxt:FlxText;
	private var rhTxt:FlxText;
	private var dpTxt:FlxText;
	private var baroTxt:FlxText;
	private var visTxt:FlxText;
	private var wndTxt:FlxText;
	private var gustTxt:FlxText;

	// 36-Hour forecast panel
	private var DOWTXT:FlxTypedGroup<FlxText>;
	private var NARRATIVES:FlxTypedGroup<FlxText>;
	private var lf_cityName:FlxText;

	// The Week Ahead panel
	private var twaIcons:FlxTypedGroup<FlxSprite>;
	private var twaHiTemps:FlxTypedGroup<FlxText>;
	private var twaLoTemps:FlxTypedGroup<FlxText>;
	private var twaPhrases:FlxTypedGroup<FlxText>;
	private var twaDays:FlxTypedGroup<FlxText>;
	private var twaWeekend:FlxTypedGroup<FlxSprite>;

	// Sounds
	private var LOCALVOCAL_CC:FlxSound; // Current Condition narration
	private var LOCALVOCAL_TMP:FlxSound; // Temperature narration
	private var LOCALVOCAL_INTRO:FlxSound; // CC Intro
	private var music_playlist:Array<String>; // String array of every music file in assets/music/

	// Maps
	private var map:FlxSprite;

	// LOT8 Slide bools
	private var CC:Bool;
	private var CCFO:Bool;
	private var RR:Bool;
	private var DR:Bool;
	private var TWA:Bool;
	private var finished:Bool;

	// this is a stupid way of doing this lmao
	private var LF:Bool;
	private var LF_0:Bool;
	private var LF_1:Bool;
	private var LF_2:Bool;
	private var LF_3:Bool;
	private var LF_4:Bool;

	private var LDL:LowerDisplayLine;

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

		trace(FlxG.save.data.apiKey);
		OS_DEBUG = FlxG.save.data.OS_DEBUG;

		// CREATE BACKGROUND

		if (OS_DEBUG)
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

		makeMusicPL();

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Resources.music(HelpfulFunctions.fromArray(music_playlist)), 0.8, false);
			FlxG.sound.music.persist = false;
		}

		// create map
		// map = new FlxSprite(0, 0);
		// map.loadGraphic(FlxAssets.getBitmapData('assets/images/radar/map.png'));
		// map.scale.x = 0.8;
		// map.scale.y = 0.8;
		// map.antialiasing = true;
		// map.alpha = 0;
		// map.screenCenter(XY);
		// add(map);

		// CREATE PANEL TITLES \\

		// Title Textures

		var ccTitleTex = Resources.graphic('titles', 'current_conditions');
		var lfTitleTex = Resources.graphic('titles', 'local-forecast');
		var rrTitleTex = Resources.graphic('titles', 'regional_radar');
		var lrTitleTex = Resources.graphic('titles', 'local_radar');
		var drTitleTex = Resources.graphic('titles', 'radar_satellite');
		var alTitleTex = Resources.graphic('titles', 'almanac');
		var twaTitleTex = Resources.graphic('titles', '7day_outlook');

		ccTitle = new FlxSprite(-174, -58);
		ccTitle.loadGraphic(ccTitleTex);
		ccTitle.scale.x = 0.65;
		ccTitle.scale.y = 0.65;
		ccTitle.antialiasing = true;
		ccTitle.alpha = 0;
		add(ccTitle);

		lfTitle = new FlxSprite(-174, -58);
		lfTitle.loadGraphic(lfTitleTex);
		lfTitle.scale.x = 0.65;
		lfTitle.scale.y = 0.65;
		lfTitle.antialiasing = true;
		lfTitle.alpha = 0;
		add(lfTitle);

		rrTitle = new FlxSprite(-174, -58);
		rrTitle.loadGraphic(rrTitleTex);
		rrTitle.scale.x = 0.65;
		rrTitle.scale.y = 0.65;
		rrTitle.antialiasing = true;
		rrTitle.alpha = 0;
		add(rrTitle);

		lrTitle = new FlxSprite(-174, -58);
		lrTitle.loadGraphic(lrTitleTex);
		lrTitle.scale.x = 0.65;
		lrTitle.scale.y = 0.65;
		lrTitle.antialiasing = true;
		lrTitle.alpha = 0;
		add(lrTitle);

		drTitle = new FlxSprite(-174, -58);
		drTitle.loadGraphic(drTitleTex);
		drTitle.scale.x = 0.65;
		drTitle.scale.y = 0.65;
		drTitle.antialiasing = true;
		drTitle.alpha = 0;
		add(drTitle);

		alTitle = new FlxSprite(-174, -58);
		alTitle.loadGraphic(alTitleTex);
		alTitle.scale.x = 0.65;
		alTitle.scale.y = 0.65;
		alTitle.antialiasing = true;
		alTitle.alpha = 0;
		add(alTitle);

		twaTitle = new FlxSprite(-174, -58);
		twaTitle.loadGraphic(twaTitleTex);
		twaTitle.scale.x = 0.65;
		twaTitle.scale.y = 0.65;
		twaTitle.antialiasing = true;
		twaTitle.alpha = 0;
		add(twaTitle);

		// CREATE PANELS \\

		// Panel Textures
		var ccPanelTex = Resources.graphic('Panels', 'Current-Conditions');
		var lfPanelTex = Resources.graphic('Panels', 'Local-Forecast');
		var twaPanelTex = Resources.graphic('Panels', 'The-Week-Ahead');
		var noaaPanelTex = Resources.graphic('Panels', 'Weather-Bulletin');

		ccPanel = new FlxSprite(0, 165);
		ccPanel.loadGraphic(ccPanelTex);
		ccPanel.screenCenter(X);
		ccPanel.antialiasing = true;
		ccPanel.alpha = 0;
		add(ccPanel);

		lfPanel = new FlxSprite(0, 165);
		lfPanel.loadGraphic(lfPanelTex);
		lfPanel.screenCenter(X);
		lfPanel.antialiasing = true;
		lfPanel.alpha = 0;
		add(lfPanel);

		twaPanel = new FlxSprite(0, 165);
		twaPanel.loadGraphic(twaPanelTex);
		twaPanel.screenCenter(X);
		twaPanel.antialiasing = true;
		twaPanel.alpha = 0;
		add(twaPanel);

		// Panel logic

		// Current condtions

		// check to see if an icon exists
		if (FileSystem.exists(Resources.icon(APIHandler._CCVARS.ccIconCode)))
		{
			ccIcon = new FlxSprite().loadGraphic(Resources.icon(APIHandler._CCVARS.ccIconCode), false);
		}
		else
		{
			trace('FAILED TO FIND ICON CODE ${APIHandler._CCVARS.ccIconCode}, DEFAULTING TO N/A ICON');
			ccIcon = new FlxSprite().loadGraphic(Resources.icon('44'), false);
		}

		ccIcon.scale.set(1.7, 1.7);
		ccIcon.updateHitbox();
		ccIcon.setPosition(268, 320);
		ccIcon.antialiasing = true;

		// create barometric pressure trend graphic
		switch (APIHandler._CCVARS.baroTrend)
		{
			case "Steady":
				baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'steady'));
			case "Rising":
				baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'arrow'));
			case "Rapidly Rising":
				baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'arrow'));
			case "Falling":
				baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'arrow'));
				baroArrow.angle = 180;
			case "Rapidly Falling":
				baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'arrow'));
				baroArrow.angle = 180;
		}

		baroArrow.scale.x = 0.25;
		baroArrow.scale.y = 0.25;
		baroArrow.updateHitbox();
		baroArrow.antialiasing = true;
		baroArrow.setPosition(1485, 500);
		baroArrow.alpha = 0;
		add(baroArrow);

		// Text elements
		CCTXT = new FlxTypedGroup<FlxText>();

		cc_cityName = new FlxText(150, 176, 0, APIHandler._LOCATIONDATA.cityName.toUpperCase());
		condTxt = new FlxText(275, 550, 200, APIHandler._CCVARS.currentCondition);
		tmpTxt = new FlxText(260, 725, 225, '${APIHandler._CCVARS.temperature}');
		rhTxt = new FlxText(1200, 265, 255, '${APIHandler._CCVARS.relHumidity}%');
		dpTxt = new FlxText(1200, 365, 500, '${APIHandler._CCVARS.dewpoint}°');
		baroTxt = new FlxText(1200, 465, 500, '${APIHandler._CCVARS.baroPressure}');
		visTxt = new FlxText(1200, 565, 500, 'N/A');
		wndTxt = new FlxText(1200, 665, 500, '${APIHandler._CCVARS.windSpd}');
		gustTxt = new FlxText(1200, 765, 500, 'None');

		condTxt.setFormat(Resources.font('interstate-bold'), 50, FlxColor.WHITE, CENTER);
		tmpTxt.setFormat(Resources.font('interstate-bold'), 115, CENTER);
		cc_cityName.setFormat(Resources.font('interstate-bold'), 70, FlxColor.YELLOW);

		rhTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
		dpTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
		baroTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
		visTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
		wndTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
		gustTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);

		rhLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
		dpLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
		dpLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
		baroLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
		visLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
		wndLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
		gustLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);

		CCTXT.add(cc_cityName);

		CCTXT.add(condTxt);
		CCTXT.add(tmpTxt);
		CCTXT.add(rhTxt);
		CCTXT.add(dpTxt);
		CCTXT.add(baroTxt);
		CCTXT.add(visTxt);
		CCTXT.add(wndTxt);
		CCTXT.add(gustTxt);

		// add labels
		CCTXT.add(rhLabel);
		CCTXT.add(dpLabel);
		CCTXT.add(baroLabel);
		CCTXT.add(visLabel);
		CCTXT.add(wndLabel);
		CCTXT.add(gustLabel);

		// add graphical elements
		add(ccIcon);

		// set alpha + enable antialiasing
		for (i in 0...CCTXT.members.length)
		{
			CCTXT.members[i].antialiasing = true;
			CCTXT.members[i].alpha = 0;
		}
		ccIcon.alpha = 0;

		add(CCTXT);

		// 7-Day Outlook
		twaIcons = new FlxTypedGroup<FlxSprite>();
		twaHiTemps = new FlxTypedGroup<FlxText>();
		twaLoTemps = new FlxTypedGroup<FlxText>();
		twaPhrases = new FlxTypedGroup<FlxText>();
		twaDays = new FlxTypedGroup<FlxText>();
		twaWeekend = new FlxTypedGroup<FlxSprite>();

		for (i in 0...7)
		{
			// Icons
			var icon:FlxSprite;
			if (FileSystem.exists(Resources.icon(APIHandler._SEVENDAYDATA.iconCodes[i])))
			{
				icon = new FlxSprite().loadGraphic(Resources.icon(APIHandler._SEVENDAYDATA.iconCodes[i]), false);
			}
			else
			{
				trace('FAILED TO FIND ICON CODE ${APIHandler._SEVENDAYDATA.iconCodes[i]}, DEFAULTING TO N/A ICON');
				icon = new FlxSprite().loadGraphic(Resources.icon('44'), false);
			}

			icon.antialiasing = true;
			icon.scale.x = 1.5;
			icon.scale.y = 1.5;
			icon.updateHitbox();
			icon.setPosition((twaIcons.members[i - 1] != null ? twaIcons.members[i - 1].x + 235 : 160), 330);
			icon.ID = i;
			twaIcons.add(icon);

			// Hi/Lo Temperature Labels
			var hiTemp:FlxText;
			hiTemp = new FlxText((twaHiTemps.members[i - 1] != null ? twaHiTemps.members[i - 1].x + 235 : 155), 625, 200, APIHandler._SEVENDAYDATA.hiTemps[i]);
			hiTemp.setFormat(Resources.font('interstate-bold'), 100, FlxColor.WHITE, CENTER);
			hiTemp.antialiasing = true;
			hiTemp.ID = i;
			twaHiTemps.add(hiTemp);

			var loTemp:FlxText;
			loTemp = new FlxText((twaLoTemps.members[i - 1] != null ? twaLoTemps.members[i - 1].x + 235 : 155), 725, 200, APIHandler._SEVENDAYDATA.loTemps[i]);
			loTemp.setFormat(Resources.font('interstate-bold'), 100, FlxColor.WHITE, CENTER);
			loTemp.antialiasing = true;
			loTemp.ID = i;
			twaLoTemps.add(loTemp);

			// Days + Weekend rectangle graphic
			var DOW:FlxText;
			DOW = new FlxText((twaDays.members[i - 1] != null ? twaDays.members[i - 1].x + 235 : 176), 280, 150, APIHandler._SEVENDAYDATA.dow[i]);
			DOW.setFormat(Resources.font('interstate-light'), 50, (APIHandler._SEVENDAYDATA.isWeekend[i] ? FlxColor.fromString("0x102a70") : FlxColor.WHITE),
				CENTER);
			DOW.antialiasing = true;
			DOW.ID = i;
			twaDays.add(DOW);

			var WEEKEND_RECT:FlxSprite;
			WEEKEND_RECT = new FlxSprite((twaWeekend.members[i - 1] != null ? twaWeekend.members[i - 1].x + 235 : 145.5),
				274).makeGraphic(218, 60, FlxColor.WHITE);
			WEEKEND_RECT.antialiasing = true;
			WEEKEND_RECT.visible = APIHandler._SEVENDAYDATA.isWeekend[i];
			WEEKEND_RECT.alpha = 0.95;
			WEEKEND_RECT.ID = i;
			twaWeekend.add(WEEKEND_RECT);
		}

		for (i in 0...twaDays.members.length)
		{
			twaDays.members[i].alpha = 0;
			twaWeekend.members[i].alpha = 0;
			twaHiTemps.members[i].alpha = 0;
			twaLoTemps.members[i].alpha = 0;
			twaIcons.members[i].alpha = 0;
		}

		add(twaIcons);
		add(twaHiTemps);
		add(twaLoTemps);
		add(twaWeekend);
		add(twaDays);

		// 36-hour forecast
		DOWTXT = new FlxTypedGroup<FlxText>();
		NARRATIVES = new FlxTypedGroup<FlxText>();

		lf_cityName = new FlxText(150, 176, 0, APIHandler._LOCATIONDATA.cityName.toUpperCase());
		lf_cityName.setFormat(Resources.font('interstate-bold'), 70, FlxColor.YELLOW);
		lf_cityName.antialiasing = true;
		lf_cityName.alpha = 0;

		// tfw I was about to do this by making a shitload of FlxText variables
		// https://github.com/AyeTSG/Funkin_SmallThings/blob/master/source/OptionsMenu.hx
		for (i in 0...APIHandler._FORECASTDATA.daypart_name.length)
		{
			var txt = new FlxText(150, 275, 700, APIHandler._FORECASTDATA.daypart_name[i]);
			txt.setFormat(Resources.font('interstate-regular'), 70, FlxColor.YELLOW, LEFT);
			txt.alpha = 0;
			txt.antialiasing = true;
			txt.ID = i;
			DOWTXT.add(txt);
		}

		for (i in 0...APIHandler._FORECASTDATA.narrative.length)
		{
			var txt = new FlxText(150, 350, 1620, APIHandler._FORECASTDATA.narrative[i]);
			txt.setFormat(Resources.font('interstate-bold'), 65, FlxColor.WHITE, LEFT);
			txt.alpha = 0;
			txt.antialiasing = true;
			txt.ID = i;
			NARRATIVES.add(txt);
		}

		add(lf_cityName);
		add(DOWTXT);
		add(NARRATIVES);

		// Narrations

		if (FlxG.save.data.localVocal)
		{
			LOCALVOCAL_INTRO = FlxG.sound.load(Resources.narration("CC_INTRO1", null), 1.0, false, null, false, false, null, () -> LOCALVOCAL_TMP.play());
			LOCALVOCAL_TMP = FlxG.sound.load(Resources.narration('${APIHandler._CCVARS.temperature}', "temperatures"), 1.0, false, null, false, false, null,
				() -> LOCALVOCAL_CC.play());
			LOCALVOCAL_CC = FlxG.sound.load(Resources.narration('${APIHandler._CCVARS.ccIconCode}', "conditions"));

			/*
				I genuinely don't know why, but for some god-forsaken reason,
				using the StartTime variable in the play() function for FlxG doesn't actually
				do anything besides completely ignoring the onComplete() function that's done when
				these are all loaded into the state.
			 */
			new FlxTimer().start(0.2, timer -> LOCALVOCAL_INTRO.play());
		}
		else
			trace("Skipping local vocal initalization because it's false..");

		createPresentationTimers();

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

	function createPresentationTimers():Void // Real units keep all of these within 2 Minutes (120 seconds), so everything should be at 7-second intervals.
	{
		var timers:Array<FlxTimer> = FlxTimer.globalManager._timers;
		trace("Created Presentation Timers");
		new FlxTimer().start(0, timer -> CC = true); // Current Conditions
		new FlxTimer().start(7, timer -> CCFO = true); // Current Conditions Fade Out
		new FlxTimer().start(14, timer -> RR = true); // Regional Radar
		new FlxTimer().start(21, timer -> DR = true); // Doppler Radar
		new FlxTimer().start(28, timer -> LF = true);

		// Local Forecast Text switching
		// I'm aware of how messy this is, but this is legit something that needs to be done so I can
		// avoid the FPS going to hell.
		// ^^ see https://github.com/Zeexel/OpenStar/commit/59891df5683bdd80707f6fd9d7f95c1b88ccf907 line 590.

		// The timers for these are usually decided by the narration and when it completes,
		// but we don't have any of the full out LF narrations. So, for now they're about 7 seconds each.
		new FlxTimer().start(28, timer -> LF_0 = true);
		new FlxTimer().start(35, timer -> LF_1 = true);
		new FlxTimer().start(42, timer -> LF_2 = true);
		new FlxTimer().start(49, timer -> LF_3 = true);
		new FlxTimer().start(56, timer -> LF_4 = true);

		// Back to panels, then we're done!
		new FlxTimer().start(63, timer -> TWA = true);
		new FlxTimer().start(70, timer -> finished = true);
	}

	// Everything in this function will be called every frame
	// Remember to destroy your timers!
	override public function update(elapsed):Void
	{
		// Lower audio when any of the local vocals are playing
		if (LOCALVOCAL_INTRO.playing || LOCALVOCAL_TMP.playing || LOCALVOCAL_CC.playing && FlxG.sound.music != null)
			FlxG.sound.music.volume = 0.1;
		else
			FlxG.sound.music.volume = 0.8;

		// LOT8
		// Current Conditions
		if (CC == true)
		{
			trace("CC IS TRUE!!!");
			ccPanel.alpha += 0.1;
			ccTitle.alpha += 0.1;
			ccIcon.alpha += 0.1;
			baroArrow.alpha += 0.1;

			for (i in 0...CCTXT.members.length)
			{
				CCTXT.members[i].alpha += 0.1;

				if (CCTXT.members[i].alpha >= 1)
					CCTXT.members[i].alpha = 1;
			}

			if (ccPanel.alpha >= 1)
			{
				ccPanel.alpha = 1;
				ccTitle.alpha = 1;
				ccIcon.alpha = 1;
				baroArrow.alpha = 1;
				CC = false;
			}
		}

		// Current Conditions Fadeout
		if (CCFO == true)
		{
			trace("FADING OUT OF CURRENT CONDITIONS");

			ccPanel.alpha -= 0.3;
			ccIcon.alpha -= 0.3;
			baroArrow.alpha -= 0.3;

			for (i in 0...CCTXT.members.length)
			{
				CCTXT.members[i].alpha -= 0.3;

				if (CCTXT.members[i].alpha == 0)
					remove(CCTXT);
			}

			if (ccPanel.alpha == 0)
			{
				remove(ccPanel);
				remove(ccIcon);
				remove(baroArrow);
				CCFO = false;
			}
		}

		// Regional Radar
		if (RR == true)
		{
			trace("REGIONAL RADAR");
			rrTitle.alpha += 0.1;
			ccTitle.alpha -= 0.3;

			if (ccTitle.alpha == 0)
				remove(ccTitle);

			if (rrTitle.alpha >= 1)
			{
				rrTitle.alpha = 1;
				RR = false;
			}
		}
		// Doppler Radar
		if (DR == true)
		{
			trace("DOPPLER RADAR FADE IN");

			drTitle.alpha += 0.1;
			rrTitle.alpha -= 0.1;

			if (rrTitle.alpha == 0)
			{
				remove(rrTitle);
			}

			if (drTitle.alpha >= 1)
			{
				drTitle.alpha = 1;
				DR = false;
			}
		}

		// LOCAL FORECAST
		if (LF == true)
		{
			lfTitle.alpha += 0.1;
			lfPanel.alpha += 0.1;
			lf_cityName.alpha += 0.1;
			drTitle.alpha -= 0.3;

			if (drTitle.alpha == 0)
			{
				remove(drTitle);
			}

			if (lfTitle.alpha >= 1)
			{
				lfTitle.alpha = 1;
				lfPanel.alpha = 1;
				lf_cityName.alpha = 1;
				LF = false;
			}
		}

		if (LF_0 == true)
		{
			DOWTXT.members[0].alpha += 0.1;
			NARRATIVES.members[0].alpha += 0.1;

			if (DOWTXT.members[0].alpha >= 1)
				LF_0 = false;
		}

		if (LF_1 == true)
		{
			if (DOWTXT.members[0] != null)
			{
				DOWTXT.members[0].alpha -= 0.3;
				NARRATIVES.members[0].alpha -= 0.3;

				if (DOWTXT.members[0].alpha == 0)
				{
					DOWTXT.remove(DOWTXT.members[0]);
					NARRATIVES.remove(NARRATIVES.members[0]);
				}
			}

			DOWTXT.members[1].alpha += 0.1;
			NARRATIVES.members[1].alpha += 0.1;

			if (DOWTXT.members[1].alpha >= 1)
				LF_1 = false;
		}

		if (LF_2 == true)
		{
			if (DOWTXT.members[1] != null)
			{
				DOWTXT.members[1].alpha -= 0.3;
				NARRATIVES.members[1].alpha -= 0.3;

				if (DOWTXT.members[1].alpha == 0)
				{
					DOWTXT.remove(DOWTXT.members[1]);
					NARRATIVES.remove(NARRATIVES.members[1]);
				}
			}

			DOWTXT.members[2].alpha += 0.1;
			NARRATIVES.members[2].alpha += 0.1;

			if (DOWTXT.members[2].alpha >= 1)
				LF_2 = false;
		}

		if (LF_3 == true)
		{
			if (DOWTXT.members[2] != null)
			{
				DOWTXT.members[2].alpha -= 0.3;
				NARRATIVES.members[2].alpha -= 0.3;

				if (DOWTXT.members[2].alpha == 0)
				{
					DOWTXT.remove(DOWTXT.members[2]);
					NARRATIVES.remove(NARRATIVES.members[2]);
				}
			}

			DOWTXT.members[3].alpha += 0.1;
			NARRATIVES.members[3].alpha += 0.1;

			if (DOWTXT.members[3].alpha >= 1)
				LF_3 = false;
		}

		if (LF_4 == true)
		{
			if (DOWTXT.members[3] != null)
			{
				DOWTXT.members[3].alpha -= 0.3;
				NARRATIVES.members[3].alpha -= 0.3;

				if (DOWTXT.members[3].alpha == 0)
				{
					DOWTXT.remove(DOWTXT.members[3]);
					NARRATIVES.remove(NARRATIVES.members[3]);
				}
			}

			DOWTXT.members[4].alpha += 0.1;
			NARRATIVES.members[4].alpha += 0.1;

			if (DOWTXT.members[4].alpha >= 1)
				LF_4 = false;
		}

		// The Week Ahead!
		if (TWA == true)
		{
			if (DOWTXT.members[4] != null)
			{
				DOWTXT.members[4].alpha -= 0.3;
				NARRATIVES.members[4].alpha -= 0.3;
				lfTitle.alpha -= 0.3;
				lfPanel.alpha -= 0.3;

				if (DOWTXT.members[4].alpha == 0)
				{
					remove(DOWTXT);
					remove(NARRATIVES);
					remove(lfTitle);
					remove(lfPanel);
				}
			}

			twaPanel.alpha += 0.1;
			twaTitle.alpha += 0.1;

			for (i in 0...twaDays.members.length)
			{
				twaDays.members[i].alpha += 0.1;
				twaWeekend.members[i].alpha += 0.1;
				twaHiTemps.members[i].alpha += 0.1;
				twaLoTemps.members[i].alpha += 0.1;
				twaIcons.members[i].alpha += 0.1;

				if (twaDays.members[i].alpha >= 1)
				{
					twaDays.members[i].alpha = 1;
					twaWeekend.members[i].alpha = 1;
					twaHiTemps.members[i].alpha = 1;
					twaLoTemps.members[i].alpha = 1;
					twaIcons.members[i].alpha = 1;
				}
			}

			// TODO: 7-Day Outlook code

			if (twaTitle.alpha >= 1)
				TWA = false;
		}

		// Clean up and GTFO
		if (finished == true)
		{
			// Fade out entirely.
			twaPanel.alpha -= 0.3;
			twaTitle.alpha -= 0.3;
			lf_cityName.alpha -= 0.3;
			BG.alpha -= 0.3;

			for (i in 0...twaDays.members.length)
			{
				twaDays.members[i].alpha -= 0.3;
				twaWeekend.members[i].alpha -= 0.3;
				twaHiTemps.members[i].alpha -= 0.3;
				twaLoTemps.members[i].alpha -= 0.3;
				twaIcons.members[i].alpha -= 0.3;
			}

			if (BG.alpha == 0)
			{
				// Destroy EVERYTHING to clean up memory.

				ccIcon.destroy();
				CCTXT.destroy();
				ccTitle.destroy();
				lfTitle.destroy();
				lrTitle.destroy();
				drTitle.destroy();
				alTitle.destroy();

				// Destroy TWA stuff
				twaDays.destroy();
				twaWeekend.destroy();
				twaHiTemps.destroy();
				twaLoTemps.destroy();
				twaIcons.destroy();

				BG.destroy();
				FlxTimer.globalManager.destroy();

				resetSubState();
				FlxG.switchState(new BroadcastState());
			}
		}

		super.update(elapsed);
	}
}
