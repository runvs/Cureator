package ;
import flixel.animation.FlxAnimation;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import haxe.ds.EnumValueMap;
import haxe.ds.ObjectMap;
import haxe.ds.Vector;

/**
 * ...
 * @author 
 */
class PatientPicker
{
	var list : FlxTypedGroup<PatientDescriptor>;
	
	public function new() 
	{
		list = new FlxTypedGroup<PatientDescriptor>();
		
		var i : Int = 0;
		var p : PatientDescriptor = null;
		
		///////////////////////////////////////
		//	Level 1
		///////////////////////////////////////
		
		//-------------------------------------
		//	L1 Red
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.One;
		p._color = Color.Red;
		p._name = "assets/images/patient_soldier.png";
		p._frame = [1];
		p._difficulty  = 1;
		list.add(p);
		
		//-------------------------------------
		//	L1 Green
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.One;
		p._color = Color.Green;
		p._name = "assets/images/patient_imp.png";
		p._frame = [2];
		p._difficulty  = 1;
		list.add(p);
		
		p = new PatientDescriptor();
		p._fill = FillState.One;
		p._color = Color.Green;
		p._name = "assets/images/patient_soldier.png";
		p._frame = [2];
		p._difficulty  = 1;
		list.add(p);
		
		//-------------------------------------
		//	L1 Blue
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.One;
		p._color = Color.Blue;
		p._name = "assets/images/patient_soldier.png";
		p._frame = [3];
		p._difficulty  = 1;
		list.add(p);
		
		p = new PatientDescriptor();
		p._fill = FillState.One;
		p._color = Color.Blue;
		p._name = "assets/images/patient_imp.png";
		p._frame = [1];
		p._difficulty  = 1;
		list.add(p);
		
		
		///////////////////////////////////////
		//	Level 2
		///////////////////////////////////////
		
		//-------------------------------------
		//	L2 Red
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Two;
		p._color = Color.Red;
		p._name = "assets/images/patient_archer.png";
		p._frame = [1];
		p._difficulty  = 2;
		list.add(p);
		
		p = new PatientDescriptor();
		p._fill = FillState.Two;
		p._color = Color.Red;
		p._name = "assets/images/patient_peasant.png";
		p._frame = [1];
		p._difficulty  = 2;
		list.add(p);
		
		//-------------------------------------
		//	L2 Blue
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Two;
		p._color = Color.Blue;
		p._name = "assets/images/patient_archer.png";
		p._frame = [3];
		p._difficulty  = 2;
		list.add(p);
		
		//-------------------------------------
		//	L2 Orange
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Two;
		p._color = Color.Orange;	
		p._name = "assets/images/patient_archer.png";
		p._frame = [2];
		p._difficulty  = 3;
		list.add(p);
		
		//-------------------------------------
		//	L3 YellowGreen
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Three;
		p._color = Color.YellowGreen;
		p._name = "assets/images/patient_peasant.png";
		p._frame = [3];
		p._difficulty  = 5;
		list.add(p);
		
		//-------------------------------------
		//	L2 Magenta
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Two;
		p._color = Color.Pruple;
		p._name = "assets/images/patient_peasant.png";
		p._frame = [4];
		p._difficulty  = 5;
		list.add(p);
		
		//-------------------------------------
		//	L3 SeaGreen
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Three;
		p._color = Color.SeaGreen;
		p._name = "assets/images/patient_peasant.png";
		p._frame = [2];
		p._difficulty  = 6;
		list.add(p);
		
		///////////////////////////////////////
		//	Level 3
		///////////////////////////////////////
		
		//-------------------------------------
		//	L3 Red
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Three;
		p._color = Color.Red;
		p._name = "assets/images/patient_troll.png";
		p._frame = [1];
		p._difficulty  = 4;
		list.add(p);
		
		//-------------------------------------
		//	L3 Green
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Three;
		p._color = Color.Green;
		p._name = "assets/images/patient_troll.png";
		p._frame = [3];
		p._difficulty  = 4;
		list.add(p);
		
		//-------------------------------------
		//	L3 Pink
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Three;
		p._color = Color.Pink;
		p._name = "assets/images/patient_imp.png";
		p._frame = [3];
		p._difficulty  = 5;
		list.add(p);
		
		//-------------------------------------
		//	L2 Yellow
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Two;
		p._color = Color.Yellow;
		p._name = "assets/images/patient_priest.png";
		p._frame = [2];
		p._difficulty  = 3;
		list.add(p);
		
		//-------------------------------------
		//	L2 Magenta
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Two;
		p._color = Color.Magenta;
		p._name = "assets/images/patient_priest.png";
		p._frame = [3];
		p._difficulty  = 3;
		list.add(p);
		
		//-------------------------------------
		//	L3 Purple
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Three;
		p._color = Color.Purple;
		p._name = "assets/images/patient_troll.png";
		p._frame = [2];
		p._difficulty  = 5;
		list.add(p);
		
		//-------------------------------------
		//	L3 Cyan
		//-------------------------------------
		p = new PatientDescriptor();
		p._fill = FillState.Two;
		p._color = Color.Cyan;
		p._name = "assets/images/patient_priest.png";
		p._frame = [1];
		p._difficulty  = 5;
		list.add(p);
		
	}
	
	public function RandomPatient() : PatientDescriptor
	{
		var i : Int = FlxRandom.intRanged(0, list.length-1);
		return list.members[i];
	}
	
	
	public function RandomPatientWithDifficultyUpTo (d : Int) : PatientDescriptor
	{
		trace("spawn d: " + d);
		var p : PatientDescriptor = RandomPatient();
		while (p._difficulty > d)
		{
			p = RandomPatient();
		}
		return p;
	}
	
	
	
}