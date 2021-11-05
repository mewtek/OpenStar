package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sys.FileSystem;

class LowerDisplayLine extends FlxSubState
{
	private var LDL:FlxSprite;

	// Text
	private var timeTicker:FlxText;
	private var temperatureTicker:FlxText;
	private var LDL_SlideText:FlxText;
	private var LDL_MainText:FlxText;
	private var LDL_cc_label:FlxText;
	private var LDL_ccTxt:FlxText;
	private var CCIcon:FlxSprite;

	// LDL loop bools
	private var DISPLAY_TimeTick:Bool;
	private var DISPLAY_TempTick:Bool;
	private var DISPLAY_ID:Bool;
	private var DISPLAY_DATE:Bool;
	private var CC:Bool;
	private var CC_wind:Bool;
	private var CC_humidity:Bool;
	private var CC_dewpoint:Bool;
	private var CC_pressure:Bool;
	private var CC_visibilty:Bool;

	override public function create()
	{
		super.create();
		APIHandler.getCC();

		// Make sure that everything else is still updating
		if (_parentState != null)
		{
			_parentState.persistentUpdate = true;
		}

		trace("CREATE LDL");
		LDL = new FlxSprite(0, FlxG.height - 165);
		LDL.loadGraphic(Resources.graphic('LDL', 'LDL'));
		LDL.screenCenter(X);
		LDL.antialiasing = true;
		LDL.y = (FlxG.height - 165);
		add(LDL);

		timeTicker = new FlxText(1500, 915, 150, "XX:XX"); // time updates automatically
		timeTicker.setFormat(Resources.font('interstate-bold'), 45, FlxColor.BLACK, LEFT);
		timeTicker.antialiasing = true;
		add(timeTicker);

		temperatureTicker = new FlxText(1500, 915, 150, "XX"); // temperature updates automatically
		temperatureTicker.setFormat(Resources.font('interstate-bold'), 45, FlxColor.BLACK, LEFT);
		temperatureTicker.antialiasing = true;
		temperatureTicker.alpha = 0;
		add(temperatureTicker);

		LDL_SlideText = new FlxText(100, 915, "CURRENTLY");
		LDL_SlideText.setFormat(Resources.font('interstate-bold'), 40, FlxColor.fromString("0x79abcf"));
		LDL_SlideText.antialiasing = true;
		add(LDL_SlideText);

		LDL_MainText = new FlxText(100, 950, "The Quick Brown Fox");
		LDL_MainText.setFormat(Resources.font('interstate-bold'), 80, FlxColor.WHITE, RIGHT);
		LDL_MainText.antialiasing = true;
		add(LDL_MainText);

		LDL_cc_label = new FlxText(1000, 985, "XXX:");
		LDL_cc_label.setFormat(Resources.font('interstate-regular'), 40, FlxColor.WHITE, RIGHT);
		LDL_cc_label.antialiasing = true;
		LDL_cc_label.visible = false;
		add(LDL_cc_label);

		LDL_ccTxt = new FlxText(1130, 970, "XXX");
		LDL_ccTxt.setFormat(Resources.font('interstate-bold'), 60, FlxColor.WHITE, LEFT);
		LDL_ccTxt.antialiasing = true;
		LDL_ccTxt.visible = false;
		add(LDL_ccTxt);

		CCIcon = new FlxSprite(1020, 950).loadGraphic(Resources.icon(APIHandler._CCVARS.ccIconCode));

		CCIcon.scale.x = 0.8;
		CCIcon.scale.y = 0.8;
		CCIcon.updateHitbox();
		CCIcon.antialiasing = true;
		CCIcon.visible = false;
		add(CCIcon);

		new FlxTimer().start(1200, timer -> APIHandler.getCC(), 0); // Checks every 15 minutes for current condition updates.

		new FlxTimer().start(6, function(tmr:FlxTimer)
		{
			if (!DISPLAY_TempTick)
			{
				DISPLAY_TempTick = true;
				DISPLAY_TimeTick = false;
			}

			new FlxTimer().start(6, timer ->
			{
				if (!DISPLAY_TimeTick)
				{
					DISPLAY_TempTick = false;
					DISPLAY_TimeTick = true;
				}
			});
		}, 0);

		makeTimers();
	}

	function makeTimers():Void
	{
		trace("Timers have been made!");
		new FlxTimer().start(0, timer -> DISPLAY_ID = true);
		new FlxTimer().start(8, timer -> DISPLAY_DATE = true);
		new FlxTimer().start(18, timer -> CC = true);
		new FlxTimer().start(26, timer -> CC_wind = true);
		new FlxTimer().start(34, timer -> CC_humidity = true);
		new FlxTimer().start(42, timer -> CC_pressure = true);
		new FlxTimer().start(50, timer -> CC_visibilty = true);
		new FlxTimer().start(58, timer -> CC_dewpoint = true);
		new FlxTimer().start(66, timer -> makeTimers(), 0);
	}

	override public function update(elapsed)
	{
		timeTicker.text = DateTools.format(Date.now(), "%I:%M");
		temperatureTicker.text = '${APIHandler._CCVARS.temperature}';

		if (DISPLAY_TempTick)
		{
			timeTicker.alpha -= 0.1;
			temperatureTicker.alpha += 0.1;

			if (temperatureTicker.alpha >= 1)
			{
				timeTicker.alpha = 0;
				temperatureTicker.alpha = 1;
			}
		}

		if (DISPLAY_TimeTick)
		{
			timeTicker.alpha += 0.1;
			temperatureTicker.alpha -= 0.1;

			if (timeTicker.alpha >= 1)
			{
				timeTicker.alpha = 1;
				temperatureTicker.alpha = 0;
			}
		}

		// Basically the same system for MainState

		if (DISPLAY_DATE)
		{
			LDL_ccTxt.visible = false;
			LDL_cc_label.visible = false;
			LDL_SlideText.visible = true;
			LDL_ccTxt.setPosition(1130, 970);
			LDL_MainText.text = DateTools.format(Date.now(), "%A, %B %d");
			DISPLAY_DATE = false;
		}
		if (DISPLAY_ID)
		{
			LDL_MainText.text = 'Local Weather ID: ${APIHandler._LOCATIONDATA.zone}';
			LDL_SlideText.visible = false;
			LDL_ccTxt.visible = false;
			LDL_cc_label.visible = false;
			DISPLAY_ID = false;
		}

		if (CC)
		{
			LDL_SlideText.visible = true;
			LDL_cc_label.visible = false;
			LDL_ccTxt.visible = true;
			CCIcon.visible = true;
			LDL_ccTxt.text = '${APIHandler._CCVARS.temperature}';
			LDL_MainText.text = APIHandler._LOCATIONDATA.cityName;
			CC = false;
		}

		if (CC_wind)
		{
			CCIcon.visible = false;
			LDL_cc_label.visible = true;
			LDL_cc_label.text = "WIND:";
			LDL_ccTxt.text = APIHandler._CCVARS.windSpd;
			CC_wind = false;
		}

		if (CC_humidity)
		{
			CCIcon.visible = false;
			LDL_cc_label.text = "HUMIDITY:";
			LDL_ccTxt.text = '${APIHandler._CCVARS.relHumidity}%';
			LDL_ccTxt.setPosition(1230, 970);
			CC_humidity = false;
		}

		if (CC_pressure)
		{
			LDL_cc_label.text = "PRESSURE:";
			LDL_ccTxt.text = '${APIHandler._CCVARS.baroPressure}';
			CC_pressure = false;
		}

		if (CC_visibilty)
		{
			LDL_cc_label.text = "VISIBILITY:";
			LDL_ccTxt.text = 'N/A';
			CC_visibilty = false;
		}

		super.update(elapsed);
	}
}
