package;

import APIHandler.CCVARS;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
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
	private var TestTimer:FlxTimer;

	private var OS_DEBUG:Bool;
	private var activeAlert:Bool;

	// Panels
	private var ccPanel:FlxSprite;
	private var lfPanel:FlxSprite;
	private var twaPanel:FlxSprite;
	private var noaaPanel:FlxSprite;

	// Panel Titles
	private var ccTitle:FlxSprite;
	private var lfTitle:FlxSprite;
	private var lrTitle:FlxSprite;

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
	private var lf_cityName:FlxText;
	private var dow:FlxText; // Day of Week
	private var forecastTxt:FlxText;

	private var CURR_SLIDE:String;
	private var DEBUG_SLIDE_TXT:FlxText;

	override public function create():Void
	{
		CURR_SLIDE = "None";
		FlxG.mouse.visible = false;
		FlxG.autoPause = false; // Disable the program pausing when the window is out of focus

		// get information from IBM
		APIHandler.getLocationData(); // this needs to be ran before retrieving anything else in order to get latitude and longitude
		APIHandler.get36hour;
		APIHandler.get7Day;
		APIHandler.getCC();

		OS_DEBUG = true;

		// CREATE BACKGROUND

		if (OS_DEBUG)
		{
			FlxG.debugger.drawDebug = true;
			// vv Basically the WeatherSTAR 4000 BG gradient, a bit easier to see draw boxes with
			var bg:FlxSprite = FlxGradient.createGradientFlxSprite(1920, 1080, [FlxColor.fromString('0x1d0255'), FlxColor.fromString('0xba5c13')], 1, 90);
			add(bg);
			DEBUG_SLIDE_TXT = new FlxText(0, 0, 0, "CURRENT SLIDE: XXXX", 19); // Updated in update() function
			add(DEBUG_SLIDE_TXT);
		}
		else
		{
			var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/Backgrounds/Background-Normal.png');
			bg.screenCenter();
			bg.antialiasing = false;
			add(bg);
		}
		// CREATE PANEL TITLES \\

		// Title Textures
		var ccTitleTex = Resources.graphic('titles', 'current_conditions');
		var lfTitleTex = Resources.graphic('titles', 'todays_forecast');
		var lrTitleTex = Resources.graphic('titles', 'local_radar');

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

		lrTitle = new FlxSprite(-174, -58);
		lrTitle.loadGraphic(lrTitleTex);
		lrTitle.scale.x = 0.65;
		lrTitle.scale.y = 0.65;
		lrTitle.antialiasing = true;
		lrTitle.alpha = 0;
		add(lrTitle);

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
			ccIcon = new FlxSprite().loadGraphic(Resources.icon('Not Available'), false);
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

		lf_cityName = new FlxText(150, 176, 0, APIHandler._LOCATIONDATA.cityName.toUpperCase());
		dow = new FlxText(150, 275, 700, "Today");
		forecastTxt = new FlxText(150, 350, 1620, "Forecast Not Available"); // Should be updated automatically

		lf_cityName.setFormat(Resources.font('interstate-bold'), 70, FlxColor.YELLOW);
		dow.setFormat(Resources.font('interstate-regular'), 70, FlxColor.YELLOW, LEFT);
		forecastTxt.setFormat(Resources.font('interstate-bold'), 65, FlxColor.WHITE, LEFT);

		LFTXT.add(lf_cityName);
		LFTXT.add(dow);
		LFTXT.add(forecastTxt);

		for (i in 0...LFTXT.members.length)
		{
			LFTXT.members[i].antialiasing = true;
			LFTXT.members[i].alpha = 0;
		}

		add(LFTXT);

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
	}

	// Everything in this function will be called every frame
	// Remember to destroy your timers!
	override public function update(elapsed):Void
	{
		if (OS_DEBUG)
		{
			DEBUG_SLIDE_TXT.text = "CURRENT SLIDE: " + CURR_SLIDE;
		}

		// Update time in LDL
		// trace(DateTools.format(Date.now(), "%I:%M"));
		timeTicker.text = DateTools.format(Date.now(), "%I:%M");

		// Presentations

		// Fade in current conditions
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			CURR_SLIDE = "CC";
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
			}
		});

		super.update(elapsed);
	}
}
