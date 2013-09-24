package org.ns.RemoteImportModule.controller
{
	import flash.filesystem.File;
	
	import org.ns.RemoteImportModule.controller.NotificationConstants;
	import org.ns.RemoteImportModule.model.proxy.ConnectorProxy;
	import org.ns.RemoteImportModule.model.proxy.RemoteStationProxy;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.QueryVO;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.VO.RemoteDatasourceVO;
	import org.ns.common.model.utils.QueryVOCast;
	import org.ns.common.model.utils.StationVOCast;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class StationsloadRemoteCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var pxyRemoteStation:RemoteStationProxy=retrieveProxy(RemoteStationProxy.NAME) as RemoteStationProxy;
			var pxyConnector:ConnectorProxy=retrieveProxy(ConnectorProxy.NAME) as ConnectorProxy;
			
			var datamodel:Object=note.getBody() as Object
			//get query from datamodel
			var query:QueryVO=datamodel.QUERY	
			
			//get connector from proxy
			var connector:RemoteConnectorVO=pxyConnector.getConnector
			
			// create login:password string if it is required
			var strAuthentification:String
			if (connector.rd_authRequired==true){
				strAuthentification=connector.rd_login + ":" + connector.rd_password
			}else{
				strAuthentification=null
			}

			//Construit l'url avec la requête	
			var url:String=connector.rd_url;
			if (connector.rd_format=='nsml'){
				url+=QueryVOCast.toNsHttpStr(query);
			}else if (connector.rd_format=='sparql'){
				//url+="?default-graph-uri=&should-sponge=&query=";
				url+="?query=";
				var sparql:String=QueryVOCast.toSparql(query,'data');
				url+=escape(sparql)
				//url+="&format=xml&debug=off&timeout=";
				url+="&output=xml&jsonp=&key=";
				//notify to log url
				routeNotification("httpRequested",sparql, "sparql request", "*")
			}						
			if (connector.rd_format=='ns'){
				query.qry_Count=false;
				url+=QueryVOCast.toNsHttpStr(query);
			}	
			//notify to log url
			routeNotification("httpRequested",url, "url request", "*")
			
			pxyRemoteStation.GetStation(query,url,strAuthentification)
		}
		
	}
}