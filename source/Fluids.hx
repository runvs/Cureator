package ;

import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class Fluids extends FlxObject
{
	
	private var _leftRed : FlxSprite;
	private var _leftGreen : FlxSprite;
	private var _leftBlue : FlxSprite;
	
	private var _rightRed : FlxSprite;
	private var _rightGreen : FlxSprite;
	private var _rightBlue : FlxSprite;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		_leftRed = new FlxSprite();
		_leftGreen = new FlxSprite();
		_leftBlue = new FlxSprite();
	
		_rightRed = new FlxSprite();
		_rightGreen = new FlxSprite();
		_rightBlue = new FlxSprite();
		
		_leftRed.loadGraphic(AssetPaths.fluid_left_red__png, true, 16,16);
		_leftGreen.loadGraphic(AssetPaths.fluid_left_green__png, true, 16,16);
		_leftBlue.loadGraphic(AssetPaths.fluid_left_blue__png, true, 16,16);
	
		_rightRed.loadGraphic(AssetPaths.fluid_right_red__png, true, 16,16);
		_rightGreen.loadGraphic(AssetPaths.fluid_right_green__png, true, 16,16);
		_rightBlue.loadGraphic(AssetPaths.fluid_right_blue__png, true, 16, 16);
		
		
		_leftRed.animation.add("anim", [0, 1, 2, 3, 4, 5], 6, true);
		_leftGreen.animation.add("anim", [0, 1, 2, 3, 4, 5], 6, true);
		_leftBlue.animation.add("anim", [0, 1, 2, 3, 4, 5], 6, true);
	
		_rightRed.animation.add("anim", [0, 1, 2, 3, 4, 5], 6, true);
		_rightGreen.animation.add("anim", [0, 1, 2, 3, 4, 5], 6, true);
		_rightBlue.animation.add("anim", [0, 1, 2, 3, 4, 5], 6, true);
		
		
		_leftRed.animation.play("anim",true);
		_leftGreen.animation.play("anim",true);
		_leftBlue.animation.play("anim",true);
	
		_rightRed.animation.play("anim",true);
		_rightGreen.animation.play("anim",true);
		_rightBlue.animation.play("anim", true);
		
		
		_leftRed.setPosition(0, 448);
		_leftGreen.setPosition(0, 448);
		_leftBlue.setPosition(0, 448);
		
		_rightRed.setPosition(704, 448);
		_rightGreen.setPosition(704, 448);
		_rightBlue.setPosition(704, 448);
		
		
		_leftRed.scale.set(4, 4);
		_leftGreen.scale.set(4, 4);
		_leftBlue.scale.set(4, 4);
		
		_rightRed.scale.set(4, 4);
		_rightGreen.scale.set(4, 4);
		_rightBlue.scale.set(4, 4);
		
		
		_leftRed.origin.set(0, 0);
		_leftGreen.origin.set(0, 0);
		_leftBlue.origin.set(0, 0);
		
		_rightRed.origin.set(0, 0);
		_rightGreen.origin.set(0, 0);
		_rightBlue.origin.set(0, 0);
		
		
		_leftRed.alpha = 0.0;
		_leftGreen.alpha = 0.0;
		_leftBlue.alpha = 0.0;
	
		_rightRed.alpha = 0.0;
		_rightGreen.alpha = 0.0;
		_rightBlue.alpha = 0.0;
		
		
	}
	
	public function SetLeftColor (c:Color) : Void
	{		
		_leftRed.alpha = (c == Color.Red)? 1.0 : 0.0;
		_leftGreen.alpha = (c == Color.Green)? 1.0 : 0.0;
		_leftBlue.alpha = (c == Color.Blue)? 1.0 : 0.0;
	}
	
	public function SetRightColor (c:Color) : Void
	{
		_rightRed.alpha = (c == Color.Red)? 1.0 : 0.0;
		_rightGreen.alpha = (c == Color.Green)? 1.0 : 0.0;
		_rightBlue.alpha = (c == Color.Blue)? 1.0 : 0.0;
	}
	
	public override function update () : Void 
	{
		_leftRed.update();
		_leftGreen.update();
		_leftBlue.update();
	
		_rightRed.update();
		_rightGreen.update();
		_rightBlue.update();
	}
	
	public override function draw () : Void 
	{
		_leftRed.draw();
		_leftGreen.draw();
		_leftBlue.draw();
	
		_rightRed.draw();
		_rightGreen.draw();
		_rightBlue.draw();
	}
}