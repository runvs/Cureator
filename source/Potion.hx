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
	private var _col : Color;
	private var _fill : FillState;
	
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
		
		_sprite = GetSpriteFromColor(_col);
		_hitBox = new FlxSprite(0, 0);
		_hitBox.makeGraphic(64, 64, FlxColorUtil.makeFromARGB(0.0,1,1,1));
		
		_originalPosition = new FlxPoint(x, y);
		
		_complete = false;
		
		MouseEventManager.add(this._hitBox, null, null , onOver, onOut);
		
	}
	
	
	public function onDown(spr:FlxSprite):Void 
	{
		var p :FlxPoint = new FlxPoint(x - FlxG.mouse.x, y - FlxG.mouse.y);
		_state.setActivePotion(this, p);
		
	}
	
	public function onUp(spr:FlxSprite):Void 
	{
		
	}
	
	public function onOver(spr:FlxSprite):Void 
	{
		_sprite = GetSpriteFromColor(Color.White);
		spr.updateHitbox();
	}
	
	public function onOut(spr:FlxSprite):Void 
	{
		updateColor();
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
		if (_fill == FillState.Three)
		{
			Break();
			alive = false;
			exists = false;
		}
		else if (_fill == FillState.Empty)
		{
			_fill = FillState.One;
			_col = i._col;
		}
		else if (_fill == FillState.One)
		{
			_fill = FillState.Two;
			_col = ColorManagement.CombineColors(_col, i._col);
		}
		else if (_fill == FillState.Two)
		{
			_fill = FillState.Three;
			_col = ColorManagement.CombineColors(_col, i._col);
		}
		
		updateColor();
	}
	
	
	
	
	
	public function Break():Void
	{
		
	}
	
	public function updateColor():Void
	{
		_sprite = GetSpriteFromColor(_col);
		_sprite.updateHitbox();
	}
	
	
	public function GetSpriteFromColor (c:Color): FlxSprite
	{
		var spr : FlxSprite = new FlxSprite();
		
		
		
		if (c == Color.Red)
		{
			spr.loadGraphic(AssetPaths.potion_red__png, true, 16, 16);
			_complete = true;
		}
		else if (c == Color.Green)
		{
			spr.loadGraphic(AssetPaths.potion_green__png, true, 16, 16);
			_complete = true;
		}
		else if (c == Color.Blue)
		{
			spr.loadGraphic(AssetPaths.potion_blue__png, true, 16, 16);
			_complete = true;
		}
		else if (c == Color.None)
		{
			spr.loadGraphic(AssetPaths.potion_empty____png, true, 16, 16);
		}
		else 
		{
			spr.makeGraphic(16, 16, ColorManagement.GetIntFromEnum(c));
			_complete = false;
		}
		
		if ( _complete && c != Color.None)
		{
			spr.animation.add ("One", [0], 30, true);
			spr.animation.add ("Two", [1], 30, true);
			spr.animation.add ("Three", [2], 30, true);
		}
		
		if (_complete)
		{
			if (_fill == FillState.One)
			{
				spr.animation.play("One");
			}
			else if (_fill == FillState.Two)
			{
				spr.animation.play("Two");
			}
			else if (_fill == FillState.Three)
			{
				spr.animation.play("Three");
			}
		}
		spr.scale.set(4, 4);
		spr.updateHitbox();
		
		return spr;
	}
	
}