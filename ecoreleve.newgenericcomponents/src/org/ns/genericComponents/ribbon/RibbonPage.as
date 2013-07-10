package org.ns.genericComponents.ribbon
{
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.ribbon.skin.RibbonPageSkin;
	
	import spark.components.NavigatorContent;
	
	public class RibbonPage extends NavigatorContent
	{
		public function RibbonPage()
		{
			super();
			setStyle("skinClass",RibbonPageSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function createChildren():void 
		{
			super.createChildren();			
		}		
		
		override protected function measure():void 
		{
			super.measure();
			//this.percentWidth=100
			this.percentHeight=100
		}
		
		//PRIVATE----------------------------------------------------------------------------------------------------
		
	}
}