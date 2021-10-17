package;

// i know how messy this is, it's not supposed to be good lmao
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.xml.Fast;
import lime.utils.AssetManifest;

class DebugMenu extends FlxState
{
	private var OpenStar_Logo:FlxSprite;

	private var _lfBtn:FlxButton;

	private var areaCodeBox:FlxInputText;
	private var langBox:FlxInputText;
	private var unitsBox:FlxInputText;

	private var OSDEBUGToggle:FlxInputText;

	// text
	private var areaTxt:FlxText;
	private var langTxt:FlxText;
	private var unitsTxt:FlxText;
	private var OSTOGGLEtxt:FlxText;

	override public function create():Void
	{
		FlxG.autoPause = false;
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeDownKeys = null;
		FlxG.sound.volumeUpKeys = null;
		initSettings(); // Do this so we can actually change values.
		// APIHandler.apiSetup();
		// APIHandler.getLocationData();
		// APIHandler.getMap();

		_lfBtn = new FlxButton(0, FlxG.height - 40, null, loadLF);
		_lfBtn.scale.x = 1.5;
		_lfBtn.scale.y = 1.5;
		_lfBtn.updateHitbox();
		add(_lfBtn);

		// bgColor = 0xFFFF00FF;

		// Text boxes
		areaCodeBox = new FlxInputText(0, 30, 200, '${FlxG.save.data.areaCode}', 15);
		add(areaCodeBox);

		langBox = new FlxInputText(0, 50, 200, '${FlxG.save.data.lang}', 15);
		add(langBox);

		unitsBox = new FlxInputText(0, 70, 200, '${FlxG.save.data.units}', 15);
		add(unitsBox);

		OSDEBUGToggle = new FlxInputText(0, 120, 200, '${FlxG.save.data.OS_DEBUG}', 15);
		add(OSDEBUGToggle);

		// Create labels yadda yadda
		areaTxt = new FlxText(250, 30, 9999, "Area Code. zipCode:CountryCode", 15);
		langTxt = new FlxText(250, 50, 9999, "Language", 15);
		unitsTxt = new FlxText(250, 70, 9999, "Units. e for imperial, m for metric.", 15);
		OSTOGGLEtxt = new FlxText(250, 120, 9999, "Debug Mode?", 15);

		add(areaTxt);
		add(langTxt);
		add(unitsTxt);
		add(OSTOGGLEtxt);

		OpenStar_Logo = new FlxSprite(0, 0);
		OpenStar_Logo.loadGraphic(Resources.graphic("Logos", "OpenStar_white"));
		OpenStar_Logo.scale.set(0.2, 0.2);
		OpenStar_Logo.screenCenter(X);
		OpenStar_Logo.antialiasing = true;
		add(OpenStar_Logo);

		super.create();
	}

	function initSettings():Void
	{
		OSSettings.initSave();
		trace("INIT SAVE FROM OSSettings.hx");
	}

	function saveSettings():Void
	{
		trace("Saving settings..");
		// Save settings if changed
		FlxG.save.data.areaCode = areaCodeBox.text;
		FlxG.save.data.lang = langBox.text;
		FlxG.save.data.units = unitsBox.text;

		switch (OSDEBUGToggle.text)
		{
			case "false":
				FlxG.save.data.OS_DEBUG = false;
			case "true":
				FlxG.save.data.OS_DEBUG = true;
			default:
				FlxG.save.data.OS_DEBUG = false;
		}
	}

	function loadLF():Void
	{
		saveSettings();
		FlxG.switchState(new MainState());
		trace("!!SWITCH STATE!!");
	}

	override public function update(elapsed):Void
	{
		super.update(elapsed);
	}
}
