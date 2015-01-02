package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
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
		
		
		_hitBox = new FlxSprite(0, 0);
		_hitBox.makeGraphic(32, 32);
		
		_sprite = new FlxSprite(0, 0);
		_sprite = GetSpriteFromColor(_col);
		
		MouseEventManager.add(this._hitBox, null, null, onOver, onOut);
		
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
			_sprite = GetSpriteFromColor(Color.White);
			spr.updateHitbox();
		}
	}
	
	public function onOut(spr:FlxSprite):Void 
	{
		if (!_isNextIngredient && alive)
		{
		_sprite = GetSpriteFromColor(_col);
		spr.updateHitbox();
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
		
		_sprite.x = x;
		_sprite.y = y;
		
		_hitBox.x = x;
		_hitBox.y = y;
		
		
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
		
		spr.makeGraphic(16, 16, ColorManagement.GetIntFromEnum(c));
		spr.scale.set(2, 2);
		
		spr.updateHitbox();
		
		return spr;
	}
	
}