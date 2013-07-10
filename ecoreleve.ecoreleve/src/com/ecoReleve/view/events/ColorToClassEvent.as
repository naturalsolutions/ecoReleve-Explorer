package com.ecoReleve.view.events
{ 
    import flash.events.Event;

   
    public class ColorToClassEvent extends Event
    {
       
        public static var CHANGE:String = "change";  
        private var _data:Object;
       
        public function ColorToClassEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }
       
        override public function clone():Event
        {
            return new ColorToClassEvent(type, bubbles, cancelable, data);
        }
       
        public function get data():Object
        {
            return _data;
        }
    }
}