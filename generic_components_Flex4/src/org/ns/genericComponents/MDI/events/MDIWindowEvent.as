
package org.ns.genericComponents.MDI.events
{
	import flash.events.Event;
	
	import org.ns.genericComponents.MDI.components.MDIWindow;
	
	/**
	 * Event type dispatched by MDIWindow. Events will also be rebroadcast (as MDIManagerEvents)
	 * by the window's manager, if one is present.
	 */
	public class MDIWindowEvent extends Event
	{
		public static const MINIMIZE:String = "minimize";
		public static const RESTORE:String = "restore";
		public static const MAXIMIZE:String = "maximize";
		public static const CLOSE:String = "close";
		
		public static const FOCUS_START:String = "focusStart";
		public static const FOCUS_END:String = "focusEnd";
		public static const DRAG_START:String = "dragStart";
		public static const DRAG:String = "drag";
		public static const DRAG_END:String = "dragEnd";
		public static const RESIZE_START:String = "resizeStart";
		public static const RESIZE:String = "resize";
		public static const RESIZE_END:String = "resizeEnd";
		
		public var window:MDIWindow;
		
		public function MDIWindowEvent(type:String, window:MDIWindow, bubbles:Boolean = false)
		{
			super(type, bubbles, true);
			this.window = window;
		}
		
		override public function clone():Event
		{
			return new MDIWindowEvent(type, window, bubbles);
		}
	}
}
