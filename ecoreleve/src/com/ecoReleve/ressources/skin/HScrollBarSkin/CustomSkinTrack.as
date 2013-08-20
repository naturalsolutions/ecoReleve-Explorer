package com.ecoReleve.ressources.skin.HScrollBarSkin
{
	import mx.skins.halo.ScrollTrackSkin;
	import flash.display.Graphics;
	import mx.graphics.RectangularDropShadow;
	
	public class CustomSkinTrack extends ScrollTrackSkin
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
			drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 0, 0xFFFFFF, 1.0);
		}
	}
}
