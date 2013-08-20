
package org.ns.genericComponents.MDIDockable.events
{
	import flash.events.Event;
	
	import org.ns.genericComponents.MDIDockable.components.MDIDockableWindow;
	import org.ns.genericComponents.MDI.components.MDIWindow;
	import org.ns.genericComponents.MDIDockable.components.MDIDockableWindow;
	
	/**
	 * Event type dispatched by MDIWindow. Events will also be rebroadcast (as MDIManagerEvents)
	 * by the window's manager, if one is present.
	 */
	public class MDIDockableWindowEvent extends Event
	{
		public static const EXPANDED:String = "expanded";
		public static const COLLAPSED:String = "collapsed";
		
		public var window:MDIDockableWindow;
		
		public function MDIDockableWindowEvent(type:String, window:MDIDockableWindow, bubbles:Boolean = false)
		{
			super(type, bubbles, true);
			this.window = window;
		}
		
		override public function clone():Event
		{
			return new MDIDockableWindowEvent(type, window, bubbles);
		}
	}
}
