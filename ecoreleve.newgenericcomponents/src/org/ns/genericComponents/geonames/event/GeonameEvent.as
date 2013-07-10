package org.ns.genericComponents.geonames.event
{
	import flash.events.Event;
	
	public class GeonameEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		public static const HTTP_STATUS:String = "httpStatus";
		
		private var _data:Object;
		
		public function GeonameEvent(type:String,data:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_data=data;
		}
		
		override public function clone():Event
		{
			return new GeonameEvent(type,_data, bubbles, cancelable);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}