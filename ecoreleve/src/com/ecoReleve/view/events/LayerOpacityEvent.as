package com.ecoReleve.view.events
{   
    import flash.events.Event;
    
    import org.openscales.core.layer.Layer;
   
    public class LayerOpacityEvent extends Event
    {
       
        public static var DATA_LOADED:String = "dataLoaded";
       
        private var _data:Layer;
        private var _opacity:Number;
       
        public function LayerOpacityEvent(type:String,data:Layer=null,opacity:Number=100,bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _data = data;
            _opacity=opacity;
        }
       
        override public function clone():Event
        {
            return new LayerOpacityEvent(type,_data,_opacity, bubbles, cancelable);
        }
       
        public function get data():Layer
        {
            return _data;
        }
        
        public function get opacity():Number
        {
            return _opacity;
        }
    }
}