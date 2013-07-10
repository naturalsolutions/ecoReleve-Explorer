package com.ecoReleve.openscales_extend.layer
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import org.openscales.core.Trace;
	import org.openscales.geometry.basetypes.Bounds;
	import org.openscales.core.feature.Feature;
	import com.ecoReleve.openscales_extend.format.GPXFormat;
	import org.openscales.core.request.XMLRequest;
	import org.openscales.core.layer.FeatureLayer;
	
	/**
	 * GPX layer
	 */
	public class GPX extends FeatureLayer
	{
		private var _url:String = "";
		private var _request:XMLRequest = null;
		private var _gpxFormat:GPXFormat = null;
		private var _xml:XML = null;
		
		public function GPX(name:String,url:String,bounds:Bounds = null) 
		{
			this._url = url;
			this.maxExtent = bounds;
			
			super(name);
			this._gpxFormat = new GPXFormat();
			
			this.loading = true;
			this._request = new XMLRequest(url, onSuccess, onFailure);
			this._request.proxy = this.proxy;
			this._request.security = this.security;
			this._request.send();
		}
		
		override public function destroy():void 
		{
			if (this._request) {
				this._request.destroy();
				this._request = null;
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
		
		public function onSuccess(event:Event):void
		{
			this.loading = false;
			var loader:URLLoader = event.target as URLLoader;
			
			// To avoid errors if the server is dead
			try {
				this._xml = new XML(loader.data);
				if (this.map.baseLayer.projection != null && this.projection != null && this.projection.srsCode != this.map.baseLayer.projection.srsCode) {
					this._gpxFormat.externalProj = this.projection;
					this._gpxFormat.internalProj = this.map.baseLayer.projection;
				}
				this._gpxFormat.proxy = this.proxy;
				var features:Vector.<Feature> = this._gpxFormat.read(this._xml) as Vector.<Feature>;
				this.addFeatures(features);
				
				this.clear();
				this.draw();
			}
			catch(error:Error) {
				Trace.error(error.message);
			}
		}
		
		protected function onFailure(event:Event):void 
		{
			this.loading = false;
			Trace.error("Error when loading gpx " + this._url);
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
