package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxBitmapTextField;
import flixel.text.FlxText;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class MoneyDisplay extends FlxObject
{

	private var _sprite :FlxSprite;
	
	private var _number : Int;
	
	private static var _xOffs : Int = 24;
	
	public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) 
	{
		super(X, Y, Width, Height);
		
	}
	
	public override function draw():Void
	{
		var Ones : Int = _number % 10;
		
		
		
	}
	
	public static function getDigitCount ( n : Int) : Int
	{
		var digits = 0;
		if (n != 0)
		{
			var baseExponent : Float =  Math.log(n) / Math.log(10);
			digits = Std.int(baseExponent) + 1;
			
		}
		//trace (n + " has " + digits + " digits");
		return digits;
	}
	
	public static function drawSingleNumber ( n : Int, p:FlxPoint)	// recursive !
	{
		if (n < 10)
		{
			//trace (n);
			var t : FlxText = new FlxText(p.x, p.y, _xOffs, Std.string(n));
			t.draw();
		}
		else 
		{
			var m : Int = Std.int(n/10);
			drawSingleNumber(m, new FlxPoint(p.x - _xOffs, p.y));
			drawSingleNumber(n % 10, p);
		}
		
	}
	
	public function SetNumber ( n : Int) : Void
	{
		_number = n;
	}
	
}