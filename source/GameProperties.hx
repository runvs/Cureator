package ;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class GameProperties
{

	public static var PotionPosition1 : FlxPoint = new FlxPoint(220, 324);
	public static var PotionPosition2 : FlxPoint = new FlxPoint(308, 324);
	public static var PotionPosition3 : FlxPoint = new FlxPoint(396, 324);
	public static var PotionPosition4 : FlxPoint = new FlxPoint(484, 324);

	public static var IngredientPositionNext : FlxPoint = new FlxPoint(0, 448);
	public static var IngredientPositionActive : FlxPoint = new FlxPoint(96, 224);
	
	public static var JarSpawnTime : Float = 1.0;
	
	public static var PatientSpawnPosition : FlxPoint = new FlxPoint(-128, 176);
	public static var PatientExitPosition : FlxPoint = new FlxPoint(800, 176 );
	
	public static var PatientSeat1 : FlxPoint = new FlxPoint(128, 176);
	public static var PatientSeat2 : FlxPoint = new FlxPoint(320, 176);
	public static var PatientSeat3 : FlxPoint = new FlxPoint(512, 176);
	
	public static var PatientSpeed : Float = 100;
	public static var PatientSpawnTime : Float = 5;
	
	public static var ActionsForPatitentsToMove : Int = 2;
	
	public static var MoneyBaseGainValue : Float = 4;
	public static var MoneyIngredientCost : Int = 1;
	public static var MoneyStartAmount : Int = 7;
	
	public static var Difficulty : DifficultyLevel  = DifficultyLevel.Medium;
	static public var Platform_AndroidPickupYOffset : Float = 50;
	
	
	//public static var DEBUGDrawHitBoxes : Bool = false;
	
}