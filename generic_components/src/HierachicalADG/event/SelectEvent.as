package HierachicalADG.event
{   
    import com.fnicollet.datafilter.filter.DataFilterParameters;
    
    import flash.events.Event;
   
    public class SelectEvent extends Event
    {
       
        private var _data:Array;
       
        public function SelectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Array=null)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }
       
        override public function clone():Event
        {
            return new SelectEvent(type, bubbles, cancelable, data);
        }
       
        public function get data():Array
        {
            return _data;
        }
    }
}