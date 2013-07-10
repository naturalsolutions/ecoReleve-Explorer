package org.ns.dataconnecteur.shell.controller
{
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class SqliteCompactCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         			
			//Compact database
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			pxyDatabase.compact();	
		}
    }

}