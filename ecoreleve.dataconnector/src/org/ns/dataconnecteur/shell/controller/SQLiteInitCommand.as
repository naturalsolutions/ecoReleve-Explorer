package org.ns.dataconnecteur.shell.controller
{
	import flash.filesystem.File;
	
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class SQLiteInitCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy
			
			//INIT SQLITE
			//path to sb model
			
			//init sqlite in database proxy
			pxyDatabase.init();	
			
		}
    }

}