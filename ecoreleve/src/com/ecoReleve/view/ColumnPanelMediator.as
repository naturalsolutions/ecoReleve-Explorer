package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.StationEnhanceProxy;
	import com.ecoReleve.view.mycomponents.Display.table.DisplayTable;
	import com.ecoReleve.view.mycomponents.ribbon.TablePanel.ColumnPanel;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.ns.common.model.utils.StationVOCast;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	import spark.components.gridClasses.GridColumn;
	
	public class ColumnPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "ColumnPanelMediator";	
		private var _dataProxy:StationEnhanceProxy;
		private var boOnlyOnce:Boolean=true;
		
		public function ColumnPanelMediator(viewComponent:ColumnPanel)
		{
			super(NAME, viewComponent);
		} 
		 
		override public function onRegister():void
		{
			super.onRegister();
			
			//récupération du proxy
			_dataProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy;		
			
			//Handlers
			columnpanel.addEventListener(ColumnPanel.SELECT_VISIBLE_COLUMN,onVisibleHandler)
			columnpanel.addEventListener(ColumnPanel.SELECT_HIDED_COLUMN,onHidedHandler)
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION,
					NotificationConstants.STATIONS_ADDED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION:	
					columnpanel.boEnabled=true;
					break;
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:	
					if ((note.getBody() as ArrayCollection)!=null){
						if ((note.getBody() as ArrayCollection).length==0){
							columnpanel.boEnabled=false;
						}else{
							if (boOnlyOnce==true){
								populateAttributeList()
							}
							columnpanel.boEnabled=true;
							
						}
					}
					break;
			}
		}	
		
		//REACTIONS
		
		
		//PRIVATE FUNCTIONS
		private function populateAttributeList():void
		{ 
			var arr:Array=_dataProxy.getListField()
			
			columnpanel.VisibleColumns.removeAll();
			columnpanel.VisibleColumns.addAll(new ArrayCollection(arr));
				
			columnpanel.HidedColumns=new ArrayCollection();
			
			boOnlyOnce=false
		}

		
		private function onVisibleHandler(event:Event):void
		{
			var colName:String=columnpanel.lstVisibleColumn.selectedItem as String
			columnpanel.VisibleColumns.removeItemAt(columnpanel.lstVisibleColumn.selectedIndex)	
			columnpanel.HidedColumns.addItem(colName)
			sendNotification(NotificationConstants.COLUMN_VISIBILITY_NOTIFICATION,false,colName)
		}
		
		private function onHidedHandler(event:Event):void
		{
			var colName:String=columnpanel.lstHideColumn.selectedItem as String
			columnpanel.HidedColumns.removeItemAt(columnpanel.lstHideColumn.selectedIndex)	
			columnpanel.VisibleColumns.addItem(colName)	
			sendNotification(NotificationConstants.COLUMN_VISIBILITY_NOTIFICATION,true,colName)
		}
		
        protected function get columnpanel():ColumnPanel
        {
            return viewComponent as ColumnPanel;
        }
		

		
	}
}