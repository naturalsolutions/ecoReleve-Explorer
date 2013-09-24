package com.ecoReleve.interceptors
{
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.LocalConnectorVO;
	import org.ns.common.model.VO.ModuleVO;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.VO.RemoteDatasourceVO;
	import com.ecoReleve.controller.NotificationConstants;
	import com.ecoReleve.model.DatabaseProxy;
	import com.ecoReleve.model.proxy.ModuleProxy;
	import com.ecoReleve.model.proxy.QueryProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.AbstractInterceptor;
	
	public class loadModuleInterceptor extends AbstractInterceptor
	{
		override public function intercept():void 
		{
			//if module is local then continue
			// if module is remote then get queries collection from proxy 
			// and give it in params of load module command
			
			var params:Array=notification.getBody() as Array
			
			var connector:Object=params[0] as Object;
				
			switch (connector.mod_type)
			{
				case "local":
					if (params.length>1){
						notification.setBody([connector,params[1]])
					}else{
						notification.setBody([connector,null])
					}
					proceed();        
					break;
				case "remote":
					
					//get collection of queries
					var pxyQuery:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy;
					
					notification.setBody([connector,pxyQuery.getQueryCollection])
					//continue
					proceed();
					
					break;
			}
		}
	}
}