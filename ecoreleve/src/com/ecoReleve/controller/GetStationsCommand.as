package com.ecoReleve.controller
{
	import com.ecoReleve.model.DataProxy;
	import com.ecoReleve.model.DatabaseProxy;
	import com.ecoReleve.model.SelectionProxy;
	import com.ecoReleve.model.StationEnhanceProxy;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class GetStationsCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			
			var pxyStationEnhance:StationEnhanceProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy;
			
			if (note.getBody()!=null){
				var where:String=note.getBody() as String
				pxyStationEnhance.selectStations(pxyDatabase.getSqlConnexion,where);
			}else{
				pxyStationEnhance.selectStations(pxyDatabase.getSqlConnexion)
			}	
			//reset selection
			var pxySelection:SelectionProxy;
			pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
			pxySelection.removeAll();
		}
    }

}