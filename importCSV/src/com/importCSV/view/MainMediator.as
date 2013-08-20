package com.importCSV.view
{
	import com.importCSV.controller.*;
	import com.importCSV.utils.Debug;
	import com.importCSV.view.mycomponents.Main;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Form;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MainMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "mainmediator";		
 				
 		//constructeur
        public function MainMediator(viewComponent:Main)
        {
            super(NAME, viewComponent);   
			main.addEventListener(Main.BROWSE,onBrowse)
			main.addEventListener(Main.NEXT,onNext)
			main.addEventListener(Main.PREVIOUS,onPrevious)
			main.addEventListener(Main.FINISH,onFinish)
        }
        
        // Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [ApplicationFacade.FILE_SELECTED_NOTIFICATION,
					ApplicationFacade.FILE_READED_NOTIFICATION,
					ApplicationFacade.HEADER_READED_NOTIFICATION,
					ApplicationFacade.FILE_DROPED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
 	 			case ApplicationFacade.FILE_SELECTED_NOTIFICATION:
					main.f=note.getBody() as File;
				break;
				case ApplicationFacade.FILE_READED_NOTIFICATION:
					main.arrCsvLines.removeAll()
					main.arrCsvLines.addAll(note.getBody() as ArrayCollection);
				break;
				case ApplicationFacade.HEADER_READED_NOTIFICATION:
					main.arrCSVField.removeAll()
					main.arrCSVField.addAll(note.getBody() as ArrayCollection);
				break;
				case ApplicationFacade.FILE_DROPED_NOTIFICATION:
					main.f=note.getBody() as File
					//next step
					main.currentViewSelector+=1;
					break;
			}
		}     

		private function onBrowse(event:Event):void
		{
			sendNotification(ApplicationFacade.BROWSE_NOTIFICATION);
		}
		
		private function onFinish(event:Event):void
		{
			sendNotification(ApplicationFacade.GET_CSV_NOTIFICATION,main.arrFieldMapping);
		}
		
		public function onPrevious(event:Event):void
		{
			//go to previous page
			main.currentViewSelector-=1;
		}
		
		public function onNext(event:Event):void
		{				
			//send event of next page
			if (main.currentViewSelector==0){
				sendNotification(ApplicationFacade.READ_FILE_NOTIFICATION,main.f);			
			}else if(main.currentViewSelector==1){
				sendNotification(ApplicationFacade.READ_HEADER_NOTIFICATION,[main.stepHeaderRow.value,main.cbSeparator.selectedItem]);
			}
			
			//go to next page
			main.currentViewSelector+=1;
		}
		
        protected function get main():Main
        {
            return viewComponent as Main;
        }
    }
}