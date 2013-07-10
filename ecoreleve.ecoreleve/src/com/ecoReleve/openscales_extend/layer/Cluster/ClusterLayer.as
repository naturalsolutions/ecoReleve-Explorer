package com.ecoReleve.openscales_extend.layer.Cluster
{
	
	import flash.events.Event;
	
	import org.openscales.core.Map;
	import org.openscales.core.events.FeatureEvent;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.geometry.MultiPoint;
	import org.openscales.geometry.basetypes.Bounds;
	import org.openscales.geometry.basetypes.Location;
	import org.openscales.geometry.basetypes.Pixel;
	
	public class ClusterLayer extends FeatureLayer
	{
		private  var _features:Vector.<Feature>;
		private  var _gridSize:Number;
		private var _zoomLimit:Number;
		private var _gridCells:Vector.<Object>;
		
		public function ClusterLayer(name:String,gridSize:Number,zoomLimit:int)
		{
			super(name);
			this._gridSize=gridSize;
			this._zoomLimit=zoomLimit;
		}
		
		override public function destroy():void
		{
			this.loading = false;
			super.destroy();
		}
		
		override public function set map(map:Map):void
		{
			super.map = map;
		}
		
		override public function redraw(fullRedraw:Boolean = true):void
		{
			this.loading = false;
			
			//only fullredraw if zoom change (not if map move)
			if (fullRedraw==true){
				initGrid()      
				computeCluster()
			}
			
			this.removeFeatures(this.features);            
			var features:Vector.<Feature> = getFeaturesFromCluster() as Vector.<Feature>;
			this.addFeatures(features);
			
			this.clear();
			this.draw();
		}      
		
		private function initGrid():void
		{
			var i:int;
			var j:int;
			
			//break the map into grid
			var numXCells:int=Math.ceil(this.map.width/_gridSize)
			var numYCells:int=Math.ceil(this.map.height/_gridSize)
			
			//create array to store all th clustered data
			_gridCells=new Vector.<Object>(numXCells*numYCells)
			
			// Initialize the grid array with a structure to store all the data
			for(i = 0; i < numXCells; i++){
				for(j = 0; j < numYCells;j++)
				{      
					//init cell object
					var cell:Object=new Object()
					
					cell.features=new Vector.<Number>
					cell.length=0
					_gridCells[i+j*numXCells]=cell;
				}
			}
		}
		
		public function addFeaturesToCluster(features:Vector.<Feature>):void
		{
			this._features=features
			if (this.map){
				this.redraw()
			}
		}
		
		private function computeCluster():void
		{
			var i:int;
			var j:int;
			var key:int;
			
			var numXCells:int=Math.ceil(this.map.width/_gridSize)
			var numYCells:int=Math.ceil(this.map.height/_gridSize)
			
			var feat:PointFeature
			for each(feat in _features){
				//convert point lat lon to pixel
				var lonlat:Location=new Location(feat.lonlat.lon,feat.lonlat.lat,this.projection)
				lonlat=lonlat.reprojectTo(this.map.baseLayer.projection)
				
				var pixel:Pixel=this.map.getMapPxFromLocation(lonlat.clone())
				
				var xPixel:Number=pixel.x;
				var yPixel:Number=pixel.y;
				
				// Check whether the shape is within the bounds of the viewable map
				if(this.map.width >= xPixel && this.map.height >= yPixel && xPixel >= 0 && yPixel >= 0)
				{
					// Calculate the grid position on the map of where the shape is located
					i = Math.floor(xPixel/_gridSize);
					j= Math.floor(yPixel/_gridSize);
					
					// Calculate the grid location in the array
					key = i+j*numXCells;
					
					_gridCells[key].features.push(feat.lonlat.lon)
					_gridCells[key].features.push(feat.lonlat.lat)
					_gridCells[key].length++;                              
				}                      
			}
		}
		
		private function getFeaturesFromCluster():Vector.<Feature>
		{
			var clusterFeatures:Vector.<Feature>=new Vector.<Feature>
			var key:int
			
			// Iterate through the clustered data in the grid array
			for(key=0; key < _gridCells.length; key++)
			{
				_gridCells[key] = _gridCells[key];
				
				// Add a shape to the cluster layer
				if(_gridCells[key].length > 0)
				{
					//find cenroid of the collection of location in the cluster    
					// if only one point centroid==point
					var points:MultiPoint=new MultiPoint(_gridCells[key].features)
					var locCluster:Location=points.bounds.center
					
					//create point
					var geom:org.openscales.geometry.Point=new org.openscales.geometry.Point(locCluster.lon,locCluster.lat);
					
					if (this.map.baseLayer.projection != null && this.projection != null && this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
						geom.transform(this.projection,this.map.baseLayer.projection);
					}
					
					var pointCluster:PointFeature=new PointFeature(geom);
					pointCluster.attributes['title']=_gridCells[key].title;
					pointCluster.attributes['length']=_gridCells[key].length;
					pointCluster.attributes['Description']=_gridCells[key].description;
					
					clusterFeatures.push(pointCluster)
				}
			}
			
			return clusterFeatures
		}
	}
}

