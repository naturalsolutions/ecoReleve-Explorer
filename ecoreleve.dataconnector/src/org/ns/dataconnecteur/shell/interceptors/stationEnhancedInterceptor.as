package org.ns.dataconnecteur.shell.interceptors
{
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.LocalConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.ModuleProxy;
	import org.ns.dataconnecteur.shell.model.proxy.QueryProxy;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteDatasourceProxy;
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.AbstractInterceptor;
	
	public class stationEnhancedInterceptor extends AbstractInterceptor
	{
		override public function intercept():void 
		{
			Alert.yesLabel = "Ok";
			Alert.show("station(s) enhanced", "", Alert.OK, null, closeListener);
		}
		
		private function closeListener(event:CloseEvent):void 
		{
			proceed();
		}
	}
}