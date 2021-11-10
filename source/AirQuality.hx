package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class AirQuality extends FlxSpriteGroup
{

  // Generic Panel GFX
  var panel:FlxSprite;
  var tex:String = Resources.graphic('Panels', 'panelName');
  public var fadedIn:Bool;
  public var fadedOut:Bool;

  public function new()
  {
    super();
    
    // create panel
    panel = new FlxSprite(0, 165).loadGraphic(tex);
    panel.screenCenter(X);
    add(panel);

    forEach(sprite -> {sprite.antialiasing = true;});
  }

  public inline function fadeIn() {}
  public inline function fadeOut() {}
  
}