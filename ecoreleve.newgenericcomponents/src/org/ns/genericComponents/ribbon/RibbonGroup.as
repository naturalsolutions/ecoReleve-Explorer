package org.ns.genericComponents.ribbon
{
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.ribbon.skin.RibbonGroupSkin;
	
	import spark.components.Panel;
	
	public class RibbonGroup extends Panel
	{
		public function RibbonGroup()
		{
			super();
			setStyle("skinClass",RibbonGroupSkin);
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
			this.percentHeight=100
		}
		
		//PRIVATE----------------------------------------------------------------------------------------------------
		
	}
}