
package org.ns.genericComponents.MDIDockable.events
{
	import flash.events.Event;
	
	import mx.effects.Effect;
	
	import org.ns.genericComponents.MDIDockable.components.MDIDockableWindow;
	import org.ns.genericComponents.MDI.components.MDIWindow;
	import org.ns.genericComponents.MDIDockable.managers.MDIDockableManager;
	import org.ns.genericComponents.MDI.managers.MDIManager;
	import org.ns.genericComponents.MDIDockable.components.MDIDockableWindow;
	import org.ns.genericComponents.MDIDockable.managers.MDIDockableManager;
	
	/**
	 * Event type dispatched by MDIManager.
	 */
	public class MDIDockableManagerEvent extends Event
	{
		public static const WINDOW_ADD:String = "windowAdd";
		
		public var window:MDIDockableWindow;
		public var manager:MDIDockableManager;

		
		public function MDIDockableManagerEvent(type:String, window:MDIDockableWindow, manager:MDIDockableManager,  bubbles:Boolean = false)
		{
			super(type, bubbles, true);
			this.window = window;
			this.manager = manager;
		}
		
		override public function clone():Event
		{
			return new MDIDockableManagerEvent(type, window, manager, bubbles);
		}
	}
}
