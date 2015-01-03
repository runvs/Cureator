package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxPoint;


/**
 * ...
 * @author 
 */
class Potion extends FlxObject
{
	public var _col : Color;
	public var _fill : FillState;
	
	private var _sprite : FlxSprite;
	
	public var _hitBox :FlxSprite;
	
	
	private var _state : PlayState;
	
	public var _originalPosition : FlxPoint;
	
	private var _complete :Bool;


	public function new(X:Float=0, Y:Float=0, c:Color , state:PlayState ) 
	{
		super(X, Y);
		_col = c;
		_state = state;
		
		_fill = FillState.Empty;
		
		GetSpriteFromColor();
		_hitBox = new FlxSprite(0, 0);
		_hitBox.makeGraphic(64, 64, FlxColorUtil.makeFromARGB(0.0,1,1,1));
		
		_originalPosition = new FlxPoint(x, y);
		
		_complete = false;
		
	}
	

	
	public function getColor () : Color 
	{
		return _col;
	}
	
	public override function update():Void
	{
		super.update();
		_sprite.update();
		_hitBox.update();
		
		_sprite.x = x;
		_sprite.y = y;
		
		_hitBox.x = x;
		_hitBox.y = y;
	}
	
	
	public override function draw():Void
	{
		super.draw();
		_hitBox.draw();
		_sprite.draw();
	}
	
	public function AddIngedient(i:Ingredient):Void
	{
		//trace ("old color: " + _col);
		//trace ("add color: " + i._col);
		_col = ColorManagement.CombineColors(this, i._col);
		if (_fill == FillState.Three)
		{
			Break();
		}
		else if (_fill == FillState.Empty)
		{
			_fill = FillState.One;
			_col = i._col;
		}
		else if (_fill == FillState.One)
		{
			_fill = FillState.Two;
			
		}
		else if (_fill == FillState.Two)
		{
			_fill = FillState.Three;
		}
		
		updateColor();
	}
	

	public function Break():Void
	{
		alive = false;
		exists = false;
		_state.SpawnNewJar(_originalPosition);
	}
	
	public function updateColor():Void
	{
		GetSpriteFromColor();
		_sprite.updateHitbox();
	}
	
	
	public function GetSpriteFromColor (): Void
	{
		if (_sprite == null)
		{
			_sprite = new FlxSprite();
		}
		if (_col == Color.Red)
		{
			_sprite.loadGraphic(AssetPaths.potion_red__png, true, 16, 16);
			_complete = true;
		}
		else if (_col == Color.Green)
		{
			_sprite.loadGraphic(AssetPaths.potion_green__png, true, 16, 16);
			_complete = true;
		}
		else if (_col == Color.Blue)
		{
			_sprite.loadGraphic(AssetPaths.potion_blue__png, true, 16, 16);
			_complete = true;
		}
		else if (_col == Color.Yellow)
		{
			_sprite.loadGraphic(AssetPaths.potion_yellow__png, true, 16, 16);
		}
		else if (_col == Color.Orange)
		{
			_sprite.loadGraphic(AssetPaths.potion_orange__png, true, 16, 16);
		}
		else if (_col == Color.YellowGreen)
		{
			_sprite.loadGraphic(AssetPaths.potion_yellowgreen__png, true, 16, 16);
		}
		else if (_col == Color.Pink)
		{
			_sprite.loadGraphic(AssetPaths.potion_pink__png, true, 16, 16);
		}
		else if (_col == Color.Magenta)
		{
			_sprite.loadGraphic(AssetPaths.potion_magenta__png, true, 16, 16);
		}
		else if (_col == Color.Purple)
		{
			_sprite.loadGraphic(AssetPaths.potion_purple__png, true, 16, 16);
		}
		
		else if (_col == Color.Cyan)
		{
			_sprite.loadGraphic(AssetPaths.potion_cyan__png, true, 16, 16);
		}
		else if (_col == Color.SeaGreen)
		{
			_sprite.loadGraphic(AssetPaths.potion_seagreen__png, true, 16, 16);
		}
		else if (_col == Color.Skyblue)
		{
			_sprite.loadGraphic(AssetPaths.potion_skyblue__png, true, 16, 16);
		}
		else if (_col == Color.White)
		{
			_sprite.loadGraphic(AssetPaths.potion_white__png, true, 16, 16);
		}
		else if (_col == Color.None)
		{
			_sprite.loadGraphic(AssetPaths.potion_empty__png, true, 16, 16);
		}
		else 
		{
			//_sprite.makeGraphic(16, 16, ColorManagement.GetIntFromEnum(_col));
			_complete = false;
		}
		
		if ( _complete && _col != Color.None)
		{
			_sprite.animation.add ("One", [0], 30, true);
			_sprite.animation.add ("Two", [1], 30, true);
			_sprite.animation.add ("Three", [2], 30, true);
		}
		
		if (_complete)
		{
			if (_fill == FillState.One)
			{
				_sprite.animation.play("One");
			}
			else if (_fill == FillState.Two)
			{
				_sprite.animation.play("Two");
			}
			else if (_fill == FillState.Three)
			{
				_sprite.animation.play("Three");
			}
		}
		_sprite.scale.set(4, 4);
		_sprite.updateHitbox();
	}
	
}