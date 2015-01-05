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
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		_background = new FlxSprite();
		_background.loadGraphic(AssetPaths.potions_samplecolor__png, false, 477, 577);
		//_spr.origin.set();
		_background.screenCenter();
		
		_btn = new FlxButton(0, 0, "StartGame", StartGame);
		_btn.screenCenter();
		
		#if flash
		FlxG.sound.playMusic(AssetPaths.cureator_OST_v__02__mp3, 1.0, true);
		#else
		FlxG.sound.playMusic(AssetPaths.cureator_OST_v__02__ogg, 1.0, true);
		#end
		
		_vignette  = new FlxSprite();
		_vignette.loadGraphic(AssetPaths.vignette__png, false, 800, 600);
		_vignette.origin.set();
		_vignette.alpha = 0.4;
		
	}
	
	public function StartGame(): Void 
	{
		FlxG.switchState(new PlayState());
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
		_background.update();
		_btn.update();
	}	
	
	override public function draw():Void
	{
		super.draw();
		FlxG.camera.fill( FlxColorUtil.makeFromARGB(1.0, 64, 64, 64));
		_background.draw();
		_btn.draw();
		
		_vignette.draw();
	}
}