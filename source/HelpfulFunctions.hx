package;

// Mainly just some random choice type stuff
class HelpfulFunctions
{
	// These two functions borrowed from jasononeil/hxrandom
	// https://github.com/jasononeil/hxrandom/blob/master/src/Random.hx
	public static inline function int(from:Int, to:Int):Int
	{
		return from + Math.floor(((to - from + 1) * Math.random()));
	}

	public static inline function fromArray<T>(arr:Array<T>):Null<T>
	{
		return (arr != null && arr.length > 0) ? arr[int(0, arr.length - 1)] : null;
	}
}
