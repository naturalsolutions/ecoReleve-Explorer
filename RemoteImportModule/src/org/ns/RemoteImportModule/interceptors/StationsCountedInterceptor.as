package org.ns.RemoteImportModule.interceptors
{
	import org.ns.RemoteImportModule.model.proxy.ConnectorProxy;
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
			var results:XML
			
			if (connector.rd_format=="nsml"){
				//results=new XML(data);
				//nbResult=Number(results.header.summary.attribute("totalMatched"));
				results=new XML(data);
				nbResult=Number(results);				
				trace("result: "+results);
			}else if (connector.rd_format=="sparql"){
				//nettoyage du xml ==> erreur de convertion xml
				// on ne garde que la balise results
				var settingsStart:String = "<results";
				var settingsEnd:String = "</results>";
				var settingsDirty:String = String(data);
				
				var settingsClean:String = 
					settingsDirty.substring(
						settingsDirty.indexOf(settingsStart)
						,(settingsDirty.lastIndexOf(settingsEnd)+settingsEnd.length)
					);
				
				results=new XML(settingsClean);
				
				nbResult=Number(results.result.binding.literal.text());
			}else if (connector.rd_format=="ns"){
				results=new XML(data);
				nbResult=Number(results);
				
				trace("result: "+results);
			}
			//change notification body with nb of returned data
			notification.setBody(nbResult)
			
			//continue the notification
			proceed()
		}
	}
}