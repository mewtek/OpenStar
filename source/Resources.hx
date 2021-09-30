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
			return 'assets/sounds/narrations/$file.mp3';
		}
		else
		{
			return 'assets/sounds/narrations/$lib/$file.mp3';
		}
	}

	public static function font(file:String)
	{
		return 'assets/fonts/$file.ttf';
	}
}
