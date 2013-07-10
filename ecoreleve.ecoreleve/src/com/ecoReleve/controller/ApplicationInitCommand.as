package com.ecoReleve.controller
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.ApplicationMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;


    public class ApplicationInitCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
		{
			//register command
			registerCommand(REMOVE_STATION_LAYER_NOTIFICATION,RemoveStationLayerCommand);
			
			//NEW COMMAND FOR SQLITE IMPROVEMENT
			registerCommand(NotificationConstants.SELECT_STATIONS_NOTIFICATION, GetStationsCommand);
			
			//LUNCH COMMAND
			registerCommand(STARTUP_NOTIFICATION, startupCommand);
			registerCommand(LOAD_PROXIES_NOTIFICATION, LoadProxiesCommand);
			registerCommand(ConfigProxy.SUCCESS,LoadConfigSuccessCommand);
			registerCommand(ConfigProxy.FAILURE,LoadConfigFailedCommand);
			
			
			//register interceptors

			
			//register proxy

		}		
    }
}