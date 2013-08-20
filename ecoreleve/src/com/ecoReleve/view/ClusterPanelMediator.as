package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.ClusterPanel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class ClusterPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "ClusterPanelMediator";	
 		
		public function ClusterPanelMediator(viewComponent:ClusterPanel)
		{
			super(NAME, viewComponent);
		}    
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//REACTIONS
		public function reactToStationMode$Click(event:MouseEvent):void
		{
			if (clusterpanel.stationMode.selected==true){
				sendNotification(NotificationConstants.STATION_LAYER_MODE_NOTIFICATION,DisplayMapMediator.MODE_CLUSTER,'change mode')
			}else{
				sendNotification(NotificationConstants.STATION_LAYER_MODE_NOTIFICATION,DisplayMapMediator.MODE_RAW,'change mode')
			}
		}

		
        protected function get clusterpanel():ClusterPanel
        {
            return viewComponent as ClusterPanel;
        }
		

		
	}
}