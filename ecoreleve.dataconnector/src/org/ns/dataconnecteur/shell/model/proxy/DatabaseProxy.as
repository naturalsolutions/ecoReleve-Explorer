package org.ns.dataconnecteur.shell.model.proxy
{
	import flash.data.SQLConnection;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class DatabaseProxy extends FabricationProxy
	{
		public static const NAME:String = "DatabaseProxy";
		public static const DB_RELEASE:String="0.1.04";
		
		private static var dbFilePath:String='org/ns/dataconnecteur/db_model/NSDB.sqlite';
		private static var dbRWFile:String='NSDB_rw.sqlite'
			
		private  var sqlConnexion:SQLConnection;
		private  var sqlFile:File;
		private  var dbFile:File;
		private  var countInit:int=0;
		
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
			return 	dbFile
		}
		
		public function init():void
		{
			var dbModel:File=File.applicationDirectory.resolvePath(dbFilePath);
			// applicationStorageDirectory==> user name/Application Data/applicationID.publisherID/Local Store/
			dbFile = File.applicationStorageDirectory.resolvePath(dbRWFile);
			
			if (!dbFile.exists){
				dbModel.copyTo(dbFile,true);
			}
			
			sqlConnexion=new SQLConnection();
			
			sqlConnexion.addEventListener(SQLEvent.OPEN,openSuccess)
			sqlConnexion.addEventListener(SQLErrorEvent.ERROR,openFailure)

			if (countInit<2){
				sqlConnexion.openAsync(dbFile,'create',null,true)	
			} else {
				sendNotification(NotificationConstants.LOG_NOTIFICATION,'ERROR RELEASE DB')
			}
		}
		
		public function backup():void
		{
			var dbModel:File=File.applicationDirectory.resolvePath(dbFilePath);
			var dbBkpFile:File = File.desktopDirectory.resolvePath('NSDB_backup.sqlite');
			dbModel.copyTo(dbBkpFile,true);
		}
		
		public function recreate():void
		{
			sqlConnexion.addEventListener(SQLEvent.CLOSE,recreateHandler);
			sqlConnexion.close();			
		}
		
		public function close():void
		{
			sqlConnexion.addEventListener(SQLEvent.CLOSE,closeHandler);
			sqlConnexion.close();
		}
		
		public function compact():void
		{
			sqlConnexion.addEventListener(SQLEvent.COMPACT,onCompactHandler);
			sqlConnexion.compact();
		}
		
		private function onCompactHandler(event:SQLEvent):void			
		{
			trace('COMPACT FINISH ==> ' + dbFile.size)
			sendNotification(NotificationConstants.SQLITE_COMPACTED_NOTIFICATION);
		}
		
		private function openSuccess(event:SQLEvent):void			
		{
			countInit+=1;
			
			sqlConnexion.removeEventListener(SQLEvent.OPEN, openSuccess);
			sqlConnexion.removeEventListener(SQLErrorEvent.ERROR, openFailure);
			//notify the app that sqlite is initialized
			sendNotification(NotificationConstants.SQLITE_INITIALIZED_NOTIFICATION);
			sendNotification(NotificationConstants.LOG_NOTIFICATION,'INIT:DB INITIALIZED')
		}
		
		private function recreateHandler(event:SQLEvent):void			
		{
			sqlConnexion.removeEventListener(SQLEvent.CLOSE,closeHandler);
			var dbFolder:File = File.applicationStorageDirectory.resolvePath(dbRWFile);	
			
			sendNotification(NotificationConstants.LOG_NOTIFICATION,'INIT:DB RECREATED')
			
			dbFile.addEventListener(Event.COMPLETE, fileDeleteHandler);
			dbFile.deleteFileAsync()	
		}
		
		private function fileDeleteHandler(event:Event):void 
		{
			sqlConnexion=null;
			//recreate dbfile	
			this.init()
		}
		
		private function closeHandler(event:SQLEvent):void			
		{
			sqlConnexion.removeEventListener(SQLEvent.CLOSE,closeHandler);
			dbFile.deleteFile();
			sqlConnexion=null;
			sendNotification(NotificationConstants.SQLITE_CLOSED_NOTIFICATION);
		}
		
		private function openFailure(event:SQLErrorEvent):void
		{
			sqlConnexion.removeEventListener(SQLEvent.OPEN, openSuccess);
			sqlConnexion.removeEventListener(SQLErrorEvent.ERROR, openFailure);
			trace('DB ERROR')
			//notify the app that sqlite is not initialized
			sendNotification(NotificationConstants.SQLITE_ERROR_NOTIFICATION);
		} 
		
	}
}

