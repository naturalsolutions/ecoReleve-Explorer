package org.ns.genericComponents.MDIDockable.components
{
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.MDI.managers.MDIManager;
	import org.ns.genericComponents.MDIDockable.managers.MDIDockableManager;
	
	import spark.components.Group;
	import spark.layouts.VerticalLayout;
	

	public class MDIDockableCanvas extends Group
	{
		public var windowManager:MDIDockableManager;
		
		public function MDIDockableCanvas()
		{
			super();
			windowManager = new MDIDockableManager(this);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		
		private function initComponent(pEvent:FlexEvent):void
		{
			this.layout=new VerticalLayout()
			
			var i:int=0
			for (i;i<this.numElements;i++)
			{
				var child:IVisualElement=this.getElementAt(i) as IVisualElement	
				if(child is MDIDockableWindow)
				{
					var win:MDIDockableWindow=child as MDIDockableWindow
					windowManager.add(win);
				}
			}
			removeEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		//OVERRIDE

		
	}
}
