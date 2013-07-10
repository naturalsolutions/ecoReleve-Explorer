package org.ns.dataconnecteur.shell.controller
{
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class SelectAttributeCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			var pxyStation:StationProxy=retrieveProxy(StationProxy.NAME) as StationProxy;
			
			var type:String=note.getType() as String
			var attribute:String=note.getBody() as String
			
			pxyStation.selectDistinctValue(attribute,pxyDatabase.getSqlConnexion);
			
		}
    }

}