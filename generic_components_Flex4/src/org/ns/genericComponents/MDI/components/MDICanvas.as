package org.ns.genericComponents.MDI.components
{
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.MDI.managers.MDIManager;
	
	import spark.components.BorderContainer;
	
	/**
	 * Convenience class that allows quick MXML implementations by implicitly creating
	 * container and manager members of MDI. Will auto-detect MDIWindow children
	 * and add them to list of managed windows.
	 */
	public class MDICanvas extends BorderContainer
	{
		public var windowManager:MDIManager;
		
		public function MDICanvas()
		{
			super();
			windowManager = new MDIManager(this);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			var i:int=0
			for (i;i<this.numElements;i++)
			{
				var child:IVisualElement=this.getElementAt(i) as IVisualElement
				if(child is MDIWindow)
				{
					windowManager.add(child as MDIWindow);
				}
			}
			
			windowManager.showWindow(child as MDIWindow);
			
			removeEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		
	}
}
