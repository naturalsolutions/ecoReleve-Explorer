package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.events.LayerOpacityEvent;
	import com.ecoReleve.view.manager.PopManager;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.LayerManager.LayerManager;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import mx.events.DragEvent;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.layer.Layer;

	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class LayerManagerMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "LayerManagerMediator";	
		private var map:Map;
		// Array wich contains all baseLayer
		private var _baselayArray:Array = new Array();
			
		// Array wich contains all overlayer
		private var _overlayArray:Array = new Array();
			
		public function LayerManagerMediator(viewComponent:LayerManager)
		{
			super(NAME, viewComponent);		    	
		} 		
		
		override public function onRegister():void
		{
			super.onRegister();
		
			layermanager.addEventListener(LayerManager.CANCEL, onCancel);
			layermanager.addEventListener(LayerManager.CHANGE_LAYER_ORDER,onChangeLayerOrder);
			layermanager.addEventListener("deleteButtonClicked",onDeleteLayer);
			layermanager.addEventListener("OpacityButtonClicked",onOpacityChange);
			
			//création de la liste de layer (sauf baselayers)
			this.createOverLayerList();
		
		}
		
		/** Create overlay list
		 * 
		 **/
		private function createOverLayerList():void 
		{
			var mapMediator:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
			map=mapMediator.myMap
			
			map.addEventListener(LayerEvent.LAYER_CHANGED,this.refresh);
			map.addEventListener(LayerEvent.LAYER_REMOVED,this.refresh);
			
		    for(var i:int=0;i<this.map.layers.length;i++)
		    {
		      var layer:Layer = this.map.layers[i] as Layer;
			  if(layer.isBaseLayer == true){
		      	_baselayArray.push(layer);
		      } else {
		        _overlayArray.push(layer);
		      }
		    }

		    layermanager.baselayArray=_baselayArray;
		    layermanager.overlayArray = _overlayArray.reverse();
		}

		/** Refresh the LayerSwitcher when a layer is add, delete or update
		 * 
		 * @param event Layer event
		 */
		 private function refresh(event:LayerEvent):void {		
		 	//Test the triggered event		 	
			if(event.type == "openscales.removelayer"){		
		      	_overlayArray.splice(_overlayArray.indexOf(event.layer),1);
		      	layermanager.overlayList.invalidateList();
			}
			
		  	if(event.type == LayerEvent.LAYER_CHANGED){
		  		_overlayArray = null;
		  		_overlayArray = new Array();
		  		for(var i:int=0;i<this.map.layers.length;i++){
		      		var layer:Layer = this.map.layers[i] as Layer;
		      	//	if(layer.isBaseLayer == false){
		        //		_overlayArray.push(layer);
		      	//	}
		    	}
		    	layermanager.overlayArray = _overlayArray.reverse();
		  	}
		}
		
		/** Evenement Cancel: quitte le popup
		 * 
		 **/
		private function onCancel(event:Event):void 
		{
			var facade:FabricationFacade=this.facade as FabricationFacade
			PopManager.closePopUpWindow(facade,layermanager,LayerManagerMediator.NAME)
		}
		
		
		/** Delete Layer
		 * 
		 **/
		private function onDeleteLayer(event:LayerEvent):void 
		{
			map.removeLayer(event.layer);
			sendNotification(NotificationConstants.LAYER_REMOVED_NOTIFICATION,event.layer,"removed")
		}
		
		
		private function onChangeLayerOrder(event:DragEvent):void
		{
			var i:uint=_baselayArray.length + _overlayArray.length - 1;
			for each(var lay:Layer in layermanager.overlayArray){
				lay.zindex=i;
				i--;
			}
		}
		
		
		
		/** ScrollUp
		 * 
		 **/
		private function onScrollUpLayer(event:LayerEvent):void 
		{
			if(event.layer.zindex+1 <= _baselayArray.length + _overlayArray.length -1){
				event.layer.zindex=event.layer.zindex+1
				map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_CHANGED,event.layer));
			}
		}
		
		
		/** Scroll Down
		 * 
		 **/
		private function onScrollDownLayer(event:LayerEvent):void 
		{
			if(event.layer.zindex-1 >= _baselayArray.length - 1){
				event.layer.zindex=event.layer.zindex-1
				map.dispatchEvent(new LayerEvent(LayerEvent.LAYER_CHANGED,event.layer));
			}
		}
		
		private function onOpacityChange(event:LayerOpacityEvent):void
		{
			if (event.data.name=="Stations"){    //layer station
				sendNotification(NotificationConstants.STATION_OPACITY_CHANGED_NOTIFICATION,event.opacity/100,"opacity")
			} else {							// other
				event.data.alpha=event.opacity/100
			}
		}
		
        protected function get layermanager():LayerManager
        {
            return viewComponent as LayerManager;
        }
		

		
	}
}