
package org.ns.genericComponents.MDI.events
{
	import flash.events.Event;
	
	import org.ns.genericComponents.MDI.components.MDIWindow;
	import org.ns.genericComponents.MDI.managers.MDIManager;
	
	import mx.effects.Effect;
	
	/**
	 * Event type dispatched by MDIManager.
	 */
	public class MDIManagerEvent extends Event
	{
		public static const WINDOW_ADD:String = "windowAdd";
		public static const WINDOW_SHOW:String = "windowShow";
		
		public var window:MDIWindow;
		public var manager:MDIManager;

		
		public function MDIManagerEvent(type:String, window:MDIWindow, manager:MDIManager,  bubbles:Boolean = false)
		{
			super(type, bubbles, true);
			this.window = window;
			this.manager = manager;
		}
		
		override public function clone():Event
		{
			return new MDIManagerEvent(type, window, manager, bubbles);
		}
	}
}
