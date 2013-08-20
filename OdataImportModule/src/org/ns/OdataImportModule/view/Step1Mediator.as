package org.ns.OdataImportModule.view
{
	import org.ns.OdataImportModule.controller.*;
	import org.ns.OdataImportModule.model.proxy.MetadataProxy;
	import org.ns.OdataImportModule.view.components.steps.Step1;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.components.TitleWindow;
	
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
			
		}

		
		//RESPOND	
		public function respondToModuleShowed(note:INotification):void
		{
			step.containerError.visible=true
			step.containerList.visible=false
			step.lblError.text="contacting service.Please wait..."
			sendNotification(NotificationConstants.METADATA_GET_NOTIFICATION)
		}
		
		public function respondToMetadataGetted(note:INotification):void
		{
			//get entry list from metadata
			var pxyMetadata:MetadataProxy=retrieveProxy(MetadataProxy.NAME) as MetadataProxy;
			step.entities.source=pxyMetadata.GetEntityNameList()
			
			step.lblError.text=""
			step.containerError.visible=false
			step.containerList.visible=true
		}

		public function respondToMetadataError(note:INotification):void
		{
			step.containerError.visible=true
			step.containerList.visible=false
			step.lblError.text="service is not valid or unreachable"
		}
		
		//REACTION

		
		
		//GETTER		
		public function get step():Step1
		{
			return viewComponent as Step1;
		}
	}
}