package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.input.keyboard.FlxKeyboard;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import haxe.ds.ObjectMap;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _listPatients : FlxTypedGroup<Patient>;
	
	private var _listPotions : FlxTypedGroup<Potion>;
	private var _ingredientActive : Ingredient;
	private var _ingredientNext : Ingredient;
	
	private var _activePotion : Potion;
	private var _activePotionOffset : FlxPoint;
	
	private var _backgroundSprite1 : FlxSprite;
	private var _backgroundSprite2 : FlxSprite;
	private var _switchBackground : Bool;
	
	private var _pourIngredient : Ingredient;
	
	private var _activeIngredient : Ingredient;
	private var _activeIngredientOffset : FlxPoint;
	
	private var _assistantLeft : LeftAssistant;
	
	private var _actionCounter : Int;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		super.create();
		_listPotions = new FlxTypedGroup<Potion>();
		
		_listPotions.add(new Potion(GameProperties.PotionPosition1.x, GameProperties.PotionPosition1.y, Color.None, this));
		_listPotions.add(new Potion(GameProperties.PotionPosition2.x, GameProperties.PotionPosition2.y, Color.None, this));
		_listPotions.add(new Potion(GameProperties.PotionPosition3.x, GameProperties.PotionPosition3.y, Color.None, this));
		_listPotions.add(new Potion(GameProperties.PotionPosition4.x, GameProperties.PotionPosition4.y, Color.None, this));
		
		_listPatients = new FlxTypedGroup<Patient>();
		SpawnNewPatient();
		
		
		_ingredientActive = new Ingredient(GameProperties.IngredientPositionActive.x, GameProperties.IngredientPositionActive.y, Color.Red, this);
		_ingredientActive._isNextIngredient = false;
		_ingredientNext = new Ingredient(GameProperties.IngredientPositionNext.x, GameProperties.IngredientPositionNext.y, Color.Green, this);
		_ingredientNext ._isNextIngredient = true;
		
		_activePotion = null;
		_activePotionOffset = new FlxPoint();
		
		_activeIngredient = null;
		_activeIngredientOffset = new FlxPoint();
		
		
		_backgroundSprite1 = new FlxSprite();
		_backgroundSprite1.loadGraphic(AssetPaths.sampletambev2black__png, false, 192, 128);
		_backgroundSprite1.scale.set(4, 4);
		_backgroundSprite1.origin.set();
		
		_backgroundSprite2 = new FlxSprite();
		_backgroundSprite2.loadGraphic(AssetPaths.blackbackground__png, false, 192, 128);
		_backgroundSprite2.scale.set(4, 4);
		_backgroundSprite2.origin.set();
		
		_switchBackground = true;
		
		_assistantLeft = new LeftAssistant();
		
		_actionCounter = 0;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	public function CleanUp():Void
	{
		{
			var newPotionList:FlxTypedGroup<Potion> = new FlxTypedGroup<Potion>();
			_listPotions.forEach(function(p:Potion) { if (p.alive) { newPotionList.add(p); } else { p.destroy(); } } );
			_listPotions = newPotionList;
		}
		
		{
			var newPatientList:FlxTypedGroup<Patient> = new FlxTypedGroup<Patient>();
			_listPatients.forEach(function(p:Patient) { if (p.alive) { newPatientList.add(p); } else { p.destroy(); } } );
			_listPatients = newPatientList;
		}
	}
	
	
	/**
	 * 
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		trace (_listPatients.length);
		
		//// Input
		if (FlxG.keys.anyJustPressed(["F10"]))
		{
			_switchBackground = ! _switchBackground;
		}
		
		
		//// Cleaning Up
		CleanUp();
		
		
		//// Additional Logic
		MouseFollow();
		
		PickupObject();
		DropObject();
		

		//// Update Block
		_assistantLeft.update();
		_listPatients.update();
		_listPotions.update();
		
		_ingredientActive.update();
		_ingredientNext.update();
		
		// TODO
		if (_pourIngredient != null && _pourIngredient.active)
		{
			_pourIngredient.update();
		}
		
		//trace (_listPotions.length);
		

		
		
		
		
	}	
	
	private function SwapIngredients () : Void 
	{
		_ingredientActive = _ingredientNext;
		_ingredientActive.setPosition(GameProperties.IngredientPositionActive.x, GameProperties.IngredientPositionActive.y);
		_ingredientActive._isNextIngredient = false;
		_ingredientActive._doDraw = false;
	}
	
	function MouseFollow():Void 
	{
		if (_activePotion != null)
		{
			_activePotion.setPosition(FlxG.mouse.x + _activePotionOffset.x, FlxG.mouse.y + _activePotionOffset.y);
		}
		else if (_activeIngredient != null)
		{
			_activeIngredient.setPosition(FlxG.mouse.x + _activeIngredientOffset.x, FlxG.mouse.y + _activeIngredientOffset.y);
		}
	}
	
	function PickupObject():Void 
	{
		if (FlxG.mouse.justPressed)
		{
			// check active ingredient
			if (_ingredientActive._hitBox.overlapsPoint(FlxG.mouse))
			{
				var p :FlxPoint = new FlxPoint(_ingredientActive.x - FlxG.mouse.x, _ingredientActive.y - FlxG.mouse.y);
				setActiveIngredient(_ingredientActive, p);
				_assistantLeft.Take();
			}
			
			// check any of the Potions
			for ( i in 0 ... _listPotions.length)
			{
				var p : Potion = _listPotions.members[i];
				if (p._hitBox.overlapsPoint(FlxG.mouse))
				{
					var off :FlxPoint = new FlxPoint(p.x - FlxG.mouse.x, p.y - FlxG.mouse.y);
					setActivePotion(p, off);
				}
			}
		}
	}
	
	function DropIngredient():Void 
	{
		if (_activeIngredient != null && _activeIngredient.active == true)
		{
			_assistantLeft.Release();
			//trace ("active ingredient");
			var dropped :Bool = false;
			for ( i in 0 ... _listPotions.length)
			{
				var p : Potion = _listPotions.members[i];
				if (FlxG.overlap(_activeIngredient._hitBox, p._hitBox))
				{	
					//trace ("dropped");
					dropped = true;
					p.AddIngedient(_activeIngredient);
					p.updateColor();
					_activeIngredient.setPosition( -500, -500);
					_activeIngredient._hitBox.setPosition( -500, -500);	// dunno, why i need to update the hitboxes position manually. probably, because update woud have to be called.
					_activeIngredient.Pour();
					_pourIngredient = _activeIngredient;
					_activeIngredient = null;
					break;
				}
			}
			
			if (dropped)
			{
				SwapIngredients();
				SpawnNewIngredient();
				MakePatientsMove();
			}
			else
			{

				FlxTween.tween(_activeIngredient, { x:GameProperties.IngredientPositionActive.x, y:GameProperties.IngredientPositionActive.y }, 0.75, {ease:FlxEase.circOut});
			}
		}
	}
	
	function DropPotion():Void 
	{
		if (_activePotion != null)
		{
			var dropped :Bool = false;
			if ( _activePotion._fill !=  FillState.Empty)
			{
				for ( i in 0 ... _listPatients.length)
				{
					var p : Patient = _listPatients.members[i];
					if (p._status == PatientStatus.Waiting)
					{
						//trace(_activePotion._hitBox);
						//trace(p._hitBox);
						if (FlxG.overlap(p._hitBox, _activePotion._hitBox))
						{	
							dropped = true;
							p.Cure(_activePotion);
							_activePotion.setPosition( -500, -500);
							_activePotion._hitBox.setPosition( -500, -500);	// dunno, why i need to update the hitboxes position manually. probably, because update woud have to be called.
							_activePotion.Break();
							
							_activePotion = null;
							break;
						}
					}
				}
			}
			
			if ( dropped)
			{
				MakePatientsMove();
			}
			else
			{
				FlxTween.tween(_activePotion, { x:_activePotion._originalPosition.x, y:_activePotion._originalPosition.y }, 0.75, { ease:FlxEase.circOut } );
			}
		}
	}
	
	function DropObject():Void 
	{
		if (FlxG.mouse.justReleased)
		{
			//trace ("mouse released");
			DropIngredient();
			
			
			DropPotion();
			
			_activePotion = null;
			_activeIngredient = null;
		}
	}
	
	public function MakePatientsMove() : Void
	{
		_actionCounter++;
		if (_actionCounter == GameProperties.ActionsForPatitentsToMove)
		{
			for ( i in 0 ... _listPatients.length)
			{
				var p : Patient = _listPatients.members[i];
				p.MoveForward();
			}
			SpawnNewPatient();
			_actionCounter = 0;
		}
	}
	
	
	public function SpawnNewIngredient():Void
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
		_assistantLeft.Pick(_ingredientNext._col);
		var i : Ingredient = new Ingredient(GameProperties.IngredientPositionNext.x, GameProperties.IngredientPositionNext.y, c, this);
		i._isNextIngredient = true;
		_ingredientNext = i;
		
		
		var t : FlxTimer  = new FlxTimer(LeftAssistant.GetAnimTimeUntilPotionApears(), function (t:FlxTimer) 
		{
			_ingredientActive._doDraw = true;
		} 
		);
	}
	
	public function SpawnNewJar (p:FlxPoint) : Void 
	{
		
		var t : FlxTimer = new FlxTimer(GameProperties.JarSpawnTime, function (t:FlxTimer) : Void 
		{
			//trace ("spawn new jar");
			_listPotions.add(new Potion(p.x, p.y, Color.None, this));
		} 
		);
	}
	
	public function SpawnNewPatient ( ) : Void 
	{
		var p : Patient  = new Patient(this);
		_listPatients.add(p);
		//var t : FlxTimer  = new FlxTimer(GameProperties.PatientSpawnTime, function (x:FlxTimer) : Void { SpawnNewPatient(); } );
	}
	
	
	override public function draw () : Void 
	{
		if (_switchBackground )
		{
			_backgroundSprite2.draw();
		}
		else 
		{
			_backgroundSprite1.draw();
		}
		
		
		_listPatients.draw();
		
		_listPotions.draw();
		
		_assistantLeft.draw();
		
		_ingredientActive.draw();
		_ingredientNext.draw();
		if (_pourIngredient != null && _pourIngredient.active)
		{
			_pourIngredient.draw();
		}
	}
	
	public function AddPotion (p:Potion):Void
	{
		_listPotions.add(p);
	}
	
	public function ResetActivePotion () : Void 
	{
		_activePotion = null;
	}
	
	public function ResetActiveIngredient () : Void 
	{
		_activeIngredient = null;
		_pourIngredient = null;
	}
	
	public function setActivePotion (p:Potion, offs:FlxPoint) : Void
	{
		_activePotion  = p;
		_activePotionOffset = offs;
	}
	
	public function setActiveIngredient (i:Ingredient, offs:FlxPoint) : Void 
	{
		//trace ("set active ingredient");
		_activeIngredient = i;
		_activeIngredientOffset = offs;
	}
	
}