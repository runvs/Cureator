package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;

/**
 * ...
 * @author 
 */
class AssistantBack2Menu extends FlxObject
{

	private var _sprite : FlxSprite;
	private var _state : PlayState;
	private var _over : Bool;	// needed to play the lifting animation only once

	public function new( state : PlayState ) 
	{
		super();
		_state = state;
		_sprite = new FlxSprite();
		_sprite.loadGraphic(AssetPaths.assistant4__png, true, 32, 32);
		_sprite.animation.add("out", [0], 30, true);
		_sprite.animation.add("over", [1, 0], 3, true);
		_sprite.origin.set();
		_sprite.scale.set(4, 4);
		_sprite.setPosition(0, 0);
		_sprite.animation.play("out");
		_over = false;
	}
	

	public override function update () : Void 
	{
		super.update();
		_sprite.update();
		// check for mouse over!
		if (FlxG.mouse.x < 256 && FlxG.mouse.y < 128)
		{
			if (!_over)
			{
				_sprite.animation.play("over", true);
				_over = true;
			}
			//trace("over " + FlxG.mouse.x + " " + FlxG.mouse.y);
			if (FlxG.mouse.justReleased)
			{
				_state.LooseGame();
			}
		}
		else
		{
			_sprite.animation.play("out", true);
			_over = false;
			//trace("out " + FlxG.mouse.x + " " + FlxG.mouse.y);
		}
	}
	
	public override function draw () : Void 
	{
		super.draw();
		_sprite.draw();
		
	}
}