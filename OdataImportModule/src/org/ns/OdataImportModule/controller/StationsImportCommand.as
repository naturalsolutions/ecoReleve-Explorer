package org.ns.OdataImportModule.controller
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.ns.OdataImportModule.controller.NotificationConstants;
	import org.ns.OdataImportModule.model.proxy.RemoteStationProxy;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.QueryVO;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class StationsImportCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var stations:ArrayCollection=note.getBody() as ArrayCollection	
			
			if (stations.length!=0){
				//notify shell with stations
				routeNotification(CommonNotificationConstants.STATIONS_IMPORTED,stations, "stations", "*")
			}else{
				//notify everybody that no stations will be loaded
				routeNotification(CommonNotificationConstants.STATIONS_IMPORTED_FAILED,"0 stations imported because of unknown error(s)","odata import failed", "*")
			}
			
			//notify module of the end of import
			sendNotification(NotificationConstants.IMPORT_FINISHED_NOTIFICATION);
		}
		
	}
}