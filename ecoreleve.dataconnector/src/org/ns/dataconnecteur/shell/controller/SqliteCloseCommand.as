package org.ns.dataconnecteur.shell.controller
{
	import flash.filesystem.File;
	
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.QueryProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class SqliteCloseCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			
			//delete all no persistent query
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			var pxyQuery:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy
			
			pxyQuery.deleteUnpersistentQuery(pxyDatabase.getSqlConnexion);			
		}
    }

}