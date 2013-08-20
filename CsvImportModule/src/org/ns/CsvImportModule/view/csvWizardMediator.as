package org.ns.CsvImportModule.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.controller.CommonNotificationConstants
	import org.ns.CsvImportModule.controller.*;
	import org.ns.CsvImportModule.view.components.csvWizard;
	import org.ns.genericComponents.wizard.events.WizardEvent;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;

	public class csvWizardMediator extends FlexMediator
	{
		//nom du médiator
	    public static const NAME:String = "csvWizardMediator";		
		
 		//constructeur
        public function csvWizardMediator(viewComponent:Object)
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
			onCloseWizard()
		}
		
		//HANDLERS
		private function onWizardComplete(event:WizardEvent):void 
		{
			//trace(wizard.dataModel.file)
			//trace(wizard.dataModel.settings)
			//trace(wizard.dataModel.mapping)		
			sendNotification(NotificationConstants.CREATE_STATIONS_NOTIFICATION,wizard.dataModel.mapping)
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
					var f:File=wizard.step1.stepDecision as File
					sendNotification(NotificationConstants.IMPORT_FILE_NOTIFICATION,f);
					break;
				case 2:
					var arrSettings:Array=new Array
					arrSettings=wizard.step2.stepDecision as Array;
					sendNotification(NotificationConstants.READ_HEADER_NOTIFICATION,arrSettings);
					break;
				case 3:
					var arrMapping:ArrayCollection=new ArrayCollection
					arrMapping=wizard.step3.stepDecision as ArrayCollection;
					break;
			}
		}
		
		private function onPreviousStep(event:WizardEvent):void 
		{
			
		}
		
		
		//GETTER
        public function get wizard():csvWizard
        {
            return viewComponent as csvWizard;
        }
    }
}