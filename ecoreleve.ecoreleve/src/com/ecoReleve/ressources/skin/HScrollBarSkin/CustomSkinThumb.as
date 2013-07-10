package com.ecoReleve.ressources.skin.HScrollBarSkin
{
	import mx.skins.halo.ScrollThumbSkin;
	import flash.display.Graphics;
	
	public class CustomSkinThumb extends ScrollThumbSkin
	{
		
		override public function get measuredWidth():Number 
		{
			return 8; 
		}
		override public function get measuredHeight():Number 
		{
			return 10;
		}

		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			// Fill with zero alpha: if no fill, mouse events are not recognized
			drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 0, 0x000000, 1.0);
		}		
	}
}
