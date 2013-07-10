package com.ecoReleve.model
{
	import com.ecoReleve.controller.*;
	
	import flash.data.SQLConnection;
	import flash.events.ProgressEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class DatabaseProxy extends FabricationProxy
	{
		public static const NAME:String = "DatabaseProxy";
		
		private  var sqlConnexion:SQLConnection;
		private var sqlFile:File;
		
		public function DatabaseProxy()
		{
			super(NAME);
		}

		public function get getSqlConnexion():SQLConnection
		{
			return 	sqlConnexion
		}
		
		public function get getSqlFile():File
		{
			return 	sqlFile
		}
		
		public function init(file:File):void
		{
			sqlConnexion=new SQLConnection();
			sqlFile=file;
			
			sqlConnexion.addEventListener(SQLEvent.OPEN,openSuccess)
			sqlConnexion.addEventListener(SQLErrorEvent.ERROR,openFailure)
			
			sqlConnexion.openAsync(sqlFile)			
		}
		
		private function openSuccess(event:SQLEvent):void
			
		{
			sqlConnexion.removeEventListener(SQLEvent.OPEN, openSuccess);
			sqlConnexion.removeEventListener(SQLErrorEvent.ERROR, openFailure);
			trace('DB OPEN')
			//notify the app that sqlite is initialized
			sendNotification(NotificationConstants.SQLITE_INITIALIZED_NOTIFICATION);
		}
		
		private function openFailure(event:SQLErrorEvent):void
		{
			sqlConnexion.removeEventListener(SQLEvent.OPEN, openSuccess);
			sqlConnexion.removeEventListener(SQLErrorEvent.ERROR, openFailure);
			trace('DB ERROR')
			//notify the app that sqlite is not initialized
			//sendNotification(NotificationConstants.SQLITE_ERROR_NOTIFICATION);
		} 
		
	}
}

