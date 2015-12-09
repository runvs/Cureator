package ;

import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class RecipeDrawer extends FlxSprite
{

	public function new() 
	{
		super();
		loadGraphic(AssetPaths.texts_recipe__png, true, 50, 7);
		scale.set(4, 4);
		origin.set();
		setPosition(284, 56);
		animation.add("red1", [0], 6, true);
		animation.add("red2", [3], 6, true);
		animation.add("red3", [15], 6, true);
		
		animation.add("green1", [1], 6, true);
		animation.add("green2", [4], 6, true);
		animation.add("green3", [16], 6, true);
		
		animation.add("blue1", [2], 6, true);
		animation.add("blue2", [5], 6, true);
		animation.add("blue3", [17], 6, true);
		
		animation.add("yellow", [6], 6, true);
		animation.add("magenta", [7], 6, true);
		animation.add("cyan", [8], 6, true);
		animation.add("orange", [9], 6, true);
		animation.add("yellowgreen", [10], 6, true);
		animation.add("pink", [11], 6, true);
		animation.add("purple", [12], 6, true);
		animation.add("seagreen", [13], 6, true);
		animation.add("skyblue", [14], 6, true);
	}
	
	private function DrawColor(c : Color, f : FillState)
	{
		var animString :String = "";
		var fi : Int = 1;
		if (f == FillState.One)
		{	
			fi = 1;
		}
		else if (f == FillState.Two)
		{	
			fi = 2;
		}
		else if (f == FillState.Three)
		{	
			fi = 3;
		}
		
		if (c == Color.Red)
		{
			animString = "red" + Std.string(fi);
		}
		else if (c == Color.Green)
		{
			animString = "green" + Std.string(fi);
		}
		else if (c == Color.Blue)
		{
			animString = "blue" + Std.string(fi);
		}
		else if (c == Color.Yellow)
		{
			animString = "yellow";
		}
		else if (c == Color.Magenta)
		{
			animString = "magenta";
		}
		else if (c == Color.Cyan)
		{
			animString = "cyan";
		}
		else if (c == Color.Orange)
		{
			animString = "orange";
		}
		else if (c == Color.YellowGreen)
		{
			animString = "yellowgreen";
		}
		else if (c == Color.Pink)
		{
			animString = "pink";
		}
		else if (c == Color.Purple)
		{
			animString = "purple";
		}
		else if (c == Color.SeaGreen)
		{
			animString = "seagreen";
		}
		else if (c == Color.Skyblue)
		{
			animString = "skyblue";
		}
		
		animation.play(animString, true);
	}
	
	public function DrawColorPotion(p:Potion)
	{
		var c : Color = p._col;
		var f : FillState = p._fill;
		DrawColor(c, f);
	}
	
	
	
	public function DrawColorPatient(p:Patient)
	{
		var c : Color = p._col;
		var f : FillState = p._neededFillState;
		
		DrawColor(c, f);
		
	}
	
}