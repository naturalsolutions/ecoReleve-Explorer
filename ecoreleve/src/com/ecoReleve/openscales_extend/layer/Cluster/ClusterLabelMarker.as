package com.ecoReleve.openscales_extend.layer.Cluster
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.openscales.core.feature.Feature;
	import org.openscales.core.style.marker.Marker;
	
	import spark.filters.GlowFilter;
	
	public class ClusterLabelMarker extends Marker
	{
		private var _xOffSet:Number
		private var _yOffSet:Number
		
		public function ClusterLabelMarker(xOffSet:Number=0,yOffSet:Number=0,size:Object=6, opacity:Number=1, rotation:Number=0)
		{
			super(size, opacity, rotation);
			this._xOffSet=xOffSet
			this._yOffSet=yOffSet
		}
		
		public function get yOffSet():Number
		{
			return this._yOffSet	
		}
		
		public function set yOffSet(value:Number):void
		{
			this._yOffSet=value	
		}
		
		public function get xOffSet():Number
		{
			return this._xOffSet	
		}
		
		public function set xOffSet(value:Number):void
		{
			this._xOffSet=value	
		}
		
		override protected function	generateGraphic(feature:Feature):DisplayObject 
		{
			var size:Number=this.getSizeValue(feature);
			var txt:String=feature.attributes['length']
			
			var glow:GlowFilter=new GlowFilter()
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;

				
			var label:TextField = new TextField();
			label.selectable=false;
			label.filters.push(glow);
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text =txt;
			
			label.width=size/2
			
			label.x =-(label.width/2) + _xOffSet; 
			label.y =-(label.height/2)+ _yOffSet;
			
			
			return label;
		} 
		
	}
}