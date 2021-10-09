package;

import APIHandler.CCVARS;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.system.debug.watch.Tracker;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
import lime.math.BGRA;
import lime.utils.Resource;
import sys.FileSystem;

class MainState extends FlxState
{
	private var OS_DEBUG:Bool;
	private var activeAlert:Bool;

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

	// Text Elements
	// LDL
	private var LDL:FlxSprite;
	private var LDLlogo:FlxSprite;
	private var LDLcrawl:FlxText;
	private var timeTicker:FlxText;
	private var LDLslide:FlxText;

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
	private var LFTXT:FlxTypedGroup<FlxText>;
	private var DOWTXT:FlxTypedGroup<FlxText>;
	private var NARRATIVES:FlxTypedGroup<FlxText>;
	private var lf_cityName:FlxText;

	// Sounds
	private var LOCALVOCAL_CC:FlxSound; // Current Condition narration
	private var LOCALVOCAL_TMP:FlxSound; // Temperature narration
	private var LOCALVOCAL_INTRO:FlxSound; // CC Intro

	override public function create():Void
	{
		FlxG.mouse.visible = false;
		FlxG.autoPause = false; // Disable the program pausing when the window is out of focus

		// get information from IBM
		APIHandler.apiSetup();
		APIHandler.getLocationData(); // RUN THIS BEFORE RETRIEVING ANY OTHER INFORMATION
		APIHandler.get36hour();
		APIHandler.get7Day;
		APIHandler.getCC();

		trace(FlxG.save.data.apiKey);
		OS_DEBUG = FlxG.save.data.OS_DEBUG;

		// CREATE BACKGROUND

		if (OS_DEBUG)
		{
			FlxG.debugger.drawDebug = true;
			// vv Basically the WeatherSTAR 4000 BG gradient, a bit easier to see draw boxes with
			var bg:FlxSprite = FlxGradient.createGradientFlxSprite(1920, 1080, [FlxColor.fromString('0x1d0255'), FlxColor.fromString('0xba5c13')], 1, 90);
			add(bg);
		}
		else
		{
			var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/Backgrounds/Background-Normal.png');
			bg.screenCenter();
			bg.antialiasing = false;
			add(bg);
		}

		// TODO: Automatically create a list of music using files in assets/music
		if (FlxG.sound.music == null)
			FlxG.sound.playMusic(Resources.music("jazzpiano.ogg"), 0.8, true);

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

		twaPanel.loadGraphic(twaPanelTex);
		twaPanel.screenCenter(X);
		twaPanel.antialiasing = true;

		// Create panel information

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

		CCTXT.add(condTxt);
		CCTXT.add(cc_cityName);
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

		// 36-hour forecast
		LFTXT = new FlxTypedGroup<FlxText>();
		DOWTXT = new FlxTypedGroup<FlxText>();
		NARRATIVES = new FlxTypedGroup<FlxText>();

		lf_cityName = new FlxText(150, 176, 0, APIHandler._LOCATIONDATA.cityName.toUpperCase());
		lf_cityName.setFormat(Resources.font('interstate-bold'), 70, FlxColor.YELLOW);

		// tfw I was about to do this by making a shitload of FlxText variables
		// https://github.com/AyeTSG/Funkin_SmallThings/blob/master/source/OptionsMenu.hx
		for (i in 0...APIHandler._FORECASTDATA.dow.length)
		{
			var txt = new FlxText(150, 275, 700, APIHandler._FORECASTDATA.dow[i]);
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

		LFTXT.add(lf_cityName); // 0

		// Set text automatically

		for (i in 0...APIHandler._FORECASTDATA.dow.length) {}

		for (i in 0...LFTXT.members.length)
		{
			LFTXT.members[i].antialiasing = true;
			LFTXT.members[i].alpha = 0;
		}

		add(LFTXT);
		add(DOWTXT);
		add(NARRATIVES);

		// 7-Day outlook panel

		// Create LDL
		LDL = new FlxSprite(0, FlxG.height - 165);
		LDL.loadGraphic(Resources.graphic('LDL', 'LDL'));
		LDL.screenCenter(X);
		LDL.antialiasing = true;
		LDL.y = (FlxG.height - 165);
		add(LDL);

		// TODO: Make the X value change by the length of the text of the scroll text

		// LDL stuff
		timeTicker = new FlxText(1500, 915, 150, "XX:XX"); // time updates automatically
		timeTicker.setFormat(Resources.font('interstate-bold'), 45, FlxColor.BLACK, LEFT);
		timeTicker.antialiasing = true;
		add(timeTicker);

		// LDLslide = new FlxText(100, 915, "CURRENTLY");
		// LDLslide.setFormat(Resources.font('interstate-bold'), 40, FlxColor.fromString("0x697ca2"));
		// LDLslide.antialiasing = true;
		// add(LDLslide);

		// Narrations

		LOCALVOCAL_INTRO = FlxG.sound.load(Resources.narration("CC_INTRO1", null), 1.0, false, null, false, false, null, () -> LOCALVOCAL_TMP.play());
		LOCALVOCAL_TMP = FlxG.sound.load(Resources.narration('${APIHandler._CCVARS.temperature}', "temperatures"), 1.0, false, null, false, false, null,
			() -> LOCALVOCAL_CC.play());
		LOCALVOCAL_CC = FlxG.sound.load(Resources.narration('${APIHandler._CCVARS.ccIconCode}', "conditions")); // Don't ask.

		/*
			I genuinely don't know why, but for some god-forsaken reason,
			using the StartTime variable in the play() function for FlxG doesn't actually
			do anything besides completely ignoring the onComplete() function that's done when
			these are all loaded into the state.
		 */
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			LOCALVOCAL_INTRO.play();
		});
	}

	// Everything in this function will be called every frame
	// Remember to destroy your timers!
	override public function update(elapsed):Void
	{
		// Lower audio when any of the local vocals are playing
		if (LOCALVOCAL_INTRO.playing || LOCALVOCAL_TMP.playing || LOCALVOCAL_CC.playing)
			FlxG.sound.music.volume = 0.1;
		else
			FlxG.sound.music.volume = 0.8;

		// Update time in LDL
		// trace(DateTools.format(Date.now(), "%I:%M"));
		timeTicker.text = DateTools.format(Date.now(), "%I:%M");

		// Presentations
		// TODO: Make a better system for the presentation engine

		// Fade in current conditions
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			ccPanel.alpha += 0.1;
			ccTitle.alpha += 0.1;
			ccIcon.alpha += 0.1;

			// Fade in text
			for (i in 0...CCTXT.members.length)
			{
				CCTXT.members[i].alpha += 0.1;

				if (CCTXT.members[i].alpha >= 1)
					CCTXT.members[i].alpha = 1;
			}

			if (ccPanel.alpha >= 1) // Going to full alpha should sync with everything else, use the panel as a baseline
			{
				ccPanel.alpha = 1;
				ccIcon.alpha = 1;
				ccTitle.alpha = 1;
				tmr.destroy();
			}
		});

		new FlxTimer().start(10, function(tmr:FlxTimer)
		{
			ccPanel.alpha -= 0.3;
			ccIcon.alpha -= 0.3;

			for (i in 0...CCTXT.members.length)
			{
				CCTXT.members[i].alpha -= 0.3;

				if (CCTXT.members[i].alpha == 0)
					CCTXT.members[i].visible = false;
			}

			if (ccPanel.alpha == 0)
			{
				ccPanel.visible = false;
				ccIcon.visible = false;
				tmr.destroy();
			}
		});

		new FlxTimer().start(10.2, function(tmr:FlxTimer)
		{
			tmr.destroy();
			// TODO: IMPLEMENT CODE TO SHOW A REGIONAL CONDITION PRODUCT
		});

		new FlxTimer().start(20, function(tmr:FlxTimer)
		{
			ccTitle.alpha -= 0.3;

			if (ccTitle.alpha == 0)
			{
				ccTitle.visible = false;
				tmr.destroy();
			}
		});

		new FlxTimer().start(20.2, function(tmr:FlxTimer)
		{
			rrTitle.alpha += 0.1;

			// TODO: ADD CODE FOR SHOWING RADAR IMAGES

			if (rrTitle.alpha >= 1)
				tmr.destroy();
		});

		new FlxTimer().start(25, function(tmr:FlxTimer)
		{
			rrTitle.alpha -= 0.3;

			if (rrTitle.alpha == 0)
			{
				tmr.destroy();
				rrTitle.visible = false;
			}
		});

		new FlxTimer().start(25.2, function(tmr:FlxTimer)
		{
			lrTitle.alpha += 0.1;

			if (lrTitle.alpha >= 1)
				tmr.destroy();
		});

		new FlxTimer().start(35, function(tmr:FlxTimer)
		{
			lrTitle.alpha -= 0.3;

			if (lrTitle.alpha == 0)
			{
				lrTitle.visible = false;
				tmr.destroy();
			}
		});

		new FlxTimer().start(35, function(tmr:FlxTimer)
		{
			drTitle.alpha += 0.1;

			if (drTitle.alpha >= 1)
				tmr.destroy();
		});

		new FlxTimer().start(45, function(tmr:FlxTimer)
		{
			drTitle.alpha -= 0.3;

			if (drTitle.alpha == 0)
			{
				drTitle.visible = false;
				tmr.destroy();
			}
		});

		new FlxTimer().start(45.2, function(tmr:FlxTimer)
		{
			// We can make multiple FlxTimers in this, which makes switching between the local forecast pretty easy

			lfTitle.alpha += 0.1;
			lfPanel.alpha += 0.1;
			DOWTXT.members[0].alpha += 0.1;
			NARRATIVES.members[0].alpha += 0.1;

			for (i in 0...LFTXT.members.length)
			{
				LFTXT.members[i].alpha += 0.1;

				if (LFTXT.members[i].alpha >= 1)
					LFTXT.members[i].alpha = 1;
			}

			if (lfPanel.alpha >= 1)
			{
				lfTitle.alpha = 1;
				lfPanel.alpha = 1;
			}

			if (DOWTXT.members[0].alpha >= 1)
			{
				DOWTXT.members[0].alpha = 1;
				NARRATIVES.members[0].alpha = 1;
			}

			// Switch between all of the forecasts.
			// This only uses 5 forecasts because there's unfortunately no options for just doing
			// an actual 36-hour forecast (1 1/2 days)
			new FlxTimer().start(12, function(tmr:FlxTimer)
			{
				DOWTXT.members[0].alpha -= 0.3;
				NARRATIVES.members[0].alpha -= 0.3;

				if (NARRATIVES.members[0].alpha == 0)
				{
					DOWTXT.members[0].visible = false;
					NARRATIVES.members[0].visible = false;
					tmr.destroy();
				}
			});

			new FlxTimer().start(12.2, function(tmr:FlxTimer)
			{
				DOWTXT.members[1].alpha += 0.1;
				NARRATIVES.members[1].alpha += 0.1;

				if (NARRATIVES.members[1].alpha >= 1)
				{
					DOWTXT.members[1].alpha = 1;
					NARRATIVES.members[1].alpha = 1;

					tmr.destroy();
				}
			});

			new FlxTimer().start(24, function(tmr:FlxTimer)
			{
				DOWTXT.members[1].alpha -= 0.3;
				NARRATIVES.members[1].alpha -= 0.3;

				if (NARRATIVES.members[1].alpha == 0)
				{
					DOWTXT.members[1].visible = false;
					NARRATIVES.members[1].visible = false;
					tmr.destroy();
				}
			});

			new FlxTimer().start(24.2, function(tmr:FlxTimer)
			{
				DOWTXT.members[2].alpha += 0.1;
				NARRATIVES.members[2].alpha += 0.1;

				if (NARRATIVES.members[2].alpha >= 1)
				{
					DOWTXT.members[2].alpha = 1;
					NARRATIVES.members[2].alpha = 1;

					tmr.destroy();
				}
			});

			new FlxTimer().start(36, function(tmr:FlxTimer)
			{
				DOWTXT.members[2].alpha -= 0.3;
				NARRATIVES.members[2].alpha -= 0.3;

				if (NARRATIVES.members[2].alpha == 0)
				{
					DOWTXT.members[2].visible = false;
					NARRATIVES.members[2].visible = false;
					tmr.destroy();
				}
			});

			new FlxTimer().start(36.2, function(tmr:FlxTimer)
			{
				DOWTXT.members[3].alpha += 0.1;
				NARRATIVES.members[3].alpha += 0.1;

				if (NARRATIVES.members[3].alpha >= 1)
				{
					DOWTXT.members[3].alpha = 1;
					NARRATIVES.members[3].alpha = 1;

					tmr.destroy();
				}
			});

			new FlxTimer().start(48, function(tmr:FlxTimer)
			{
				DOWTXT.members[3].alpha -= 0.3;
				NARRATIVES.members[3].alpha -= 0.3;

				if (NARRATIVES.members[3].alpha == 0)
				{
					DOWTXT.members[3].visible = false;
					NARRATIVES.members[3].visible = false;
					tmr.destroy();
				}
			});

			new FlxTimer().start(48.2, function(tmr:FlxTimer)
			{
				DOWTXT.members[4].alpha += 0.1;
				NARRATIVES.members[4].alpha += 0.1;

				if (NARRATIVES.members[4].alpha >= 1)
				{
					DOWTXT.members[4].alpha = 1;
					NARRATIVES.members[4].alpha = 1;

					tmr.destroy();
				}
			});
		});

		super.update(elapsed);
	}
}
