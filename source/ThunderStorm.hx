package;

import flixel.util.FlxTimer;


// Deals with timing what times presentation panels should appear
// when the presentation is active
// Also haha funny ThunderStorm card reference
class ThunderStorm extends FlxTimerManager
{

    var timers:Array<FlxTimer>;
    var manager:FlxTimerManager;
    
    // Booleans for presentation slides
    // Based off of https://twcclassics.com/information/intellistar-flavors.html
    public var WA:Bool; // Weather Alerts Panel, doesn't appear if there's no alerts to be found
    public var CC:Bool;
    public var RC:Bool;
    public var RR:Bool;
    public var AL:Bool;
    public var AQ:Bool; 
    // or (time dependant)
    public var GA:Bool;
    public var OA:Bool; // Can be switched between School day and Outdoor activity dependant on time
    public var DP:Bool;
    public var RF:Bool;
    public var LF:Bool; // THIS IS COMPLICATED, READ COMMENT BELOW
    public var EF:Bool;
    // or
    public var TWA:Bool;
    public var TF:Bool; // TODO: Needs API for traffic conditions in the unit's area.

    public var FIN:Bool;    // Used for telling the presentation engine to switch back to the broadcast state

    /*
    Note about the LF system:
    
    The timers for the local forecast panel are handled in its panel logic due to
    it requiring several "slides" with the txt in order to function properly.

    The timer to switch from the Local Forecast to TWA or the Extended 3-Day Forecast
    should be determined by how long it takes for the local forecast slide to run through its logic.
    */

    public function new() {
        super();
        this.manager = new FlxTimerManager();
        timers = manager._timers;

        var timeStarted:Int = Date.now().getMinutes();


        // Create timers
        // Note: Real IS1 Units keep this around 2 minutes, but nothing's stopping you from going
        // well over.

        // TODO: Add timers for Weather Alerts screen
        new FlxTimer(manager).start(0, tmr -> CC = true);
        new FlxTimer(manager).start(timers[0].time + 7, tmr -> RC = true);  
        new FlxTimer(manager).start(timers[1].time + 7, tmr -> RR = true);
        new FlxTimer(manager).start(timers[2].time + 7, tmr -> AL = true);
        // Panel switch between Getaway Forecast & Almanac panels
        if ([8, 28].contains(timeStarted))
            new FlxTimer(manager).start(timers[3].time + 7, tmr -> GA = true);
        else 
            new FlxTimer(manager).start(timers[3].time + 7, tmr -> AL = true);

        new FlxTimer(manager).start(timers[4].time + 7, tmr -> OA = true);
        new FlxTimer(manager).start(timers[5].time + 7, tmr -> DP = true);
        new FlxTimer(manager).start(timers[6].time + 7, tmr -> RF = true);  
        new FlxTimer(manager).start(timers[7].time + 7, tmr -> LF = true);
        
        // Panel switch between TWA and Extended 3-Day
        // TODO: Timers need be fixed to account for the LF panel's total time.
        if([18, 48].contains(timeStarted))
            new FlxTimer(manager).start(timers[8].time + 7, tmr -> EF = true);
        else
            new FlxTimer(manager).start(timers[8].time + 7, tmr -> TWA = true);

        new FlxTimer(manager).start(timers[9].time + 7, tmr -> TF = true);
        new FlxTimer(manager).start(timers[10].time + 7, tmr -> FIN = true);

        trace(timers.length);
       
    }

    public override function update(elapsed) {
        
        if(manager.active)
            manager.update(elapsed);
    }
}