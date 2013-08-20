package org.ns.genericComponents.wizard
{
	import mx.containers.Canvas;
	import org.ns.genericComponents.wizard.interfaces.IWizardStep;

	
	public class WizardStep extends Canvas implements IWizardStep
	{
		private var _stepName:String;
		private var _stepDescription:String;
		private var _isValid:Boolean;
		private var _dataField:String;
		
		public function WizardStep() 
		{
			super();
		}
		
		public function get stepName():String 
		{
			return _stepName;
		}
		
		public function set stepName(value:String):void 
		{
			_stepName = value;
		}
		
		public function get stepDescription():String 
		{
			return _stepDescription;
		}
		
		public function set stepDescription(value:String):void 
		{
			_stepDescription = value;
		}
		[Bindable]
		public function get isValid():Boolean 
		{
			return _isValid;
		}
		
		public function set isValid(value:Boolean):void 
		{
			_isValid = value;
		}
		
		public function get dataField():String 
		{
			return _dataField;
		}
		
		public function set dataField(value:String):void 
		{
			_dataField = value;
		}
		
		public function get stepDecision():* 
		{
			return null;
		}
		
		public function get readableStepDecision():String 
		{
			return null;    
		}

	}
}