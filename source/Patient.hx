package ;

import flixel.animation.FlxPrerotatedAnimation;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
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
	private var _hitbox : FlxSprite;
	
	private var _state : PlayState;
	
	private var _status : PatientStatus;
	
	private var _targetPosition : FlxPoint;
	
	public static var ChairTaken1 : Bool = false;
	public static var ChairTaken2 : Bool = false;
	public static var ChairTaken3 : Bool = false;
	
	public function new(state:PlayState) 
	{
		super();
		
		_state = state;
		
		_status = PatientStatus.ComingIn;
		
		PickRandomColor();
		x = GameProperties.PatientSpawnPosition.x;
		y = GameProperties.PatientSpawnPosition.y;
		
		_sprite = new FlxSprite ();
		_sprite.makeGraphic(32, 32);
		_sprite.scale.set(4, 4);
		
		_hitbox = new FlxSprite();
		_hitbox.makeGraphic(128, 128, FlxColorUtil.makeFromARGB(0.0, 1, 1, 1));
		
		if (!ChairTaken1)
		{
			_targetPosition = GameProperties.PatientSeat1;
			ChairTaken1 = true;
		}
		else if (!ChairTaken2)
		{
			_targetPosition = GameProperties.PatientSeat2;
			ChairTaken2 = true;
		}
		else if (!ChairTaken3)
		{
			_targetPosition = GameProperties.PatientSeat3;
			ChairTaken3 = true;
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
		//_state.SpawnNewJar(_originalPosition);
	}
	
	private function PickRandomColor() : Void
	{
		_col = Color.Red;
	}
	
	
	public override function update () : Void
	{
		super.update();
		_hitbox.x = _sprite.x = x;
		_hitbox.y = _sprite.y = y;
		
		if (_status == PatientStatus.ComingIn)
		{
			
		}
	}
	
	public override function draw () : Void
	{
		super.draw();
		_hitbox.draw();
		_sprite.draw();
		
	}
}