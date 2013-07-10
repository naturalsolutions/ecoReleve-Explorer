package com.ecoReleve.ressources.skin.RibbonSliderSkin
{
	import mx.controls.sliderClasses.SliderThumb;
	import mx.core.mx_internal;
   
    use namespace mx_internal;
    
    public class SliderThb extends SliderThumb
    {
		
		public var _ThumbColor:uint;
		
		public function SliderThb()
		{
        	super();
        	_ThumbColor=0x000000
   		}
		 
		 override protected function measure():void
		 {
            super.measure();
            measuredWidth = 1;
            measuredHeight = 1;
            measuredMinHeight = -1;
            measuredMinWidth = -1;
	     }

	    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	    {
            super.updateDisplayList(unscaledWidth,unscaledHeight);           
            
            this.graphics.beginFill(_ThumbColor,1);
            this.graphics.drawCircle(2,-9,4);
            this.graphics.endFill();
	     }
	}
}
