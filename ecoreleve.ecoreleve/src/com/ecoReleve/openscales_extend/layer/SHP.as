package com.ecoReleve.openscales_extend.layer
{
	import com.ecoReleve.openscales_extend.format.SHPFormat;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.openscales.core.Trace;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.geometry.basetypes.Bounds;
	
	public class SHP extends FeatureLayer
	{
		private var _url:String = "";
		private var _shpFormat:SHPFormat = null;
		private var _shpLoader:URLLoader = null;
		private var _dbfLoader:URLLoader = null;
		
		public function SHP(name:String,url:String,bounds:Bounds = null)
		{
			this._url = url;
			this.maxExtent = bounds;
			
			super(name);
			this._shpFormat=new SHPFormat();
			
			this.loading = true;
			
			var request:URLRequest = null;
			request = new URLRequest(_url);
			this._shpLoader = new URLLoader();
			this._shpLoader.dataFormat = URLLoaderDataFormat.BINARY
			this._shpLoader.addEventListener(Event.COMPLETE, onShpSuccess);
			this._shpLoader.addEventListener(IOErrorEvent.IO_ERROR, onShpFailure);
			this._shpLoader.load(request);
		}
		
		override public function destroy():void 
		{
			if (this._shpLoader) {
				this._shpLoader = null;
			}
			this.loading = false;
			super.destroy();
		}
		
		override public function redraw(fullRedraw:Boolean = true):void 
		{
			if (!displayed) {
				this.clear();
				return;
			}
			
			this.clear();
			this.draw();
		}
		
		public function onShpSuccess(event:Event):void
		{
			var request:URLRequest = null;
			
			var url:String=this._url.slice(0,this._url.indexOf('.')) + '.dbf'
			
			request = new URLRequest(url);
			this._dbfLoader = new URLLoader();
			this._dbfLoader.dataFormat = URLLoaderDataFormat.BINARY
			this._dbfLoader.addEventListener(Event.COMPLETE, onDbfSuccess);
			this._dbfLoader.addEventListener(IOErrorEvent.IO_ERROR, onDBFFailure);
			this._dbfLoader.load(request);
		}
		
		public function onDbfSuccess(event:Event):void
		{       
			this.loading = false;
			
			try {
				var bytesSHP:ByteArray = this._shpLoader.data as ByteArray;
				var bytesDBF:ByteArray = this._dbfLoader.data as ByteArray;
				
				if (this.map.baseLayer.projection != null && this.projection != null && this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
					this._shpFormat.externalProj = this.projection;
					this._shpFormat.internalProj = this.map.baseLayer.projection;
				}
				this._shpFormat.proxy = this.proxy;
				var features:Vector.<Feature>=this._shpFormat.read([bytesSHP,bytesDBF]) as Vector.<Feature>;
				this.addFeatures(features);
				
				this.clear();
				this.draw();
			}
			catch(error:Error) {
				Trace.error(error.message);
			}
			
		}
		
		protected function onShpFailure(event:IOErrorEvent):void 
		{
			this.loading = false;
			Trace.error("Error when loading shapefile " + this._url);
		}
		
		protected function onDBFFailure(event:IOErrorEvent):void 
		{
			this.loading = false;
			Trace.error("Error when loading dbf file " + this._url);
		}
		
		public function get url():String 
		{
			return this._url;
		}
		
		public function set url(value:String):void 
		{
			this._url = value;
		}
		
		override public function getURL(bounds:Bounds):String 
		{
			return this._url;
		}
	}
}
