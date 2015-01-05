package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class RightAssistant extends FlxObject
{
	private var _sprite : FlxSprite;

	public function new() 
	{
		super();
		
		_sprite = new FlxSprite();
		_sprite.loadGraphic(AssetPaths.assistant2__png, true, 32, 32);
		_sprite.animation.add("idle", [0], 6, true);
		_sprite.animation.add("brew", [1, 2, 3, 1, 2, 3], 6, false);
		_sprite.animation.play("idle");
		_sprite.scale.set(4, 4);
		_sprite.origin.set();
		
		_sprite.x  = 576;
		_sprite.y = 260;
	}
	
	public function Brew() : Void
	{
		_sprite.animation.play("brew", true);
		var t : FlxTimer = new FlxTimer(1.0, function (t:FlxTimer) : Void { _sprite.animation.play("idle", true); } );
	}
	
	
	public override function update () : Void
	{
		_sprite.update();
	}
	
	public override function draw () : Void
	{
		_sprite.draw();
	}
}