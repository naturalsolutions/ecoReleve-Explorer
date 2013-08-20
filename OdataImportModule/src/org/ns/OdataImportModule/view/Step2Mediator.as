package org.ns.OdataImportModule.view
{
	import org.ns.OdataImportModule.controller.*;
	import org.ns.OdataImportModule.model.proxy.MetadataProxy;
	import org.ns.OdataImportModule.view.components.steps.Step2;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.components.TitleWindow;
	
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
			step.isValid=true
		}

		
		//RESPOND			
		public function respondToStep1Next(note:INotification):void
		{
			var entity:XML=note.getBody() as XML
				
			var pxyMetadata:MetadataProxy=retrieveProxy(MetadataProxy.NAME) as MetadataProxy;
			step.entities.source=pxyMetadata.GetEntityLinkedList(entity)	
		}
		
		//REACTION

		
		
		//GETTER		
		public function get step():Step2
		{
			return viewComponent as Step2;
		}
	}
}