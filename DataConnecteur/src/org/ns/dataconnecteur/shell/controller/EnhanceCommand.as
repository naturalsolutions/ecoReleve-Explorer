package org.ns.dataconnecteur.shell.controller
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.EnhanceProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class EnhanceCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			var pxyEnhance:EnhanceProxy=retrieveProxy(EnhanceProxy.NAME) as EnhanceProxy;
			
			//enhance data with arraycollection in notifictaion
			pxyEnhance.enhanceData(pxyDatabase.getSqlConnexion,note.getBody() as ArrayCollection);
			
		}
    }

}