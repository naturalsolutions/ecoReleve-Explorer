////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 Andrei Ionescu
//  http://www.flexer.info/
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, misuse,
//  copy, modify, merge, publish, distribute, love, hate, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to no conditions whatsoever.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE. DON'T SUE ME FOR SOMETHING DUMB
//  YOU DO. 
//
//  PLEASE DO NOT DELETE THIS NOTICE.
//
////////////////////////////////////////////////////////////////////////////////

package VerticalTabNavigator
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.*;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.TabNavigator;
	import mx.controls.Button;
	import mx.controls.LinkButton;
	import mx.core.UIComponent;
	import mx.effects.Resize;
	import mx.managers.CursorManager;
	
	public class VerticalTabPanel extends Canvas
	{
		private var resizeEffect:Resize = new Resize();
		
		private var min:LinkButton;
		private var demi:LinkButton;
		private var close:LinkButton;
		private var max:LinkButton;
		private var state:String="close"
		private var toolBar:HBox=new HBox();
		
		// right edge of the canvas
		private var _rightEdge:Button;
		// if it is resizable
		// it can be set as not resizable
		private var _resizable:Boolean;
		// the cursor id
		private var _currentCursorId:int;
		// true if the drag started
		private var _dragStarted:Boolean;
		// the position before starting to drag
		private var _dragStartPosition:int;
		// last width of our canvas before starting to drag
		private var _dragLastWidth:int;
		// cursor image
		[Embed("assets/img/h_resize.gif")]
		private var hResizeCursor:Class;
		
		private var lkBtnStyleName:String="styleLkButton"
		
		// Constructor
		public function VerticalTabPanel():void
		{
			super();
			// initialization
			_dragStarted = false;
			_dragStartPosition = 0;
			_currentCursorId = -1;
			// by default our canvas is resizable
			resizable = true;
		}
		
		
		override protected function createChildren():void 
		{
			super.createChildren()
			
			//EFFECT
			resizeEffect.duration=500
			
				
			toolBar.setStyle("horizontalAlign","center");
			toolBar.setStyle("backgroundColor","white");
			
			close=new LinkButton;
			close.label="close";
			close.id="lkClose";
			close.useHandCursor=true;
			close.styleName=lkBtnStyleName;
			close.addEventListener(MouseEvent.CLICK,onChangeSizePanel)
			close.setStyle("color","black");
			
			min=new LinkButton;
			min.id="lkMin";
			min.label="min";
			min.useHandCursor=true;
			min.styleName=lkBtnStyleName;
			min.addEventListener(MouseEvent.CLICK,onChangeSizePanel)
			min.setStyle("color","black");
			
			demi=new LinkButton;
			demi.id="lkDemi";
			demi.label="1/2";
			demi.useHandCursor=true;
			demi.styleName=lkBtnStyleName;
			demi.addEventListener(MouseEvent.CLICK,onChangeSizePanel)
			demi.setStyle("color","black");
			
			max=new LinkButton;
			max.label="max";
			max.id="lkMax";
			max.useHandCursor=true;
			max.styleName=lkBtnStyleName;
			max.addEventListener(MouseEvent.CLICK,onChangeSizePanel)
			max.setStyle("color","black");		
			
			toolBar.addChild(close)
			toolBar.addChild(min)
			toolBar.addChild(demi)
			toolBar.addChild(max)
			
			this.addChild(toolBar);				
		}

		private function onChangeSizePanel(event:MouseEvent):void
		{
			var myTabNav:TabNavigator=this.parent as TabNavigator
			resizeEffect.target=myTabNav
			switch (event.currentTarget.id){
				case "lkClose":
					resizeEffect.widthFrom=myTabNav.width
					resizeEffect.widthTo=myTabNav.getStyle("tabBarPosition") as int
					resizeEffect.play()
					myTabNav.selectedIndex=0
					state="close"
				break;
				case "lkMin":
					resizeEffect.widthFrom=myTabNav.width
					resizeEffect.widthTo=minWidth
					resizeEffect.play()
					this.percentWidth=100
					state="min"
				break;
				case "lkDemi":
					resizeEffect.widthFrom=myTabNav.width
					resizeEffect.widthTo=maxWidth/2
					resizeEffect.play()
					this.percentWidth=100
					state="demi"
				break;
				case "lkMax":
					resizeEffect.widthFrom=myTabNav.width
					resizeEffect.widthTo=maxWidth
					resizeEffect.play()
					this.percentWidth=100
					state="max"
				break;
			}			
		}

		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight); 

			switch (state)
			{
				case "close":
					//comme si a létat min
					min.enabled=false
					demi.enabled=true
					max.enabled=true
					break;
				case "min":
					min.enabled=false
					demi.enabled=true
					max.enabled=true
					break;
				case "demi":
					min.enabled=true
					demi.enabled=false
					max.enabled=true
					break;
				case "max":
					min.enabled=true
					demi.enabled=true
					max.enabled=false
					break;
				case "custom":
					min.enabled=true
					demi.enabled=true
					max.enabled=true
					break;
			}
			
			toolBar.width=200;
			var w:uint=this.width -200 -  this.borderMetrics.right/2 - 5 //getStyle("paddingRight") - getStyle("borderThickness")/2 -2
			var h:uint=0 + this.borderMetrics.top/2 //getStyle("paddingTop")+ getStyle("borderThickness")/2
			toolBar.move(w,h);
			
		}
		
		// setter to enable/disable the resize functionality
		public function set resizable(value:Boolean):void
		{
			// if the value is changed
			if (value != _resizable)
			{
				if (value)
				{
					// resizable = true

					// we add the right edge which is a button
					_rightEdge = new Button();
					// no label
					_rightEdge.label = "";
					// no tooltip
					_rightEdge.tabEnabled = false;
					_rightEdge.toolTip = null;
					_rightEdge.setStyle("right", 0);
					_rightEdge.setStyle("verticalCenter",0);
					_rightEdge.percentHeight = 90;
					_rightEdge.width = 9;
					// set its style
					// in this style we set the skin to not show anything
					_rightEdge.styleName = "canvasRightEdge";
					
					// used to display the resize icon
					_rightEdge.addEventListener(MouseEvent.MOUSE_OVER, handleResizeOver, false, 0 ,true);
					// used to display the resize icon
					_rightEdge.addEventListener(MouseEvent.MOUSE_MOVE, handleResizeOver, false, 0 ,true);
					// used to hide the resize icon
					_rightEdge.addEventListener(MouseEvent.MOUSE_OUT, handleResizeOut, false, 0 ,true);
					// used to start the drag
					// we save the initial position and width
					_rightEdge.addEventListener(MouseEvent.MOUSE_DOWN, handleDragStart, false, 0 ,true);
					// used for real rezise and other important stuff
					_rightEdge.addEventListener(Event.ENTER_FRAME, handleDragMove, false, 0 ,true);
					// used to stop the drag - mouse up on the edge
					_rightEdge.addEventListener(MouseEvent.MOUSE_UP, handleDragStop, false, 0 ,true);
					
					addChild(_rightEdge);
					
				} else {
					// resizable = false
					
					// we check if the events are created and we remove them				
					if (_rightEdge.hasEventListener(MouseEvent.MOUSE_OVER))
						_rightEdge.removeEventListener(MouseEvent.MOUSE_OVER, handleResizeOver);
					if (_rightEdge.hasEventListener(MouseEvent.MOUSE_OUT))
						_rightEdge.removeEventListener(MouseEvent.MOUSE_OUT, handleResizeOut);
					if (_rightEdge.hasEventListener(MouseEvent.MOUSE_DOWN))
						_rightEdge.removeEventListener(MouseEvent.MOUSE_DOWN, handleDragStart);
					if (_rightEdge.hasEventListener(MouseEvent.MOUSE_UP))
						_rightEdge.removeEventListener(MouseEvent.MOUSE_UP, handleDragStop);
					if (_rightEdge.hasEventListener(Event.ENTER_FRAME))
						_rightEdge.removeEventListener(Event.ENTER_FRAME, handleDragMove);
					// we check if the stage if created and if it has the event listener
					if (stage != null && stage.hasEventListener(MouseEvent.MOUSE_UP))
						stage.removeEventListener(MouseEvent.MOUSE_UP, handleDragStop);
					// we remove the edge
					removeChild(_rightEdge);
				}
				// set the resizable value
				// used to see if the value is changed
				_resizable = value;
			}
		}
		
		// event handler to show the resize cursor
		private function handleResizeOver(event:MouseEvent):void
		{
			// check if we already have the resize cursor set
			if (_currentCursorId == -1)
				_currentCursorId = CursorManager.setCursor(hResizeCursor,2,-10);
		}
		
		// event handler to hide the resize cursor
		private function handleResizeOut(event:MouseEvent):void
		{
			if (!_dragStarted) {
				CursorManager.removeCursor(_currentCursorId);
				_currentCursorId = -1;
			}
		}
		
		// event handler to start the drag
		private function handleDragStart(event:MouseEvent):void
		{
			_dragStarted = true;
			
			//add listener for canceled resize
			this.addEventListener(MouseEvent.MOUSE_UP, handleDragStop, false, 0 ,true);
			this.addEventListener(MouseEvent.CLICK, handleDragStop, false, 0 ,true);
			
			// we save the initial position and width
			_dragStartPosition = stage.mouseX;
			_dragLastWidth = width;
		}

		// event handler to stop the drag
		private function handleDragStop(event:MouseEvent):void
		{
			_dragStarted = false;
			
			//remove listener
			if (this.hasEventListener(MouseEvent.CLICK))
				this.removeEventListener(MouseEvent.CLICK, handleDragStop);
			if (this.hasEventListener(MouseEvent.MOUSE_UP))
				this.removeEventListener(MouseEvent.MOUSE_UP, handleDragStop);
			
			CursorManager.removeCursor(_currentCursorId);
			_currentCursorId = -1;
		}
		
		// event handler for real rezise and other important stuff
		private function handleDragMove(event:Event):void
		{
			// we put the edge always on the top of the other children
			if (getChildIndex(_rightEdge) < numChildren-1)
				setChildIndex(_rightEdge,numChildren-1);
			// we add the event to stop the drag also on the stage
			// we cannot add this event in set resizable because the
			// stage is not created because set resizable is done at
			// constructor time and stage is set after adding our
			// canvas to the application
			if (stage!=null){
				if (!stage.hasEventListener(MouseEvent.MOUSE_UP))
					stage.addEventListener(MouseEvent.MOUSE_UP, handleDragStop, false, 0 ,true);
			}

			// we resize our canvas only if drag started
			if (_dragStarted)
			{
					// get the amount of movement
					// difference between the current mouse x position relative 
					// to the stage and the saved position at mouse down event
					var movement:int = (stage.mouseX - _dragStartPosition);
					// if the canvas is positioned relative to the center
					// the width will be changed in both left and right directions
					// so we will double the movement
					if (getStyle("horizontalCenter") != undefined)
					{
						movement *= 2;
					}
					// if we move to the left
					if (movement <= 0)
					{
						// check not to pass the minimum width
						// add 30 to the parent container (because of child width 100%)
						if (minWidth < _dragLastWidth + movement){
							this.parent.width=_dragLastWidth + movement + 30;	
							width=_dragLastWidth + movement;
							state="custom"
						}else{
							width = minWidth;
							}
					} else {
						// check not to pass the maximum width
						// add 30 to the parent container (because of child width 100%)
						if (maxWidth > _dragLastWidth + movement){
							this.parent.width=_dragLastWidth + movement + 30;
							width=_dragLastWidth + movement;
							state="custom"
						}else{
							width = maxWidth;}
					}
			}
			
		}

			

	}
}