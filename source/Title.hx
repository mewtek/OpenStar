package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;


// Planning on making an actual system for generating text titles so its not entirely based on
// textures, but for the meantime it's being unused.
class Title extends FlxSpriteGroup
{

    var GRADIENT_BLACK:FlxSprite;
    var GRADIENT_WHITE:FlxSprite;

    // Text
    var blackTxt:FlxText;
    var blackTxt_shadow:FlxText;
    var whiteTxt:FlxText;

    public function new(text_black:String, ?text_white:String, ?isRadarTitle:Bool = false)
    {
        super();

        GRADIENT_BLACK = new FlxSprite().loadGraphic(Resources.graphic('titles', 'title-parts/TITLE_BLACK'));
        GRADIENT_WHITE = new FlxSprite().loadGraphic(Resources.graphic('titles', 'title-parts/TITLE_WHITE'));


        // Set sizes and positions
    
        GRADIENT_BLACK.scale.set(0.65, 0.65);
        GRADIENT_BLACK.setPosition(-10, -58);
        // add(GRADIENT_BLACK);

        if (text_white != null)
        {
            GRADIENT_WHITE.scale.set(0.65, 0.65);
            GRADIENT_WHITE.setPosition(0, -62);
            add(GRADIENT_WHITE);
        }


        // create text
        blackTxt_shadow = new FlxText(152, 53.2);
        blackTxt_shadow.setFormat(Resources.font('interstate-bold'), 85, FlxColor.BLACK, LEFT);
        blackTxt_shadow.text = text_black;
        add(blackTxt_shadow);


        blackTxt = new FlxText(150, 50);
        blackTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
        blackTxt.text = text_black;
        add(blackTxt);

        if(text_white != null)
        {
            whiteTxt = new FlxText((blackTxt.fieldWidth + 178 ), 50);
            whiteTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.BLACK, LEFT);
            whiteTxt.text = text_white;
            GRADIENT_WHITE.x = whiteTxt.x - 218;
            add(whiteTxt); 
        }

    
        forEach(sprite -> sprite.antialiasing = true);
    }
}