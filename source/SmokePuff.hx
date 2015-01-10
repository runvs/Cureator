package ;

import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class SmokePuff extends FlxSprite
{
	private var _col : Color;
	
	private var _sprite : FlxSprite;
	
	public function new(X:Float=0, Y:Float=0, c: Color) 
	{
		super(X, Y);
		
		_col = c;

		if (_col == Color.Cyan)
		{
			loadGraphic(AssetPaths.puff_cyan__png, true, 16, 16);
		}
		else if (_col == Color.Magenta)
		{
			loadGraphic(AssetPaths.puff_cyan__png, true, 16, 16);
		}
		else if (_col == Color.Orange)
		{
			loadGraphic(AssetPaths.puff_orange__png, true, 16, 16);
		}
		else if (_col == Color.Pink)
		{
			loadGraphic(AssetPaths.puff_pink__png, true, 16, 16);
		}
		else if (_col == Color.Purple)
		{
			loadGraphic(AssetPaths.puff_purple__png, true, 16, 16);
		}
		else if (_col == Color.SeaGreen)
		{
			loadGraphic(AssetPaths.puff_seagreen__png, true, 16, 16);
		}
		else if (_col == Color.Skyblue)
		{
			loadGraphic(AssetPaths.puff_skyblue__png, true, 16, 16);
		}
		else if (_col == Color.White)
		{
			loadGraphic(AssetPaths.puff_white__png, true, 16, 16);
		}
		else if (_col == Color.Yellow)
		{
			loadGraphic(AssetPaths.puff_yellow__png, true, 16, 16);
		}
		else if (_col == Color.YellowGreen)
		{
			loadGraphic(AssetPaths.puff_yellowgreen__png, true, 16, 16);
		}
		else if (_col == Color.Red)
		{
			loadGraphic(AssetPaths.puff_red__png, true, 16, 16);
		}
		else if (_col == Color.Green)
		{
			loadGraphic(AssetPaths.puff_green__png, true, 16, 16);
		}
		else if (_col == Color.Blue)
		{
			loadGraphic(AssetPaths.puff_blue__png, true, 16, 16);
		}
		else 
		{
			loadGraphic(AssetPaths.puff_white__png, true, 16, 16);
		}
		scale.set(4, 4);
		x = X;
		y = Y;
		animation.add("anim", [0, 1, 2, 3, 4, 5], 6, false);
		animation.play("anim", true);
	}
}