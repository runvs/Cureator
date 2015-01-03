package ;

import flixel.animation.FlxPrerotatedAnimation;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class Patient extends FlxObject
{

	public var _col : Color;
	
	private var _sprite : FlxSprite;
	public var _hitBox : FlxSprite;
	
	private var _state : PlayState;
	
	private var _status : PatientStatus;
	
	private var _targetPosition : FlxPoint;
	
	public static var ChairTaken1 : Bool = false;
	public static var ChairTaken2 : Bool = false;
	public static var ChairTaken3 : Bool = false;
	
	private var chair :Int;
	
	private var _success : Bool;
	
	
	public function new(state:PlayState) 
	{
		super();
		
		_state = state;
		
		_status = PatientStatus.ComingIn;
		
		_success = false;
		
		PickRandomColor(DifficultyLevel.Hard);
		x = GameProperties.PatientSpawnPosition.x;
		y = GameProperties.PatientSpawnPosition.y;
		
		GetSpriteFromColor();
		
		_hitBox = new FlxSprite();
		_hitBox.makeGraphic(128, 128, FlxColorUtil.makeFromARGB(0.0, 1, 1, 1));
		
		if (!ChairTaken1)
		{
			_targetPosition = GameProperties.PatientSeat1;
			ChairTaken1 = true;
			chair = 1;
		}
		else if (!ChairTaken2)
		{
			_targetPosition = GameProperties.PatientSeat2;
			ChairTaken2 = true;
			chair = 2;
		}
		else if (!ChairTaken3)
		{
			_targetPosition = GameProperties.PatientSeat3;
			ChairTaken3 = true;
			chair = 3;
		}
		else 
		{
			Break();
			return;
		}
		var distance : FlxVector = new FlxVector();
		distance.set(_targetPosition.x - x, _targetPosition.y - y );
		var length : Float = distance.length;
		
		var time : Float = length / GameProperties.PatientSpeed;
		
		
		FlxTween.tween( this, { x:_targetPosition.x, y:_targetPosition.y }, time, {complete:function (t:FlxTween) : Void
		{
			_status = PatientStatus.Waiting;
		}}
		);
		
	}
	
	
	public function Break():Void
	{
		alive = false;
		exists = false;
	}
	
	private function PickRandomColor(dl:DifficultyLevel) : Void
	{
		var c : Color;
		
		var r : Int = FlxRandom.intRanged(0, 2);
		
		if ( r == 0)
		{
			c = Color.Red;
		}
		else if (r == 1)
		{
			c = Color.Green;
		}
		else 
		{
			c = Color.Blue;
		}
		_col = c;
	}
	
	function GetSpriteFromColor():Void 
	{
		_sprite = new FlxSprite ();
		//_sprite.makeGraphic(32, 32, ColorManagement.GetIntFromEnum(_col));
		
		_sprite.loadGraphic(AssetPaths.patient_soldier__png, true, 32, 32);
		_sprite.animation.add("cured", [0], 0, true);
		_sprite.animation.add("red", [1], 0, true);
		_sprite.animation.add("green", [2], 0, true);
		_sprite.animation.add("blue", [3], 0, true);
		_sprite.scale.set(4, 4);
		
		if (_col == Color.Red)
		{
			_sprite.animation.play("red");
		}
		if (_col == Color.Green)
		{
			_sprite.animation.play("green");
		}
		if (_col == Color.Blue)
		{
			_sprite.animation.play("blue");
		}
	}
	
	
	public function Cure (p:Potion) : Void
	{
		_status = PatientStatus.GoingOut;

		
		// free the chair
		if (chair == 1)
		{
			ChairTaken1 = false;
		}
		else if (chair == 2)
		{
			ChairTaken2 = false;
		}
		else if (chair == 3)
		{
			ChairTaken3 = false;
		}
		
		
		// check if correct potion
		if ( p._col == _col)
		{
			_success = true;
		}
		
		// make him move
		_targetPosition = GameProperties.PatientExitPosition;
		
		var distance : FlxVector = new FlxVector();
		distance.set(_targetPosition.x - x, _targetPosition.y - y );
		var length : Float = distance.length;
		
		var time : Float = length / GameProperties.PatientSpeed;
		
		
		FlxTween.tween( this, { x:_targetPosition.x, y:_targetPosition.y }, time, {complete:function (t:FlxTween) : Void
		{
			Break();
		}}
		);
		
		
	}
	
	
	public override function update () : Void
	{
		super.update();
		_hitBox.x = _sprite.x = x;
		_hitBox.y = _sprite.y = y;
		
		if (_status == PatientStatus.ComingIn)
		{
			
		}
	}
	
	public override function draw () : Void
	{
		super.draw();
		_hitBox.draw();
		_sprite.draw();
		
	}
}