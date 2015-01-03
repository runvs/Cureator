package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class LeftAssistant extends FlxObject
{
	
	private var _spriteRed :FlxSprite;
	private var _spriteGreen :FlxSprite;
	private var _spriteBlue :FlxSprite;
	
	private var _col:Color;
	
	private var _isInTake :Bool;
	
	public static function GetAnimTimeUntilPotionApears () : Float { return 0.571; }
	
	
	public function new( ) 
	{
		super();
		_col = Color.None;
		
		_isInTake = false;
		
		_spriteRed = new FlxSprite();
		_spriteGreen = new FlxSprite();
		_spriteBlue = new FlxSprite();
		
		_spriteRed.loadGraphic(AssetPaths.Assistant1_red__png, true, 32, 48);
		_spriteGreen.loadGraphic(AssetPaths.Assistant1_green__png, true, 32, 48);
		_spriteBlue.loadGraphic(AssetPaths.Assistant1_blue__png, true, 32, 48);
		
		_spriteRed.scale.set(4, 4);
		_spriteGreen.scale.set(4, 4);
		_spriteBlue.scale.set(4, 4);
		
		_spriteRed.origin.set();
		_spriteGreen.origin.set();
		_spriteBlue.origin.set();
		
		_spriteRed.animation.add("idle", [0], 6, true);
		_spriteRed.animation.add("pick", [0, 1, 2, 3], 6, false);
		_spriteRed.animation.add("hold", [4], 6, true);
		_spriteRed.animation.add("take", [5], 6, true);
		_spriteRed.animation.add("takeMid", [0], 6, true);
		
		_spriteGreen.animation.add("idle", [0], 6, true);
		_spriteGreen.animation.add("pick", [0, 1, 2, 3], 6, false);
		_spriteGreen.animation.add("hold", [4], 6, false);
		_spriteGreen.animation.add("take", [5], 6, true);
		_spriteGreen.animation.add("takeMid", [0], 6, true);
		
		_spriteBlue.animation.add("idle", [0], 6, true);
		_spriteBlue.animation.add("pick", [0, 1, 2, 3], 6, false);
		_spriteBlue.animation.add("hold", [4], 6, true);
		_spriteBlue.animation.add("take", [5], 6, true);
		_spriteBlue.animation.add("takeMid", [0], 6, true);
		
		_spriteRed.animation.play("hold");
		
		_spriteRed.x = _spriteGreen.x = _spriteBlue.x  = 64;
		_spriteRed.y = _spriteGreen.y = _spriteBlue.y  = 192;
		
		_spriteRed.setFacingFlip(FlxObject.LEFT, true, false);
		_spriteRed.setFacingFlip(FlxObject.RIGHT, false, false);
		
		_spriteGreen.setFacingFlip(FlxObject.LEFT, true, false);
		_spriteGreen.setFacingFlip(FlxObject.RIGHT, false, false);
		
		_spriteBlue.setFacingFlip(FlxObject.LEFT, true, false);
		_spriteBlue.setFacingFlip(FlxObject.RIGHT, false, false);
	}
	
	// when ingr. is taken from the assistant
	public function Take () : Void
	{
		_isInTake = true;
		//trace ("take");
		_spriteRed.animation.play("take");
		_spriteGreen.animation.play("take");
		_spriteBlue.animation.play("take");
	}
	
	// when ingr. returns to assistant
	public function Release () : Void
	{
		_spriteRed.animation.play("hold");
		_spriteGreen.animation.play("hold");
		_spriteBlue.animation.play("hold");
		_isInTake = false;
	}
	
	public function Pick(c:Color):Void
	{
		_isInTake = false;
		if (c == Color.Red)
		{
			PickRed();
		}
		else if (c == Color.Green)
		{
			PickGreen();
		}
		else if (c == Color.Blue)
		{
			PickBlue();
		}
	}
	
	private function PickRed():Void
	{
		_col = Color.Red;
		_spriteRed.animation.play("pick");
	}
	
	private function PickGreen():Void
	{
		_col = Color.Green;
		_spriteGreen.animation.play("pick");
	}
	
	private function PickBlue():Void
	{
		_col = Color.Blue;
		_spriteBlue.animation.play("pick");
	}
	
	
	public override function update () : Void 
	{
		_spriteRed.update();
		_spriteGreen.update();
		_spriteBlue.update();
		_spriteRed.facing = FlxObject.RIGHT;
		_spriteGreen.facing = FlxObject.RIGHT;
		_spriteBlue.facing = FlxObject.RIGHT;
		
		if (_isInTake)
		{
			var facingLeft : Bool = (FlxG.mouse.x < _spriteRed.x );
			var facingRight : Bool = (FlxG.mouse.x > _spriteRed.x  + 128); 
			if (facingLeft)
			{
				//trace("face left");
				_spriteRed.animation.play("take", true);
				_spriteGreen.animation.play("take", true);
				_spriteBlue.animation.play("take", true);
				_spriteRed.facing = FlxObject.LEFT;
				_spriteGreen.facing = FlxObject.LEFT;
				_spriteBlue.facing = FlxObject.LEFT;
			}
			else if (facingRight)
			{
				//trace("face right");
				_spriteRed.animation.play("take", true);
				_spriteGreen.animation.play("take", true);
				_spriteBlue.animation.play("take", true);
				_spriteRed.facing = FlxObject.RIGHT;
				_spriteGreen.facing = FlxObject.RIGHT;
				_spriteBlue.facing = FlxObject.RIGHT;
			}
			else 
			{
				//trace("center");
				_spriteRed.animation.play("takeMid", true);
				_spriteGreen.animation.play("takeMid", true);
				_spriteBlue.animation.play("takeMid", true);
			}
		}
		else
		{
			if (_col == Color.Red && _spriteRed.animation.finished)
			{
				_spriteRed.animation.play("hold");
			}
			else if (_col == Color.Green && _spriteGreen.animation.finished)
			{
				_spriteGreen.animation.play("hold");
				_spriteRed.animation.play("idle");
			}
			else if (_col == Color.Blue && _spriteBlue.animation.finished)
			{
				_spriteBlue.animation.play("hold");
				_spriteRed.animation.play("idle");
			}
		}
	}
	
	
	
	public override function draw () : Void 
	{
		if (_col == Color.None)
		{
			_spriteRed.draw();
		}
		else if (_col == Color.Red)
		{
			_spriteRed.draw();
		}
		else if (_col == Color.Green)
		{
			_spriteGreen.draw();
		}
		else if (_col == Color.Blue)
		{
			_spriteBlue.draw();
		}
	}
}