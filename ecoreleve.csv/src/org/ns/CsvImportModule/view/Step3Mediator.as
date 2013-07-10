package org.ns.CsvImportModule.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.CsvImportModule.view.components.steps.Step3;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	public class Step3Mediator extends FlexMediator
	{
		//mediator NAME
		public static const NAME:String = "Step3Mediator";
		
		//object with: staFIELD,csvFIELD,format
		public var arrFieldMapping:ArrayCollection=new ArrayCollection;
		
		public function Step3Mediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		} 		
		
		//RESPOND
		public function respondToHeaderReaded(note:INotification):void 
		{
			step3.arrCSVField.removeAll();
			step3.arrCSVField.addAll(note.getBody() as ArrayCollection);
		}
		
		//REACTIONS
		
		protected function get step3():Step3
		{
			return viewComponent as Step3;
		}
	}
}