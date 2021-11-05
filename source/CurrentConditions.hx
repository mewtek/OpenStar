package;

import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;

class CurrentConditions extends FlxSpriteGroup
{
    var panel:FlxSprite;
    var tex:String = Resources.graphic('Panels', 'Current-Conditions');

    // GFX
    var icon:FlxSprite;
    var baroArrow:FlxSprite;


    // Text Labels
    var rhLabel = new FlxText(828, 285,'HUMIDITY');
    var dpLabel = new FlxText(668, 385, 450, 'DEW POINT');
    var barolabel = new FlxText(668, 485, 450, 'PRESSURE');
    var visLabel = new FlxText(668, 585, 450, 'VISIBILITY');
    var wndLabel = new FlxText(668, 685, 450, 'WIND');
    var gustLabel = new FlxText(668, 785, 450, 'GUSTS');    // This can be changed between Gusts and Wind Chill
   
    // Data Text
    var city:FlxText;
    var cond:FlxText;
    var tmpTxt:FlxText;
    var rhTxt:FlxText;
    var dpTxt:FlxText;
    var baroTxt:FlxText;
    var visTxt:FlxText;
    var wndTxt:FlxText;
    var gstTxt:FlxText;


    public function new()
    {
        super();

        panel = new FlxSprite(0, 165).loadGraphic(tex);
        panel.screenCenter(X);
        add(panel);

        icon = new FlxSprite().loadGraphic(Resources.icon(APIHandler._CCVARS.ccIconCode));
        icon.scale.set(1.7, 1.7);
        icon.updateHitbox();
        icon.setPosition(268, 320);
        add(icon);

        // Create arrow for barometric pressure trend
        switch(APIHandler._CCVARS.baroTrend)
        {
            case "Steady":
                baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'steady'));
            case "Rising":
                baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'arrow'));
            case "Rapidly Rising":
                baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'arrow'));
            case "Falling":
                baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'arrow'));
                baroArrow.angle = 180;
            case "Rapidly Falling":
                baroArrow = new FlxSprite().loadGraphic(Resources.graphic('generic', 'arrow'));
                baroArrow.angle = 180;
        }

        baroArrow.scale.set(0.25, 0.25);
        baroArrow.updateHitbox();
        baroArrow.setPosition(1485, 500);
        add(baroArrow);

        city = new FlxText(150, 176, 0, APIHandler._LOCATIONDATA.cityName.toUpperCase());
        cond = new FlxText(275, 550, 200, APIHandler._CCVARS.currentCondition);
        tmpTxt = new FlxText(260, 725, 225, '${APIHandler._CCVARS.temperature}');

        rhTxt = new FlxText(1200, 265, 255, '${APIHandler._CCVARS.relHumidity}%');
        dpTxt = new FlxText(1200, 365, 500, '${APIHandler._CCVARS.dewpoint}');
        baroTxt = new FlxText(1200, 465, 500, '${APIHandler._CCVARS.baroPressure}');
        visTxt = new FlxText(1200, 565, 500, '${APIHandler._CCVARS.visibility}');
        wndTxt = new FlxText(1200, 665, 500, '${APIHandler._CCVARS.windSpd}');
        gstTxt = new FlxText(1200, 765, 500, 'None');

        // Set formats
        city.setFormat(Resources.font('interstate-bold'), 70, FlxColor.YELLOW);
        cond.setFormat(Resources.font('interstate-bold'), 50, FlxColor.WHITE, CENTER);
        tmpTxt.setFormat(Resources.font('interstate-bold'), 115, FlxColor.WHITE, CENTER);

        rhTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
        dpTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
        baroTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
        visTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
        wndTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
        gstTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);


        rhLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
        dpLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
        barolabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
        visLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
        wndLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);
        gustLabel.setFormat(Resources.font('interstate-regular'), 60, FlxColor.WHITE, RIGHT);


        add(city);
        
        add(cond);
        add(tmpTxt);
        
        add(rhTxt);
        add(dpTxt);
        add(baroTxt);
        add(visTxt);
        add(wndTxt);
        add(gstTxt);

        add(rhLabel);
        add(dpLabel);
        add(barolabel);
        add(visLabel);
        add(wndLabel);
        add(gustLabel);
        


        forEach(sprite -> sprite.antialiasing = true);

    }
}