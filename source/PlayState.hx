package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _listPotions : FlxTypedGroup<Potion>;
	private var _ingredientActive : Ingredient;
	private var _ingredientNext : Ingredient;
	
	private var _activePotion : Potion;
	private var _activePotionOffset : FlxPoint;
	
	private var _backgroundSprite : FlxSprite;
	
	private var _pourIngredient : Ingredient;
	
	private var _activeIngredient : Ingredient;
	private var _activeIngredientOffset : FlxPoint;
	
	private var _assistantLeft : Assistant;
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
		
		_ingredientActive = new Ingredient(GameProperties.IngredientPositionActive.x, GameProperties.IngredientPositionActive.y, Color.Red, this);
		_ingredientActive._isNextIngredient = false;
		_ingredientNext = new Ingredient(GameProperties.IngredientPositionNext.x, GameProperties.IngredientPositionNext.y, Color.Green, this);
		_ingredientNext ._isNextIngredient = true;
		
		_activePotion = null;
		_activePotionOffset = new FlxPoint();
		
		_activeIngredient = null;
		_activeIngredientOffset = new FlxPoint();
		
		
		_backgroundSprite = new FlxSprite();
		_backgroundSprite.loadGraphic(AssetPaths.sampletambev2black__png, false, 192, 128);
		_backgroundSprite.scale.set(4, 4);
		_backgroundSprite.origin.set();
		
		_assistantLeft = new Assistant(true);
		
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
	}
	
	
	/**
	 * 
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		CleanUp();
		
		_assistantLeft.update();
		
		if (_activePotion != null)
		{
			_activePotion.setPosition(FlxG.mouse.x + _activePotionOffset.x, FlxG.mouse.y + _activePotionOffset.y);
		}
		else if (_activeIngredient != null)
		{
			_activeIngredient.setPosition(FlxG.mouse.x + _activeIngredientOffset.x, FlxG.mouse.y + _activeIngredientOffset.y);
		}
		
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
		
		else if (FlxG.mouse.justReleased)
		{
			//trace ("mouse released");
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
				}
				else
				{
					FlxTween.tween(_activeIngredient, { x:GameProperties.IngredientPositionActive.x, y:GameProperties.IngredientPositionActive.y }, 0.75, {ease:FlxEase.circOut});
				}
			}
			else if (_activePotion != null)
			{
				FlxTween.tween(_activePotion, { x:_activePotion._originalPosition.x, y:_activePotion._originalPosition.y }, 0.75, {ease:FlxEase.circOut});
			}
			
			_activePotion = null;
			_activeIngredient = null;
		}
		
		_listPotions.update();
		
		_ingredientActive.update();
		_ingredientNext.update();
		
		if (_pourIngredient != null && _pourIngredient.active)
		{
			_pourIngredient.update();
		}
		
	}	
	
	private function SwapIngredients () : Void 
	{
		_ingredientActive = _ingredientNext;
		_ingredientActive.setPosition(GameProperties.IngredientPositionActive.x, GameProperties.IngredientPositionActive.y);
		_ingredientActive._isNextIngredient = false;
		_ingredientActive._doDraw = false;
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
		
		
		var t : FlxTimer  = new FlxTimer(Assistant.GetAnimTimeUntilPotionApears(), function (t:FlxTimer) 
		{
			_ingredientActive._doDraw = true;
		} 
		);
		
		
		
	}
	
	
	override public function draw () : Void 
	{
		_backgroundSprite.draw();
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