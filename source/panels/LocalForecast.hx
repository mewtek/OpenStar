package panels;

import flixel.group.FlxGroup.FlxTypedGroupIterator;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;

class LocalForecast extends FlxSpriteGroup
{   
    var panel:FlxSprite;
    var tex:String = Resources.graphic('Panels', 'Local-Forecast');
    var title:Title;
    public var fadedIn:Bool = false;
    public var fadedOut:Bool = false;

    // Text
    var daypartName:FlxTypedGroup<FlxText>;
    var forecastTxt:FlxTypedGroup<FlxText>;
    var city:FlxText;

    var LFTimers:ForecastTimers;

    public function new()
    {
        super();

        panel = new FlxSprite(0, 165).loadGraphic(tex);
        panel.screenCenter(X);
        add(panel);

        title = new Title('local', 'forecast');
        add(title);

        city = new FlxText(150, 176, 0, APIHandler._LOCATIONDATA.cityName.toUpperCase());
        city.setFormat(Resources.font('interstate-bold'), 70, FlxColor.YELLOW);
        add(city);


        daypartName = new FlxTypedGroup<FlxText>();
        forecastTxt = new FlxTypedGroup<FlxText>();

        // Add the forecast texts & Daypart texts
		for(i in 0...APIHandler._FORECASTDATA.daypart_name.length)
            {
                var txt = new FlxText(150, 275, 700, APIHandler._FORECASTDATA.daypart_name[i]);
                txt.setFormat(Resources.font('interstate-regular'), 70, FlxColor.YELLOW, LEFT);
                txt.ID = i;
                daypartName.add(txt);
            }
    
        for(i in 0...APIHandler._FORECASTDATA.narrative.length)
        {
            var txt = new FlxText(150, 350, 1620, APIHandler._FORECASTDATA.narrative[i]);
            txt.setFormat(Resources.font('interstate-regular'), 65, FlxColor.WHITE, LEFT);
            txt.ID = i;
            forecastTxt.add(txt);
        }

        for(i in 0...daypartName.members.length)
        {
            add(daypartName.members[i]);
            add(forecastTxt.members[i]);
        }

        forEach(sprite -> {sprite.antialiasing = true; sprite.alpha = 0;});
    }

    public function updateLF(ts:ForecastTimers):Void
    {
        if (ts.timersActive)
        {
            if(ts.LF0)
            {
                daypartName.members[0].alpha += 0.1;
                forecastTxt.members[0].alpha += 0.1;

                if (forecastTxt.members[0].alpha >= 1)
                {
                    daypartName.members[0].alpha = 1;
                    forecastTxt.members[0].alpha = 1;
                    ts.LF0 = false;
                }
            }

            if(ts.LF1)
            {
                if(daypartName.members[0].alpha > 0)
                {
                    daypartName.members[0].alpha -= 0.1;
                    forecastTxt.members[0].alpha -= 0.1;
                }

                if(daypartName.members[1].alpha < 1)
                {
                    daypartName.members[1].alpha += 0.1;
                    forecastTxt.members[1].alpha += 0.1;
                } else 
                    ts.LF1 = false;

            }

            if(ts.LF2)
            {
                if(daypartName.members[1].alpha > 0)
                {
                    daypartName.members[1].alpha -= 0.1;
                    forecastTxt.members[1].alpha -= 0.1;
                 }

                if(daypartName.members[2].alpha < 1)
                 {
                    daypartName.members[2].alpha += 0.1;
                       forecastTxt.members[2].alpha += 0.1;
                } else 
                    ts.LF2 = false;
            }


            if(ts.LF3)
            {
                if(daypartName.members[2].alpha > 0)
                {
                    daypartName.members[2].alpha -= 0.1;
                    forecastTxt.members[2].alpha -= 0.1;
                }
    
                if(daypartName.members[3].alpha < 1)
                    {
                    daypartName.members[3].alpha += 0.1;
                    forecastTxt.members[3].alpha += 0.1;
                } else 
                    ts.LF3 = false;
            }

            if(ts.LF4)
            {
                if(daypartName.members[3].alpha > 0)
                {
                    daypartName.members[3].alpha -= 0.1;
                    forecastTxt.members[3].alpha -= 0.1;
                }
    
                if(daypartName.members[4].alpha < 1)
                    {
                    daypartName.members[4].alpha += 0.1;
                    forecastTxt.members[4].alpha += 0.1;
                } else 
                    ts.LF4 = false;
            }
            
        }
    }
    
    public inline function fadeIn()
    {
        if (panel.alpha < 1)
        {
            panel.alpha += 0.1;
            title.alpha += 0.1;
            city.alpha += 0.1;
        } else if(panel.alpha >= 1)
        {
            panel.alpha = 1;
            title.alpha = 1;
            city.alpha = 1;
            fadedIn = true;
        }
    }

    public inline function fadeOut()
    {

    }
}

class ForecastTimers extends FlxTimerManager
{
    var timers:Array<FlxTimer>;
    var manager:FlxTimerManager;

    // Switching variables
    public var LF0:Bool = false;    // Today/Tonight
    public var LF1:Bool = false;    // Tomorrow
    public var LF2:Bool = false;    // Tomorrow Night
    public var LF3:Bool = false;    // 3rd Day
    public var LF4:Bool = false;    // 3rd Night

    public var timersMade:Bool = false;
    public var timersActive:Bool = false;

    public function new()
    {
        super();
        this.manager = new FlxTimerManager();
        timers = manager._timers;

        new FlxTimer(manager).start(0.3, tmr -> LF0 = true);
        new FlxTimer(manager).start(timers[0].time + 6 , tmr -> LF1 = true);
        new FlxTimer(manager).start(timers[1].time + 6 , tmr -> LF2 = true);
        new FlxTimer(manager).start(timers[2].time + 6 , tmr -> LF3 = true);
        new FlxTimer(manager).start(timers[3].time + 6 , tmr -> LF4 = true);
        timersActive = false;
        active = false;
        trace("Local Forecast Panel - Timers made");
    }

    public function makeActive():Void
    {
        if (!timersActive)
        {
            active = true;
            timersActive = true;
            trace("LF timers have been made active");
        }

        return;
    }

    public override function update(e)
    {
        if(manager.active)
            manager.update(e);
    }

}
