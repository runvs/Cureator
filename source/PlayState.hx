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
	private var _listPatients : FlxTypedGroup<Patient>;
	
	private var _listPotions : FlxTypedGroup<Potion>;
	private var _ingredientActive : Ingredient;
	private var _ingredientNext : Ingredient;
	
	private var _activePotion : Potion;
	private var _activePotionOffset : FlxPoint;
	
	private var _backgroundSprite1 : FlxSprite;
	private var _backgroundSprite2 : FlxSprite;
	private var _switchBackground : Bool;
	
	private var _activeIngredient : Ingredient;
	private var _activeIngredientOffset : FlxPoint;
	
	private var _assistantLeft : LeftAssistant;
	private var _assistantRight : RightAssistant;
	private var _assistantTop : FlxSprite;
	
	private var _actionCounter : Int;
	
	private var _money : Int;
	private var _moneyText : MoneyDisplay;
	
	private var _level : Int;
	private var _moneyNeeded :Int;
	private var _moneyNeededText : MoneyDisplay;
	
	private var _loosing : Bool;
	
	private var _screenOverlay : FlxSprite;
	
	private var _vignette : FlxSprite;
	
	private var _fluids : Fluids;
	
	private var _recipe : RecipeDrawer;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//MoneyDisplay.drawSingleNumber(5, new FlxPoint());
		//trace("");
		//MoneyDisplay.drawSingleNumber(11, new FlxPoint());
		//trace("");
		//MoneyDisplay.drawSingleNumber(1234, new FlxPoint());
		
		_moneyText = new MoneyDisplay(false);
		_moneyNeededText  = new MoneyDisplay(true);
		
		
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
		_backgroundSprite2.loadGraphic(AssetPaths.background_v2__png, false, 192, 128);
		_backgroundSprite2.scale.set(4, 4);
		_backgroundSprite2.origin.set();
		
		_screenOverlay = new FlxSprite();
		_screenOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColorUtil.makeFromARGB(1.0, 0, 0, 0));
		//_screenOverlay.color = FlxColorUtil.makeFromARGB(0.0, 255, 255, 255);
		_screenOverlay.alpha = 1.0;
		
		
		_vignette  = new FlxSprite();
		_vignette.loadGraphic(AssetPaths.vignette__png, false, 800, 600);
		_vignette.origin.set();
		_vignette.alpha = 0.4;
		
		
		_switchBackground = true;
		
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
		
		_fluids = new Fluids();
		_fluids.SetLeftColor(_ingredientActive._col);
		_fluids.SetRightColor(_ingredientNext._col);
		
		FlxTween.tween(_screenOverlay, { alpha : 0.0 }, 1.0);	// start the game with a tween.
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
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
		
		//// Cleaning Up
		CleanUp();
		
		//// Additional Logic
		MouseFollow();
		
		PickupObject();
		DropObject();
		
		DrawRecipeTooltip();
		
		PourIngredient();
		
		CheckMoneyNegative();
		
		if (_money >= _moneyNeeded)
		{
			FlxTween.tween(_screenOverlay, { alpha:1.0 } );
			var t:FlxTimer = new FlxTimer(1.25, function (t:FlxTimer) : Void 
			{
				var p: PlayState = new PlayState();
				p.SetLevel(_level +1);
				FlxG.switchState(p);
			});
		}
		
		var us : Float = 0;
		var ua : Float = 0;
		var ul : Float = 0;
		var ui : Float = 0;
		
		//// Update Block
		if (!_loosing)
		{
			_fluids.update();
			
			_assistantLeft.update();
			_assistantRight.update();
		
			_listPatients.update();
			_listPotions.update();
			
			_ingredientActive.update();
			_ingredientNext.update();
			
			_recipe.update();
		}
		_screenOverlay.update();
		
		var u1 : Float = (ua - us) * 1000;
		var u2 : Float = (ul - ua) * 1000;
		var u3 : Float = (ui - ul) * 1000;
		//trace ("all: " + (u1+u2+u3) + "	assistants: " + u1 + "	lists: " + u2 + "	ingredients: " + u3);
	}	
	
	private function SwapIngredients () : Void 
	{

		_ingredientActive = _ingredientNext;
		_ingredientActive.setPosition(GameProperties.IngredientPositionActive.x, GameProperties.IngredientPositionActive.y);
		_ingredientActive._isNextIngredient = false;
		_ingredientActive._doDraw = false;	// a new active ingredient may be drawn only after the aassistant's pickup animation has been played
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
					_activeIngredient.destroy();
					_activeIngredient = null;
					break;
				}
			}
			
			if (dropped)
			{
				_assistantRight.Brew();
				SwapIngredients();
				SpawnNewIngredient();
				_fluids.SetLeftColor(_ingredientActive._col);
				_fluids.SetRightColor(_ingredientNext._col);
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
							_activePotion.destroy();
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
	
	function PourIngredient():Void 
	{
		if (_activeIngredient != null)
		{
			var nearPotion : Bool = false;
			for ( i in 0 ... _listPotions.length)
			{
				var p : Potion = _listPotions.members[i];
				if (FlxG.overlap(_activeIngredient._sprite, p._hitBox))
				{	
					if (FlxG.pixelPerfectOverlap(_activeIngredient._sprite, p._hitBox, 0))
					{
						nearPotion = true;
						break;
					}
				}
			}
			if ( nearPotion )
			{
				_activeIngredient.Pour();
			}
			else 
			{
				_activeIngredient.Unpour();
			}
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
		RemoveMoney(GameProperties.MoneyIngredientCost);
		
		
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
		
		_fluids.draw();
		
		_listPatients.draw();
		_listPotions.draw();
		
		_assistantLeft.draw();
		_assistantRight.draw();
		
		
		_ingredientActive.draw();
		_ingredientNext.draw();
		
		_assistantTop.draw();
		_recipe.draw();
		
		_moneyText.drawSingleNumber(_money, new FlxPoint(412, 16));
		_moneyNeededText.drawSingleNumber(_moneyNeeded, new FlxPoint(468, 92));
		
		_screenOverlay.draw();
		_vignette.draw();
		
	}
	
	public function AddPotion (p:Potion):Void
	{
		_listPotions.add(p);
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
				if (p._sprite.overlapsPoint(FlxG.mouse))
				{
					_recipe.alpha = 1.0;
					_recipe.DrawColor(p);
				}
			}
		}
	}
	
	public function LooseGame ( ) : Void 
	{
		_loosing = true;
		//FlxG.camera.fade();
		
		FlxTween.tween(_screenOverlay, { alpha:1.0 }, 1.0 );
		
		var t: FlxTimer = new FlxTimer(1.25, function (t:FlxTimer) : Void 
		{
			FlxG.switchState(new MenuState());
		});
		//FlxTween.tween ( FlxG.camera.color, { r:0, g:0, b:0 }, 1.0, 
		//{
			//complete : function (t:FlxTween):Void
			//{
				//FlxG.switchState(new MenuState());
			//}
		//} );
		
	}
	
	
}