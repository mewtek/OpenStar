package;

// This class works as a file name shortener for loading graphics
// and audio files.
class Resources
{
	public static function graphic(lib:String, file:String)
	{
		return 'assets/images/$lib/$file.png';
	}

	public static function icon(id:String) // Used for current conditons & TWA icons
	{
		return 'assets/images/cc_icons/$id.png';
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
