package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _background : FlxSprite;
	
	private var _btn : FlxButton;
	
	private var _vignette :FlxSprite;
	
	private var _btnDUp : FlxButton;
	private var _btnDDown : FlxButton;
	private var _difficultyText : FlxSprite;
	
	private var _difficultyEasy : FlxSprite;
	private var _difficultyMedium : FlxSprite;
	private var _difficultyHard : FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		var difficultyPosY :Int = 224;
		
		_background = new FlxSprite();
		_background.loadGraphic(AssetPaths.opening__png, false, 192, 128);
		_background.scale.set(4, 4);
		_background.x = 0;
		_background.y = 0;
		_background.origin.set();
		add(_background);
		

		
		_btn = new FlxButton(550, 324,"", StartGame);
		_btn.loadGraphic(AssetPaths.button_play__png, false, 48, 16);
		_btn.scale.set(4, 4);
		_btn.updateHitbox();
		//_btn.origin.set();
		
		_btnDDown = new FlxButton(137 * 4, difficultyPosY, "", DDown);
		_btnDDown.loadGraphic(AssetPaths.button_left__png, false, 5, 7);
		_btnDDown.scale.set(4, 4);
		_btnDDown.updateHitbox();
		
		_btnDUp = new FlxButton(181 * 4, difficultyPosY, "", DUp);
		_btnDUp.loadGraphic(AssetPaths.button_right__png, false, 5, 7);
		_btnDUp.scale.set(4, 4);
		_btnDUp.updateHitbox();
		
		_difficultyText = new FlxSprite();
		_difficultyText.loadGraphic(AssetPaths.button_difficulty__png, false, 34, 6);
		_difficultyText.scale.set(4, 4);
		_difficultyText.x = 577;
		_difficultyText.y = difficultyPosY;
		_difficultyText.origin.set(0,-1);
		
		
		
		_difficultyEasy = new FlxSprite();
		_difficultyEasy.loadGraphic(AssetPaths.button_easy__png, false, 39, 11);
		_difficultyEasy.scale.set(4, 4);
		_difficultyEasy.x = 612;
		_difficultyEasy.y = difficultyPosY + 50;
		_difficultyEasy.alpha = 0.0;
		
		_difficultyMedium = new FlxSprite();
		_difficultyMedium.loadGraphic(AssetPaths.button_normal__png, false, 39, 11);
		_difficultyMedium.scale.set(4, 4);
		_difficultyMedium.x = 640;
		_difficultyMedium.y = difficultyPosY + 50;
		_difficultyMedium.alpha = 0.0;
		
		_difficultyHard = new  FlxSprite();
		_difficultyHard.loadGraphic(AssetPaths.button_hard__png, false, 39, 11);
		_difficultyHard.scale.set(4, 4);
		_difficultyHard.x = 608;
		_difficultyHard.y = difficultyPosY + 50;
		_difficultyHard.alpha = 0.0;
		
		
		
		#if flash
		FlxG.sound.playMusic(AssetPaths.cureator_OST_v__02__mp3, 1.0, true);
		#else
		FlxG.sound.playMusic(AssetPaths.cureator_OST_v__02__ogg, 1.0, true);
		#end
		
		_vignette  = new FlxSprite();
		_vignette.loadGraphic(AssetPaths.vignette__png, false, 800, 600);
		_vignette.origin.set();
		_vignette.alpha = 0.4;
		
		
		add(_btn);
		
		add(_btnDDown);
		add(_btnDUp);
		add (_difficultyText);
		
		add(_difficultyEasy);
		add(_difficultyMedium);
		add(_difficultyHard);
		
		add(_vignette);
		
	}
	
	public function StartGame(): Void 
	{
		FlxG.switchState(new PlayState());
	}
	
	public function DUp () :Void
	{
		if (GameProperties.Difficulty == DifficultyLevel.Easy)
		{
			GameProperties.Difficulty = DifficultyLevel.Medium;
		}
		else if (GameProperties.Difficulty == DifficultyLevel.Medium)
		{
			GameProperties.Difficulty = DifficultyLevel.Hard;
		}
		
	}
	
	public function DDown () : Void
	{
		if (GameProperties.Difficulty == DifficultyLevel.Hard)
		{
			GameProperties.Difficulty = DifficultyLevel.Medium;
		}
		else if (GameProperties.Difficulty == DifficultyLevel.Medium)
		{
			GameProperties.Difficulty = DifficultyLevel.Easy;
		}
	}
	
	
	/**
	 * 
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		_difficultyEasy.alpha = (GameProperties.Difficulty == DifficultyLevel.Easy) ? 1.0 : 0.0;
		_difficultyMedium.alpha = (GameProperties.Difficulty == DifficultyLevel.Medium) ? 1.0 : 0.0;
		_difficultyHard.alpha = (GameProperties.Difficulty == DifficultyLevel.Hard) ? 1.0 : 0.0;
		
	}	
	
	override public function draw():Void
	{	
		FlxG.camera.fill( FlxColorUtil.makeFromARGB(1.0, 64, 64, 64));
		super.draw();
	}
}