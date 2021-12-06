package panels;

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

        // ? For some reason FlxSpriteGroups make you add all of this one-by-one.
        // ? It's bloody annoying.
        for (i in 0...daypartName.members.length)
        {
            add(daypartName.members[i]);
            add(forecastTxt.members[i]);
        }

        forEach(sprite -> {sprite.antialiasing = true; sprite.alpha = 0;});
    }

    public override function update(e)
    {

        if(LFTimers != null)
        {

            if(LFTimers.LF0)
                {
                    if(daypartName.members[0].alpha < 1)
                    {
                        daypartName.members[0].alpha += 0.2;
                        forecastTxt.members[0].alpha += 0.2;
                    } else if (daypartName.members[0].alpha >= 1)
                    {
                        daypartName.members[0].alpha = 1;
                        forecastTxt.members[0].alpha = 1;
                        LFTimers.LF0 = false;
                    }
                }
        
                if(LFTimers.LF1)
                {
        
                    // Fade out the last set of text + daypart names
                    if(daypartName.members[0].alpha != 0)
                        {
                            daypartName.members[0].alpha -= 0.2;
                            forecastTxt.members[0].alpha -= 0.2;
                        } else 
                        {
                            daypartName.members[0].alpha = 0;
                            forecastTxt.members[0].alpha = 0;
                        }
        
                        if(daypartName.members[1].alpha < 1)
                        {
                            daypartName.members[1].alpha += 0.2;
                            forecastTxt.members[1].alpha += 0.2;
                        } else if (daypartName.members[1].alpha >= 1)
                        {
                            daypartName.members[1].alpha = 1;
                            forecastTxt.members[1].alpha = 1;
                            LFTimers.LF1 = false;
                        }
                }
        
        
                if(LFTimers.LF2)
                    {
            
                        // Fade out the last set of text + daypart names
                        if(daypartName.members[1].alpha != 0)
                            {
                                daypartName.members[1].alpha -= 0.2;
                                forecastTxt.members[1].alpha -= 0.2;
                            } else 
                            {
                                daypartName.members[1].alpha = 0;
                                forecastTxt.members[1].alpha = 0;
                            }
            
                            if(daypartName.members[2].alpha < 1)
                            {
                                daypartName.members[2].alpha += 0.2;
                                forecastTxt.members[2].alpha += 0.2;
                            } else if (daypartName.members[2].alpha >= 1)
                            {
                                daypartName.members[2].alpha = 1;
                                forecastTxt.members[2].alpha = 1;
                                LFTimers.LF2 = false;
                            }
                    }
            
        
                    if(LFTimers.LF3)
                        {
                
                            // Fade out the last set of text + daypart names
                            if(daypartName.members[2].alpha != 0)
                                {
                                    daypartName.members[2].alpha -= 0.2;
                                    forecastTxt.members[2].alpha -= 0.2;
                                } else 
                                {
                                    daypartName.members[2].alpha = 0;
                                    forecastTxt.members[2].alpha = 0;
                                }
                
                                if(daypartName.members[3].alpha < 1)
                                {
                                    daypartName.members[3].alpha += 0.2;
                                    forecastTxt.members[3].alpha += 0.2;
                                } else if (daypartName.members[3].alpha >= 1)
                                {
                                    daypartName.members[3].alpha = 1;
                                    forecastTxt.members[3].alpha = 1;
                                    LFTimers.LF3 = false;
                                }
                        }

        }
       

        super.update(e);
    }
    
    public inline function fadeIn()
    {
        if (panel.alpha < 1)
        {
            panel.alpha += 0.1;
            title.alpha += 0.1;
        } else if(panel.alpha >= 1)
        {
            panel.alpha = 1;
            title.alpha = 1;
            fadedIn = true;
            LFTimers = new ForecastTimers();
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

    public var LF0:Bool = false; // Today/Tonight
    public var LF1:Bool = false; // Tomorrow
    public var LF2:Bool = false; // Tomorrow Night
    public var LF3:Bool = false; // 3rd day

    public var timersMade:Bool = false;

    public function new()
    {
        super();

        this.manager = new FlxTimerManager();
        timers = manager._timers;

        if(!timersMade)
        {
            new FlxTimer(manager).start(0.5, tmr -> LF0 = true);
            new FlxTimer(manager).start(timers[0].time + 5, tmr -> LF1 = true);
            new FlxTimer(manager).start(timers[1].time + 5, tmr -> LF2 = true);
            new FlxTimer(manager).start(timers[2].time + 5, tmr -> LF3 = true);
            timersMade = true;
            trace("LF Panel timers created!");
        }
        else
            trace("TIMERS ALREADY MADE!");
    }

    public override function update(e) {
        if(manager.active)
        {
            manager.update(e);
            trace("Updating timer..");
        }
    }
}