package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class AssistantTop extends FlxObject
{

	private var _sprite : FlxSprite;

	public function new( ) 
	{
		super();
		_sprite = new FlxSprite();
		_sprite.loadGraphic(AssetPaths.assistant3__png, true, 32, 16);
		_sprite.animation.add("idle", [0], 30, true);
		_sprite.animation.add("write", [1, 2, 3, 4, 5, 6, 0], 7, false);
		_sprite.scale.set(4, 4);
		_sprite.origin.set();
		_sprite.setPosition(128, 4);
		_sprite.animation.play("idle");
	}
	

	public override function update () : Void 
	{
		super.update();
		_sprite.update();
	}
	
	public function write() : Void 
	{
		_sprite.animation.play("write", true);
		
	}
	
	
	public override function draw () : Void 
	{
		super.draw();
		_sprite.draw();
	}
}