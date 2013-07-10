package Timeline.event
{ 
    import flash.events.Event;

   
    public class TimeScaleEvent extends Event
    {
       
        public static var SCALE_CHANGE:String = "ScaleChange";  
        private var _data:Object;
       
        public function TimeScaleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }
       
        override public function clone():Event
        {
            return new TimeScaleEvent(type, bubbles, cancelable, data);
        }
       
        public function get data():Object
        {
            return _data;
        }
    }
}