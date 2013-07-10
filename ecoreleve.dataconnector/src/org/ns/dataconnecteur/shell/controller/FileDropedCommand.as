package org.ns.dataconnecteur.shell.controller
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.LocalConnectorVO;
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.LocalConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class FileDropedCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			var pxyConnector:LocalConnectorProxy=retrieveProxy(LocalConnectorProxy.NAME) as LocalConnectorProxy
			
			//get connector by module name
			var connector:LocalConnectorVO=pxyConnector.getConnectorByExtension(String(note.getType()));
			
			sendNotification(NotificationConstants.LOAD_MODULE_NOTIFICATION,[connector,note.getBody() as File])
			
		}
    }

}