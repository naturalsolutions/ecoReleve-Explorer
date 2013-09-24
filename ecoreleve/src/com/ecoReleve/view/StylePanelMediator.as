package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.StylePanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	
	import org.openscales.core.Map;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.*;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class StylePanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "StyleTransparencyPanelMediator";	
		private var map:Map;
		
		public function StylePanelMediator(viewComponent:StylePanel)
		{
			super(NAME, viewComponent);			
		}		
		 
		override public function onRegister():void
		{
			super.onRegister();
			
			stylePanel.addEventListener(StylePanel.OPACITY_CHANGED,onChangeOpacity)
			stylePanel.addEventListener(StylePanel.SIZE_CHANGED,onchangeSize)
				
			stylePanel.addEventListener(StylePanel.COLOR_CHANGED,onchangeColor)
			stylePanel.addEventListener(StylePanel.COLOR_SELECTED,onselectColor)
			stylePanel.addEventListener(StylePanel.COLORPICKER_OUT,onSwatchPanelClose)
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION,
					NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION,
					NotificationConstants.STATION_LAYER_MODE_NOTIFICATION,
					NotificationConstants.STATIONS_ADDED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION:
					var mapMediator:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
					map=mapMediator.myMap
					GetStationOpacity()
					GetStationSize()
					stylePanel.boEnabled=true;
					break;
				case NotificationConstants.STATION_PROPORTIONALSIZE_UNSELECT_NOTIFICATION:
					sendNotification(NotificationConstants.STATION_SIZE_CHANGED_NOTIFICATION,stylePanel.nsSize.value,"size")	
					sendNotification(NotificationConstants.STATION_COLOR_CHANGED_NOTIFICATION,stylePanel.pickColor.selectedColor,"color")
					break;
				case NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION:
					GetStationOpacity()
					break;
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:	
					if ((note.getBody() as ArrayCollection)!=null){
						if ((note.getBody() as ArrayCollection).length==0){
							stylePanel.boEnabled=false;
						}else{
							stylePanel.boEnabled=true;
						}
					}
					break;
				case NotificationConstants.STATION_LAYER_MODE_NOTIFICATION:
					if (note.getBody()==DisplayMapMediator.MODE_CLUSTER){
						stylePanel.boEnabled=false;
					}else{
						stylePanel.boEnabled=true;
					}
					break;
			}
		}		

		private function getSymbolizerFromLayer(strLayerName:String):WellKnownMarker
		{
			var vect:FeatureLayer=map.getLayerByName(strLayerName) as FeatureLayer;
			var pf:PointFeature;
			
			//récupère l'objet wellknownmarker du pointSymbolizer de la couche
			var layPtSymb:PointSymbolizer=vect.style.rules[0].symbolizers[0] as PointSymbolizer;
			var layWkm:WellKnownMarker =layPtSymb.graphic as WellKnownMarker;
			
			return layWkm
		}
		
		
		//OPACITY FUNCTION
		private function GetStationOpacity():void
		{
			//récupère la symbologie de la couche stations
			var myWknMarker:WellKnownMarker = getSymbolizerFromLayer("Stations")
			stylePanel.nsOpacity.value= myWknMarker.fill.opacity*100;			
		}
		

		public function onChangeOpacity(event:Event):void
		{
			var opacity:Number=stylePanel.nsOpacity.value/100;
			sendNotification(NotificationConstants.STATION_OPACITY_CHANGED_NOTIFICATION,opacity,"opacity")
						
		}
		
		//SIZE FUNCTION
		private function GetStationSize():void
		{
			//récupère la symbologie de la couhce stations
			var myWknMarker:WellKnownMarker = getSymbolizerFromLayer("Stations")
			stylePanel.nsSize.value= Number(myWknMarker.size);			
		}
		
		private function onchangeSize(event:Event):void
		{
			sendNotification(NotificationConstants.STATION_SIZE_CHANGED_NOTIFICATION,stylePanel.nsSize.value,"size")	
		}
		
		//COLOR FUNCTION
		private function GetStationColor():void
		{
			//récupère la symbologie de la couche stations
			var myWknMarker:WellKnownMarker = getSymbolizerFromLayer("Stations");
			stylePanel.pickColor.selectedColor=uint(myWknMarker.fill.color)
		}
		
		
		public function onSwatchPanelClose(event:Event):void
		{
			//test si la couleur selectionné est differente de la couleur choisit alors on annule
			if (stylePanel.pickColor.selectedColor!=stylePanel.selectedColor){
				sendNotification(NotificationConstants.STATION_COLOR_CHANGED_NOTIFICATION,stylePanel.pickColor.selectedColor,"color")
			}
		}
		
		public function onselectColor(event:Event):void
		{
			sendNotification(NotificationConstants.STATION_COLOR_CHANGED_NOTIFICATION,stylePanel.selectedColor,"color")
		}
		
		public function onchangeColor(event:Event):void
		{
			sendNotification(NotificationConstants.STATION_COLOR_CHANGED_NOTIFICATION,stylePanel.pickColor.selectedColor,"color")
		}
		
        protected function get stylePanel():StylePanel
        {
            return viewComponent as StylePanel;
        }
		

		
	}
}