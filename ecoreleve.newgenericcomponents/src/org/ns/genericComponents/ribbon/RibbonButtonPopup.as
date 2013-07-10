package org.ns.genericComponents.ribbon
{
	import mx.events.FlexEvent;
	
	import spark.components.PopUpAnchor;
	import spark.effects.Fade;
	import spark.effects.Scale;
	
	public class RibbonButtonPopup extends PopUpAnchor
	{
		public function RibbonButtonPopup()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			this.popUpPosition="below"
			
			/*
				var fade:Fade=new Fade(this)
			fade.alphaFrom=0
			fade.alphaTo=1
				fade.duration=500
			this.setStyle('addedEffect',fade)
				*/
		}
		
	}
}