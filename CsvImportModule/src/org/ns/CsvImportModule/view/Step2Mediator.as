package org.ns.CsvImportModule.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.CsvImportModule.view.components.steps.Step2;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	public class Step2Mediator extends FlexMediator
	{
		//mediator NAME
		public static const NAME:String = "Step2Mediator";
		
		public function Step2Mediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}  		

		override public function onRegister():void 
		{
			super.onRegister();
			
			//step2 is always valid
			step2.isValid=true;
		}
		
		//RESPOND
		public function respondToFileImported(note:INotification):void 
		{
			step2.arrCsvLines=note.getBody() as ArrayCollection
		}
		
		//REACTIONS
		
		protected function get step2():Step2
		{
			return viewComponent as Step2;
		}
	}
}