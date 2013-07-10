package com.ecoReleve.controller
{
	import flash.filesystem.File;
	
	import com.ecoReleve.model.DatabaseProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class SQLiteInitCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			//INIT SQLITE
			//open sqlite from applicationStorageDirectory==> user name/Application Data/applicationID.publisherID/Local Store/	

			var strPath=File.applicationStorageDirectory.nativePath.replace('Explorer','DataConnector')
			var dir:File=new File(strPath)
			var sqlFile:File = dir.resolvePath("NSDB_rw.sqlite");
			
			if (sqlFile.exists){
				var proxyDB:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy
				proxyDB.init(sqlFile)
			}	else {
				//erreur de connexion à la db
			}
			
		}
    }

}