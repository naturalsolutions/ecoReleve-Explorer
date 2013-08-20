package org.ns.genericComponents.MDI.components
{

	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.MDI.events.MDIWindowEvent;
	import org.ns.genericComponents.MDI.managers.MDIManager;
	import org.ns.genericComponents.MDI.skin.MDIWindowSkin;
	
	import spark.components.Panel;
	import spark.effects.Fade;


	public class MDIWindow extends Panel
	{               

		public var windowManager:MDIManager;		
		
		public function MDIWindow()
		{
			super();
			this.percentWidth= 100
			this.percentHeight = 100
			this.visible=false
				
			this.setStyle("showEffect","Fade")
			this.setStyle("hideEffect","Fade")	
			this.setStyle("skinClass",MDIWindowSkin);
			
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{	
			
		}
	}
}
