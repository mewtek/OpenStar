package;

import sys.FileSystem;

// This class works as a file name shortener for loading graphics
// and audio files.
class Resources
{
	public static function graphic(lib:String, file:String)
	{
		return 'assets/images/$lib/$file.png';
	}

	public static function icon(code:Int)
	{
		var codeStr = Std.string(code);

		if (FileSystem.exists('assets/images/cc_icons/$codeStr.png'))
			return 'assets/images/cc_icons/$codeStr.png';
		else
			return 'assets/images/cc_icons/44.png';
	}

	public static function narration(file:String, lib:String)
	{
		if (lib == null)
		{
			return 'assets/narrations/$file.ogg';
		}
		else
		{
			return 'assets/narrations/$lib/$file.ogg';
		}
	}

	public static function font(file:String)
	{
		return 'assets/fonts/$file.ttf';
	}

	public static function music(file:String) // Remember to use the full file for this
	{
		return 'assets/music/$file';
	}
}
