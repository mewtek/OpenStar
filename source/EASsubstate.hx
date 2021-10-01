package;

import flixel.FlxSubState;

/*
	THIS IS AN EXTREMELY EXPERIMENTAL FEATURE AND I AM NOT RESPONSIBLE FOR ANY
	OVER-THE-AIR BROADCASTS THAT MAY OCCUR WITH THIS.

	This is a substate responsible for handling EAS (Emergency Alert System) Emulation.
	At the moment, this will only work with North American SAME (Specific Area Message Encoding) systems
	as it's more simple to manage.

	I wouldn't recommend using this if you're for whatever reason using OpenStar to broadcast on TV stations,
	instead using an actual unit like a SAGE ENDEC with a character generator. 

	~ June P. (Zeexel)
 */
class EASsubstate extends FlxSubState {}
