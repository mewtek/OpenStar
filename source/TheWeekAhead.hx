package;

import flixel.util.FlxColor;
import flixel.ui.FlxButton.FlxTypedButton;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Resource;
import flixel.group.FlxSpriteGroup;


class TheWeekAhead extends FlxSpriteGroup
{
    var panel:FlxSprite;
    var tex:String = Resources.graphic('Panels', 'The-Week-Ahead');

    // GFX
    var icons:FlxTypedGroup<FlxSprite>;
    var weekendBar:FlxTypedGroup<FlxSprite>;

    // Text
    var hi:FlxTypedGroup<FlxText>;
    var lo:FlxTypedGroup<FlxText>;
    var phrases:FlxTypedGroup<FlxText>;
    var days:FlxTypedGroup<FlxText>;
    

    public function new()
    {
        super();

        panel = new FlxSprite(0, 165).loadGraphic(tex);
        panel.screenCenter(X);
        add(panel);

        // Set up groups
        icons = new FlxTypedGroup<FlxSprite>();
        weekendBar = new FlxTypedGroup<FlxSprite>();

        hi = new FlxTypedGroup<FlxText>();
        lo = new FlxTypedGroup<FlxText>();
        phrases = new FlxTypedGroup<FlxText>();
        days = new FlxTypedGroup<FlxText>();

        // Create icons and groups for each part of the panel
        for(i in 0...7)
        {
            // Make icons
            var ico:FlxSprite = new FlxSprite().loadGraphic(Resources.icon(APIHandler._SEVENDAYDATA.iconCodes[i]));
            ico.antialiasing = true; // Dunno if this is unnecessary so.. Just gonna put it in there anyways!
            ico.scale.set(1.5, 1.5);
            ico.updateHitbox();
            ico.setPosition((icons.members[i - 1] != null ? icons.members[i - 1].x + 235 : 160), 330);
            ico.ID = i;
            icons.add(ico);


            // Hi/Lo temperature labels
            var hiTemp:FlxText = new FlxText((hi.members[i - 1] != null ? hi.members[i - 1].x + 235 : 155), 625, 200, APIHandler._SEVENDAYDATA.hiTemps[i]);
            hiTemp.setFormat(Resources.font('interstate-bold'), 100, FlxColor.WHITE, CENTER);
            hiTemp.ID = i;
            hi.add(hiTemp);

            var loTemp:FlxText = new FlxText((lo.members[i - 1] != null ? lo.members[i - 1].x + 235 : 155), 725, 200, APIHandler._SEVENDAYDATA.loTemps[i]);
            loTemp.setFormat(Resources.font('interstate-bold'), 100, FlxColor.WHITE, CENTER);
            loTemp.ID = i;
            lo.add(loTemp);

            // DOW labels
            var day = new FlxText((days.members[i - 1] != null ? days.members[i-1].x + 235 :176), 280, 150, APIHandler._SEVENDAYDATA.dow[i]);
            day.setFormat(Resources.font('interstate-light'), 50, (APIHandler._SEVENDAYDATA.isWeekend[i] ? FlxColor.fromString('0x102a70'):FlxColor.WHITE), CENTER);
            day.antialiasing = true;
            day.ID = i;
            days.add(day);

            // Weekend Rectangle
            var rect:FlxSprite = new FlxSprite((weekendBar.members[i - 1 ] != null ? weekendBar.members[i - 1].x + 235 : 145.5), 274);
            rect.makeGraphic(218, 60, FlxColor.WHITE);
            rect.alpha = 0.85;
            rect.visible = APIHandler._SEVENDAYDATA.isWeekend[i];
            rect.ID = i;
            weekendBar.add(rect);

            // TODO: Phrases

        }

        // This is a really stupid way of doing this, but for some reason
        // HaxeFlixel keeps giving me an error saying that it needs to be an FlxSprite.
        
        // Add all of the graphics
        for (i in 0...icons.members.length)
        {
            add(icons.members[i]);
            add(weekendBar.members[i]);
            add(hi.members[i]);
            add(lo.members[i]);
            add(days.members[i]);
        }


        forEach(sprite -> sprite.antialiasing = true);
    }
}