package ;
import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class PatientDescriptor extends FlxObject
{
	public var _fill : FillState;
	public var _color : Color;
	public var _name : String;
	public var _frame : Array<Int>;
	
	public function new () : Void 
	{
		super();
	}
	
}