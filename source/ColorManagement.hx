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
		// TODO: For neat code, create a dictionary and obtain values from there to avoid redundance
	}
	
	
	public static function GetIntFromEnum (c:Color):Int
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
	
	public static function GetEnumFromInt (c:Int) : Color
	{
		var col:Color;
		if (c == FlxColorUtil.makeFromARGB(1.0, 64, 64, 64))
		{
			col  = Color.None;
		}
		else if (c == FlxColorUtil.makeFromARGB(1.0, 255, 0, 0))
		{
			col  = Color.Red;
		}
		else if (c == FlxColorUtil.makeFromARGB(1.0, 0, 255, 0))
		{
			col  = Color.Green ;
		}
		else if (c == FlxColorUtil.makeFromARGB(1.0, 0, 0, 255))
		{
			col  = Color.Blue ;
		}
		
		else if (c == FlxColorUtil.makeFromARGB(1.0, 255, 255, 0))
		{
			col  = Color.Brown ;
		}
		else if (c == FlxColorUtil.makeFromARGB(1.0,255, 0, 255))
		{
			col  = Color.Purple ;
		}
		else if (c == FlxColorUtil.makeFromARGB(1.0, 0, 255, 255))
		{
			col  = Color.Cyan ;
		}
		
		else if (c == FlxColorUtil.makeFromARGB(1.0, 255, 255, 255))
		{
			col  =  Color.White;
		}
		else 
		{
			throw ("Unknown Color");
		}
		
		return col;
	}
	
	
	public static function CombineColors( c1:Color, c2: Color) : Color
	{
		if (c1 == c2)
		{
			return c1;
		}
		
		var i1 : Int = ColorManagement.GetIntFromEnum(c1);
		var i2 : Int = ColorManagement.GetIntFromEnum(c2);
		
		
		var ir :Int = FlxColorUtil.getRed(i1) + FlxColorUtil.getRed(i2);
		var ig :Int = FlxColorUtil.getGreen(i1) + FlxColorUtil.getGreen(i2);
		var ib :Int = FlxColorUtil.getBlue(i1) + FlxColorUtil.getBlue(i2);
		ir = (ir > 255) ? 255 : ir;
		ig = (ig > 255) ? 255 : ig;
		ib = (ib > 255) ? 255 : ib;
		
		
		var i3 : Int = FlxColorUtil.makeFromARGB(1.0, ir, ig, ib);
		
		var c3 :Color = null;
		try
		{
			c3 = GetEnumFromInt(i3);
		}
		catch ( msg : String ) 
		{
			trace("Error occurred: " + msg);
			
		}
		
		
		return c3;
	}
	
	
}