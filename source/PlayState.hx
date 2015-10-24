package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.input.keyboard.FlxKeyboard;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _listPatients : FlxTypedGroup<Patient>;	// list for all the patients in the game
	private var _listPotions : FlxTypedGroup<Potion>;	// list for all the potions in the game
	
	private var _backgroundSprite : FlxSprite;
	
	private var _ingredientCurrent : Ingredient;
	private var _ingredientNext : Ingredient;
	
	private var _pickedPotion : Potion;			// the potion, the player is currently dragging&dropping around. can be null
	private var _pickedPotionOffset : FlxPoint;
	
	private var _pickedIngredient : Ingredient; // the ingredient, the player is currently dragging&dropping around. can be null
	private var _activeIngredientOffset : FlxPoint;

	private var _assistantLeft : LeftAssistant;		// the Assistant holding the ingredients
	private var _assistantRight : RightAssistant;	// the assistant mixing the potions
	private var _assistantTop : FlxSprite;			// the assistant writing the numbers
	
	private var _actionCounter : Int;	// how many actions have been passed since the patients moved forward?
	
	private var _money : Int;	// current amount of money
	private var _moneyText : MoneyDisplay;	// current money display
	
	private var _level : Int;	// current level. must be zero or positive
	private var _moneyNeeded :Int;	// money needed to complete the current level
	private var _moneyNeededText : MoneyDisplay;
	
	private var _loosing : Bool;	
	
	private var _screenOverlay : FlxSprite;	// the sprite to fade in/from black on level start/end
	
	private var _vignette : FlxSprite;	// some graphical juice
	
	private var _fluids : Fluids;	// the animation for the fluids in the left/right bottom corner
	
	private var _recipe : RecipeDrawer;	// the recipe drawer
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		_backgroundSprite = new FlxSprite();
		_backgroundSprite.loadGraphic(AssetPaths.background_v2__png, false, 192, 128);
		_backgroundSprite.scale.set(4, 4);
		_backgroundSprite.origin.set();
		

		// create the default potions on the 1 to 4 plattforms
		_listPotions = new FlxTypedGroup<Potion>();
		_listPotions.add(new Potion(GameProperties.PotionPosition1.x, GameProperties.PotionPosition1.y, Color.None, this));
		_listPotions.add(new Potion(GameProperties.PotionPosition2.x, GameProperties.PotionPosition2.y, Color.None, this));
		_listPotions.add(new Potion(GameProperties.PotionPosition3.x, GameProperties.PotionPosition3.y, Color.None, this));
		_listPotions.add(new Potion(GameProperties.PotionPosition4.x, GameProperties.PotionPosition4.y, Color.None, this));
		
		// create the first patient 
		_listPatients = new FlxTypedGroup<Patient>();
		SpawnNewPatient();
		
		// add active and next ingredient
		_ingredientCurrent = new Ingredient(GameProperties.IngredientPositionActive.x, GameProperties.IngredientPositionActive.y, Color.Red, this);
		_ingredientCurrent._isNextIngredient = false;
		_ingredientNext = new Ingredient(GameProperties.IngredientPositionNext.x, GameProperties.IngredientPositionNext.y, Color.Green, this);
		_ingredientNext ._isNextIngredient = true;
		
		_pickedPotion = null;
		_pickedPotionOffset = new FlxPoint();
		
		_pickedIngredient = null;
		_activeIngredientOffset = new FlxPoint();
		
		
		_assistantLeft = new LeftAssistant();
		_assistantRight = new RightAssistant();
		
		_assistantTop = new FlxSprite();
		_assistantTop.loadGraphic(AssetPaths.assistant3__png, false, 32, 16);
		_assistantTop.scale.set(4, 4);
		_assistantTop.origin.set();
		_assistantTop.setPosition(128, 4);
		
		_recipe = new RecipeDrawer();
		
		_actionCounter = 0;
		
		_money = GameProperties.MoneyStartAmount;
		_loosing = false;
		
		_moneyText = new MoneyDisplay(false);
		_moneyNeededText  = new MoneyDisplay(true);
		
		_fluids = new Fluids();
		_fluids.SetLeftColor(_ingredientCurrent._col);
		_fluids.SetRightColor(_ingredientNext._col);
		

		
		_screenOverlay = new FlxSprite();
		_screenOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColorUtil.makeFromARGB(1.0, 0, 0, 0));
		//_screenOverlay.color = FlxColorUtil.makeFromARGB(0.0, 255, 255, 255);
		_screenOverlay.alpha = 1.0;
		
		
		_vignette  = new FlxSprite();
		_vignette.loadGraphic(AssetPaths.vignette__png, false, 800, 600);
		_vignette.origin.set();
		_vignette.alpha = 0.4;
		

		
	
		
		FlxTween.tween(_screenOverlay, { alpha : 0.0 }, 1.0);	// start the game with a tween.
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		
		_listPatients.forEach(function(p:Patient):Void { p.destroy(); } );
		_listPatients.clear();
		_listPatients = null;
		
		_listPotions.forEach(function(p:Potion):Void { p.destroy(); } );
		_listPotions.clear();
		_listPotions = null;
		
		_backgroundSprite.destroy();
		_backgroundSprite = null;
		
		_ingredientCurrent.destroy();
		_ingredientCurrent = null;
		
		_ingredientNext.destroy();
		_ingredientNext = null;
		
		_pickedPotion = null;
		_pickedPotionOffset = null;
		
		_pickedIngredient = null;
		_activeIngredientOffset = null;
		
		_assistantLeft.destroy();
		_assistantLeft = null;
		
		_assistantRight.destroy();
		_assistantRight = null;
		
		_assistantTop.destroy();
		_assistantTop = null;

		_moneyText = null;
		_moneyNeededText = null;
		
		_screenOverlay.destroy();
		_screenOverlay = null;
		
		_vignette.destroy();
		_vignette = null;
		
		_fluids.destroy();
		_fluids = null;
		
		_recipe.destroy();
		_recipe = null;
	
	}

	public function SetLevel(level:Int)
	{
		if (level < 0)
		{
			throw ("error: Level negative");
		}
		_level = level;
		
		CalculateMoneyFromLevel();
	}
	
	// this function cleans any lists in the game and gets rid of no longer needed objects.
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
	
	
	override public function update():Void
	{
		super.update();
		
		// Cleaning Up
		CleanUp();
		
		// Additional Logic
		MouseFollow();
		
		PickupObject();
		DropObject();
		
		DrawRecipeTooltip();
		
		PourIngredient();
		
		CheckMoneyNegative();
		
		CheckLevelPassed();
		
		
		//// Update Block
		if (!_loosing)
		{
			_fluids.update();
			
			_assistantLeft.update();
			_assistantRight.update();
		
			_listPatients.update();
			_listPotions.update();
			
			_ingredientCurrent.update();
			_ingredientNext.update();
			
			_recipe.update();
		}
		_screenOverlay.update();
	}	
	
	private function SwapIngredients () : Void 
	{
		_ingredientCurrent = _ingredientNext;
		_ingredientCurrent.setPosition(GameProperties.IngredientPositionActive.x, GameProperties.IngredientPositionActive.y);
		_ingredientCurrent._isNextIngredient = false;
		_ingredientCurrent._doDraw = false;	// a new active ingredient may be drawn only after the aassistant's pickup animation has been played
	}
	
	// if any potion or ingredient is picked up, it shall follow the mouse. This creates a drag and drop feeling
	function MouseFollow():Void 
	{
		if (_pickedPotion != null)
		{
			_pickedPotion.setPosition(FlxG.mouse.x + _pickedPotionOffset.x, FlxG.mouse.y + _pickedPotionOffset.y);
		}
		else if (_pickedIngredient != null)
		{
			_pickedIngredient.setPosition(FlxG.mouse.x + _activeIngredientOffset.x, FlxG.mouse.y + _activeIngredientOffset.y);
		}
	}
	
	// check, if any object has been picked up
	function PickupObject():Void 
	{
		if (FlxG.mouse.justPressed)
		{
			// check active ingredient
			if (_ingredientCurrent._hitBox.overlapsPoint(FlxG.mouse))
			{
				var p :FlxPoint = new FlxPoint(_ingredientCurrent.x - FlxG.mouse.x, _ingredientCurrent.y - FlxG.mouse.y);
				setActiveIngredient(_ingredientCurrent, p);
				
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
	
	
	function DropObject():Void 
	{
		if (FlxG.mouse.justReleased)
		{
			DropIngredient();
			DropPotion();
			
			_pickedPotion = null;
			_pickedIngredient = null;
		}
	}
	
	
	function DropIngredient():Void 
	{
		if (_pickedIngredient != null && _pickedIngredient.active == true)
		{
			_assistantLeft.Release();
			var dropped :Bool = false;
			for ( i in 0 ... _listPotions.length)
			{
				var p : Potion = _listPotions.members[i];
				if (FlxG.overlap(_pickedIngredient._hitBox, p._hitBox))
				{	
					dropped = true;
					p.AddIngedient(_pickedIngredient);
					p.updateColor();
					_pickedIngredient.setPosition( -500, -500);
					_pickedIngredient._hitBox.setPosition( -500, -500);	// dunno, why i need to update the hitboxes position manually. probably, because update woud have to be called.
					_pickedIngredient.Pour();
					_pickedIngredient.destroy();	// just make sure, this never exists any further
					_pickedIngredient = null;
					break;
				}
			}
			
			if (dropped)
			{
				_assistantRight.Brew();
				SwapIngredients();
				SpawnNewIngredient();
				_fluids.SetLeftColor(_ingredientCurrent._col);
				_fluids.SetRightColor(_ingredientNext._col);
				MakePatientsMove();
			}
			else
			{
				FlxTween.tween(_pickedIngredient, { x:GameProperties.IngredientPositionActive.x, y:GameProperties.IngredientPositionActive.y }, 0.75, {ease:FlxEase.circOut});
			}
		}
	}
	
	function DropPotion():Void 
	{
		if (_pickedPotion != null)
		{
			var dropped :Bool = false;
			if ( _pickedPotion._fill !=  FillState.Empty)
			{
				for ( i in 0 ... _listPatients.length)
				{
					var p : Patient = _listPatients.members[i];
					if (p._status == PatientStatus.Waiting)
					{
						if (FlxG.overlap(p._hitBox, _pickedPotion._hitBox))
						{	
							dropped = true;
							p.Cure(_pickedPotion);
							_pickedPotion.setPosition( -500, -500);
							_pickedPotion._hitBox.setPosition( -500, -500);	// dunno, why i need to update the hitboxes position manually. probably, because update woud have to be called.
							_pickedPotion.Break();
							_pickedPotion.destroy();	// just make sure, this never exists any further
							_pickedPotion = null;
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
				FlxTween.tween(_pickedPotion, { x:_pickedPotion._originalPosition.x, y:_pickedPotion._originalPosition.y }, 0.75, { ease:FlxEase.circOut } );
			}
		}
	}
	
	function PourIngredient():Void 
	{
		if (_pickedIngredient != null)
		{
			var nearPotion : Bool = false;
			for ( i in 0 ... _listPotions.length)
			{
				var p : Potion = _listPotions.members[i];
				if (FlxG.overlap(_pickedIngredient._sprite, p._hitBox))
				{	
					if (FlxG.pixelPerfectOverlap(_pickedIngredient._sprite, p._hitBox, 0))
					{
						nearPotion = true;
						break;
					}
				}
			}
			if ( nearPotion )
			{
				_pickedIngredient.Pour();
			}
			else 
			{
				_pickedIngredient.Unpour();
			}
		}
	}
	
	// this function checks if the neccesary number of actions has passed, so the patients move one position forward(right)
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
		RemoveMoney(GameProperties.MoneyIngredientCost);
		
		
		var i : Ingredient = new Ingredient(GameProperties.IngredientPositionNext.x, GameProperties.IngredientPositionNext.y, c, this);
		i._isNextIngredient = true;
		_ingredientNext = i;

		
		var t : FlxTimer  = new FlxTimer(LeftAssistant.GetAnimTimeUntilPotionApears(), function (t:FlxTimer) 
		{
			_ingredientCurrent._doDraw = true;
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
	}
	
	
	override public function draw () : Void 
	{
		// create a draworder for all the sprites in this scene
		
		// backbround
		_backgroundSprite.draw();
		
		// objects
		_fluids.draw();
		
		_listPatients.draw();
		_listPotions.draw();
		
		_assistantLeft.draw();
		_assistantRight.draw();
		
		_ingredientCurrent.draw();
		_ingredientNext.draw();
		
		_assistantTop.draw();
		
		// hud/gui overlays
		_recipe.draw();
		
		_moneyText.drawSingleNumber(_money, new FlxPoint(412, 16));
		_moneyNeededText.drawSingleNumber(_moneyNeeded, new FlxPoint(468, 92));
		
		// visual effects
		_screenOverlay.draw();
		_vignette.draw();
		
	}
	
	public function AddPotion (p:Potion):Void
	{
		_listPotions.add(p);
	}
	
	public function setActivePotion (p:Potion, offs:FlxPoint) : Void
	{
		_pickedPotion  = p;
		_pickedPotionOffset = offs;
	}
	
	public function setActiveIngredient (i:Ingredient, offs:FlxPoint) : Void 
	{
		_pickedIngredient = i;
		_activeIngredientOffset = offs;
	}
	
	// this function calculates the amount of money a patient pays and adds it to the _money var
	public function AddMoney (p:Patient)
	{
		var amount : Float = GameProperties.MoneyBaseGainValue;
		
		var factor : Float = 1.0;
		if (p._neededFillState == FillState.Two)
		{
			factor = 1.25;
		}
		else if (p._neededFillState == FillState.Three)
		{
			factor = 1.5;
		}
		amount *= factor;
		
		var chair : Float = p._chair;
		amount /= 0.5 + (0.5*chair);
		
		var i : Int = Std.int(amount);
		_money += i;
	}
	
	
	private function RemoveMoney (amount : Int ) : Void 
	{
		_money -= amount;
	}
	
	function CheckMoneyNegative():Void 
	{
		if (_money < 0)
		{
			LooseGame();
		}
	}
	
	public function LooseGame ( ) : Void 
	{
		_loosing = true;
		
		FlxTween.tween(_screenOverlay, { alpha:1.0 }, 1.0 );
		
		var t: FlxTimer = new FlxTimer(1.25, function (t:FlxTimer) : Void 
		{
			FlxG.switchState(new MenuState());
		});
	}
	
	function CheckLevelPassed():Void 
	{
		if (_money >= _moneyNeeded)
		{
			FlxTween.tween(_screenOverlay, { alpha:1.0 } );
			_loosing = true;
			var t:FlxTimer = new FlxTimer(1.25, function (t:FlxTimer) : Void 
			{
				var p: PlayState = new PlayState();
				p.SetLevel(_level +1);
				FlxG.switchState(p);
			});
		}
	}
	
	function CalculateMoneyFromLevel():Void 
	{
		var moneyIncrease: Int = 5;
		var moneyStart : Int = 12;
		
		_moneyNeeded = moneyIncrease * _level  + moneyStart;
	}
	
	function DrawRecipeTooltip():Void 
	{
		_recipe.alpha = 0.0;
		// check any of the Patients
		for ( i in 0 ... _listPatients.length)
		{
			var p : Patient = _listPatients.members[i];
			if (!p.IsCured())
			{
				if (p._hitBox.overlapsPoint(FlxG.mouse))
				{
					_recipe.alpha = 1.0;
					_recipe.DrawColor(p);
				}
			}
		}
	}
	
	
}