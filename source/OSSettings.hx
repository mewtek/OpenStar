package;

import flixel.FlxG;

// Handles settings settings for the OpenStar unit
class OSSettings
{
	public static function initSave()
	{
		// API settings
		if (FlxG.save.data.units == null)
			FlxG.save.data.units = 'e'; // Default to imperial

		if (FlxG.save.data.areaCode == null)
			FlxG.save.data.areaCode = "20008:US"; // Default to Washington DC

		if (FlxG.save.data.lang == null)
			FlxG.save.data.lang = "en-US"; // Default to American English

		if (FlxG.save.data.apiKey == null)
			FlxG.save.data.apiKey = "d522aa97197fd864d36b418f39ebb323"; // feel free to use this if you're building a custom version!

		// Mapbox
		if (FlxG.save.data.mapboxKey == null) // Get a key from https://www.mapbox.com/
			FlxG.save.data.mapboxKey = '';

		if (FlxG.save.data.mapStyle == null)
			FlxG.save.data.mapStyle = "/zeexel32/ckuoj1uwh06qo18qiyyk6h0zc"; // Exclude mapbox://styles/

		// Broadcast settings

		if (FlxG.save.data.lfOnlyUnit == null)
			FlxG.save.data.lfOnlyUnit = false; // Do we want this unit to only do LOT8 simulation?

		if (FlxG.save.data.EAS == null)
			FlxG.save.data.EAS = false; // This will stop the unit entirely and just kick in the EAS substate.

		// DEBUG SETTINGS - MAINLY FOR DEVELOPMENT \\

		if (FlxG.save.data.OS_DEBUG == null)
			FlxG.save.data.OS_DEBUG = false;
	}
}
