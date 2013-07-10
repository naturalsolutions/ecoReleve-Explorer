package ResizableCanvas
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.events.FlexMouseEvent
		
	import mx.binding.utils.*;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.LinkButton;
	import mx.core.UIComponent;
	import mx.effects.Resize;
	import mx.effects.WipeDown;
	import mx.effects.WipeUp;
	import mx.managers.CursorManager;
	
	public class ResizableCanvas extends Canvas
	{
		private var resizeEffect:Resize = new Resize();
		private var toolBar:HBox=new HBox();
		private var btn:Button=new Button;
		private var _backgroundAlpha:Number=new Number
		private var _borderThickness:Number=new Number
		private var state:String="close"
		
		private var min:LinkButton;
		private var demi:LinkButton;
		private var close:LinkButton;
		private var max:LinkButton;
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _buttonLabel:String="";
		
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
		
			
		public function set buttonLabel(value:String):void  
		{
			_buttonLabel = value;                                
		}
		
		[Bindable]
		public function get buttonLabel():String 
		{
			return _buttonLabel;
		}
			
			
		// Constructor
		public function ResizableCanvas():void
		{
			super();
			// initialization
			_dragStarted = false;
			_dragStartPosition = 0;
			_currentCursorId = -1;
			//resizable actif
			resizable=true;
		}

		
		override protected function createChildren():void 
		{
			super.createChildren()
			
			//get style value to retrieve when open panel
			if (getStyle("backgroundAlpha") != null){
	            _backgroundAlpha=getStyle("backgroundAlpha")
	        }
	        if (getStyle("borderThickness") != null){
				_borderThickness=getStyle("borderThickness")	
        	}
			
			//EFFECT
			resizeEffect.duration=500
			resizeEffect.target=this
			
			var wipeT:WipeUp=new WipeUp;
			var wipeB:WipeDown=new WipeDown;
			wipeT.duration=500
			wipeB.duration=500
			
			//ToolBar for resize			
			
			toolBar.setStyle("horizontalAlign","center");
			toolBar.setStyle("backgroundColor","white");
			
			close=new LinkButton;
			close.label="close";
			close.id="lkClose";
			close.setStyle("color","black");
			close.useHandCursor=true;
			close.styleName=lkBtnStyleName;
			close.addEventListener(MouseEvent.CLICK,onChangeSizePanel)			
				
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
				
			btn.label=_buttonLabel
			btn.visible=false
			btn.styleName="ResizableCanvasButton"
			btn.addEventListener(MouseEvent.CLICK,onOpenPanel)
			
			toolBar.addChild(close)
			toolBar.addChild(min)
			toolBar.addChild(demi)
			toolBar.addChild(max)
			
			this.addChild(toolBar);	
			this.addChild(btn);
			this.horizontalScrollPolicy="off";
			this.verticalScrollPolicy="off";		
		}

		private function onOpenPanel(event:MouseEvent):void
		{
			resizeEffect.widthFrom=btn.height + 5
			resizeEffect.widthTo=minWidth
			resizeEffect.play()
			state="open"
			invalidateDisplayList()
		}

		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight); 
			
			var component:UIComponent
			switch (state)
			{
				case "close":		
					this.resizable=false
					//masquer tous les children
					for each(component in this.getChildren()){
						component.visible=false
					}	
					//on s'assure que l bouton est visible
					btn.visible=true	
					//changer le style
					this.setStyle("backgroundAlpha",0);
					this.setStyle("borderThickness",0);
				break;
				case "open":
					this.resizable=true
					//masquer tous les children
					for each(component in this.getChildren()){
						component.visible=true
					}
					//on s'assure que l bouton est caché
					btn.visible=false
					//comme si a létat min
					min.enabled=false
					demi.enabled=true
					max.enabled=true
					
					//changer le style
					this.setStyle("backgroundAlpha",_backgroundAlpha);
					this.setStyle("borderThickness",_borderThickness);
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
			
			btn.rotation=-90
			btn.width=100
			btn.height=30
			btn.move(0, this.height - (this.height-btn.width)/2 )
			
		}

		private function onChangeSizePanel(event:MouseEvent):void
		{
			switch (event.currentTarget.id){
				case "lkClose":
					resizeEffect.widthFrom=this.width
					resizeEffect.widthTo=btn.height + 5
					resizeEffect.play()	
					state="close"
				break;
				case "lkMin":
					resizeEffect.widthFrom=this.width
					resizeEffect.widthTo=minWidth
					resizeEffect.play()
					state="min"
				break;
				case "lkDemi":
					resizeEffect.widthFrom=this.width
					resizeEffect.widthTo=maxWidth/2
					resizeEffect.play()
					state="demi"
				break;
				case "lkMax":
					resizeEffect.widthFrom=this.width
					resizeEffect.widthTo=maxWidth
					resizeEffect.play()
					state="max"
				break;
			}			
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
					_rightEdge.styleName = "ResizableCanvasRightEdge";
					
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
							this.width=_dragLastWidth + movement + 30;	
							width=_dragLastWidth + movement;
							state="custom"
						}else{
							width = minWidth;
							}
					} else {
						// check not to pass the maximum width
						// add 30 to the parent container (because of child width 100%)
						if (maxWidth > _dragLastWidth + movement){
							this.width=_dragLastWidth + movement + 30;
							width=_dragLastWidth + movement;
							state="custom"
						}else{
							width = maxWidth;}
					}
			}
			
		}

			

	}
}