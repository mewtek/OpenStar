

# Building OpenStar
### This is for *building* OpenStar. If you're looking to just run the software, you should download the [latest release](https://github.com/mewtek/OpenStar/releases) instead

### Important Note:
In order to build for one operating system, **you need to be on that operating system.** So, to build on Windows, you need to be on Windows, same with Linux, and same with macOS. If you don't want to multi-boot, you can probably build for different operating systems using a virtual machine, but I can't personally garuntee the compile time will be too great.

## Set up compilers on Windows
Setting up compilers on Windows is a bit more complicated than other operating systems. In order to download the compilers, you also need to download [Visual Studio](https://visualstudio.microsoft.com/downloads/). 

When installing it, *don't click on the options to install workloads.* Instead, go to the **individual components** and install the following:

 - MSVC v142 - VS 2019 C++ x64/x86 build tools
 - Windows SDK (10.0.17763.0)

These will install 4 GB worth of tools. After this is finished, [download & install Haxe](https://haxe.org/download/), then continue to **[Set up HaxeFlixel & OpenFl](#set-up-haxeflixel--openfl)**

## Set up compilers on macOS
The software needed for compiling on macOS is included Apple's Xcode software. Download the latest verison of Xcode from [Apple's website.](https://developer.apple.com/xcode/) 
> Note, Xcode is kind of big, Go like, grab a coffee or take a shower or something, this will take a while.

After Xcode is installed, [download & install Haxe](https://haxe.org/download/), then continue to **[Set up HaxeFlixel & OpenFl](#set-up-haxeflixel--openfl)**

## Set up compilers on Linux
The software for building on Linux distros (debian, arch, etc.) should be pre-installed with your system. If not, install GCC and G++ using the following commands:

Debian: ``sudo apt install build-essential `` (Installs GCC, G++, and make.)
Arch: ``sudo pacman -Syu gcc``
centOS: ``sudo yum install gcc-c++``
Fedora: ``sudo dnf groupinstall 'Development Tools'``

> NOTE: You may also need to install ``g++-multilib`` and ``gcc-multilib``

After you've confirmed that GCC is installed on your system, [install Haxe](https://haxe.org/download/linux/), then continue to **[Set up HaxeFlixel & OpenFl](#set-up-haxeflixel--openfl)**


# Set up HaxeFlixel & OpenFl
After haxe is fully set up on your system, use ``haxelib`` to install the required libraries to your system.
```
haxelib install lime
haxelib install openfl
haxelib install flixel
```
Set up lime:
``haxelib run lime setup flixel``

After lime is set up, set up flixel-tools, and install the ``flixel`` command.
```
haxelib install flixel-tools
haxelib run flixel-tools setup
```

Use ``cd`` to change into OpenStar's directory, then use ``lime build [platform]`` to build the software. 
Aditionally, you can use the ``--debug`` command to build a debug version of OpenStar, and use ``lime test [platform]`` to automatically run the software after compiling.









