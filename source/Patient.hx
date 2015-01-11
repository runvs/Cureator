package ;

import flixel.animation.FlxPrerotatedAnimation;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
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
	
	private var _picker : PatientPicker;
	
	private var _speechbubble : FlxSprite;
	
	private var _cumulativeTimer: Float;
	
	
	public function new(state:PlayState) 
	{
		super();
		
		_state = state;
		
		
		_status = PatientStatus.ComingIn;
		
		_success = false;
		_picker = new PatientPicker();
		PickRandomPatientAndLoadSprite();
		//PickRandomFillState(DifficultyLevel.Hard);
		//PickRandomColor(DifficultyLevel.Hard);
		
		_cumulativeTimer = 0;
		
		x = GameProperties.PatientSpawnPosition.x;
		y = GameProperties.PatientSpawnPosition.y;
		
		_speechbubble = new FlxSprite();
		_speechbubble.loadGraphic(AssetPaths.Texts__png, true, 32, 15, false);
		_speechbubble.scale.set(4, 4);
		_speechbubble.origin.set(32,32);
		_speechbubble.animation.add("thank", [0], 6, true);
		_speechbubble.animation.add("no", [1], 6, true);
		_speechbubble.animation.add("hey", [2], 6, true);
		_speechbubble.animation.play("thank");
		_speechbubble.alpha = 0.0;
		
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
				
			_speechbubble.animation.play("hey", true);
			_speechbubble.alpha = 1.0;
			FlxTween.tween(_speechbubble, { alpha:0.0 }, 1.5, { ease:FlxEase.cubeIn } );
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
	
	private function PickRandomPatientAndLoadSprite() : Void
	{
		var p : PatientDescriptor = null;
		if (GameProperties.Difficulty == DifficultyLevel.Easy)
		{
			p = _picker.RandomPatientWithFillstate(FillState.One);
		}
		else if (GameProperties.Difficulty == DifficultyLevel.Medium)
		{
			if (FlxRandom.chanceRoll())
			{
				p = _picker.RandomPatientWithFillstate(FillState.One);
			}
			else
			{
				p = _picker.RandomPatientWithFillstate(FillState.Two);
			}
		}
		else
		{
			p = _picker.RandomPatient();
		}

		_col = p._color;
		_neededFillState = p._fill;
		
		_sprite = new FlxSprite ();
		_sprite.loadGraphic(p._name, true, 32, 32);
		_sprite.animation.add("color", p._frame, 6, true);
		_sprite.animation.add("cured", [0], 6, true);
		_sprite.animation.play("color");
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
			
			_speechbubble.animation.play("thank", true);
			_speechbubble.alpha = 1.0;
			FlxTween.tween(_speechbubble, { alpha:0.0 }, 1.5, { ease:FlxEase.cubeIn } );
		}
		else 
		{
			//trace ("not cured");
			_success = false;
			_wrongSound.play();
			
			_speechbubble.animation.play("no", true);
			_speechbubble.alpha = 1.0;
			FlxTween.tween(_speechbubble, { alpha:0.0 }, 1.5, { ease:FlxEase.cubeIn } );
		}
		MoveToExit();
	}
	
	
	public override function update () : Void
	{
		super.update();
		_hitBox.x = _sprite.x = x;
		_hitBox.y = _sprite.y = y;
		_cumulativeTimer += FlxG.elapsed;
		_speechbubble.setPosition(x + 3 * Math.sin(_cumulativeTimer*2), y + 7 * Math.cos(_cumulativeTimer*1.82373));
		
		_speechbubble.update();
		
	}
	
	public override function draw () : Void
	{
		super.draw();
		_hitBox.draw();
		_sprite.draw();
		_speechbubble.draw();
	}
}