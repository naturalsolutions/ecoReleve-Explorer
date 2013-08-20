package org.ns.genericComponents.wizard.events
{
	import flash.events.Event;
	
	public class WizardEvent extends Event
	{
		public static const NEXT_STEP:String = "nextStep";
		public static const PREV_STEP:String = "prevStep";
		public static const WIZARD_COMPLETE:String = "wizardComplete";
		public static const WIZARD_CANCEL:String = "wizardCancel";
		
		private var _stepIdx:int;
		
		public function WizardEvent(type:String,stepIndex:int, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_stepIdx=stepIndex;
		}
		
		override public function clone():Event
		{
			return new WizardEvent(type,_stepIdx, bubbles, cancelable);
		}
		
		public function get stepIdx():int
		{
			return _stepIdx;
		}
	}
}