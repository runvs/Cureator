package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class SplashScreen extends FlxState
{
	
	private var _intro : FlxSprite;	// for fading the menu in  and out
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		trace("Splash intro");
		_intro = new FlxSprite();
		_intro.loadGraphic(AssetPaths.splash__png, true, 192, 128);
		var numberOfImages : Int = 40;
		var a : Array<Int> = new Array<Int>();
		for ( i in 0...numberOfImages)
		{
			a[i] = i;
		}
		var totalTime : Float = 1.0;
		var framerate : Int = Std.int(numberOfImages / totalTime);
		trace(framerate);
		_intro.animation.add("start", a, framerate, false);
		_intro.origin.set();
		_intro.offset.set();
		_intro.scale.set(4, 4);
		_intro.animation.play("start");
		add(_intro);
		var t : FlxTimer = new FlxTimer(totalTime, function (t : FlxTimer)
		{
			FlxG.switchState(new MenuState());
		});
	}
	
	/**
	 * 
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function draw()
	{
		super.draw();
		_intro.draw();
	}
}