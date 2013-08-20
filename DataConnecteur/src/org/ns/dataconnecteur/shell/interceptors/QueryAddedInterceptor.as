package org.ns.dataconnecteur.shell.interceptors
{
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.QueryVO;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.QueryProxy;
	import org.ns.dataconnecteur.shell.model.proxy.SQLProxy;
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.AbstractInterceptor;
	
	public class QueryAddedInterceptor extends AbstractInterceptor
	{
		override public function intercept():void 
		{
			var pxyQuery:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy
			
			//notify module with added query
			routeNotification(CommonNotificationConstants.REFRESH_NOTIFICATION,pxyQuery.getQueryCollection as ArrayCollection,"query", "*")
			
			//continue the notification
			proceed()
		}
	}
}