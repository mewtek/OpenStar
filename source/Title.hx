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

    var TITLE_BORDER:FlxSprite;
    var GRADIENT_BLACK:FlxSprite;
    var GRADIENT_WHITE:FlxSprite;

    // Text
    var blackTxt:FlxText;
    var whiteTxt:FlxText;

    public function new(text_black:String, text_white:String, ?isRadarTitle:Bool = false)
    {
        super();

        TITLE_BORDER = new FlxSprite().loadGraphic('assets/images/titles/title-parts/TITLE_BORDER.png');
        GRADIENT_BLACK = new FlxSprite().loadGraphic(Resources.graphic('titles', 'title-parts/TITLE_BLACK'));
        GRADIENT_WHITE = new FlxSprite().loadGraphic(Resources.graphic('titles', 'title-parts/TITLE_WHITE'));

        // Set sizes and positions
        
        GRADIENT_BLACK.scale.set(0.65, 0.65);
        GRADIENT_BLACK.setPosition(50, -58);
        // add(GRADIENT_BLACK);

        GRADIENT_WHITE.scale.set(0.65, 0.65);
        GRADIENT_WHITE.setPosition(265, -55);
        // add(GRADIENT_WHITE);

        TITLE_BORDER.scale.set(0.65, 0.65);
        TITLE_BORDER.setPosition(-174, -58);       
        add(TITLE_BORDER);


        // create text
        blackTxt = new FlxText(150, 55);
        blackTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.WHITE, LEFT);
        blackTxt.text = "current";
        add(blackTxt);

        whiteTxt = new FlxText((blackTxt.fieldWidth + 178 ), 55);
        whiteTxt.setFormat(Resources.font('interstate-bold'), 85, FlxColor.BLACK, LEFT);
        whiteTxt.text = "conditions";
        add(whiteTxt); 


        // GRADIENT_BLACK.width = Std.int(blackTxt.fieldWidth);
        // GRADIENT_BLACK.x = blackTxt.fieldWidth - 305;

        forEach(sprite -> sprite.antialiasing = true);
    }
}