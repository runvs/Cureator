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
	
	public var _sprite : FlxSprite;
	
	public var _hitBox : FlxSprite;
	
	public var _isNextIngredient : Bool;
	
	public var _doDraw : Bool;
	
	
	public function new(X:Float=0, Y:Float=0, c:Color, state:PlayState ) 
	{
		super(X, Y);
		_col = c;
		
		_doDraw = true;
		
		_state = state;
		
		
		_sprite = new FlxSprite(0, 0);
		_sprite = GetSpriteFromColor(_col);
		_hitBox = new FlxSprite(0, 0);
		_hitBox.makeGraphic(64, 64, FlxColorUtil.makeFromARGB(0,100,100,100));
		
	}
	
	public function Pour () : Void 
	{
		_sprite.animation.play("pour", true);
	}
	public function Unpour () : Void 
	{
		_sprite.animation.play("idle", true);
	}

	public function getColor () : Color 
	{
		return _col;
	}
	
	
	public override function update () :Void 
	{
		//super.update();
		_sprite.update();
		_hitBox.update();
		if ( active)
		{
			_sprite.x = _hitBox.x =  x;
			_sprite.y = _hitBox.y = y;
		}
		else
		{
		}
		
	}
	
	
	public override function draw () :Void 
	{
		super.draw();
		_hitBox.draw();
		if (_doDraw)
		{
			_sprite.draw();
		}
	}
	
	
	
	
	
	
	public function GetSpriteFromColor (c:Color): FlxSprite
	{
		var spr : FlxSprite = new FlxSprite();
		
		//spr.makeGraphic(16, 16, ColorManagement.GetIntFromEnum(c));
		if (c == Color.Red)
		{
			spr.loadGraphic(AssetPaths.ingredients_red__png, true, 16, 16);
		}
		if (c == Color.Green)
		{
			spr.loadGraphic(AssetPaths.ingredients_green__png, true, 16, 16);
		}
		if (c == Color.Blue)
		{
			spr.loadGraphic(AssetPaths.ingredients_blue__png, true, 16, 16);
		}
		spr.animation.add("idle", [0], 30, true);
		spr.animation.add("pour", [1], 30, true);
		spr.animation.play("idle");
		
		
		spr.scale.set(4, 4);
		spr.updateHitbox();
		
		return spr;
	}
	
}