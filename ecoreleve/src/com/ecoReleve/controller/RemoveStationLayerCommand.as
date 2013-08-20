package com.ecoReleve.controller
{
	import com.ecoReleve.model.DataProxy;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;

	public class RemoveStationLayerCommand extends SimpleFabricationCommand
	{
		override public function execute(notification:INotification):void
		{						
			//Supprime toutes les stations
			var pxyData:DataProxy=retrieveProxy(DataProxy.NAME) as DataProxy
			pxyData.stations.removeAll();
		}		
	}
}