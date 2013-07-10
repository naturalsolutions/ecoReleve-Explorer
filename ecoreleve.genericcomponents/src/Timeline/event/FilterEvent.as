package Timeline.event
{   
    import com.fnicollet.datafilter.filter.DataFilterParameters;
    
    import flash.events.Event;
   
    public class FilterEvent extends Event
    {
       
        public static var DATAFILTER:String = "dataFilter";
       
        private var _data:DataFilterParameters;
       
        public function FilterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:DataFilterParameters=null)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }
       
        override public function clone():Event
        {
            return new FilterEvent(type, bubbles, cancelable, data);
        }
       
        public function get data():DataFilterParameters
        {
            return _data;
        }
    }
}