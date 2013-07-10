package org.ns.genericComponents.geonames.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.ns.genericComponents.geonames.VO.ToponymVO;
	import org.ns.genericComponents.geonames.event.GeonameEvent;
	
	[Event(name="complete",type="flash.events.Event")]
	
	public class Geoname extends EventDispatcher
	{
		private var _url:String = "http://ws.geonames.org/";
		private var _method:String = URLRequestMethod.GET;
		private var _params:Object;
		private var _result:Array;
		private var _loader:URLLoader;
		
		public var params:Object;
		
		public function Geoname(url:String,params:Object = null):void
		{
			_url = url;
			_params = params;
		}
		
		
		public function get result():Array 
		{
			return _result;
		}

		
		public function call():void
		{
			var request:URLRequest = new URLRequest(_url);
			request.method;
			var vars:URLVariables;
			
			if(_params)
			{
				vars = new URLVariables();
				for( var property:String in _params)
				{
					if( _params[property] != null )
					{
						vars[property] = _params[property];
					}
				}
				request.data = vars;
			}
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,onStatus);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			_loader.load(request);
			trace(request.url);
		}
		
		protected function onComplete(event:Event):void
		{
			var xml:XML = new XML(_loader.data);
			var result:Array = new Array();
			var i:XML;
			for each (i in xml.children())
			{
				var toponym:ToponymVO=new ToponymVO;
				
				toponym.name = i.name.text()
				toponym.lat = i.lat.text() 
				toponym.lng = i.lng.text() 
				toponym.geonameId = i.geonameId.text()
				toponym.countryCode = i.countryCode.text() 
				toponym.countryName = i.countryName.text() 
				toponym.fcl = i.fcl.text() 
				toponym.fcode = i.fcode.text() 
				toponym.fclName = i.fclName.text() 
				toponym.fcodeName = i.fcodeName.text() 
				toponym.population = i.population.text() 
				toponym.alternateNames = i.alternateNames.text() 
				toponym.elevation = i.elevation.text() 
				toponym.continentCode = i.continentCode.text() 
				toponym.adminCode1 = i.adminCode1.text() 
				toponym.adminName1 = i.adminName1.text() 
				toponym.adminCode2 = i.adminCode2.text() 
				toponym.adminName2 = i.adminName2.text() 
				toponym.timezone = i.timezone.text() 
				toponym.distance = i.distance.text() 
				
				
				result.push(toponym);
			}
			
			_result = result;
			
			dispatchEvent(new GeonameEvent(GeonameEvent.COMPLETE,result));
		}
		
		protected function onStatus(event:HTTPStatusEvent):void
		{
			dispatchEvent(new GeonameEvent(GeonameEvent.HTTP_STATUS,event));
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			dispatchEvent(new GeonameEvent(GeonameEvent.ERROR,event));
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			trace('loading...')
		}
		
	}
}