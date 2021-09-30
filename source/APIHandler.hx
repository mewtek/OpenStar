package;

import flixel.FlxG;
import haxe.Json;
import sys.Http;

// types
typedef LOCATIONDATA =
{
	var cityName:String;
	var zoneID:String;
	// Used for forecast and other data
	var lat:Float;
	var long:Float;
}

typedef CCVARS =
{
	var ccIconCode:String;
	var currentCondition:String;
	var windSpd:String; // Put as a string due to the getCC function returning the wind direction
	var temperature:Int;
	var dewpoint:Int;
	var relHumidity:Int;
	var baroPressure:Float;
	var baroTrend:String;
}

typedef FORECASTDATA = {}

// Handles calls to IBM's JSON API.
class APIHandler
{
	private static var APIKey:String;
	static var units:String;
	static var areaCode:String;
	static var lang:String;

	// types
	public static var _CCVARS:CCVARS;
	public static var _LOCATIONDATA:LOCATIONDATA;

	// Set up the API among other information using save data
	public static function apiSetup()
	{
		OSSettings.initSave();
		APIKey = FlxG.save.data.apiKey;
		units = FlxG.save.data.units;
		areaCode = FlxG.save.data.areaCode;
		lang = FlxG.save.data.lang;
	}

	// https://weather.com/swagger-docs/ui/sun/v3/sunV3LocationSearch.json
	public static function getLocationData():Void
	{
		var APIURL:String = 'https://api.weather.com/v3/location/point?postalKey=$areaCode&language=$lang&apiKey=$APIKey&format=json';
		var API = new haxe.Http(APIURL);

		API.onData = function(data:String)
		{
			var res = Json.parse(data);

			// SET LOCATION DATA
			_LOCATIONDATA = {
				cityName: res.location.displayName,
				zoneID: res.location.zoneId,
				lat: res.location.latitude,
				long: res.location.longitude
			};
		}

		API.onError = function(erMsg)
		{
			trace('[API ERROR] $erMsg');
		}

		API.request();
	}

	// Obtain the current weather conditions for an area
	// https://weather.com/swagger-docs/ui/sun/v3/sunV3CurrentsOnDemand.json
	public static function getCC():Void
	{
		// God I hate long-ass API URL strings.
		var APIURL:String = 'https://api.weather.com/v3/wx/observations/current?apiKey=$APIKey&units=$units&postalKey=$areaCode&language=$lang&format=json';
		var API = new haxe.Http(APIURL);

		API.onData = function(data:String)
		{
			var res = Json.parse(data);
			// SET CURRENT CONDITION VARIABLES
			_CCVARS = {
				ccIconCode: res.iconCode,
				currentCondition: res.wxPhraseMedium,
				windSpd: '${res.windDirectionCardinal} ${res.windSpeed}',
				temperature: res.temperature,
				dewpoint: res.temperatureDewPoint,
				relHumidity: res.relativeHumidity,
				baroPressure: res.pressureAltimeter,
				baroTrend: res.pressureTendencyTrend
			};
		}

		API.onError = function(erMsg)
		{
			trace('[API ERROR] $erMsg');
		}

		API.request();
	}

	// Obtain information for the 36-Hour forecast
	// NOTE: getLocationData() needs to be ran so this function can get the latitude and longitude for the location!
	public static function get36hour():Void
	{
		var APIURL:String = 'https://api.weather.gov/v1/geocode/${_LOCATIONDATA.lat}/${_LOCATIONDATA.long}/3day.json?language=$lang&units=$units&apiKey=$APIKey';
	}

	// Obtains a 7-Day Forecast, mainly used for
	// The Week Ahead panels and the forecast panels.
	// https://weather.com/swagger-docs/ui/sun/v1/sunV1DailyForecast.json
	public static function get7Day():Void {}

	// Obtains the current conditions around the region for the given
	// area.
	// [API LINK]
	public static function getRegionalCC():Void {}
}
