package com.ecoReleve.ressources.skin.VerticalTabNavigatorSkin
{
import mx.skins.ProgrammaticSkin;
import flash.display.Graphics;
import mx.styles.StyleManager;
   
	public class FirstTabSkin extends ProgrammaticSkin 
	{
		public var _backgroundFillColor:Number;
		public var _backgroundAlpha:Number;

	    public function FirstTabSkin():void 
	    {
	            
	        super();
	        _backgroundFillColor=0x5E81A4
	        _backgroundAlpha=0
	    }
	    
	    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
	    {
	        
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	        
	            var g:Graphics = graphics;
	            g.clear();
	                        
	      }
            
    }
}