package com.ecoReleve.utils
{
	import flash.geom.Point;
	
	import mx.accessibility.LabelAccImpl;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.MapEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.MultiPointFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.geometry.Collection;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LinearRing;
	import org.openscales.geometry.MultiPoint;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.Polygon;
	import org.openscales.geometry.basetypes.Bounds;
	import org.openscales.geometry.basetypes.Location;
	import org.openscales.geometry.basetypes.Pixel;
	import org.openscales.proj4as.ProjProjection;
	import com.ecoReleve.openscales_extend.layer.Cluster.GraticuleLabelMarker;

	public class Cluster 
	{	
		private var layCluster:FeatureLayer
		private  var _map:Map;
		private  var _features:Vector.<Feature>;
		private  var _drawGrid:Boolean;
		private  var _gridSize:Number;
		private var _zoomLimit:Number;
		private var _gridCells:Vector.<Object>;
		private  var _numXCells:int;
		private  var _numYCells:int;
		
		public function Cluster(map:Map,gridSize:Number,zoomLimit:int,features:Vector.<Feature>,drawGrid:Boolean):void
		{
			super()
			this._map=map
			this._features=features
			this._drawGrid=drawGrid
			this._gridSize=gridSize
			this._zoomLimit=zoomLimit
			this._map.addEventListener(MapEvent.MOVE_END, onMapMove,false,0,true);
			this._map.addEventListener(MapEvent.RESIZE, onMapResize,false,0,true);
		}
		
		private function onMapMove(e:MapEvent):void 
		{
			computeCluster()
		}
		
		private function onMapResize(e:MapEvent):void 
		{
			computeCluster()
		}
		
		public  function computeCluster():void
		{
			var i:int
			var j:int
			var key:int
			
			
			//create grid layer	if requested
			if (_drawGrid==true){
				var grid:FeatureLayer
				if (_map.getLayerByName('grid')){
					//delete all shape of layer
					grid=_map.getLayerByName('grid') as FeatureLayer
					grid.removeFeatures(grid.features)
				}else{
					grid=new FeatureLayer("grid")
					grid.name='grid'
					grid.projection=_map.baseLayer.projection
				}	
			}
						
			//if cluster layer not exist create it
			if (_map.getLayerByName('cluster')){
				//delete all shape of layer
				layCluster=_map.getLayerByName('cluster') as FeatureLayer
				layCluster.removeFeatures(layCluster.features)
			}else{
				layCluster=new FeatureLayer("cluster")
				layCluster.name='cluster'
				layCluster.projection=ProjProjection.getProjProjection('EPSG:4326')
			}	
				
			//get the size in pixels of the map
			var mapWidth:Number=_map.width
			var mapHeight:Number=_map.height
			
			//break the map into grid
			var numXCells:int=Math.ceil(mapWidth/_gridSize)
			var numYCells:int=Math.ceil(mapHeight/_gridSize)
				
			//create array to store all th clustered data
			var gridCells:Vector.<Object>=new Vector.<Object>(numXCells*numYCells)
				
			// Initialize the grid array with a structure to store all the data
			for(i = 0; i < numXCells; i++){
				for(j = 0; j < numYCells;j++)
				{	
					//init cell object
					var cell:Object=new Object()
						
					cell.features=new Vector.<Number>
					cell.length=0
					gridCells[i+j*numXCells]=cell;
					
					if (_drawGrid==true){
						var pxUL:Pixel=new Pixel(i*_gridSize,j*_gridSize);
						var pxRB:Pixel=new Pixel((i+1)*_gridSize,(j+1)*_gridSize);
						
						var locRB:Location=_map.getLocationFromMapPx(pxRB)
						var locUL:Location=_map.getLocationFromMapPx(pxUL)
						
						var bounds:Bounds=new Bounds(locUL.lon,locRB.lat,locRB.lon,locUL.lat)					

						var styleGrid:Style= new Style();					
						styleGrid.name="grid"
						var ruleGrid:Rule;
						ruleGrid = new Rule(); 
						ruleGrid.symbolizers.push(new PolygonSymbolizer(null,new Stroke(0xFFFFFF,1,1)))
						
						styleGrid.rules.push(ruleGrid)	
							
						var polygon:Polygon=bounds.toGeometry()
						
						var pFeat:PolygonFeature=new PolygonFeature(polygon,null,styleGrid)					
						grid.addFeature(pFeat)
					}
				}
			}
			
			_map.addLayer(grid,false,true)
			
			
			// Iterate through the shapes in the base layer
			var feat:PointFeature 
			for each(feat in _features){
				//convert point lat lon to pixel
				var lonlat:Location=new Location(feat.lonlat.lon,feat.lonlat.lat,layCluster.projection)
				lonlat=lonlat.reprojectTo(_map.baseLayer.projection)
				
				var pixel:Pixel=_map.getMapPxFromLocation(lonlat.clone())
				
				var xPixel:Number=pixel.x;
				var yPixel:Number=pixel.y;

				// Check whether the shape is within the bounds of the viewable map
				if(mapWidth >= xPixel && mapHeight >= yPixel && xPixel >= 0 && yPixel >= 0)
				{
					// Calculate the grid position on the map of where the shape is located
					i = Math.floor(xPixel/_gridSize);
					j= Math.floor(yPixel/_gridSize);
					
					// Calculate the grid location in the array
					key = i+j*numXCells;
					
					// Define a standard way to display an individual shape 
					/*if(gridCells[key].length == 0)
					{
						gridCells[key].loc = feat.lonlat;
					}*/
					
					gridCells[key].features.push(feat.lonlat.lon)
					gridCells[key].features.push(feat.lonlat.lat)
					gridCells[key].length++;
					
				}
					
			}
			
			// Iterate through the clustered data in the grid array
			for(key=0; key < gridCells.length; key++)
			{
				gridCells[key] = gridCells[key];

				// Add a shape to the cluster layer
				if(gridCells[key].length > 0) 
				{
					//find cenroid of the collection of location in the cluster	
					// if only one point centroid==point
					var points:MultiPoint=new MultiPoint(gridCells[key].features)
					var locCluster:Location=points.bounds.center
					
					//create point
					var geom:org.openscales.geometry.Point=new org.openscales.geometry.Point(locCluster.lon,locCluster.lat);

					var pointCluster:PointFeature=new PointFeature(geom);
					pointCluster.attributes['title']=gridCells[key].title;
					pointCluster.attributes['nb']=gridCells[key].length;
					pointCluster.attributes['Description']=gridCells[key].description;
					
					//add styel
					var style:Style= new Style();					
					style.name="cluster"
					var rule:Rule;
					rule = new Rule(); 
					//add point symbolizer
					var wkn:WellKnownMarker
					var lbl:GraticuleLabelMarker
					//choose color in function of cluster size
					if (gridCells[key].length==1){
						wkn=new WellKnownMarker(WellKnownMarker.WKN_CIRCLE,new SolidFill(0x2ff409,0.7),new Stroke(0xFFFFFF,1,1),12)
						lbl=new GraticuleLabelMarker(String(gridCells[key].length),0,0,12,1,0)
					}else if (gridCells[key].length>1 && gridCells[key].length<10){
						wkn=new WellKnownMarker(WellKnownMarker.WKN_SQUARE,new SolidFill(0x2ff409,0.7),new Stroke(0xFFFFFF,1,1),20)
						lbl=new GraticuleLabelMarker(String(gridCells[key].length),0,0,20,1,0)
					}else if (gridCells[key].length>=10 && gridCells[key].length<50){
						wkn=new WellKnownMarker(WellKnownMarker.WKN_SQUARE,new SolidFill(0xe6f409,0.7),new Stroke(0xFFFFFF,1,1),20)
						lbl=new GraticuleLabelMarker(String(gridCells[key].length),0,0,20,1,0)
					}else if (gridCells[key].length>=50 && gridCells[key].length<500){
						wkn=new WellKnownMarker(WellKnownMarker.WKN_SQUARE,new SolidFill(0xf4c509,0.7),new Stroke(0xFFFFFF,1,1),20)
						lbl=new GraticuleLabelMarker(String(gridCells[key].length),0,0,20,1,0)
					}else {
						wkn=new WellKnownMarker(WellKnownMarker.WKN_SQUARE,new SolidFill(0xf44009,0.7),new Stroke(0xFFFFFF,1,1),20)
						lbl=new GraticuleLabelMarker(String(gridCells[key].length),0,0,20,1,0)
					}
										
					rule.symbolizers.push(new PointSymbolizer(wkn));
					//add label symbolizer 
					rule.symbolizers.push(new PointSymbolizer(lbl))
					style.rules.push(rule);	
						
					pointCluster.style=style
						
					layCluster.addFeature(pointCluster);
				}
			}
			
			_map.addLayer(layCluster,false,true)	
		}
	}
}