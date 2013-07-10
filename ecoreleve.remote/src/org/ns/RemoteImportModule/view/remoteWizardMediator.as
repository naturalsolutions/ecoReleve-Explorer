package org.ns.RemoteImportModule.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.RemoteImportModule.controller.*;
	import org.ns.RemoteImportModule.view.components.remoteWizard;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.VO.RemoteDatasourceVO;
	import org.ns.genericComponents.wizard.events.WizardEvent;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;

	public class remoteWizardMediator extends FlexMediator
	{
		//nom du médiator
	    public static const NAME:String = "csvWizardMediator";		
		
 		//constructeur
        public function remoteWizardMediator(viewComponent:Object)
        {
            super(NAME, viewComponent); 	
        } 
	
		override public function onRegister():void 
		{
			super.onRegister();
			//register all step mediator
			registerMediator(new Step1Mediator(wizard.step1));
			
			wizard.dataModel=new Object
			
			wizard.addEventListener(WizardEvent.WIZARD_COMPLETE, onWizardComplete);
			wizard.addEventListener(WizardEvent.NEXT_STEP, onNextStep);
			wizard.addEventListener(WizardEvent.PREV_STEP, onPreviousStep);
			wizard.addEventListener(WizardEvent.WIZARD_CANCEL, onCancel);
		}

		//RESPONDER
		public function respondToImportFinished(note:INotification):void
		{		
			onCloseWizard()
		}		
		
		//HANDLERS
		private function onWizardComplete(event:WizardEvent):void 
		{		
			sendNotification(NotificationConstants.LOAD_STATIONS_NOTIFICATION,wizard.dataModel)
		}
		
		private function onCancel(event:WizardEvent):void 
		{
			wizard.dataModel=new Object;
			
			onCloseWizard()
		}
		
		private function onCloseWizard():void 
		{	
			removeMediator(Step1Mediator.NAME);
			
			routeNotification(CommonNotificationConstants.UNLOAD_MODULE_NOTIFICATION, null, null, "*")
		}
		
		private function onNextStep(event:WizardEvent):void 
		{
			switch (event.stepIdx)
			{
				case 1:
					break;
			}
		}
		
		private function onPreviousStep(event:WizardEvent):void 
		{
			
		}
		
		
		//GETTER
        public function get wizard():remoteWizard
        {
            return viewComponent as remoteWizard;
        }
    }
}