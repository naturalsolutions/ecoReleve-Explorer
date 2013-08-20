package org.ns.genericComponents.RedListWidget
{
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.*;
	
	import org.ns.genericComponents.RedListWidget.event.RedListEvent;
	import org.ns.genericComponents.RedListWidget.skin.RedListWidgetSkin;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	
	public class RedListWidget extends SkinnableContainer
	{
		
		[SkinPart(required="true")] public var imgLogo:Image;
		[SkinPart(required="true")] public var lblStatusCode:Label;
		[SkinPart(required="true")] public var lblStatusDescription:Label;
		[SkinPart(required="true")] public var lblYear:Label;
		[SkinPart(required="true")] public var lblVersion:Label;
		
		[SkinState("loading")]
		
		[Embed("./assets/move.gif")]
		private var customCursor:Class;
		
		public static const NORMAL:String 		= "normal";
		public static const LOADING:String 		= "loading";
		private var _state:String=NORMAL;
		
		private var isDraggable:Boolean=true;
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _searchSP:String;
		private var searchSPChanged:Boolean=false;
		
		[Bindable]
		public function get searchSP():String
		{
			return _searchSP;
		}
		
		public function set searchSP(value:String):void 
		{
			_searchSP=value
			searchSPChanged=true;
			invalidateProperties();
		}
		
		//Constructor
		public function RedListWidget()
		{
			setStyle("skinClass",RedListWidgetSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			this.contentGroup.addEventListener(MouseEvent.MOUSE_DOWN, startDragging );
			this.contentGroup.addEventListener(MouseEvent.MOUSE_UP, stopDragging );
			this.contentGroup.addEventListener(MouseEvent.ROLL_OVER,onComponentOverHandler)
			this.contentGroup.addEventListener(MouseEvent.ROLL_OUT,onComponentOutHandler)
		}
		
		//OVERRIDE
		
		protected override function partAdded( partName:String, instance:Object ) : void
		{
			super.partAdded( partName, instance );
		}
		
		protected override function partRemoved( partName:String, instance:Object ) : void
		{
			super.partRemoved( partName, instance );
		}
		
		override protected function getCurrentSkinState():String
		{ 			
			if (_state == NORMAL){ 
				return "normal" 
			}
			if (_state == LOADING){ 
				return "loading" 
			}
			return "normal"; 
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			//if searchSP change
			if (searchSPChanged==true && _searchSP!=""){
				searchRedList();
				searchSPChanged=false
			}
		}
		
		//FUNCTIONS
		private function searchRedList():void
		{	
			this.lblStatusCode.text="";
			this.lblStatusDescription.text="";
			this.lblYear.text="";
			this.lblVersion.text="";
			
			var redListSearch:RedListSearch=new RedListSearch();
			redListSearch.addEventListener(RedListEvent.REDLIST_SEARCH_RESULT,resultHandler);
			redListSearch.addEventListener(RedListEvent.PARSE_ERROR,parseErrorHandler);
			redListSearch.search(_searchSP);
			
			_state=LOADING
			invalidateSkinState();
		}
		
		private function resultHandler(event:RedListEvent):void
		{
			var redListItem:RedListItem=event.data as RedListItem	
			this.lblStatusCode.text=redListItem.category_code;
			this.lblStatusDescription.text=redListItem.category_title;
			this.lblYear.text=redListItem.modified_year;
			this.lblVersion.text=redListItem.category_version;
			
			
			_state=NORMAL
			invalidateSkinState();
		}
		
		private function parseErrorHandler(event:RedListEvent):void
		{
			trace('error')
			_state= NORMAL
			invalidateSkinState();
		}
		
		private function showCursor():void
		{
			CursorManager.setCursor(customCursor, CursorManagerPriority.HIGH, 3, 2);
		}
		
		private function removeCursor():void
		{
			CursorManager.removeAllCursors();
		}
		
		//HANDLERS
		private function onComponentOverHandler(event:MouseEvent):void
		{
			showCursor()
		}
		
		private function onComponentOutHandler(event:MouseEvent):void
		{
			removeCursor()
		}
		
		private function startDragging( event:MouseEvent ):void
		{
			if ( !DragManager.isDragging && isDraggable){
				if (event.target is  UIComponent ){
					DragManager.acceptDragDrop(event.target as UIComponent)
					startDrag();
				}
			}
		}
		
		private function stopDragging( event:MouseEvent ):void
		{
			//if (DragManager.isDragging){
			stopDrag();	
		}
	}
}