package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.WidgetPanel;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	import spark.components.CheckBox;

	public class WidgetPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "WidgetPanelMediator";	
		
		public function WidgetPanelMediator(viewComponent:WidgetPanel)
		{
			super(NAME, viewComponent);
		}   
        
		override public function onRegister():void
		{
			super.onRegister();
			widgetPanel.enabled=false;
			widgetPanel.addEventListener(WidgetPanel.INFO_SELECTED_CHANGE,infoChangeHandler)
			widgetPanel.addEventListener(WidgetPanel.MEDIA_SELECTED_CHANGE,mediaChangeHandler)
			widgetPanel.addEventListener(WidgetPanel.STATUS_SELECTED_CHANGE,statusChangeHandler)
		}
		
        // Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION,
					NotificationConstants.SELECTION_RESET_NOTIFICATION,
					NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.SELECTION_RESET_NOTIFICATION:
					widgetPanel.enabled=false;
					break;
				case NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION:						 
					widgetPanel.enabled=false;
					break;
				case NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION:						 
					widgetPanel.enabled=true;
					break;
			}
		} 

		private function infoChangeHandler(event:Event):void
		{
			sendNotification(NotificationConstants.WIDGET_ACTIVATE_NOTIFICATION,widgetPanel.chkInfo.selected,"info")
		}
		
		private function mediaChangeHandler(event:Event):void
		{
			sendNotification(NotificationConstants.WIDGET_ACTIVATE_NOTIFICATION,widgetPanel.chkMedia.selected,"media")
		}
		
		private function statusChangeHandler(event:Event):void
		{
			sendNotification(NotificationConstants.WIDGET_ACTIVATE_NOTIFICATION,widgetPanel.chkStatus.selected,"status")
		}

        protected function get widgetPanel():WidgetPanel
        {
            return viewComponent as WidgetPanel;
        }
		

		
	}
}