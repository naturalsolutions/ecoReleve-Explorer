package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.utils.ConvexHull;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.GeoToolPanel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.*;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import org.openscales.core.Map;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.MultiLineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.LineSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LineString;
	import org.openscales.geometry.LinearRing;
	import org.openscales.geometry.MultiLineString;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.Polygon;
	import org.openscales.geometry.basetypes.Location;
	import org.openscales.proj4as.ProjProjection;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class GeoToolPanelMediator extends FabricationMediator
	{
		//nom du médiator
		public static const NAME:String = "GeoToolPanelMediator";   
		
		private var map:Map;
		
		public function GeoToolPanelMediator(viewComponent:GeoToolPanel)
		{
			super(NAME, viewComponent);
		} 
		
		
		override public function onRegister():void
		{
			super.onRegister();     
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.LAYER_REMOVED_NOTIFICATION,
					NotificationConstants.STATIONS_ALL_DELETED_NOTIFICATION,
					NotificationConstants.STATION_LAYER_MODE_NOTIFICATION,
					NotificationConstants.STATIONS_ADDED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.LAYER_REMOVED_NOTIFICATION:
					var layer:Layer=note.getBody() as Layer
					if (layer.name=="Stations"){	
						geotool.boEnabled=false;
					}
					break;
				case NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION:    
					geotool.boEnabled=true;
					//récupère l'objet map
					var mapMediator:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
					map=mapMediator.myMap
					break;
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION: 
					if ((note.getBody() as ArrayCollection).length==0){
						geotool.boEnabled=false;
					}else{
						geotool.boEnabled=true;
					}
					break;
				case NotificationConstants.STATION_LAYER_MODE_NOTIFICATION:
					if (note.getBody()==DisplayMapMediator.MODE_CLUSTER){
						geotool.boEnabled=false;
					}else{
						geotool.boEnabled=true;
					}
					break;
			}
		}       
		
		//REACTIONS
		public function reactToLstTool$Change(event:IndexChangeEvent):void
		{
			var obj:Object=event.currentTarget.selectedItem as Object
			if (obj.name=='Path'){
				createPath()
			}else if(obj.name=='Home range'){
				createConvexHull()
			}
		}
		
		
		//PRIVATE FUNCTIONS
		
		/**
		 * Create Path
		 **/
		private function createPath():void 
		{       
			var prjWGS84:ProjProjection = new ProjProjection('EPSG:4326');
			var projBaseLayer:ProjProjection = new ProjProjection(this.map.baseLayer.projection.srsCode);
			
			//create array of point
			var arrayPointFeat:Array = new Array();
			var arrayComponents:Vector.<Number>
			var vect:FeatureLayer=this.map.getLayerByName("Stations") as FeatureLayer;
			
			//create arrayPointFeat: array with pointFeature and date for sorting
			for each(var pointFeat:PointFeature in vect.features){
				var dateTime:Number=(pointFeat.attributes["sta_date"] as Date).time     
				arrayPointFeat.push({pointF:pointFeat, date:dateTime})
				
			}
			
			//sort arrayPointFeat
			arrayPointFeat.sortOn("sta_date", Array.NUMERIC);
			
			
			//supprime le layer si il existe déjà
			if (this.map.getLayerByName("path")!= null){
				this.map.removeLayer(this.map.getLayerByName("path"))
			}
			
			//create layer
			var layer:FeatureLayer=new FeatureLayer("path")
			layer.projection=projBaseLayer;
			
			//create line object and add to layer
			var firstPoint:PointFeature
			for each(var obj:Object in arrayPointFeat){
				
				var secondPoint:PointFeature=new PointFeature
				secondPoint=obj["pointF"] as PointFeature;
				
				if (firstPoint!=null){
					arrayComponents= new Vector.<Number>();
					
					arrayComponents.push(firstPoint.point.x)
					arrayComponents.push(firstPoint.point.y)
					arrayComponents.push(secondPoint.point.x)
					arrayComponents.push(secondPoint.point.y)
					var ls:LineString=new LineString(arrayComponents)
					var lsFeat:LineStringFeature=new LineStringFeature(ls,null,null)
					
					var timeRange:Number=(secondPoint.attributes["sta_date"] as Date).time - (firstPoint.attributes["sta_date"] as Date).time
					
					lsFeat.attributes["duration"]=timeRange
					lsFeat.attributes["distance"]=ls.length         
					
					layer.addFeature(lsFeat)
				}
				
				firstPoint=new PointFeature
				firstPoint=secondPoint
			}
			
			//add style
			var style:Style = new Style();
			style.name="path"
			style.rules[0] = new Rule();
			(style.rules[0] as Rule).symbolizers.push(new LineSymbolizer(new Stroke(0x33FF00,3)));
			
			layer.style=style
			
			//add layer to map
			sendNotification(NotificationConstants.LAYER_ADD_NOTIFICATION,layer,"path")
			
			geotool.lstTool.selectedIndex=-1
		}
		
		
		/** 
		 *  Create convex Hull
		 **/
		private function createConvexHull():void 
		{       
			var prjWGS84:ProjProjection = new ProjProjection('EPSG:4326');
			var projBaseLayer:ProjProjection = new ProjProjection(this.map.baseLayer.projection.srsCode);
			
			var vect:FeatureLayer=this.map.getLayerByName("Stations") as FeatureLayer;
			var arrayVertices:Vector.<Number>=new Vector.<Number>;
			var arrayComponents:Vector.<Geometry>=new Vector.<Geometry>;                    
			var arrayOfRawPoint:Array=new Array();
			var arrayOfConvexHullPoint:Array=new Array();
			
			//create array of points(flash) from station layer
			for each(var pointFeat:PointFeature in vect.features){
				var fPoint:flash.geom.Point=new flash.geom.Point;
				fPoint.x=pointFeat.point.x
				fPoint.y=pointFeat.point.y
				arrayOfRawPoint.push(fPoint)
			}
			
			//create array of points(openscales) for convexHull
			arrayOfConvexHullPoint=ConvexHull.grahamScan2D(arrayOfRawPoint)
			for each(var pt:flash.geom.Point in arrayOfConvexHullPoint){
				var lonlat:Location = new Location(pt.x,pt.y, projBaseLayer);
				arrayVertices.push(lonlat.lon)
				arrayVertices.push(lonlat.lat)
			}
			
			//supprime le layer si il existe déjà
			if (this.map.getLayerByName("homeRange")!= null){
				this.map.removeLayer(this.map.getLayerByName("homeRange"))
			}
			
			//create layer
			var layer:FeatureLayer=new FeatureLayer("homeRange")
			layer.projection=projBaseLayer;
			
			var style:Style = new Style();
			style.name="home range"
			style.rules[0] = new Rule();
			(style.rules[0] as Rule).symbolizers.push(new PolygonSymbolizer(new SolidFill(0x0033FF,0.5),new Stroke(0x0033FF,2)));
			
			var lr:LinearRing=new LinearRing(arrayVertices);
			arrayComponents.push(lr);
			var poly:Polygon=new Polygon(arrayComponents)
			var polyFeat:PolygonFeature=new PolygonFeature(poly)
			layer.addFeature(polyFeat);
			layer.style=style
			
			trace('area: ' + lr.area)
			trace('length: ' + lr.length)
			
			trace('area: ' + poly.area)
			trace('length: ' + poly.length)
			
			sendNotification(NotificationConstants.LAYER_ADD_NOTIFICATION,layer,"home range")
			
			geotool.lstTool.selectedIndex=-1
		}
		
		
		protected function get geotool():GeoToolPanel
		{
			return viewComponent as GeoToolPanel;
		}
		
		
		
	}
}
