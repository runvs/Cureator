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
	
	public var _status : PatientStatus;
	
	private var _targetPosition : FlxPoint;
	
	private var chair :Int;
	
	private var _success : Bool;
	
	private var _levelNeeded : FillState;
	
	
	public function new(state:PlayState) 
	{
		super();
		
		_state = state;
		
		_status = PatientStatus.ComingIn;
		
		_success = false;
		
		PickRandomFillState(DifficultyLevel.Hard);
		PickRandomColor(DifficultyLevel.Hard);
		
		x = GameProperties.PatientSpawnPosition.x;
		y = GameProperties.PatientSpawnPosition.y;
		
		GetSpriteFromColor();
		
		_hitBox = new FlxSprite();
		_hitBox.makeGraphic(128, 128, FlxColorUtil.makeFromARGB(0.0, 1, 1, 1));
		
		_targetPosition = GameProperties.PatientSeat1;
		chair = 1;
		
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
	
	
	public function MoveForward():Void
	{
		if (_status != PatientStatus.GoingOut)
		{
			if (chair == 1)
			{
				trace ("Move To 2");
				chair = 2;
				_targetPosition = GameProperties.PatientSeat2;
			}
			else if (chair == 2)
			{
				trace ("Move To 3");
				chair = 3;
				_targetPosition = GameProperties.PatientSeat3;
			}
			else if (chair == 3 || chair == 4)
			{
				trace ("Move To 4/Exit");
				chair = 4;
				_targetPosition = GameProperties.PatientExitPosition;
				_status = PatientStatus.GoingOut;
			}
			
			// make him move	
			var distance : FlxVector = new FlxVector();
			distance.set(_targetPosition.x - x, _targetPosition.y - y );
			var length : Float = distance.length;
			
			var time : Float = length / GameProperties.PatientSpeed;
			
			
			FlxTween.tween( this, { x:_targetPosition.x, y:_targetPosition.y }, time, {complete:function (t:FlxTween) : Void
			{
				if (_status == PatientStatus.GoingOut)
				{
					MoveToExit();
				}
			}}
			);
		}
	}
	
	public function MoveToExit () : Void
	{
		trace ("Move To Exit");
		_status = PatientStatus.GoingOut;
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
	
	public function Break():Void
	{
		alive = false;
		exists = false;
	}
	
	private function PickRandomFillState(dl:DifficultyLevel) : Void
	{
		var f : FillState = null;
		var r : Int = FlxRandom.intRanged(0, 2);		
		if (r == 0)
		{
			f = FillState.One;
		}
		else if (r == 1)
		{
			f = FillState.Two;
		}
		else if (r == 2)
		{
			//f = FillState.Three;
			f = FillState.Two;
		}
		_levelNeeded = f;
	}
	
	private function PickRandomColor(dl:DifficultyLevel) : Void
	{
		var c : Color;
		
		var r : Int = FlxRandom.intRanged(0, 3);
		
		if ( r == 0)
		{
			c = Color.Red;
		}
		else if (r == 1)
		{
			c = Color.Green;
		}
		else if (r == 2)
		{
			c = Color.Blue;
		}
		else 
		{
			c = Color.Pink;
		}
		_col = c;
		if (_levelNeeded == FillState.One && ( _col != Color.Green && _col != Color.Blue && _col != Color.Pink) )
		{
			PickRandomColor(dl);
		}
		if (_levelNeeded == FillState.Two && (_col != Color.Red && _col != Color.Green && _col != Color.Blue ) )
		{
			PickRandomColor(dl);
		}
	}
	
	function GetSpriteFromColor():Void 
	{
		_sprite = new FlxSprite ();
		//_sprite.makeGraphic(32, 32, ColorManagement.GetIntFromEnum(_col));
		
		if (_levelNeeded == FillState.One)
		{
			if (_col == Color.Green)
			{
				_sprite.loadGraphic(AssetPaths.patient_imp__png, true, 32, 32);
				_sprite.animation.add("cured", [0], 0, true);
				_sprite.animation.add("green", [2], 0, true);
				_sprite.animation.play("green");
			}
			else if (_col == Color.Blue)
			{
				_sprite.loadGraphic(AssetPaths.patient_imp__png, true, 32, 32);
				_sprite.animation.add("cured", [0], 0, true);
				_sprite.animation.add("blue", [1], 0, true);
				_sprite.animation.play("blue");
			}
			else if (_col == Color.Pink)
			{
				_sprite.loadGraphic(AssetPaths.patient_imp__png, true, 32, 32);
				_sprite.animation.add("cured", [0], 0, true);
				_sprite.animation.add("pink", [3], 0, true);
				_sprite.animation.play("pink");
			}
			else 
			{
				
			}
			
		}
		else if (_levelNeeded == FillState.Two)
		{
			_sprite.loadGraphic(AssetPaths.patient_soldier__png, true, 32, 32);
			_sprite.animation.add("cured", [0], 0, true);
			_sprite.animation.add("red", [1], 0, true);
			_sprite.animation.add("green", [2], 0, true);
			_sprite.animation.add("blue", [3], 0, true);
			
			
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
		
		_sprite.scale.set(4, 4);
	}
	
	
	public function Cure (p:Potion) : Void
	{
		_status = PatientStatus.GoingOut;
		var _fullFilled : Bool = false;
		if (_levelNeeded == FillState.One)
		{
			if (p._fill != FillState.Empty)
			{
				_fullFilled = true;
			}
		}
		else if (_levelNeeded == FillState.Two)
		{
			if (p._fill == FillState.Two || p._fill == FillState.Three )
			{
				_fullFilled = true;
			}
		}
		else if (_levelNeeded == FillState.Three)
		{
			if (p._fill == FillState.Three)
			{
				_fullFilled = true;
			}
		}
		// check if correct potion
		if ( p._col == _col && _fullFilled )
		{
			trace ("cured");
			_success = true;
			_targetPosition = GameProperties.PatientExitPosition;
		}
		else 
		{
			trace ("not cured");
			_success = false;
		}
		
		MoveToExit();
		
		
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