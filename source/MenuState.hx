package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;

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
	
	private var _difficultyTutorial : FlxSprite;
	private var _difficultyEasy : FlxSprite;
	private var _difficultyMedium : FlxSprite;
	private var _difficultyHard : FlxSprite;
	
	private var _musicOnOff : FlxSprite;
	private var _music : Bool;
	
	private var _overlay : FlxSprite;	// for fading the menu in  and out
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		var difficultyPosY :Int = 214;
		
		_background = new FlxSprite();
		_background.loadGraphic(AssetPaths.opening__png, false, 192, 128);
		_background.scale.set(4, 4);
		_background.x = 0;
		_background.y = 0;
		_background.origin.set();
		add(_background);
		

		
		_btn = new FlxButton(550, difficultyPosY + 100 ,"", StartGame);
		_btn.loadGraphic(AssetPaths.button_play__png, false, 48, 16);
		_btn.scale.set(4, 4);
		_btn.updateHitbox();
		
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
		
		var difficultyXPos : Float = 630;
		_difficultyTutorial = new FlxSprite();
		_difficultyTutorial.loadGraphic(AssetPaths.button_tutorial__png, false, 45, 11);
		_difficultyTutorial.scale.set(4, 4);	
		_difficultyTutorial.x = difficultyXPos;
		_difficultyTutorial.y = difficultyPosY + 50;
		_difficultyTutorial.alpha = 0.0;
		
		_difficultyEasy = new FlxSprite();
		_difficultyEasy.loadGraphic(AssetPaths.button_easy__png, false, 45, 11);
		_difficultyEasy.scale.set(4, 4);
		_difficultyEasy.x = difficultyXPos;
		_difficultyEasy.y = difficultyPosY + 50;
		_difficultyEasy.alpha = 0.0;
		
		_difficultyMedium = new FlxSprite();
		_difficultyMedium.loadGraphic(AssetPaths.button_normal__png, false, 45, 11);
		_difficultyMedium.scale.set(4, 4);
		_difficultyMedium.x = difficultyXPos;
		_difficultyMedium.y = difficultyPosY + 50;
		_difficultyMedium.alpha = 0.0;
		
		_difficultyHard = new  FlxSprite();
		_difficultyHard.loadGraphic(AssetPaths.button_hard__png, false, 45, 11);
		_difficultyHard.scale.set(4, 4);
		_difficultyHard.x = difficultyXPos;
		_difficultyHard.y = difficultyPosY + 50;
		_difficultyHard.alpha = 0.0;
		
		_musicOnOff = new FlxSprite();
		_musicOnOff.loadGraphic(AssetPaths.button_music__png, true, 48, 16);
		_musicOnOff.scale.set(4, 4);
		_musicOnOff.updateHitbox();
		_musicOnOff.x = 550;
		_musicOnOff.y = difficultyPosY + 180;
		_musicOnOff.animation.add("on", [0]);
		_musicOnOff.animation.add("off", [1]);
		add(_musicOnOff);
		
		if (FlxG.sound.muted == true)
		{
			_music = false;
		}
		else 
		{
			_music = true;
		}
		
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
		
		add(_difficultyTutorial);
		add(_difficultyEasy);
		add(_difficultyMedium);
		add(_difficultyHard);
		
		add(_vignette);
		_overlay = new FlxSprite();
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		FlxTween.tween(_overlay, { alpha : 0.0 }, 0.45);
		add(_overlay);
		
	}
	
	private function ToggleMusic() : Void 
	{
		_music = !_music;
		if (_music)
		{
			_musicOnOff.animation.play("on");
			FlxG.sound.muted = false;
		}
		else 
		{
			_musicOnOff.animation.play("off");
			FlxG.sound.muted = true;
		}
	}
	
	public function StartGame(): Void 
	{
		FlxTween.tween(_overlay, { alpha : 1.0 }, 0.45);
		var t : FlxTimer = new FlxTimer(0.45, function ( t : FlxTimer)
		{
			var p : PlayState = new PlayState();
			if (GameProperties.SelectedDifficulty == DifficultyLevel.Easy)
			{
				GameProperties.Level = 0;
			}
			if (GameProperties.SelectedDifficulty == DifficultyLevel.Medium)
			{
				GameProperties.Level = 2;
			}
			if (GameProperties.SelectedDifficulty == DifficultyLevel.Hard)
			{
				GameProperties.Level = 4;
			}
			p.SetLevel();
			FlxG.switchState(p);	
		});
		
	}
	
	public function DUp () :Void
	{
		if (GameProperties.SelectedDifficulty == DifficultyLevel.Tutorial)
		{
			GameProperties.SelectedDifficulty = DifficultyLevel.Easy;
		}
		else if (GameProperties.SelectedDifficulty == DifficultyLevel.Easy)
		{
			GameProperties.SelectedDifficulty = DifficultyLevel.Medium;
		}
		else if (GameProperties.SelectedDifficulty == DifficultyLevel.Medium)
		{
			GameProperties.SelectedDifficulty = DifficultyLevel.Hard;
		}
		
	}
	
	public function DDown () : Void
	{
		if (GameProperties.SelectedDifficulty == DifficultyLevel.Hard)
		{
			GameProperties.SelectedDifficulty = DifficultyLevel.Medium;
		}
		else if (GameProperties.SelectedDifficulty == DifficultyLevel.Medium)
		{
			GameProperties.SelectedDifficulty = DifficultyLevel.Easy;
		}
		else if (GameProperties.SelectedDifficulty == DifficultyLevel.Easy)
		{
			GameProperties.SelectedDifficulty = DifficultyLevel.Tutorial;
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
		
		// difficulty selectors
		_difficultyTutorial.alpha = (GameProperties.SelectedDifficulty == DifficultyLevel.Tutorial) ? 1.0 : 0.0;
		_difficultyEasy.alpha = (GameProperties.SelectedDifficulty == DifficultyLevel.Easy) ? 1.0 : 0.0;
		_difficultyMedium.alpha = (GameProperties.SelectedDifficulty == DifficultyLevel.Medium) ? 1.0 : 0.0;
		_difficultyHard.alpha = (GameProperties.SelectedDifficulty == DifficultyLevel.Hard) ? 1.0 : 0.0;
		
		
		// music button
		if (FlxG.mouse.justPressed)
		{
			if (_musicOnOff.overlapsPoint(FlxG.mouse))
			{
				trace ("overlap");
				ToggleMusic();
			}
		}
		
	}	
	
	override public function draw():Void
	{	
		FlxG.camera.fill( FlxColorUtil.makeFromARGB(1.0, 64, 64, 64));
		super.draw();
	}
}