package Timeline.event
{ 
    import flash.events.Event;

   
    public class TimeIntervalEvent extends Event
    {
       
        public static var INTERVAL_CHANGE:String = "IntervalChange";  
        private var _data:Object;
       
        public function TimeIntervalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }
       
        override public function clone():Event
        {
            return new TimeIntervalEvent(type, bubbles, cancelable, data);
        }
       
        public function get data():Object
        {
            return _data;
        }
    }
}