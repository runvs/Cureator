package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;


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
	
	private var _activeIngredient : Ingredient;
	private var _activeIngredientOffset : FlxPoint;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		_listPotions = new FlxTypedGroup<Potion>();
		
		_listPotions.add(new Potion(100, 100, Color.None,this));
		_listPotions.add(new Potion(150, 100, Color.None,this));
		_listPotions.add(new Potion(200, 100, Color.None, this));
		
		_ingredientActive = new Ingredient(300, 100, Color.Red, this);
		_ingredientActive._isNextIngredient = false;
		_ingredientNext = new Ingredient(300, 50, Color.Green, this);
		_ingredientNext ._isNextIngredient = true;
		
		_activePotion = null;
		_activePotionOffset = new FlxPoint();
		
		_activeIngredient = null;
		_activeIngredientOffset = new FlxPoint();
		
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
		
		if (_activePotion != null)
		{
			_activePotion.setPosition(FlxG.mouse.x + _activePotionOffset.x, FlxG.mouse.y + _activePotionOffset.y);
		}
		else if (_activeIngredient != null)
		{
			_activeIngredient.setPosition(FlxG.mouse.x + _activeIngredientOffset.x, FlxG.mouse.y + _activeIngredientOffset.y);
		}
		
		if (FlxG.mouse.justReleased)
		{
			trace ("mouse released");
			if (_activeIngredient != null)
			{
				trace ("active ingredient");
				var dropped :Bool = false;
				for ( i in 0 ... _listPotions.length)
				{
					var p : Potion = _listPotions.members[i];
					if (FlxG.overlap(_activeIngredient._hitBox, p._hitBox))
					{	
						trace ("overlap");
						p.AddIngedient(_activeIngredient);
						
						dropped = true;
						break;
					}
				}
				
				if (dropped)
				{
					_ingredientActive = _ingredientNext;
					_ingredientNext = SpawnNewIngredient();
				}
				else
				{
					// snap back ingredient
				}
			}
			else if (_activePotion != null)
			{
				// TODO Snap back Potion
			}
			
			_activePotion = null;
			_activeIngredient = null;
		}
		
		_listPotions.update();
		
		_ingredientActive.update();
		_ingredientNext.update();
		
	}	
	
	public function SpawnNewIngredient():Ingredient
	{
		var i : Ingredient = new Ingredient(300, 50, Color.Cyan, this);
		return i;
	}
	
	
	override public function draw () : Void 
	{
		_listPotions.draw();
		
		_ingredientActive.draw();
		_ingredientNext.draw();
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
		_activeIngredient = i;
		_activeIngredientOffset = offs;
	}
	
}