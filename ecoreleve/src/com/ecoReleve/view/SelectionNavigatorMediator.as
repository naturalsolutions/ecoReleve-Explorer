package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.SelectionProxy;
	import com.ecoReleve.view.mycomponents.Display.map.selection.SelectionNavigator;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class SelectionNavigatorMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "SelectionNavigatorMediator";	
			
		public function SelectionNavigatorMediator(viewComponent:SelectionNavigator)
		{
			super(NAME, viewComponent);
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			selection.addEventListener(SelectionNavigator.SELECTION_ITEM_NEXT,onNextSelection)
			selection.addEventListener(SelectionNavigator.SELECTION_ITEM_PREVIOUS,onPreviousSelection)
			selection.lstSelectFeatures.addEventListener(ListEvent.ITEM_CLICK,onSelectStation)	
			selection.visible=false;
		}
		
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.SELECTION_RESET_NOTIFICATION,
				    NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION,
					NotificationConstants.SELECTION_NEW_NOTIFICATION];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch (note.getName()) 
			{
				case NotificationConstants.SELECTION_RESET_NOTIFICATION:
					selection.lstSelectFeatures.dataProvider=null
					selection.visible=false;
					break;
				case NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION:						 
					selection.lstSelectFeatures.dataProvider=null;
					selection.visible=false;
					break;
				case NotificationConstants.SELECTION_NEW_NOTIFICATION:	
					var pxySelection:SelectionProxy;
					pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
                    
					if (pxySelection.selection.length>1){
						selection.lstSelectFeatures.dataProvider=pxySelection.selection		
						selection.lstSelectFeatures.selectedIndex=0;
						enableBtn(selection.lstSelectFeatures.selectedIndex)
						selection.visible=true;
					}else{
						selection.visible=false
					}
					break;
			}
		}
		
		private function onNextSelection(event:Event):void
		{
			var pxySelection:SelectionProxy;
			pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
			pxySelection.nextItem()
			enableBtn(selection.lstSelectFeatures.selectedIndex)
		}
		
		private function onPreviousSelection(event:Event):void
		{
			var pxySelection:SelectionProxy;
			pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
			pxySelection.previousItem()
			enableBtn(selection.lstSelectFeatures.selectedIndex)
		}
		
		private function onSelectStation(event:ListEvent):void
		{
			if (selection.lstSelectFeatures.selectedItem!=null){
				var pxySelection:SelectionProxy;
				pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
				
				pxySelection.changeCurrentItem(selection.lstSelectFeatures.selectedIndex)
				enableBtn(selection.lstSelectFeatures.selectedIndex)
			}
		}
		
		private function enableBtn(index:int):void
		{
			var max:int=(selection.lstSelectFeatures.dataProvider as ArrayCollection).length -1
			if (index==0){
				selection.previous.enabled=false
			}else{
				selection.previous.enabled=true
			} 
			
			if (index==max){
				selection.next.enabled=false
			}else{
				selection.next.enabled=true
			}
		}
		
        protected function get selection():SelectionNavigator
        {
            return viewComponent as SelectionNavigator;
        }
		

		
	}
}