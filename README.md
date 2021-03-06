# We're back in business!
I've got new API Keys, a few months of free time, and alot of ideas for this emulator.

So, for starters: **I may be abandoning HaxeFlixel and going strictly with OpenFL.**
Not only would it be easier to compile for systems like the Raspberry Pi, but it would also provide a much more barebones, and generally more *customizable* way to work with OpenStar. The original HaxeFlixel versions will be available as its own branch, but from now on, the only "abandoned" part of openstar is the HaxeFlixel version as I begin to work more on the OpenFL port.

As with that OpenFL port, that actually means like stuff like Radars and the like will work much better. HaxeFlixel has a habit of using Lime's resource caching, which is great for stuff like the primary emulator and it's graphics, but when it comes to adding new skin packs (e.g. to emulate the feel of the WeatherSTAR XL), and radar images, it's hard to get HaxeFlixel to load loose files without having to do some fuckery.

This will just be a test! If I can't get a good product with the OpenFL version, then it's likely I'll come back to the HaxeFlixel version.

I'm going to be updating the API keys for this version of the emulator so that it all works as intended. Just note that will not be a finished product using HaxeFlixel. Anything that seems to be broken is pretty much on you to fix.


# Original README
<p align="center">
	<img width=750 src="https://i.imgur.com/uShXA4a.png"></img>
	
</p>

## What is this?
OpenStar is software written in Haxe using the [HaxeFlixel](https://haxeflixel.com) and [OpenFl](https://www.openfl.org) libraries. 
Its intention is to replicate, or *"simulate*" the old [IntelliStar](https://en.wikipedia.org/wiki/WeatherStar#IntelliStar) systems used in the early to mid 2000s, and early 2010s by The Weather Channel. 

However, in its current state, its not much. I'm still developing the software as time goes on, and I can only do so much whilst living with school, dealing with family matters, etc. Hopefully, by some time in 2022 or early 2023, this software will reach a point where it can be used alongside systems such as [Taiganet's WeatherSTAR 4000 Simulator](http://www.taiganet.com) and [Goldblaze's WeatherScan fork.](https://github.com/buffbears/Weatherscan/)

While it can be used in the same vein as the WeatherSTAR 4000 Simulator, creating and displaying constant local forecast products, another use case that can be done for this software is using it more like an actual overlay. The BroadcastState in this program has the LDL overlaying onto a magenta chroma key. 

This can be used with software such as OBS to stream or record external content aside from OpenStar's own Local on the 8s presentation products. 

## How do I build this?
**Once a release is out, I'd highly recommend just downloading a copy of the software rather than building it on your own.**

Build instructions for the software can be found [here](https://github.com/mewtek/OpenStar/blob/master/BUILD.md). It will take you through setting up your compilers, Haxe, and the libraries necessary for building the software from source. 

Also note that when building this software, **you can only build for the current Operating System that you're using.** That means if you're building on Windows, you can only build for Windows, same with macOS, and Linux, etc. 

Building HTML5 versions requires heavy source code modification and some rewrites to functions that may not work with it. While I don't plan on adding official HTML5 support for OpenStar anytime soon, I will gladly accept pull requests that attempt to add it for the sake of letting it run on older systems that at least have enough power to render HTML5-based applications.

## Credits
- [tomtwentytoo](https://twitter.com/tomtwentytoo) made the graphic recreations for OpenStar
- [wxTV](https://twitter.com/luesjo12) gave help regarding APIs used
- [mewtek](https://github.com/mewtek)  did the main programming
- [IBM](https://www.ibm.com/weather) for the API Data

## Attributions and Disclaimers

**This project is in no way affiliated with IBM, The Weather Company, or the National Oceanic Atmospheric Administration, and should not be used in the event of life-threatening emergencies.**

**I am not liable in the event of on-air broadcasts using this software's EAS encoder and character generator, or any broadcasts that showcase weather warnings & information.**

Air Quality measurements are powered by Copernicus Atmosphere Monitoring Service Information 2021. Neither the European Commissions nor ECMWF is responsible for any use that may be made of the Copernicus Information or Data it contains.

