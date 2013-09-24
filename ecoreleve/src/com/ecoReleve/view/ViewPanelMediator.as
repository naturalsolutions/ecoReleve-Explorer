package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.controller.NotificationConstants;
	import com.ecoReleve.utils.Debug;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.ViewPanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.IViewCursor;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.geometry.basetypes.Bounds;
	import org.openscales.proj4as.ProjProjection;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	public class ViewPanelMediator extends FabricationMediator
	{
		//nom du médiator
		public static const NAME:String = "ViewPanelMediator";      
		private var map:Map;
		private var mapMediator:DisplayMapMediator
		private var collView:ArrayCollection;
		private var cursor:IViewCursor;
		
		public function ViewPanelMediator(viewComponent:ViewPanel)
		{
			super(NAME, viewComponent);                                    
		}              
		
		override public function onRegister():void
		{
			super.onRegister();
			
			viewpanel.addEventListener(ViewPanel.PREVIOUS_CLICK,onPreviousView)
			viewpanel.addEventListener(ViewPanel.NEXT_CLICK,onNextView)
			viewpanel.addEventListener(ViewPanel.ZOOM_CLICK,onZoom)
			
			//create a cursor on collection view
			collView=new ArrayCollection;
			cursor=collView.createCursor();
			
			mapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
			map=mapMediator.myMap
			//ajoute les listener de la carte
			map.addEventListener(MapEvent.MOVE_END,onFinishLoad)                    
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array
		{
			return [NotificationConstants.STATION_LAYER_MODE_NOTIFICATION,
				NotificationConstants.STATIONS_ADDED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{      
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:
					if ((note.getBody() as ArrayCollection)!=null){
						if ((note.getBody() as ArrayCollection).length==0){
							viewpanel.boEnabled=false;
						}else{
							viewpanel.boEnabled=true;
						}
					}
					break;
				case NotificationConstants.STATION_LAYER_MODE_NOTIFICATION:
					if (note.getBody()==DisplayMapMediator.MODE_CLUSTER){
						viewpanel.boEnabled=false;
					}else{
						viewpanel.boEnabled=true;
					}
					break;
			}
		}
		
		
		private function onZoom(evt:Event):void
		{
			mapMediator.zoomToAllStation()
		}
		
		private function onFinishLoad(evt:MapEvent):void
		{
			var b:Bounds = map.extent;
			collView.addItem({view:b});
			//go to last view
			cursor.seek(CursorBookmark.LAST);
			
			enableDisableButtons()
			
			Debug.doTrace(this,"1/"+ Math.round(map.scale).toString())
			
		}
		
		private function onPreviousView(evt:Event):void
		{
			map.removeEventListener(MapEvent.MOVE_END,onFinishLoad)
			if(!cursor.beforeFirst) {
				cursor.movePrevious();
				var b:Bounds=cursor.current.view as Bounds;
				map.zoomToExtent(b);                            
			}
			enableDisableButtons()  
			map.addEventListener(MapEvent.MOVE_END,onFinishLoad)    
		}
		
		private function onNextView(evt:Event):void
		{
			map.removeEventListener(MapEvent.MOVE_END,onFinishLoad)
			if(!cursor.afterLast) {
				cursor.moveNext();
				var b:Bounds=cursor.current.view as Bounds;
				map.zoomToExtent(b);
				evt.stopPropagation()
			}
			enableDisableButtons()
			map.addEventListener(MapEvent.MOVE_END,onFinishLoad)
		}
		
		private function enableDisableButtons():void
		{
			var firstInCollection:Boolean;
			var lastInCollection:Boolean;
			if (collView.getItemAt(0)==cursor.current) {firstInCollection=true} else {firstInCollection=false}
			viewpanel.btnPrevious.enabled= !firstInCollection;
			if (collView.getItemAt(collView.length-1)==cursor.current) {lastInCollection=true} else {lastInCollection=false}
			viewpanel.btnNext.enabled = !lastInCollection;
		}
		
		
		protected function get viewpanel():ViewPanel
		{
			return viewComponent as ViewPanel;
		}
		
		
		
	}
}

