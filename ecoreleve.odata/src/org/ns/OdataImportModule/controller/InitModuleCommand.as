package org.ns.OdataImportModule.controller
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.OdataImportModule.controller.NotificationConstants;
	import org.ns.OdataImportModule.model.proxy.ConnectorProxy;
	import org.ns.OdataImportModule.model.proxy.MetadataProxy;
	import org.ns.OdataImportModule.model.proxy.ModuleProxy;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class InitModuleCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			//do init
			trace("init module")
			
			var arr:Array=note.getBody() as Array
			
			//set module container in proxy module
			var container:Object=arr[0]					
			var pxyModule:ModuleProxy=retrieveProxy(ModuleProxy.NAME) as ModuleProxy;	
			pxyModule.container=container;
					
			var params:Array=arr[1] as Array
			
			//get queries from params
			var connector:RemoteConnectorVO=params[0]
			var queries:ArrayCollection=params[1]
				
			//params contains:
			// connectorVO
			// queries collection
			if (params!=null){
				//set connecto proxy
				var pxyConnector:ConnectorProxy=retrieveProxy(ConnectorProxy.NAME) as ConnectorProxy;
				pxyConnector.setConnector(connector);
				
				//send queries collection to the module
				sendNotification(NotificationConstants.QUERIES_LOADED_NOTIFICATION,queries,"queries")
			}
			
			//notify shell to show module
			routeNotification(CommonNotificationConstants.SHOW_MODULE_NOTIFICATION, container,"module container", "*")
			
		}
		
	}
}