package org.ns.XmlImportModule.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	
	import org.ns.XmlImportModule.controller.*;
	import org.ns.XmlImportModule.view.components.steps.Step1;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.components.Button;
	
	public class Step1Mediator extends FlexMediator
	{
		//mediator NAME
		public static const NAME:String = "Step1Mediator";
		
		public function Step1Mediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		} 		
		
		override public function onRegister():void 
		{
			super.onRegister();
			step1.addEventListener("BROWSE",HandleBrowseButtonClick)
		}

		
		//RESPOND	
		private function HandleBrowseButtonClick(event:Event):void
		{
			sendNotification(NotificationConstants.BROWSE_NOTIFICATION);
		}
		
		public function respondToFileSelected(note:INotification):void 
		{
			step1.f=note.getBody() as File;	
			step1.isValid=true;
		}
		
		//GETTER		
		public function get step1():Step1
		{
			return viewComponent as Step1;
		}
	}
}