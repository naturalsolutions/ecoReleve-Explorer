package com.ecoReleve.controller
{
	import com.ecoReleve.model.StationEnhanceProxy;
	import com.ecoReleve.model.DatabaseProxy;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class SelectAttributeCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			/*var pxyData:DataProxy=retrieveProxy(DataProxy.NAME) as DataProxy;
			
			var type:String=note.getType() as String
			var attribute:String=note.getBody() as String
			
			switch (type)
			{
				case 'uniqueValue':
					if (attribute!=null){
						pxyData.selectDistinctValue(attribute,pxyDatabase.getSqlConnexion);
					}
					break;
				case 'minMax':
					if (attribute!=null){
						pxyData.selectMinMax(attribute,pxyDatabase.getSqlConnexion);
					}
					break;
			}*/
			
			var pxyStationEnhance:StationEnhanceProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy;
			var type:String=note.getType() as String
			var attribute:String=note.getBody() as String
			
			switch (type)
			{
				case 'uniqueValue':
					if (attribute!=null){
						pxyStationEnhance.selectDistinctValue(attribute,pxyDatabase.getSqlConnexion);
					}
					break;
				case 'minMax':
					if (attribute!=null){
						pxyStationEnhance.selectMinMax(attribute,pxyDatabase.getSqlConnexion);
					}
					break;
			}
		}
    }

}