package org.ns.OdataImportModule.interceptors
{
	import org.ns.OdataImportModule.model.proxy.ConnectorProxy;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.AbstractInterceptor;
	
	public class StationsCountedInterceptor extends AbstractInterceptor
	{
		override public function intercept():void 
		{
			var pxyConnector:ConnectorProxy=retrieveProxy(ConnectorProxy.NAME) as ConnectorProxy;
			var connector:RemoteConnectorVO=pxyConnector.getConnector;
			
			var data:Object=notification.getBody() as Object
			var nbResult:Number;
			
			nbResult=Number(data)
			
			//change notification body with nb of returned data
			notification.setBody(nbResult)
			
			//continue the notification
			proceed()
		}
	}
}