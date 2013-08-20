package com.ecoReleve.ressources.skin.ResizableCanvasSkin
{
import mx.skins.ProgrammaticSkin;
import flash.display.Graphics;
import mx.styles.StyleManager;
   
	public class CanvasBoutonSkin extends ProgrammaticSkin 
	{
		public var _backgroundFillColor:Number;
		public var _backgroundAlpha:Number;

	    public function CanvasBoutonSkin():void 
	    {
	            
	        super();
	        _backgroundFillColor=0x5E81A4
	        _backgroundAlpha=1
	    }
	    
	    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
	    {
	        
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	        	    		
	    		//Différent state
	    		switch (name) 
	    		{
		           case "upSkin":
			           	_backgroundAlpha=1
			           	if (this.getStyle("backgroundFillColor")!== false) {
				    		_backgroundFillColor = this.getStyle('backgroundFillColor');
				    	}
			            break;
			       case "downSkin":
			           	_backgroundAlpha=0
			            break;
		           case "overSkin":
			           	_backgroundAlpha=1
			           	if (this.getStyle("backgroundFillOverColor")!== false) {
				    		_backgroundFillColor = this.getStyle('backgroundFillOverColor');
				    	}
			            break;
		           case "selectedUpSkin":
			           	_backgroundAlpha=1
			           	if (this.getStyle("backgroundFillOverColor")!== false) {
				    		_backgroundFillColor = this.getStyle('backgroundFillOverColor');
				    	}
			            break;
				   case "selectedDownSkin":
				   		 _backgroundAlpha=1
				   		 if (this.getStyle("backgroundFillOverColor")!== false) {
				    		_backgroundFillColor = this.getStyle('backgroundFillOverColor');
				    	 }
				 		 break;
				   case "selectedOverSkin":
				   		 _backgroundAlpha=1
				   		 if (this.getStyle("backgroundFillOverColor")!== false) {
				    		_backgroundFillColor = this.getStyle('backgroundFillOverColor');
				    	 }
				 		 break; 
		        }

				
	            var g:Graphics = graphics;
	            g.clear();

				drawRoundRect(0,0,unscaledWidth, unscaledHeight,0,_backgroundFillColor,_backgroundAlpha,null,"linear",null,null);
				
	            //drawRoundRect(0,0,unscaledWidth, unscaledHeight-10,0,_backgroundFillColor,_backgroundAlpha,null,"linear",null,null);
	            //drawRoundRect(0,unscaledHeight ,unscaledWidth,-unscaledHeight,6,_backgroundFillColor,_backgroundAlpha,null,"linear",null,null);
	            
	            
	            // corners
	            //g.beginFill(_backgroundFillColor,_backgroundAlpha);
	            //g.moveTo(-6,0);
	            //g.curveTo(-6,0, 0,6 );
	            //g.lineTo(unscaledWidth ,6);
	            //g.curveTo(unscaledWidth,6, unscaledWidth +6,0 );
	    		//g.endFill();
	                        
	      }
            
    }
}