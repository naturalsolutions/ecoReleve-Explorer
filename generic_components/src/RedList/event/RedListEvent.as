package RedList.event
{
	import flash.events.Event;
	
	public class RedListEvent extends Event
	{
		public static const REDLIST_SEARCH_RESULT : String = "redlistsearchresult";
		public static const PARSE_ERROR : String = "parseError";
		public static const IO_ERROR : String = "IOError";
		public var data : Object;
		
		public function RedListEvent(type:String,params:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data=params;
		}
		
		public override function clone() : Event 
		{
			return new RedListEvent(type , this.data , bubbles , cancelable);
		}
		
		public override function toString() : String 
		{
			return formatToString("RedListEvent" , "params" , "type" , "bubbles" , "cancelable");
		}

	}
}