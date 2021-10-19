package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sys.FileSystem;

/*
	This state is for use with programs like OBS in order to handle broadcasting like a TV station to
	something like Twitch or Youtube. In the future, this may have something different done to just 
	make it a transparent window, assuming OpenFL allows for that.

	~ June P. (Zeexel)
 */
class BroadcastState extends FlxState
{
	private var LDL:LowerDisplayLine;
	private var LFTimes:Array<Int>;

	override public function create()
	{
		LFTimes = [8, 18, 28, 38, 48, 58]; // 8s of every hour!

		bgColor = 0xFFFF00FF;
		LDL = new LowerDisplayLine(FlxColor.TRANSPARENT);
		openSubState(LDL);
	}

	override public function update(elapsed)
	{
		if (LFTimes.contains(Date.now().getMinutes()))
			FlxG.switchState(new PresentationState());

		super.update(elapsed);
	}
}
