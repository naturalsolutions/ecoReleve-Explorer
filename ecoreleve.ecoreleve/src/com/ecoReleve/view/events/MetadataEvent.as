package com.ecoReleve.view.events
{   
    import flash.events.Event;
   
    public class MetadataEvent extends Event
    {
       
        public static var GET_URLS:String = "geturls";
       
        private var _data:String;
       
        public function MetadataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:String=null)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }
       
        override public function clone():Event
        {
            return new MetadataEvent(type, bubbles, cancelable, data);
        }
       
        public function get data():String
        {
            return _data;
        }
    }
}