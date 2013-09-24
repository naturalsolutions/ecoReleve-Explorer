package com.ecoReleve.controller
{
	import com.ecoReleve.model.DatabaseProxy;
	import com.ecoReleve.view.DataPanelMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class InitModuleCommand extends SimpleFabricationCommand
	{
		override public function execute(note:INotification):void 
		{
			var dtm:DataPanelMediator = retrieveMediator(DataPanelMediator.NAME) as DataPanelMediator;
			if(note.getBody()==null){
				trace("Initmodule");
				var proxyDB:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
				
				dtm.list(proxyDB);			
			}
			else {
				trace("InitModule notebody : "+note.getBody()+" typebody : "+typeof(note.getBody()));	
				dtm.respondToConnectorsRemoteSelected(note as Notification);
			}
		}
		
	}
}