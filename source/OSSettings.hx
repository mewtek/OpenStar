package;

import flixel.FlxG;

// Handles settings settings for the OpenStar unit
class OSSettings
{
	public static function initSave()
	{
		if (FlxG.save.data.units == null)
			FlxG.save.data.units = 'e'; // Default to imperial

		if (FlxG.save.data.areaCode == null)
			FlxG.save.data.areaCode = "20008:US"; // Default to Washington DC

		if (FlxG.save.data.lang == null)
			FlxG.save.data.lang = "en-US"; // Default to American English

		// API Key for IBM/TWC
		// Feel free to use this one if you're building a custom version!
		if (FlxG.save.data.apiKey == null)
			FlxG.save.data.apiKey = "d522aa97197fd864d36b418f39ebb323";

		// DEBUG SETTINGS - MAINLY FOR DEVELOPMENT \\

		if (FlxG.save.data.OS_DEBUG == null)
			FlxG.save.data.OS_DEBUG = false;
	}
}
