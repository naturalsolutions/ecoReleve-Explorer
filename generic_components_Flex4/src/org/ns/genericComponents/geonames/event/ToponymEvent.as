package org.ns.genericComponents.geonames.event
{
	import flash.events.Event;
	
	import org.ns.genericComponents.geonames.VO.ToponymVO;
	
	public class ToponymEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const CLEAR:String = "clear";
		
		private var _data:ToponymVO;
		
		public function ToponymEvent(type:String,data:ToponymVO, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_data=data;
		}
		
		override public function clone():Event
		{
			return new ToponymEvent(type,_data, bubbles, cancelable);
		}
		
		public function get data():ToponymVO
		{
			return _data;
		}
	}
}