package ;
import flixel.util.FlxColorUtil;
import haxe.ds.ObjectMap;

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
			throw ("Unknown Color" + c);
		}
		
		return col;
	}
	
	// ternary systems rock ass! :D
	public static function ConvertToOrderParameter (c:Color) : Int
	{
		if (c == Color.Red)
		{
			return 0;
		}
		else if (c == Color.Green)
		{
			return 1;
		}
		else if (c == Color.Blue)
		{
			return 2;
		}
		
		//Yellow;		// Red + Green
		//Orange;		// Red + Red + Green
		//YellowGreen;// Red + Green + Green
		else if (c == Color.Yellow)
		{
			return 10;
		}
		else if (c == Color.Orange)
		{
			return 100;
		}
		else if (c == Color.YellowGreen)
		{
			return 110;
		}
		
		

	
		//Magenta;		// Red + Blue
		//Pink;			// Red + Red + Blue
		//Purple;		// Red + Blue + Blue
		else if (c == Color.Magenta)
		{
			return 20;
		}
		else if (c == Color.Pink)
		{
			return 200;
		}
		else if (c == Color.Purple)
		{
			return 220;
		}

		//Cyan;		// Green + Blue
		//SeaGreen;	// Green + Green + Blue
		//Skyblue;	// Green + Blue + Blue
		else if (c == Color.Cyan)
		{
			return 21;
		}
		else if (c == Color.SeaGreen)
		{
			return 211;
		}
		else if (c == Color.Skyblue)
		{
			return 221;
		}
		else if (c == Color.White)
		{
			return 210;
		}
		return -1;
		
	}
	
	public static function CombineColors( p1:Potion, c2: Color) : Color
	{
		var c1 :Color = p1._col;
		
		trace ("mixing " + c1 + " " + c2 );
		
		// check the easy cases first
		if (c1 == c2)
		{
			return c1;
		}
		if (p1._fill == FillState.Empty)
		{
			return c2;
		}
		if (p1._fill == FillState.Three)
		{
			return Color.White;
		}
		if ( c1 == Color.None)
		{
			return c2;
		}
		if ( c2 == Color.None)
		{
			return c1;
		}

		var c3 :Color = Color.None;
		
		
		
		
		
		// now begins the coding fun!
		if (p1._fill == FillState.One)
		{
			if (ConvertToOrderParameter(c2) < ConvertToOrderParameter(c1))
			{
				var p : Potion  = new Potion( -100, -100, c2, null);
				p._fill = FillState.One;
				return CombineColors(p , c1);	// half the cases killed :D
			}
			if (c1 == Color.Red && c2 == Color.Green)
			{
				c3 = Color.Yellow;
			}
			if (c1 == Color.Red && c2 == Color.Blue)
			{
				c3 = Color.Magenta;
			}
			if (c1 == Color.Green && c2 == Color.Blue)
			{
				c3 = Color.Cyan;
			}
			// so with this all two color cases are handled.
		}
		else if (p1._fill == FillState.Two)
		{
			if (c1 == Color.Red && c2 == Color.Green)	// two red, one green
			{
				c3 = Color.Orange;
			}
			if (c1 == Color.Yellow && c2 == Color.Red)	// yellow(red + green), red
			{
				c3 = Color.Orange;
			}
			
			if (c1 == Color.Green && c2 == Color.Red)	// two green, red
			{
				c3 = Color.YellowGreen;
			}
			if (c1 == Color.Yellow && c2 == Color.Green)	//yellow (red + green), green
			{
				c3 = Color.YellowGreen;
			}
			
			if (c1 == Color.Red && c2 == Color.Blue) // two red, blue
			{
				c3 = Color.Pink;
			}
			if (c1 == Color.Magenta && c2 == Color.Red) // Pink (red + blue), red
			{
				c3 = Color.Pink;
			}
			
			if (c1 == Color.Blue && c2 == Color.Red) // two blue, red
			{
				c3 = Color.Purple;
			}
			if (c1 == Color.Magenta && c2 == Color.Blue) // Magenta (red + blue), blue
			{
				c3 = Color.Purple;
			}
			
			if (c1 == Color.Green && c2 == Color.Blue) // two green, blue
			{
				c3 = Color.SeaGreen;
			}
			if (c1 == Color.Cyan && c2 == Color.Blue) // cyan (green + blue), green
			{
				c3 = Color.SeaGreen;
			}
			
			if (c1 == Color.Blue && c2 == Color.Green) // two blue, green
			{
				c3 = Color.Skyblue;
			}
			if (c1 == Color.Cyan && c2 == Color.Blue) // cyan (green + blue), blue
			{
				c3 = Color.Skyblue;
			}
			
			if (c1 == Color.Yellow && c2 == Color.Blue || c2 == Color.Yellow && c1 == Color.Blue)
			{
				//trace ("crafted white");
				c3 = Color.White;
			}
			if (c1 == Color.Magenta && c2 == Color.Green || c2 == Color.Magenta && c1 == Color.Green)
			{
				//trace ("crafted white");
				c3 = Color.White;
			}
			if (c1 == Color.Cyan && c2 == Color.Red || c2 == Color.Cyan && c1 == Color.Red)
			{
				//trace ("crafted white");
				c3 = Color.White;
			}
			
		}
		
		trace ("created " + c3);
		
		return c3;
		//White;		// Red + Green + Blue
		
		
		//var i1 : Int = ColorManagement.GetIntFromEnum(c1);
		//var i2 : Int = ColorManagement.GetIntFromEnum(c2);
		//
		//
		//var ir :Int = FlxColorUtil.getRed(i1) + FlxColorUtil.getRed(i2);
		//var ig :Int = FlxColorUtil.getGreen(i1) + FlxColorUtil.getGreen(i2);
		//var ib :Int = FlxColorUtil.getBlue(i1) + FlxColorUtil.getBlue(i2);
		//ir = (ir > 255) ? 255 : ir;
		//ig = (ig > 255) ? 255 : ig;
		//ib = (ib > 255) ? 255 : ib;
		//
		//
		//var i3 : Int = FlxColorUtil.makeFromARGB(1.0, ir, ig, ib);
		//
		//var c3 :Color = null;
		//try
		//{
			//c3 = GetEnumFromInt(i3);
		//}
		//catch ( msg : String ) 
		//{
			//trace("Error occurred: " + msg);
			//
		//}
		//return c3;
	}	
	
}