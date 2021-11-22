package panels;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;

class LocalForecast extends FlxSpriteGroup
{   
    var panel:FlxSprite;
    var tex:String = Resources.graphic('Panels', 'Local-Forecast');
    public var fadedIn:Bool;
    public var fadedOut:Bool;

    // Text
    var daypartName:FlxTypedGroup<FlxText>;
    var forecastTxt:FlxTypedGroup<FlxText>;
    var city:FlxText;


    // Switching variables
    

    public function new()
    {
        super();

        panel = new FlxSprite(0, 165).loadGraphic(tex);
        panel.screenCenter(X);
        add(panel);


        // Set up groups
        daypartName = new FlxTypedGroup<FlxText>();
        forecastTxt = new FlxTypedGroup<FlxText>();

        // Make Text
        for (i in 0...APIHandler._FORECASTDATA.daypart_name.length)
        {
            var txt = new FlxText(150, 275, 700, APIHandler._FORECASTDATA.daypart_name[i]);
            txt.setFormat(Resources.font('interstate-regular'), 70, FlxColor.YELLOW, LEFT);
            txt.ID = i;
            daypartName.add(txt);
        }

        for (i in 0...APIHandler._FORECASTDATA.narrative.length)
        {
            var txt = new FlxText(150, 350, 1620, APIHandler._FORECASTDATA.narrative[i]);
            txt.setFormat(Resources.font('interstate-regular'), 65, FlxColor.WHITE, LEFT);
            txt.ID = i;
            forecastTxt.add(txt);
        }

        city = new FlxText(150, 176, 0, APIHandler._LOCATIONDATA.cityName.toUpperCase());
        city.setFormat(Resources.font('interstate-bold'), 70, FlxColor.YELLOW);
        add(city);

        for (i in 0...daypartName.members.length)
        {
            add(daypartName.members[i]);
            add(forecastTxt.members[i]);
        }

        forEach(sprite -> {sprite.antialiasing = true; sprite.alpha = 0;});
    }

    public override function update(e)
    {
        



        super.update(e);
    }
    
    function makeTimers()
    {
    }


    public inline function fadeIn()
    {

    }

    public inline function fadeOut()
    {

    }
}