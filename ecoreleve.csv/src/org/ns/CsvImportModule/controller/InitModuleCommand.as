package org.ns.CsvImportModule.controller
{
	import flash.filesystem.File;
	
	import org.ns.common.controller.CommonNotificationConstants
	import org.ns.CsvImportModule.model.proxy.FileCSVProxy;
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
				
			//if shell send file ==> notify module to use this file
			if (params!=null){
				sendNotification( NotificationConstants.FILE_SELECTED_NOTIFICATION, params[1] as File);
			}
			
			//notify shell to show module
			routeNotification(CommonNotificationConstants.SHOW_MODULE_NOTIFICATION, container,"module container", "*")
		}
		
	}
}