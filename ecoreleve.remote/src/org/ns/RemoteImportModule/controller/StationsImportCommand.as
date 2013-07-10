package org.ns.RemoteImportModule.controller
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.ns.RemoteImportModule.controller.NotificationConstants;
	import org.ns.RemoteImportModule.model.proxy.RemoteStationProxy;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.QueryVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class StationsImportCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var stations:ArrayCollection=note.getBody() as ArrayCollection	
			
			//notify shell with stations
			routeNotification("stationsImported",stations, "stations", "*")
			//notify module of the end of import
			sendNotification(NotificationConstants.IMPORT_FINISHED_NOTIFICATION);
		}
		
	}
}