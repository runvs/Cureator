package ;
import flixel.util.FlxColorUtil;

/**
 * ...
 * @author 
 */
class ColorManagement
{

	public function new() 
	{
	}
	public static function GetColorFromEnum (c:Color):Int
	{
		var col : Int;
		
		if (c == Color.None)
		{
			col  = FlxColorUtil.makeFromARGB(1.0, 64, 64, 64);
		}
		else if (c == Color.Red)
		{
			col  = FlxColorUtil.makeFromARGB(1.0, 255, 0, 0);
		}
		else if (c == Color.Green)
		{
			col  = FlxColorUtil.makeFromARGB(1.0, 0, 255, 0);
		}
		else if (c == Color.Blue)
		{
			col  = FlxColorUtil.makeFromARGB(1.0, 0, 0, 255);
		}
		
		else if (c == Color.Brown)
		{
			col  = FlxColorUtil.makeFromARGB(1.0, 255, 255, 0);
		}
		else if (c == Color.Purple)
		{
			col  = FlxColorUtil.makeFromARGB(1.0,255, 0, 255);
		}
		else if (c == Color.Cyan)
		{
			col  = FlxColorUtil.makeFromARGB(1.0, 0, 255, 255);
		}
		
		else if (c == Color.White)
		{
			col  = FlxColorUtil.makeFromARGB(1.0, 255, 255, 255);
		}
		else 
		{
			throw ("Unknown Color");
		}
		
		return col;
	}
	
}