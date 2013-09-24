package com.ecoReleve.interceptors
{
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	
	import com.ecoReleve.model.DatabaseProxy;
	import com.ecoReleve.model.proxy.QueryProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.AbstractInterceptor;
	
	public class initActionsInterceptor extends AbstractInterceptor
	{
		override public function intercept():void 
		{
			trace("intercept initactions")
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			var pxyQuery:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy;
			
			//get all queries
			pxyQuery.selectQueries(pxyDatabase.getSqlConnexion);		
			
			this.proceed();
	
		}
	}
}