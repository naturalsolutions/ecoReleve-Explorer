package org.ns.OdataImportModule.interceptors
{
	import mx.collections.ArrayCollection;
	
	import org.ns.OdataImportModule.controller.NotificationConstants;
	import org.ns.OdataImportModule.model.proxy.ConnectorProxy;
	import org.ns.OdataImportModule.model.proxy.RemoteStationProxy;
	import org.ns.OdataImportModule.model.proxy.StationProxy;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.utils.StationVOCast;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.AbstractInterceptor;
	
	public class StationsSelectedInterceptor extends AbstractInterceptor
	{
		override public function intercept():void 
		{
			var pxyRemoteStation:RemoteStationProxy=retrieveProxy(RemoteStationProxy.NAME) as RemoteStationProxy;
			var pxyStation:StationProxy=retrieveProxy(StationProxy.NAME) as StationProxy;
			var pxyConnector:ConnectorProxy=retrieveProxy(ConnectorProxy.NAME) as ConnectorProxy;
			var connector:RemoteConnectorVO=pxyConnector.getConnector;
			
			//parse notification
			var param:Array=notification.getBody() as Array
			var data:Object=param[0] as Object
			var url:String=param[1] as String
			var authentification:String=param[2] as String
			var skip:Number=Number(param[3])
			var top:Number=Number(param[4])
			var nbTotal:Number=Number(param[5])

			
			var results:XML;
			var i:XML;
						
			//create datasource name
			var strDatasourceName:String
			if (connector.rd_authRequired==true){
				strDatasourceName=connector.rd_name + "(" + connector.rd_login+ ")"
			} else {
				strDatasourceName=connector.rd_name
			}
			
			results=new XML(data);	
			for each (i in results.children())
			{
				var q:QName=i.name()	
				if (q.localName=='entry'){
					pxyStation.addItem(StationVOCast.fromODataXML(i,strDatasourceName))
				}
			}
			
			if (skip<nbTotal){
				//load next page
				skip=skip+top
				pxyRemoteStation.GetStation(url,authentification,top,skip)
				
				//notify progress
				this.proceed();	
			}else{
				//notify shell with stations
				routeNotification("stationsImported",pxyStation.stations, "stations", "*")
				
				//notify module of the end of import
				sendNotification(NotificationConstants.IMPORT_FINISHED_NOTIFICATION);
				
			}
			
			
		}
	}
}