package com.ecoReleve.ressources.skin.RibbonSliderSkin
{
	import mx.core.mx_internal;
	import mx.skins.halo.SliderThumbSkin;
   
    use namespace mx_internal;
    
    public class SliderThbSkin extends SliderThumbSkin
    {
		
		public var _ThumbColor:uint;
		
		public function SliderThbSkin()
		{
        	super();
        	_ThumbColor=0x000000
   		}

	    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	    {
            super.updateDisplayList(unscaledWidth,unscaledHeight);
            
            switch(name)
            {
	            case "thumbDisabledSkin":
	            	//transparence par défault
	                if (this.getStyle("thumbDisabledColor")!== false){_ThumbColor = this.getStyle('thumbDisabledColor');}
	                break;
			    case "thumbUpSkin":
	            	//transparence par défault
	                if (this.getStyle("thumbUpColor")!== false){_ThumbColor = this.getStyle('thumbUpColor');}
	                break;
            }            
            
            this.graphics.beginFill(_ThumbColor,1);
            this.graphics.drawCircle(2,-9,4);
            this.graphics.endFill();
	     }
	}
}
