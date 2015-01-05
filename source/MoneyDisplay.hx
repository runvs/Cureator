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
class MoneyDisplay
{

	private var _sprite :FlxSprite;
		
	private var _xOffs : Int = 24;
	private var _text : FlxText;
	
	public function new() 
	{
		_text = new FlxText();
		_text.fieldWidth = _xOffs;
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
	
	public function drawSingleNumber ( n : Int, p:FlxPoint)	// recursive !
	{
		if (n < 10)
		{
			//trace (n);
			//_text.x = p.x;
			//_text.y = p.y;
			//_text.text = Std.string(n);
			//_text.draw();
			
			//var t : FlxText = new FlxText(p.x, p.y, _xOffs, Std.string(n));
			//t.draw();
			//t.destroy();
		}
		else 
		{
			var m : Int = Std.int(n/10);
			drawSingleNumber(m, new FlxPoint(p.x - _xOffs, p.y));
			drawSingleNumber(n % 10, p);
		}
		
	}
	
}