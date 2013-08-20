package org.ns.genericComponents.MDI.managers
{
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.utils.ArrayUtil;
	
	import org.ns.genericComponents.MDI.components.MDIWindow;
	import org.ns.genericComponents.MDI.events.MDIManagerEvent;
	import org.ns.genericComponents.MDI.events.MDIWindowEvent;
	
	import spark.components.Application;
	import spark.components.BorderContainer;
	import spark.effects.Fade;
	
	[Event(name="windowAdd", type="org.ns.genericComponents.MDI.events.MDIManagerEvent")]
	[Event(name="windowShow", type="org.ns.genericComponents.MDI.events.MDIManagerEvent")]
	public class MDIManager extends EventDispatcher
	{
		/**
		 *  @private
		 *  the managed window stack
		 */
		[Bindable]
		public var windowList:Array = new Array();
		
		private var _container:BorderContainer;
		public function get container():BorderContainer
		{
			return _container;
		}
		public function set container(value:BorderContainer):void
		{
			this._container = value;
		}
		
		private var _currentWindow:MDIWindow;
		public function get currentWindow():MDIWindow
		{
			return _currentWindow;
		}
		public function set currentWindow(value:MDIWindow):void
		{
			this._currentWindow = value;
		}
		
		
		public function MDIManager(container:BorderContainer):void
		{
			this.container = container;
		}
		
		public function add(window:MDIWindow):void
		{
			if(windowList.indexOf(window) < 0)
			{
				window.windowManager = this;
				
				this.windowList.push(window);

				// to accomodate mxml impl
				if(window.parent == null)
				{
					this.container.addChild(window);
				}             
				
				this.dispatchEvent(new MDIManagerEvent(MDIManagerEvent.WINDOW_ADD, window, this,true));
			}
		}
                             

		public function showWindow(window:MDIWindow):void
		{
			if (currentWindow!=window){
				if (currentWindow!=null){
					currentWindow.visible=false;
				}
				window.visible=true;
				
				currentWindow=window;
				this.dispatchEvent(new MDIManagerEvent(MDIManagerEvent.WINDOW_SHOW,window,this,true));
			}
			
		}
  
	}
}
