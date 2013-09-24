package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.DataProxy;
	import com.ecoReleve.model.SelectionProxy;
	import com.ecoReleve.utils.ConvexHull;
	import com.ecoReleve.view.mycomponents.Filters.FilterSpecies;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	import spark.components.List;
	import spark.events.IndexChangeEvent;
	
	public class FilterPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "FilterPanelMediator";	
		private var _dataProxy:DataProxy;
		private var boAmIAsk:Boolean=false;
		private var AllSpeciesSelected:Boolean=true;
		private var onlyOneSelected:Boolean=true;
		
		public function FilterPanelMediator(viewComponent:FilterSpecies)
		{
			super(NAME, viewComponent);
		} 
		
		override public function onRegister():void
		{
			super.onRegister();	
			
			//récupération du proxy
			_dataProxy=retrieveProxy(DataProxy.NAME) as DataProxy;
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION,
					NotificationConstants.ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION,
					NotificationConstants.STATIONS_ADDED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION:
					filter.boEnabled=true;
					break;
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:	
					if ((note.getBody() as ArrayCollection)!=null){
						if ((note.getBody() as ArrayCollection).length==0){
							filter.boEnabled=false;
						}else{
							if (boAmIAsk==false){
								sendNotification(NotificationConstants.SELECT_ATTRIBUTE_NOTIFICATION,'sta_speciesName','uniqueValue')
								filter.boEnabled=true;
							}
						}
					}
					break;
				case NotificationConstants.ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION:	
					if (boAmIAsk==false){
						createSpeciesList(note.getBody() as ArrayCollection)
					}
					break;

			}
		}	
		
		//REACTIONS
		public function reactToLstSpecies$Change(event:IndexChangeEvent):void
		{
			boAmIAsk=true;
			AllSpeciesSelected=false;
			onlyOneSelected=false;
			
			var selection:Vector.<Object>=event.currentTarget.selectedItems
			
			if (selection.length==1){
				onlyOneSelected=true;
			}
				
			var where:String=' '
			var o:Object;
			for each(o in selection){
				var sp:String=o.toString()
				sp=sp.slice(0,sp.lastIndexOf('(') - 1)
				if (sp!='all species'){	
					where=where + 'OR sta_speciesName=\''+ sp +'\''
				}else{
					AllSpeciesSelected=true;
				}
			}
			
			if (AllSpeciesSelected==true){			
				sendNotification(NotificationConstants.SELECT_STATIONS_NOTIFICATION)
			}else{			
				where=where.replace('OR ','');				
				sendNotification(NotificationConstants.SELECT_STATIONS_NOTIFICATION,where)
			}
			
			var pxySelection:SelectionProxy;
			pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
			pxySelection.removeAll();
			
			//TODO
			if(AllSpeciesSelected==false && onlyOneSelected==true){

			}
			
		}
		
		//PRIVATE FUNCTIONS
		private function createSpeciesList(data:ArrayCollection):void
		{ 
			boAmIAsk=false;
			filter.species.removeAll();
			var obj:Object
			var count:Number=0;
			for each (obj in data){
				filter.species.addItem(obj.sta_speciesName + ' (' + obj.count + ')')
				count=count + Number(obj.count)
			}
			filter.species.addItemAt('all species (' + String(count) + ')',0)
		}
  
		
		
        protected function get filter():FilterSpecies
        {
            return viewComponent as FilterSpecies;
        }
		

		
	}
}