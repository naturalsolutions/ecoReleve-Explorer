package org.ns.dataconnecteur.shell.controller
{
	import mx.controls.Alert;
	
	import org.ns.common.controller.CommonNotificationConstants;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationModuleLoader;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;

	
    public class ShowErrorCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    
			var title:String=note.getType() as String
			var descriptif:String=note.getBody() as String

			sendNotification(NotificationConstants.LOG_NOTIFICATION,descriptif,title)
		}
		
		
    }

}