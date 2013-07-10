package org.ns.OdataImportModule.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.OdataImportModule.controller.*;
	import org.ns.OdataImportModule.view.components.odataWizard;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.VO.RemoteDatasourceVO;
	import org.ns.genericComponents.wizard.events.WizardEvent;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;

	public class odataWizardMediator extends FlexMediator
	{
		//nom du médiator
	    public static const NAME:String = "csvWizardMediator";		
		private var baseTimer:int
		
		
 		//constructeur
        public function odataWizardMediator(viewComponent:Object)
        {
            super(NAME, viewComponent); 	
        } 
	
		override public function onRegister():void 
		{
			super.onRegister();
			//register all step mediator
			registerMediator(new Step1Mediator(wizard.step1));
			registerMediator(new Step2Mediator(wizard.step2));
			registerMediator(new Step3Mediator(wizard.step3));
			
			wizard.dataModel=new Object
			
			wizard.addEventListener(WizardEvent.WIZARD_COMPLETE, onWizardComplete);
			wizard.addEventListener(WizardEvent.NEXT_STEP, onNextStep);
			wizard.addEventListener(WizardEvent.PREV_STEP, onPreviousStep);
			wizard.addEventListener(WizardEvent.WIZARD_CANCEL, onCancel);
		}

		//RESPONDER
		public function respondToImportFinished(note:INotification):void
		{	
			var d:Date=new Date(getTimer()-baseTimer)
			trace("import duration: "+ String(d.minutes) + ":" + String(d.seconds) + '.' + String(d.milliseconds))
			onCloseWizard()
		}				
		
		public function respondToStationsSelected(note:INotification):void
		{		
			if (wizard.showProgressBar==true){
				var param:Array=note.getBody() as Array
				var nbTotalLoaded:Number=Number(param[3])
				var nbTotal:Number=Number(param[5])
				wizard.setProgressBar([nbTotalLoaded,nbTotal])
			}
		}				
		
		//HANDLERS
		private function onWizardComplete(event:WizardEvent):void 
		{	
			baseTimer=getTimer()
			sendNotification(NotificationConstants.LOAD_STATIONS_NOTIFICATION,wizard.dataModel,'occurence')
		}
		
		private function onCancel(event:WizardEvent):void 
		{
			wizard.dataModel=new Object;
			
			onCloseWizard()
		}
		
		private function onCloseWizard():void 
		{	
			removeMediator(Step1Mediator.NAME);
			removeMediator(Step2Mediator.NAME);
			removeMediator(Step3Mediator.NAME);
			
			
			routeNotification(CommonNotificationConstants.UNLOAD_MODULE_NOTIFICATION, null, null, "*")
		}
		
		private function onNextStep(event:WizardEvent):void 
		{
			switch (event.stepIdx)
			{
				case 1:
					sendNotification(NotificationConstants.STEP1_NEXT_NOTIFICATION,wizard.dataModel.ENTITY)
					break;
				case 2:
					sendNotification(NotificationConstants.STEP2_NEXT_NOTIFICATION,wizard.dataModel)
					break;
			}
		}
		
		private function onPreviousStep(event:WizardEvent):void 
		{
			
		}
		
		
		//GETTER
        public function get wizard():odataWizard
        {
            return viewComponent as odataWizard;
        }
    }
}