package ;

import flixel.animation.FlxPrerotatedAnimation;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
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
	
	public var _chair :Int;
	
	private var _success : Bool;
	
	public var _neededFillState  : FillState;
	
	private var _cureSound : FlxSound;
	private var _wrongSound : FlxSound;
	
	
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
		_chair = 1;
		
		var distance : FlxVector = new FlxVector();
		distance.set(_targetPosition.x - x, _targetPosition.y - y );
		var length : Float = distance.length;
		
		var time : Float = length / GameProperties.PatientSpeed;
		
		
		FlxTween.tween( this, { x:_targetPosition.x, y:_targetPosition.y }, time, {complete:function (t:FlxTween) : Void
		{
			_status = PatientStatus.Waiting;
		}}
		);
		
		
		
		_cureSound = new FlxSound();
		_wrongSound = new FlxSound();
        #if flash
        _cureSound = FlxG.sound.load(AssetPaths.cure__mp3, 0.25, false, false , false );
        _wrongSound = FlxG.sound.load(AssetPaths.wrong__mp3, 0.25, false, false , false );
        #else
        _cureSound = FlxG.sound.load(AssetPaths.cure__ogg, 0.25 , false, false , false);
        _wrongSound = FlxG.sound.load(AssetPaths.wrong__ogg, 0.25, false, false , false );
        #end
		
		
	}
	
	
	public function MoveForward():Void
	{
		if (_status != PatientStatus.GoingOut)
		{
			if (_chair == 1)
			{
				//trace ("Move To 2");
				_chair = 2;
				_targetPosition = GameProperties.PatientSeat2;
			}
			else if (_chair == 2)
			{
				//trace ("Move To 3");
				_chair = 3;
				_targetPosition = GameProperties.PatientSeat3;
			}
			else if (_chair == 3 || _chair == 4)
			{
				//trace ("Move To 4/Exit");
				_chair = 4;
				MoveToExit();
				return;
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
		//trace ("Move To Exit");
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
		_neededFillState = f;
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
		if (_neededFillState == FillState.One && ( _col != Color.Green && _col != Color.Blue && _col != Color.Pink) )
		{
			PickRandomColor(dl);
		}
		if (_neededFillState == FillState.Two && (_col != Color.Red && _col != Color.Green && _col != Color.Blue ) )
		{
			PickRandomColor(dl);
		}
	}
	
	function GetSpriteFromColor():Void 
	{
		_sprite = new FlxSprite ();
		//_sprite.makeGraphic(32, 32, ColorManagement.GetIntFromEnum(_col));
		
		if (_neededFillState == FillState.One)
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
		else if (_neededFillState == FillState.Two)
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
	
	function CheckFillLevel(p:Potion) : Bool 
	{
		var ret : Bool = false;
		if (_neededFillState == FillState.One)
		{
			if (p._fill != FillState.Empty)
			{
				ret = true;
			}
		}
		else if (_neededFillState == FillState.Two)
		{
			if (p._fill == FillState.Two || p._fill == FillState.Three )
			{
				ret = true;
			}
		}
		else if (_neededFillState == FillState.Three)
		{
			if (p._fill == FillState.Three)
			{
				ret = true;
			}
		}
		return ret;
	}
	
	
	public function Cure (p:Potion) : Void
	{
		var fullFilled : Bool = CheckFillLevel(p);

		
		// check if correct potion
		if ( p._col == _col && fullFilled )
		{
			//trace ("cured");
			_success = true;
			_state.AddMoney(this);
			_sprite.animation.play("cured");
			_cureSound.play();
		}
		else 
		{
			//trace ("not cured");
			_success = false;
			_wrongSound.play();
		}
		
		MoveToExit();

	}
	
	
	public override function update () : Void
	{
		super.update();
		_hitBox.x = _sprite.x = x;
		_hitBox.y = _sprite.y = y;

	}
	
	public override function draw () : Void
	{
		super.draw();
		_hitBox.draw();
		_sprite.draw();
		
	}
}