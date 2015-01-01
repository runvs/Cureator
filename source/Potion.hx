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
	
	

	public function new(X:Float=0, Y:Float=0, c:Color, state:PlayState ) 
	{
		super(X, Y);
		_col = c;
		_fill = FillState.Empty;
		
		_state = state;
		
		_sprite = GetSpriteFromColor(_col);
		_hitBox = new FlxSprite(0, 0);
		_hitBox.makeGraphic(48, 48);
		
		
		
		MouseEventManager.add(this._hitBox, onDown, onUp, onOver, onOut);
		
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
		_sprite = GetSpriteFromColor(_col);
		spr.updateHitbox();
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
		if (_fill == FillState.Three)
		{
			Break();
			alive = false;
			exists = false;
		}
		else if (_fill == FillState.Empty)
		{
			_fill = FillState.One;
		}
		else if (_fill == FillState.One)
		{
			_fill = FillState.Two;
		}
		else if (_fill == FillState.Two)
		{
			_fill = FillState.Three;
		}
		
		_col = i._col;
		// TODO advanced color handling
		
	}
	
	public function Break():Void
	{
		
	}
	
	
	public function GetSpriteFromColor (c:Color): FlxSprite
	{
		var spr : FlxSprite = new FlxSprite();
		
		spr.makeGraphic(16, 16, ColorManagement.GetColorFromEnum(c));
		spr.scale.set(3, 3);
		
		spr.updateHitbox();
		
		return spr;
	}
	
}