package com.ecoReleve.view.events
{   
    import flash.events.Event;
   
    public class ClassEvent extends Event
    {
       
        public static var DATA_LOADED:String = "dataLoaded";
       
        private var _data:Object;
       
        public function ClassEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }
       
        override public function clone():Event
        {
            return new ClassEvent(type, bubbles, cancelable, data);
        }
       
        public function get data():Object
        {
            return _data;
        }
    }
}