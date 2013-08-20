package org.ns.XmlImportModule.controller
{
	import flash.filesystem.File;
	
	import org.ns.XmlImportModule.controller.NotificationConstants;
	import org.ns.XmlImportModule.model.proxy.FileXMLProxy;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.LocalConnectorVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class InitModuleCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			//do init
			trace("init module")
			
			var arr:Array=note.getBody() as Array
			var container:Object=arr[0]	
			var params:Object=arr[1]
				
			//get extension and set in fileXmlProxy
			var connector:LocalConnectorVO=params[0] as LocalConnectorVO
			var fileXmlProxy:FileXMLProxy = facade.retrieveProxy( FileXMLProxy.NAME ) as FileXMLProxy;
			
			fileXmlProxy.extension=connector.ld_extension
				
			//if shell send file ==> notify module to use this file
			if (params!=null){
				sendNotification( NotificationConstants.FILE_SELECTED_NOTIFICATION, params[1] as File);
			}
			
			//notify shell to show module
			routeNotification(CommonNotificationConstants.SHOW_MODULE_NOTIFICATION, container,"module container", "*")
		}
		
	}
}