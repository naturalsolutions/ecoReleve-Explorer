package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.StationEnhanceProxy;
	import com.ecoReleve.view.mycomponents.Display.table.DisplayTable;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	import spark.components.gridClasses.GridColumn;

	public class DisplayTableMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "DataStationsListMediator";		
		private var _dataProxy:StationEnhanceProxy
 					
 		//constructeur
        public function DisplayTableMediator(viewComponent:DisplayTable)
        {
            super(NAME, viewComponent);                                 		            	            
        }
        
		override public function onRegister():void
		{
			super.onRegister();
			
			//remplit la liste avec le tableau de StationVO contenu dans la notification           		             
			_dataProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy
			
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATIONS_ADDED_NOTIFICATION,
					NotificationConstants.COLUMN_VISIBILITY_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{	
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:  
					 dataStationsList.stations=_dataProxy.stations as ArrayCollection;
					 dataStationsList.myCol=_dataProxy.fieldList as ArrayCollection;
					 break;
				case NotificationConstants.COLUMN_VISIBILITY_NOTIFICATION:  
					var colName:String=note.getType();
					var visible:Boolean=note.getBody() as Boolean;
					
					var i:int;
					for (i=0;i<dataStationsList.my.columns.length;i++){
						var col:GridColumn=dataStationsList.my.columns.getItemAt(i) as GridColumn
						if (col.dataField==colName){
							col.visible=visible
						}
						
					}
					break;
			}
		} 	
        
        protected function get dataStationsList():DisplayTable
        {
            return viewComponent as DisplayTable;
        }
    }
}