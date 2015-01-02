package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.FlxG;
/**
 * ...
 * @author 
 */
class Ingredient  extends FlxObject
{

	public var _col : Color;
	
	private var _state : PlayState;
	
	private var _sprite : FlxSprite;
	
	public var _hitBox : FlxSprite;
	
	public var _isNextIngredient : Bool;
	
	
	public function new(X:Float=0, Y:Float=0, c:Color, state:PlayState ) 
	{
		super(X, Y);
		_col = c;
		
		
		_state = state;
		
		
		_sprite = new FlxSprite(0, 0);
		_sprite = GetSpriteFromColor(_col);
		_hitBox = new FlxSprite(0, 0);
		_hitBox.makeGraphic(64, 64, FlxColorUtil.makeFromARGB(0,1,1,1));
		
		MouseEventManager.add(this._hitBox, null, null, onOver, onOut);
		
	}
	
	public function Pour () : Void 
	{
		_sprite.animation.play("pour", true);
	}
	
	
	public function onDown(spr:FlxSprite):Void 
	{
		if (!_isNextIngredient && alive)
		{
			var p :FlxPoint = new FlxPoint(x - FlxG.mouse.x, y - FlxG.mouse.y);
			_state.setActiveIngredient(this, p);
		}
		
	}
	
	public function onUp(spr:FlxSprite):Void 
	{
		
	}
	
	public function onOver(spr:FlxSprite):Void 
	{
		if (!_isNextIngredient && alive)
		{
			_sprite.color = FlxColorUtil.makeFromARGB(1.0, 200, 200, 200);
		}
	}
	
	public function onOut(spr:FlxSprite):Void 
	{
		if (!_isNextIngredient && alive)
		{
			_sprite.color = FlxColorUtil.makeFromARGB(1.0, 255, 255, 255);
		}
	}
	
	
	public function getColor () : Color 
	{
		return _col;
	}
	
	
	public override function update () :Void 
	{
		super.update();
		_sprite.update();
		_hitBox.update();
		if ( active)
		{

			
			_sprite.x = x;
			_sprite.y = y;
			
			_hitBox.x = x;
			_hitBox.y = y;
		}
		else
		{
			if (_sprite.animation.finished)
			{
				_state.ResetActiveIngredient();
			}
		}
		
	}
	
	
	public override function draw () :Void 
	{
		super.draw();
		_hitBox.draw();
		_sprite.draw();
	}
	
	
	
	
	
	
	public function GetSpriteFromColor (c:Color): FlxSprite
	{
		var spr : FlxSprite = new FlxSprite();
		
		//spr.makeGraphic(16, 16, ColorManagement.GetIntFromEnum(c));
		if (c == Color.Red)
		{
			spr.loadGraphic(AssetPaths.ingredient_red__png, true, 16, 16);
		}
		if (c == Color.Green)
		{
			spr.loadGraphic(AssetPaths.ingredient_green__png, true, 16, 16);
		}
		if (c == Color.Blue)
		{
			spr.loadGraphic(AssetPaths.ingredient_blue__png, true, 16, 16);
		}
		spr.animation.add("idle", [0], 30, true);
		spr.animation.add("pour", [1, 2, 3, 4, 5, 6, 7], 30, false);
		spr.animation.play("idle");
		
		
		spr.scale.set(4, 4);
		spr.updateHitbox();
		
		return spr;
	}
	
}