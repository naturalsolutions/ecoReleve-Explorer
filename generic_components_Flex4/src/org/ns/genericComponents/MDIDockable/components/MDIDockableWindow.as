package org.ns.genericComponents.MDIDockable.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.SandboxMouseEvent;
	import mx.managers.DragManager;
	
	import org.ns.genericComponents.MDIDockable.events.MDIDockableWindowEvent;
	import org.ns.genericComponents.MDIDockable.managers.MDIDockableManager;
	import org.ns.genericComponents.MDIDockable.skin.MDIDockableWindowSkin;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Panel;
	import spark.primitives.Rect;

	public class MDIDockableWindow extends Panel
	{   
		[SkinPart(required="true")] public var imgLogo:Image;
		[SkinPart(required="true")] public var dragHandle:Group;
		[SkinPart(required="true")] public var resizeHandle:Group;
		
		public static const EXPANDED:String 	= "expanded";
		public static const NORMAL:String 		= "normal";
		private var _state:String=NORMAL;
		
		public var windowManager:MDIDockableManager;
		public var windowContainer:MDIDockableCanvas;

		protected var initWidth:Number = NaN;
		protected var initHeight:Number = NaN;
		protected var initXPosition:Number=NaN;
		protected var initYPosition:Number=NaN;
		
		private var isDraggable:Boolean=true;
		private var isResizable:Boolean=true;
		
		private var _logo:Class;		
		private var clickOffset:Point;
		private var prevWidth:Number;
		private var prevHeight:Number;
		private var posX:Number;
		private var posY:Number;
		
		public function MDIDockableWindow()
		{
			super();
			setStyle("skinClass",MDIDockableWindowSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
			
			//store initial size
			initWidth = this.width;
			initHeight= this.height;

			initXPosition=x;
			initYPosition=y;
			isDraggable=true;
			isResizable=true;
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{	
				
		}
		
		//OVERRIDE
		
		protected override function partAdded( partName:String, instance:Object ) : void
		{
			super.partAdded( partName, instance );
			
			if (instance == imgLogo)
			{
				if (_logo!=null){
					imgLogo.source=_logo;
				}
				instance.addEventListener(MouseEvent.CLICK,imgLogo_mouseClickHandler);
			}
			if (instance==dragHandle)
			{
				instance.addEventListener(MouseEvent.MOUSE_DOWN, titleBarGroup_mouseDownHandler );
				instance.addEventListener(MouseEvent.MOUSE_UP, titleBarGroup_mouseUpHandler );

			}
			
			if (instance == resizeHandle)
			{
				instance.addEventListener(MouseEvent.MOUSE_DOWN, resizeHandle_mouseDownHandler);
			}
		}
		
		protected override function partRemoved( partName:String, instance:Object ) : void
		{
			super.partRemoved( partName, instance );
			
			if (instance == imgLogo)
			{
				instance.removeEventListener(MouseEvent.CLICK,imgLogo_mouseClickHandler);
			}
			if (instance ==dragHandle)
			{
				instance.removeEventListener(MouseEvent.MOUSE_DOWN, titleBarGroup_mouseDownHandler );
				instance.removeEventListener(MouseEvent.MOUSE_UP, titleBarGroup_mouseUpHandler );	
			}
			
			if (instance == resizeHandle)
			{
				instance.removeEventListener(MouseEvent.MOUSE_DOWN, resizeHandle_mouseDownHandler);
			}
		}


		
		override protected function getCurrentSkinState():String
		{
			var skinState:String = super.getCurrentSkinState();
			
			switch(_state)
			{
				case EXPANDED:
					//this.y=initYPosition
					//this.x=initXPosition
					this.width=this.minWidth
					this.height=this.minHeight
					skinState=EXPANDED
					break;
				case NORMAL:
					//this.y=initYPosition
					//this.x=initXPosition
					this.width=32
					this.height=32
					this.percentHeight=NaN
					skinState=NORMAL
					break;
			}
			
			return skinState;
		}	
		
		//HANDLERS
		private function imgLogo_mouseClickHandler(event:MouseEvent):void
		{
			if (_state==EXPANDED){
				_state=NORMAL
				invalidateSkinState();
				this.dispatchEvent(new MDIDockableWindowEvent(MDIDockableWindowEvent.COLLAPSED,this,true));
			}else if(_state==NORMAL){
				_state=EXPANDED
				invalidateSkinState();
				this.dispatchEvent(new MDIDockableWindowEvent(MDIDockableWindowEvent.EXPANDED,this,true));
			}
			
		}
		
		protected function titleBarGroup_mouseDownHandler( event:MouseEvent ):void
		{
			if ( !DragManager.isDragging && isDraggable){
				DragManager.acceptDragDrop(this.windowContainer)
				startDrag();
			}
		}
		
		protected function titleBarGroup_mouseUpHandler( event:MouseEvent ):void
		{
			if ( DragManager.isDragging){
				stopDrag();
			}
			
		}

		protected function resizeHandle_mouseDownHandler(event:MouseEvent):void
		{
			if (enabled && isResizable && !clickOffset)
			{        
				clickOffset = new Point(event.stageX, event.stageY);
				
				prevWidth = width;
				prevHeight = height;
				
				var sbRoot:DisplayObject = systemManager.getSandboxRoot();
				
				sbRoot.addEventListener(MouseEvent.MOUSE_MOVE, resizeHandle_mouseMoveHandler, true);
				sbRoot.addEventListener(MouseEvent.MOUSE_UP, resizeHandle_mouseUpHandler, true);
				sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, resizeHandle_mouseUpHandler)
			}
		}
		
		protected function resizeHandle_mouseMoveHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (!clickOffset)
			{
				return;
			}
			
			var newWidth:Number = prevWidth + (event.stageX - clickOffset.x);;
			var newHeight:Number = prevHeight + (event.stageY - clickOffset.y);
			
			if (newWidth>this.minWidth && newWidth<this.maxWidth){
				width = newWidth;
			}
			if (newHeight>this.minHeight && newHeight<this.maxHeight){
				height = newHeight;
			}
			
			event.updateAfterEvent();
		}

		protected function resizeHandle_mouseUpHandler(event:Event):void
		{
			clickOffset = null;
			prevWidth = NaN;
			prevHeight = NaN;
			
			var sbRoot:DisplayObject = systemManager.getSandboxRoot();
			
			sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE, resizeHandle_mouseMoveHandler, true);
			sbRoot.removeEventListener(MouseEvent.MOUSE_UP, resizeHandle_mouseUpHandler, true);
			sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, resizeHandle_mouseUpHandler);
		}
		
		//FUNCTIONS		
		public function dockWindow():void
		{
			this.x=0
			this.y=0
			this.isPopUp=false
		}
		
		
		//GETTER/SETTER
		public function set logo(value:Class):void 
		{
			_logo = value;
		}
	}
}
