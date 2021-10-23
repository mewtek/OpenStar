package;

import flixel.FlxG;
import flixel.system.FlxAssets;
import haxe.Json;
import haxe.io.Bytes;
import haxe.io.Encoding;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import sys.Http;
import sys.io.File;
import sys.io.FileOutput;

using StringTools;

// types
typedef LOCATIONDATA =
{
	var cityName:String;
	var zoneID:String;
	// Used for forecast and other data
	var lat:Float;
	var long:Float;
	var zone:String;
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

typedef FORECASTDATA =
{
	var daypart_name:Array<String>;
	var narrative:Array<String>;
}

typedef SEVENDAYDATA =
{
	var iconCodes:Array<String>;
	var hiTemps:Array<String>;
	var loTemps:Array<String>;
	var dow:Array<String>;
	var isWeekend:Array<Bool>;
}

// Handles calls to IBM's JSON API.
class APIHandler
{
	private static var APIKey:String;
	private static var APIKey_Mapbox:String;
	private static var units:String;
	private static var areaCode:String;
	private static var lang:String;
	private static var MapboxStyle:String;

	// types
	public static var _CCVARS:CCVARS;
	public static var _LOCATIONDATA:LOCATIONDATA;
	public static var _FORECASTDATA:FORECASTDATA;
	public static var _SEVENDAYDATA:SEVENDAYDATA;

	// IBM API DOCS: https://www.datamensional.com/weather-data-services/weather-company-data-api-documentation/
	// Set up the API among other information using save data
	public static function apiSetup()
	{
		OSSettings.initSave();
		APIKey = FlxG.save.data.apiKey;
		APIKey_Mapbox = FlxG.save.data.mapboxKey;
		MapboxStyle = FlxG.save.data.mapStyle;
		units = FlxG.save.data.units;
		areaCode = FlxG.save.data.areaCode;
		lang = FlxG.save.data.lang;

		getLocationData(); // Do this so we dont ave to run it in MainState;
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
				long: res.location.longitude,
				zone: res.location.zoneId
			};

			trace(res.location.latitude);
			trace(res.location.longitude);
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

	// Obtain information for the local forecast + The Week Ahead
	// NOTE: getLocationData() needs to be ran so this function can get the latitude and longitude for the location!
	// https://docs.google.com/document/d/1RY44O8ujbIA_tjlC4vYKHKzwSwEmNxuGw5sEJ9dYjG4/edit
	public static function getLocalForecast():Void
	{
		var APIURL:String = 'https://api.weather.com/v3/wx/forecast/daily/7day?geocode=${_LOCATIONDATA.lat},${_LOCATIONDATA.long}&format=json&units=$units&language=$lang&apiKey=$APIKey';
		var API = new haxe.Http(APIURL);

		// Used for LF segment
		var names:Array<String> = [];
		var narratives:Array<String> = [];

		// For 7-day outlook
		var ICONS:Array<String> = [];
		var HI:Array<String> = [];
		var LO:Array<String> = [];
		var DOW:Array<String> = [];
		var WEEKEND:Array<Bool> = [];

		API.onData = function(data:String)
		{
			var res = Json.parse(data);

			// 38-hour forecast setup
			for (i in 0...res.daypart[0].daypartName.length)
			{
				if (res.daypart[0].daypartName[i] != null)
				{
					names.push(res.daypart[0].daypartName[i]);
					narratives.push(res.daypart[0].narrative[i]);
					trace(res.daypart[0].daypartName[i] + ": " + res.daypart[0].narrative[i]);

					if (res.daypart[0].narrative[i] == null)
						narratives.push("Forecast not available.");
				}
			}

			_FORECASTDATA = {
				daypart_name: names,
				narrative: narratives
			};

			// 7-Day outlook!
			for (i in 0...res.dayOfWeek.length)
			{
				ICONS.push('44'); // TODO: Figure out icons

				if (res.calendarDayTemperatureMax[i] != null)
					HI.push('${res.calendarDayTemperatureMax[i]}');
				else
					HI.push("N/A");

				if (res.calendarDayTemperatureMin != null)
					LO.push('${res.calendarDayTemperatureMin[i]}');
				else
					LO.push("N/A");

				// TODO: V3 is a bit weird with 7-day so I have to work out some other stuff.

				switch (res.dayOfWeek[i])
				{
					case "Sunday":
						DOW.push("SUN");
						WEEKEND.push(true);

					case "Monday":
						DOW.push("MON");
						WEEKEND.push(false);

					case "Tuesday":
						DOW.push("TUE");
						WEEKEND.push(false);

					case "Wednesday":
						DOW.push("WED");
						WEEKEND.push(false);

					case "Thursday":
						DOW.push("THU");
						WEEKEND.push(false);

					case "Friday":
						DOW.push("FRI");
						WEEKEND.push(false);

					case "Saturday":
						DOW.push("SAT");
						WEEKEND.push(true);
				}
			}

			trace(DOW);
			trace(WEEKEND);

			_SEVENDAYDATA = {
				iconCodes: ICONS,
				hiTemps: HI,
				loTemps: LO,
				dow: DOW,
				isWeekend: WEEKEND
			};
		}

		API.onError = function(msg:String)
		{
			trace("WHOOPS, THERE'S A PROBLEM!");
			trace(msg);
		}

		API.request();
	}

	// Obtains the current conditions around the region for the given
	// area.
	// [API LINK]
	public static function getRegionalCC():Void {}

	// Pulls from MapBox to get the base map for Radar and whatnot.
	// downloads as a 2560x1440 image instead of 1280x720.
	// TODO: Rebuild the asset library for assets/images after this function is ran!!
	public static function getMap():Void
	{
		trace("DOWNLOADING MAP DATA");
		var l:URLLoader = new URLLoader();
		l.dataFormat = URLLoaderDataFormat.BINARY;
		l.addEventListener(Event.COMPLETE, function(e:Event)
		{
			var path:String = 'assets/images/radar/map.png';
			File.saveBytes(path, l.data);
			trace("Downloaded a map that was " + l.data.length + " bytes.");
		});
		// note to self: dont put your entire fucking MapBox API key in an unused function
		l.load(new URLRequest('https://api.mapbox.com/styles/v1/zeexel32/ckuoj1uwh06qo18qiyyk6h0zc/static/${_LOCATIONDATA.long},${_LOCATIONDATA.lat},8.43,0,1/1280x720@2x?access_token=$APIKey_Mapbox'));
	}
}
