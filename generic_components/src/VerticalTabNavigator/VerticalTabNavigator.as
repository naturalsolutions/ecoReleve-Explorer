/*

The MIT License

Copyright (c) 2007-2008 Ali Rantakari

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package VerticalTabNavigator
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.containers.TabNavigator;
	import mx.core.EdgeMetrics;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.mx_internal;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	import mx.skins.ProgrammaticSkin;
	
	use namespace mx_internal;
	
	/**
	*  Vertical positioning of tabs at the side of this VerticalTabNavigator container.
	*  The possible values are <code>"top"</code>, <code>"middle"</code>,
	*  and <code>"bottom"</code>.
	*  The default value is <code>"top"</code>.
	*
	*  <p>If the value is <code>"top"</code>, the top edge of the tab bar
	*  is aligned with the top edge of the VerticalTabNavigator container.
	*  If the value is <code>"bottom"</code>, the bottom edge of the tab bar
	*  is aligned with the bottom edge of the VerticalTabNavigator container.
	*  If the value is <code>"middle"</code>, the tabs are centered on the side
	*  of the VerticalTabNavigator container.</p>
	*
	*  <p>To see a difference between the alignments,
	*  the total width of all the tabs must be less than
	*  the height of the VerticalTabNavigator container.</p>
	*/
	[Style(name="verticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]
	
	/**
	* A TabNavigator that positions the tab bar to either side
	* (left or right) of the component instead of at the top.
	* 
	* <p>The value of the <code>tabBarLocation</code> property determines
	* whether to position the tab bar to the left or the right side.</p>
	* 
	* <p>The <code>verticalAlign</code> style property can be used to 
	* align the tab bar with the top or the bottom of the component, or to
	* vertically center it.</p>
	* 
	* @see mx.containers.TabNavigator
	* 
	* @author Ali Rantakari
	*/
	public class VerticalTabNavigator extends TabNavigator {
		
		// copied from superclass:
		private static const MIN_TAB_WIDTH:Number = 30;
		
		private var _tabBarLocation:String = "left";
		private var _tabBarPosition:Number = 20;
		
		
		/**
		* Constructor.
		*/
		public function VerticalTabNavigator():void {
			super();
		}
		
		
		
		// BEGIN: private methods			-----------------------------------------------------------
		
		protected function get tabBarHeight():Number {
			return tabBar.getExplicitOrMeasuredWidth();
		}
		
		protected function get tabBarWidth():Number {
			var tabWidth:Number = getStyle("tabHeight");
			
			if (isNaN(tabWidth))
				tabWidth = tabBar.getExplicitOrMeasuredHeight();
			
			return tabWidth - 1;
		}
		
		protected function onChangeTab(event:Event):void 
		{
			var myCanvas:Canvas=this.getChildAt(event.currentTarget.selectedIndex) as Canvas
			myCanvas.width=myCanvas.minWidth			
		}
		protected function onChangeChild(event:IndexChangedEvent):void 
		{	
			//adjust the parent width to the selectedchild minWidth
			var myCanvas:Canvas=this.getChildAt(event.newIndex) as Canvas	
			this.width=myCanvas.minWidth
		}
		
		// --end--: private methods		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		
		
		
		
		
		
		// BEGIN: overridden methods			-----------------------------------------------------------
		
		
		/**
		* @private
		*/
		override protected function createChildren():void {
			
			super.createChildren();
			this.addEventListener(IndexChangedEvent.CHANGE,onChangeChild)					
			tabBar.addEventListener(ItemClickEvent.ITEM_CLICK,onChangeTab)
			if (tabBar) {
				tabBar.setStyle("paddingLeft", 0);
				tabBar.setStyle("paddingRight", 0);
			}

			
		}
		
		/**
		* @private
		*/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// determine the TabBar size based on the height of
			// the container instead of the width
			var vm:EdgeMetrics = viewMetrics;
			var h:Number = unscaledHeight - vm.top - vm.bottom;
			
			var th:Number = tabBarWidth + 1;
			var pw:Number = tabBar.getExplicitOrMeasuredWidth();
			tabBar.setActualSize(Math.min(h, pw), th);
			
			
			// rotate and position the TabBar based on the verticalAlign style
			// property and the tabBarLocation property
			var vAlign:String = getStyle("verticalAlign");
			var allowedVerticalAlignValues:Array = ["top", "bottom", "middle"];
			if (allowedVerticalAlignValues.indexOf(vAlign) == (-1)) vAlign="top";
			
			if (_tabBarLocation == "left") {
				if (tabBar.rotation != 270) tabBar.rotation = 270;
				
				if (vAlign == "top") tabBar.move(_tabBarPosition,tabBar.width);
				else if (vAlign == "middle") tabBar.move(_tabBarPosition,(unscaledHeight/2+tabBar.width/2));
				else if (vAlign == "bottom") tabBar.move(_tabBarPosition,unscaledHeight);
			}else{ 
				if (tabBar.rotation != 90) tabBar.rotation = 90;
				
				if (vAlign == "top") tabBar.move(unscaledWidth,0);
				else if (vAlign == "middle") tabBar.move(unscaledWidth,(unscaledHeight/2-tabBar.width/2));
				else if (vAlign == "bottom") tabBar.move(unscaledWidth,unscaledHeight-tabBar.width);
			}
		}
		
		/**
		* @private
		*/
		override protected function measure():void {
			super.measure();
			
			// remove the height addition made by superclass (tabs are
			// now on the side, not the top)
			var removedHeight:Number = tabBarWidth;
			measuredMinHeight -= removedHeight;
			measuredHeight -= removedHeight;
			
			// add width (same reason as above)
			var addedWidth:Number = tabBarWidth;
			measuredMinWidth += addedWidth;
			measuredWidth += addedWidth;
			
			// Make sure there is at least enough room
			// to draw all tabs at their minimum size.
			var tabWidth:Number = getStyle("tabWidth");
			if (isNaN(tabWidth)) tabWidth = 0;
			
			var minTabBarWidth:Number = numChildren * Math.max(tabWidth, MIN_TAB_WIDTH);
			
			// Add view metrics.
			var vm:EdgeMetrics = viewMetrics;
			minTabBarWidth += (vm.top + vm.bottom);
			
			// Add horizontal gaps.
			if (numChildren > 1) 
				minTabBarWidth += (getStyle("horizontalGap") * (numChildren - 1));
			
			if (measuredHeight < minTabBarWidth) measuredHeight = minTabBarWidth+tabBarWidth;
		}
		
		/**
		* @private
		*/
		override protected function get contentHeight():Number {
			// undo content height adjustment made by superclass
			return super.contentHeight + tabBarWidth;
		}
		
		/**
		* @private
		*/
		override protected function get contentWidth():Number {
			// adjust content width to accommodate the tab bar
			var vm:EdgeMetrics = viewMetricsAndPadding;
			
			var vmLeft:Number = vm.left;
			var vmRight:Number = vm.right;
			
			if (isNaN(vmLeft))
				vmLeft = 0;
			if (isNaN(vmRight))
				vmRight = 0;
			
			return unscaledWidth - tabBarWidth - vmLeft - vmRight;
		}
		
		/**
		* @private
		*/
		override protected function get contentX():Number {
			// adjust content position to accommodate the tab bar
			var paddingLeft:Number = getStyle("paddingLeft");
			
			if (isNaN(paddingLeft))
				paddingLeft = 0;
			
			if (_tabBarLocation == "left") return tabBarWidth + paddingLeft;
			else return paddingLeft;
		}
		
		/**
		* @private
		*/
		override protected function get contentY():Number {
			// undo content position adjustment made by superclass
			return super.contentY - tabBarWidth;
		}
		
		/**
		* @private
		*/
		override protected function adjustFocusRect(object:DisplayObject = null):void {
			super.adjustFocusRect(object);
			
			// Undo changes made by superclass:
			// "Adjust the focus rect so it is below the tabs"
			// - and redo the same thing with width instead of height
			var focusObj:IFlexDisplayObject = IFlexDisplayObject(getFocusObject());
			
			if (focusObj)
			{
				focusObj.setActualSize(focusObj.width - tabBarWidth, focusObj.height + tabBarWidth);
				
				if (_tabBarLocation == "left") focusObj.move(focusObj.x + tabBarWidth, focusObj.y - tabBarWidth);
				else focusObj.move(focusObj.x, focusObj.y - tabBarWidth);
				
				if (focusObj is IInvalidating)
					IInvalidating(focusObj).validateNow();
				
				else if (focusObj is ProgrammaticSkin)
					ProgrammaticSkin(focusObj).validateNow();
			}
		}
		
		/**
		* @private
		*/
		override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number):void {
			super.layoutChrome(unscaledWidth, unscaledHeight);
			
			// Undo changes made by superclass:
			// "Move our border so it leaves room for the tabs"
			// - and redo the same thing with width instead of height
			if (border)
			{
				var borderOffset:Number = tabBarWidth;
				border.setActualSize(unscaledWidth - borderOffset, unscaledHeight);
				if (_tabBarLocation == "left") border.move(borderOffset, 0);
				else border.move (0, 0);
			}
		}
		
		
		// --end--: overridden methods		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		
		
		
		
		
		
		// BEGIN: public methods			-----------------------------------------------------------
		
		/**
		* The location of the TabBar (left or right). Possible
		* values are <code>"left"</code> and <code>"right"</code>.
		*/
		public function get tabBarLocation():String {
			return _tabBarLocation;
		}
		/**
		* @private
		*/
		public function set tabBarLocation(aValue:String):void {
			if (aValue == "left" || aValue == "right") _tabBarLocation = aValue;
			else throw new ArgumentError("Value for tabBarLocation must be either \"left\" or \"right\"");
		}
		
		/**
		* The Position of the TabBar 
		*/
		public function get tabBarPosition():Number {
			return _tabBarPosition;
		}
		/**
		* @private
		*/
		public function set tabBarPosition(aValue:Number):void {
			_tabBarPosition = aValue;
		}
		
		// --end--: public methods		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		
		
		
		
	}
	
}