package org.ns.genericComponents.MDIDockable.managers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.utils.ArrayUtil;
	
	import org.ns.genericComponents.MDIDockable.components.MDIDockableCanvas;
	import org.ns.genericComponents.MDIDockable.components.MDIDockableWindow;
	import org.ns.genericComponents.MDIDockable.events.MDIDockableManagerEvent;
	import org.ns.genericComponents.MDIDockable.events.MDIDockableWindowEvent;
	
	import spark.components.Application;
	import spark.components.Group;
	

	public class MDIDockableManager extends EventDispatcher
	{
		/**
		 *  @private
		 *  the managed window stack
		 */
		[Bindable]
		public var windowList:Array = new Array();
		
		private var _container:MDIDockableCanvas;
		public function get container():MDIDockableCanvas
		{
			return _container;
		}
		public function set container(value:MDIDockableCanvas):void
		{
			this._container = value;
		}
		
		public function MDIDockableManager(container:MDIDockableCanvas):void
		{
			this.container = container;
		}
	
		public function add(window:MDIDockableWindow):void
		{
			if(windowList.indexOf(window) < 0)
			{
				//attach manager to the window
				window.windowManager = this;
				//atach canvas container to the window
				window.windowContainer=this.container;
				
				//add all window listener
				this.addListeners(window);
				
				//add window to the list
				this.windowList.push(window);

					// to accomodate mxml impl
					if(window.parent == null)
					{
						this.container.addChild(window);
					}
             
				
				dispatchEvent(new MDIDockableManagerEvent(MDIDockableManagerEvent.WINDOW_ADD, window, this));
				bringToFront(window);
			}
		}
		
		/**
		 * Brings a window to the front of the screen. 
		 * 
		 *  @param win Window to bring to front
		 * */
		public function bringToFront(window:MDIDockableWindow):void
		{		

				this.container.setElementIndex(window,this.container.numElements - 1)

		}
		
		/**
		 * Removes all windows from managed window stack; 
		 * */
		public function removeAll():void
		{       
			
			for each(var window:MDIDockableWindow in windowList)
			{
				container.removeElement(window);
	
			}
			
			this.windowList = new Array();
		}
		
		/**
		 *  Removes a window instance from the managed window stack 
		 *  @param window:MDIWindow Window to remove 
		 */
		public function remove(window:MDIDockableWindow):void
		{       
			
			var index:int = ArrayUtil.getItemIndex(window, this.windowList);
			
			windowList.splice(index, 1);

			container.removeElement(window);
			
			// set focus to newly-highest depth window
			for(var i:int = container.numElements - 1; i > -1; i--)
			{
				var dObj:IVisualElement = container.getElementAt(i);
				if(dObj is MDIDockableWindow)
				{
					bringToFront(MDIDockableWindow(dObj));
					return;
				}
			}
		}                               

		public function showWindow(window:MDIDockableWindow):void
		{
			window.percentWidth= this.container.width;
			window.percentHeight = this.container.height;
			
			bringToFront(window);
		}
		
		private function addListeners(window:MDIDockableWindow):void
		{
			//window.addEventListener(MDIWindowEvent.MINIMIZE, windowEventProxy, false, EventPriority.DEFAULT_HANDLER);
		}
  
	}
}
