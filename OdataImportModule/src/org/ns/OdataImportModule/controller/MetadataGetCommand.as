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
	
	public class MetadataGetCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			//GET CONNECTOR
			var pxyConnector:ConnectorProxy=retrieveProxy(ConnectorProxy.NAME) as ConnectorProxy;
			var connector:RemoteConnectorVO=pxyConnector.getConnector
				
			//GET METADATA	
			var pxyMetadata:MetadataProxy=retrieveProxy(MetadataProxy.NAME) as MetadataProxy;

			// create login:password string if it is required
			var strAuthentification:String
			if (connector.rd_authRequired==true){
				strAuthentification=connector.rd_login + ":" + connector.rd_password
			}else{
				strAuthentification=null
			}
			
			//Construit l'url avec la requête	
			var url:String=connector.rd_url + '/$metadata';
			
			pxyMetadata.GetMetadata(url,strAuthentification)
			
		}
		
	}
}