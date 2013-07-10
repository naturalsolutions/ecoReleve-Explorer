package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.manager.PopManager;
	import com.ecoReleve.view.mycomponents.ribbon.DataPanel.DataPanel;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class DataPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "DataPanelMediator";	
		// list des dataset utilisés	
 		public var arrFilters:ArrayCollection=new ArrayCollection;
 		
		public function DataPanelMediator(viewComponent:DataPanel)
		{
			super(NAME, viewComponent);
		}    
		
		override public function onRegister():void
		{
			super.onRegister();
		
			datapanel.addEventListener(DataPanel.GET_DATA_CLICK,getDataClickHandler);
		}
		
		//REACTIONS
		
		//FUNCTIONS
		private function getDataClickHandler(event:Event):void
		{
			sendNotification(NotificationConstants.SELECT_STATIONS_NOTIFICATION)
		}

		
        protected function get datapanel():DataPanel
        {
            return viewComponent as DataPanel;
        }
		

		
	}
}