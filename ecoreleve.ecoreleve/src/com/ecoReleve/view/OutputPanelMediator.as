package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.ribbon.IOPanel.OutputPanel;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class OutputPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "OutputPanelMediator";	
		
		public function OutputPanelMediator(viewComponent:OutputPanel)
		{
			super(NAME, viewComponent);	
		}   
        
		override public function onRegister():void
		{
			super.onRegister();
			
			outputpanel.addEventListener(OutputPanel.EXPORT_CSV,onExportCSV);
			outputpanel.addEventListener(OutputPanel.EXPORT_KML,onExportKML);
			outputpanel.addEventListener(OutputPanel.EXPORT_NSML,onExportNSML);	
			outputpanel.addEventListener(OutputPanel.EXPORT_GPX,onExportGPX);	
		
		}

		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATIONS_ADDED_NOTIFICATION];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:	
					if ((note.getBody() as ArrayCollection).length==0){
						outputpanel.boEnabled=false;
					}else{
						outputpanel.boEnabled=true;
					}
					break;
			}
		} 
        
		/** EXPORT KML
		 * 
		 **/      
        protected function onExportKML( event:Event ):void
        {       	
			sendNotification(NotificationConstants.EXPORT_FILE_NOTIFICATION,"kml")
        }
        
		/** EXPORT CSV
		 * 
		 **/        
        protected function onExportCSV( event:Event ):void
        {   
			sendNotification(NotificationConstants.EXPORT_FILE_NOTIFICATION,"csv")
        }

		/** EXPORT NSML
		 * 
		 **/       
        protected function onExportNSML( event:Event ):void
        {   
			sendNotification(NotificationConstants.EXPORT_FILE_NOTIFICATION,"nsml")
        }
		
		/** EXPORT GPX
		 * 
		 **/       
		protected function onExportGPX( event:Event ):void
		{   
			sendNotification(NotificationConstants.EXPORT_FILE_NOTIFICATION,"gpx")
		}
     
        protected function get outputpanel():OutputPanel
        {
            return viewComponent as OutputPanel;
        }
		

		
	}
}