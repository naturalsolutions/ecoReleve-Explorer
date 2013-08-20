package org.ns.genericComponents.GoogleImageWidget
{
	import be.boulevart.google.ajaxapi.search.GoogleSearchResult;
	import be.boulevart.google.ajaxapi.search.images.GoogleImageSearch;
	import be.boulevart.google.ajaxapi.search.images.data.GoogleImage;
	import be.boulevart.google.events.GoogleAPIErrorEvent;
	import be.boulevart.google.events.GoogleApiEvent;
	
	import com.adobe.utils.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.*;
	
	import org.ns.genericComponents.GoogleImageWidget.skin.GoogleImageSkin;
	
	import spark.components.Group;
	import spark.components.HSlider;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.Panel;
	import spark.components.SkinnableContainer;
	import spark.primitives.Rect;
	
	public class GoogleImageWidget extends SkinnableContainer
	{
		[SkinPart(required="true")] public var imgPrevious:Image;
		[SkinPart(required="true")] public var imgNext:Image;
		[SkinPart(required="true")] public var img:Image;
		[SkinPart(required="true")] public var slider:HSlider;
		[SkinPart(required="true")] public var lblCount:Label;
		
		[SkinState("loading")]
		
		public static const LOADING:String 		= "loading";
		public static const OUT:String 			= "out";
		public static const NORMAL:String 		= "normal";
		private var _state:String=NORMAL;
		
		[Embed("./assets/move.gif")]
		private var customCursor:Class;
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _searchText:String;
		private var searchTextChanged:Boolean=false;
		
		[Inspectable(category="General", type="int", defaultValue="5")]
		private var _nbResult:int=5;
		private var nbResultChanged:Boolean=false;
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _strDomain:String="";
		private var strDomainChanged:Boolean=false;
		
		private var _results:Array
		private var _loader:Loader;
		private var _currentIndex:Number=0;
		private var isDraggable:Boolean=true;
		
		[Bindable]
		public function get searchText():String
		{
			return _searchText;
		}
		
		public function set searchText(value:String):void 
		{
			_searchText=value
			searchTextChanged=true;
			this.invalidateProperties();
		}
		
		[Bindable]
		public function get nbResult():int
		{
			return _nbResult;
		}
		
		public function set nbResult(value:int):void 
		{
			_nbResult=value
			nbResultChanged=true;
			this.invalidateProperties();
		}
		
		[Bindable]
		public function get strDomain():String
		{
			return _strDomain;
		}
		
		public function set strDomain(value:String):void 
		{
			_strDomain=value
			strDomainChanged=true;
			this.invalidateProperties();
		}
		
		//Constructor
		public function GoogleImageWidget()
		{
			setStyle("skinClass",GoogleImageSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			this.contentGroup.addEventListener(MouseEvent.ROLL_OVER,onRollOverHandler)
			this.contentGroup.addEventListener(MouseEvent.ROLL_OUT,onRollOutHandler)
		}
		
		//OVERRIDE
		
		protected override function partAdded( partName:String, instance:Object ) : void
		{
			super.partAdded( partName, instance );
			
			if (instance==imgPrevious)
			{
				instance.addEventListener(MouseEvent.CLICK,onPreviousHandler)
			}
			
			if (instance==imgNext)
			{		
				instance.addEventListener(MouseEvent.CLICK,onNextHandler)
			}
			
			if (instance==img)
			{
				instance.addEventListener(MouseEvent.MOUSE_DOWN, startDragging );
				instance.addEventListener(MouseEvent.MOUSE_UP, stopDragging );
				instance.addEventListener(MouseEvent.ROLL_OVER,onImgOverHandler)
				instance.addEventListener(MouseEvent.ROLL_OUT,onImgOutHandler)
				
			}
		}
		
		protected override function partRemoved( partName:String, instance:Object ) : void
		{
			super.partRemoved( partName, instance );

			if (instance==imgPrevious)
			{
				instance.removeEventListener(MouseEvent.CLICK,onPreviousHandler)
			}
			
			if (instance==imgNext)
			{		
				instance.removeEventListener(MouseEvent.CLICK,onNextHandler)
			}
			
			if (instance==img)
			{
				instance.removeEventListener(MouseEvent.MOUSE_DOWN, startDragging );
				instance.removeEventListener(MouseEvent.MOUSE_UP, stopDragging );
				instance.removeEventListener(MouseEvent.ROLL_OVER,onImgOverHandler)
				instance.removeEventListener(MouseEvent.ROLL_OUT,onImgOutHandler)
			}

		}
		
		override protected function getCurrentSkinState():String
		{ 			
			if (_state == LOADING){ 
				return "loading" 
			} 
			if (_state == OUT){ 
				return "out" 
			}
			if (_state == NORMAL){ 
				return "normal" 
			}
			return "normal"; 
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			//if searchText change
			//if (nbResultChanged==true){
			//	searchImages();
			//	nbResultChanged==false
			//}
			
			//if searchText change
			if (searchTextChanged==true){
				searchImages();
				searchTextChanged=false
			}

			//if domain restrict change
			//if (strDomainChanged==true){
			//	searchImages();
			//	strDomainChanged==false
			//}
			
		}
		
		//FUNCTION
		private function searchImages():void
		{
			if (_searchText!=""){
				var googleImageSearch:GoogleImageSearch=new GoogleImageSearch()
				googleImageSearch.addEventListener(GoogleApiEvent.IMAGE_SEARCH_RESULT,onGoogleImageResult)
				googleImageSearch.addEventListener(GoogleAPIErrorEvent.API_ERROR,onAPIError)
	
				googleImageSearch.search(_searchText,0,"moderate","","","","","",false,"",_strDomain)
			}
		}
		
		private function onAPIError(event:GoogleAPIErrorEvent):void
		{
			trace("An API error has occured: " + event.responseDetails, "responseStatus was: " + event.responseStatus);
		}
		
		private function onGoogleImageResult(event:GoogleApiEvent):void
		{
			_results=new Array;
			
			for each (var image:GoogleImage in event.data.results as Array){        
				_results.push(image)
			}
			
			if (_results.length>0){
				_currentIndex=0
				loadImage(_currentIndex)
				_state=LOADING
				invalidateSkinState();
			}
		}
		
		private function loadImage(index:Number):void
		{
			var image:GoogleImage=_results[index]
			var url:String=image.url
			
			if (_loader==null){
				_loader= new Loader;
				
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded,false,0,true);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageIOError,false,0,true)
				_loader.load(new URLRequest(url));
			}
		}
		
		private function imageLoaded(event:Event):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
		
			//apply image source
			img.source= loader.content;
			
			var scale:Number
			scale=this.contentGroup.width/loader.content.width;
			
			//change count label
			lblCount.text=String(_currentIndex + 1) + "/" + String(_results.length)
			
			//change slider value wich is binded to image width and height
			slider.value=scale
			
			//change state
			_state=NORMAL
			invalidateSkinState();
			
			
			//enable,disable next and previous button
			if (_currentIndex==0){
			 	this.imgPrevious.enabled=false;
				this.imgNext.enabled=true;
			}else if (_currentIndex==_results.length -1){
				this.imgPrevious.enabled=true;
				this.imgNext.enabled=false;
			}else{
				this.imgPrevious.enabled=true;
				this.imgNext.enabled=true;
			}
			
			//kill loader
			kill()
		}
		
		private function imageIOError(e:IOErrorEvent):void
		{
			kill()
			
			//change state
			_state=NORMAL
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
		
		private function onRollOverHandler(event:MouseEvent):void
		{
			_state=NORMAL
			invalidateSkinState();
		}
		
		private function onRollOutHandler(event:MouseEvent):void
		{
			_state=OUT
			invalidateSkinState();
		}
		
		private function onImgOverHandler(event:MouseEvent):void
		{
			showCursor()
		}
		
		private function onImgOutHandler(event:MouseEvent):void
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
		
		private function onPreviousHandler(event:MouseEvent):void
		{
			if (_currentIndex>0){
				_currentIndex-=1
				loadImage(_currentIndex)
				_state=LOADING
				invalidateSkinState();
			}
		}
		
		private function onNextHandler(event:MouseEvent):void
		{
			if (_currentIndex<_results.length){
				_currentIndex+=1
				loadImage(_currentIndex)
				_state=LOADING
				invalidateSkinState();
			}
		}
		
		private function kill():void 
		{
			_loader.unload();
			_loader=null;
		}
	}
}