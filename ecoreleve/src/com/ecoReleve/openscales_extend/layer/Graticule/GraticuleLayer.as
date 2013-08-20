package com.ecoReleve.openscales_extend.layer.Graticule
{
	
	import flash.events.Event;
	
	import org.openscales.core.Map;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LineString;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.basetypes.Location;
	import org.openscales.proj4as.ProjProjection;
	
	public class GraticuleLayer extends FeatureLayer
	{
		private  var _features:Vector.<Feature>;
		
		public function GraticuleLayer(name:String) 
		{
			super(name);
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
			
			//calcul distance between graticule in function of zoom number
			var delta:Number
			if (map.zoom<5){
				delta=10
			}else if (map.zoom>=5 && map.zoom<7){
				delta=5
			}else if(map.zoom>=7 && map.zoom<9){
				delta=1
			}else if(map.zoom>=9 && map.zoom<11){
				delta=0.2
			}else if(map.zoom>=11 && map.zoom<13){
				delta=0.1
			}else if(map.zoom>=13 && map.zoom<15){
				delta=0.025
			}else{
				delta=0.01
			}

			this.removeFeatures(this.features);		
			var features:Vector.<Feature> = createGraticule(delta) as Vector.<Feature>;
			this.addFeatures(features);
			
			this.clear();
			this.draw();
		}
		
		private function createGraticule(delta:Number):Vector.<Feature>
		{	
			var graticuleFeatures:Vector.<Feature>=new Vector.<Feature>
			var arrComponents:Vector.<Number>
			var lineFeature:LineStringFeature
			var pt1:Point
			var pt2:Point
			
			//get uper-left coordinates in lat lon
			var UpLeft:Location=new Location(map.extent.left,map.extent.top,map.baseLayer.projection);
			UpLeft=UpLeft.reprojectTo(ProjProjection.getProjProjection('EPSG:4326'));
			
			//get bottom-right coordinates in lat lon
			var boRight:Location=new Location(map.extent.right,map.extent.bottom,map.baseLayer.projection);
			boRight=boRight.reprojectTo(ProjProjection.getProjProjection('EPSG:4326'));
		
			//create meridien
			var minI:Number=Math.round(UpLeft.lon) -1;
			var maxI:int=Math.round(boRight.lon) + 1;

			//draw from -90 to 90 
			var i:Number=-90
			while (i <= 90)
			{	
				//si la longitude est visible
				if (i>minI && i<maxI){
					pt1=new Point(i,UpLeft.lat);
					pt2=new Point(i,boRight.lat);
					
					if (this.map.baseLayer.projection != null && this.projection != null && this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
						pt1.transform(this.projection,this.map.baseLayer.projection);
						pt2.transform(this.projection,this.map.baseLayer.projection);
					}
					
					arrComponents=new Vector.<Number>;
					arrComponents.push(pt1.x,pt1.y,pt2.x,pt2.y);
					
					var geom:Geometry=new LineString(arrComponents)
					
					
					lineFeature=new LineStringFeature(new LineString(arrComponents));
					graticuleFeatures.push(lineFeature);	
					
				}
				i+=delta
			}

			//create parallel
			var minJ:Number=Math.round(boRight.lat) -1;
			var maxJ:int=Math.round(UpLeft.lat) + 1;

			var j:Number=-180
			while (j <= 180)
			{	
				//si la longitude est visible
				if (j>minJ && j<maxJ){
					pt1=new Point(UpLeft.lon,j);
					pt2=new Point(boRight.lon,j);
					
					if (this.map.baseLayer.projection != null && this.projection != null && this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
						pt1.transform(this.projection,this.map.baseLayer.projection);
						pt2.transform(this.projection,this.map.baseLayer.projection);
					}
					
					arrComponents=new Vector.<Number>;
					arrComponents.push(pt1.x,pt1.y,pt2.x,pt2.y);
	
					lineFeature=new LineStringFeature(new LineString(arrComponents));
					graticuleFeatures.push(lineFeature);
				}
				
				j+=delta
			}
			
			return graticuleFeatures	
		}	
	}
}