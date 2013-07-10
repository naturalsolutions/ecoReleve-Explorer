package GoogleMedias
{
	import GoogleMedias.renderer.*;
	
	import be.boulevart.google.ajaxapi.search.GoogleSearchResult;
	import be.boulevart.google.ajaxapi.search.images.GoogleImageSearch;
	import be.boulevart.google.ajaxapi.search.images.data.GoogleImage;
	import be.boulevart.google.ajaxapi.search.videos.GoogleVideoSearch;
	import be.boulevart.google.ajaxapi.search.videos.data.GoogleVideo;
	import be.boulevart.google.events.*;
	
	import com.adobe.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.controls.HorizontalList;
	import mx.controls.Label;
	import mx.controls.LinkBar;
	import mx.controls.LinkButton;
	import mx.controls.ProgressBar;
	import mx.core.ClassFactory;
	
	public class GoogleMedias extends VBox
	{
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _searchText:String;
		private var searchTextChanged:Boolean=false;
		
		[Inspectable(category="General", type="int", defaultValue="5")]
		private var _nbResult:int=5;
		private var nbResultChanged:Boolean=false;
		
		[Inspectable(category="General", type="String", defaultValue="image")]
		private var _media:String="image";
		private var mediaChanged:Boolean=false;
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _strDomain:String="";
		private var strDomainChanged:Boolean=false;
		
		private var hListImage:HorizontalList;
		private var hListVideo:HorizontalList
		private var containerVideo:HBox;
		private var containerImage:HBox;
		private var viewstack:ViewStack;
		private var pbr:ProgressBar;
		
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
		public function get media():String
		{
			return _media;
		}
		
		public function set media(value:String):void 
		{
			_media=value
			mediaChanged=true;
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
				
		//constructor
		public function GoogleMedias() 
		{
			super()
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			//create viewStack
			viewstack=new ViewStack();
			viewstack.creationPolicy="all";
			viewstack.selectedIndex=0;
			viewstack.percentHeight=100
			viewstack.percentWidth=100
			
			//create container image
			containerImage=new HBox();
			containerImage.percentHeight=100;
			containerImage.percentWidth=100;
			containerImage.label="image";
			
			hListImage=new HorizontalList();
			hListImage.percentHeight=100;
			hListImage.percentWidth=100;
			hListImage.setStyle("verticalAlign","bottom");
			hListImage.itemRenderer=new ClassFactory(GoogleMedias.renderer.ImageItem)
			
			containerImage.addChild(hListImage);
			
			//create container video
			containerVideo=new HBox();
			containerVideo.percentHeight=100;
			containerVideo.percentWidth=100;
			containerVideo.label="video";
			
			hListVideo=new HorizontalList();
			hListVideo.percentHeight=100;
			hListVideo.percentWidth=100;
			hListVideo.setStyle("verticalAlign","bottom");
			hListVideo.itemRenderer=new ClassFactory(GoogleMedias.renderer.VideoItem)
			
			containerVideo.addChild(hListVideo);
			
			//add container to viewstack
			viewstack.addChild(containerImage);
			
			//create titlebar container
			var titleContainer:HBox=new HBox;
			titleContainer.percentWidth=100;
			
			//create link bar
			var linkBarContainer:HBox=new HBox;
			linkBarContainer.percentWidth=100;
			linkBarContainer.percentHeight=100;
			linkBarContainer.setStyle("horizontalAlign","left");
			linkBarContainer.setStyle("verticalAlign","bottom");
			var linkBar:LinkBar=new LinkBar();
			linkBar.dataProvider=viewstack;
			
			pbr=new ProgressBar();
			pbr.label="";
			pbr.width=50;
			pbr.visible=false;
			
			linkBarContainer.addChild(linkBar);
			linkBarContainer.addChild(pbr);
			
			//add linkbutton for search in browser
			var MoreContainer:HBox=new HBox;
			MoreContainer.percentWidth=100;
			MoreContainer.percentHeight=100;
			MoreContainer.setStyle("horizontalAlign","right");
			MoreContainer.setStyle("verticalAlign","bottom");
			var link:Label=new Label();
			link.useHandCursor=true;
			link.buttonMode=true;
			link.mouseChildren=false;
			link.text="more";
			link.addEventListener(MouseEvent.CLICK,jumpTo);
			link.setStyle("color","blue");
			link.setStyle("textDecoration","underline");
			MoreContainer.addChild(link);
			
			titleContainer.addChild(linkBarContainer);
			titleContainer.addChild(MoreContainer);
			
			//add titlecontainer and viewstack
			this.addChild(titleContainer);
			this.addChild(viewstack);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			//if searchText change
			if (nbResultChanged==true){
				SearchMedias(media);
				nbResultChanged==false
			}
			
			//if searchText change
			if (searchTextChanged==true){
				hListImage.dataProvider=null
				hListVideo.dataProvider=null
				SearchMedias(media);
				searchTextChanged==false
			}
			
			//if media change
			if (mediaChanged==true){
				SearchMedias(media);
				mediaChanged==false
			}
			
			//if domain restrict change
			if (strDomainChanged==true){
				SearchMedias(media);
				strDomainChanged==false
			}
			
		}
		
		private function SearchMedias(media:String):void
		{
			switch (media)
			{
				case "image":
					AddChild(containerImage);
					RemoveChild(containerVideo);
					searchImages();
					break;
				case "video":
					AddChild(containerVideo);
					RemoveChild(containerImage);
					searchVideos();
					break;
				case "all":
					AddChild(containerVideo);
					AddChild(containerVideo);
					searchImages();
					searchVideos();
					break;
			}
		}
		
		private function AddChild(child:DisplayObject):void
		{
			if (!viewstack.contains(child)){
				viewstack.addChild(child);
			}
		}
		
		private function RemoveChild(child:DisplayObject):void
		{
			if (viewstack.contains(child)){
				viewstack.removeChild(child);
			}
		}
		
		private function jumpTo(event:MouseEvent):void
		{
			var type:String=""
			if (viewstack.selectedIndex==0){
				type="isch"
			}else{
				type="vid"				
			}
			var url:URLRequest=new URLRequest("http://www.google.fr/search?q="+ _searchText + "&tbm=" + type )
			navigateToURL(url,"_self");
		}
		
		//IMAGE----------------------
		
		private function searchImages():void
		{
			var googleImageSearch:GoogleImageSearch=new GoogleImageSearch()
			googleImageSearch.addEventListener(GoogleApiEvent.IMAGE_SEARCH_RESULT,onGoogleImageResult)
			
			pbr.visible=true;
			googleImageSearch.search(_searchText,0,"moderate","","","","","",false,"",strDomain)
		}
		
		private function onGoogleImageResult(event:GoogleApiEvent):void
		{
			var stop:Boolean=false;
			var teller:int=0;
			var _results:Array=new Array;
			
			for each (var image:GoogleImage in event.data.results as Array){
				teller++
				if(teller <= _nbResult){        
					_results.push(image)
				}else{
					stop=true
				}
			}
			
			if((teller<=(_nbResult)) && !stop){
				searchImages()
			}
			
			if(stop){
				pbr.visible=false;
				hListImage.dataProvider=_results
			}
		}
		
		//VIDEO----------------------
		
		private function searchVideos():void
		{
			var googleVideoSearch:GoogleVideoSearch=new GoogleVideoSearch()
			googleVideoSearch.addEventListener(GoogleApiEvent.VIDEO_SEARCH_RESULT,onVideoResult)
			
			pbr.visible=true;
			googleVideoSearch.search(_searchText,0,"","")
		}
		
		private function onVideoResult(event:GoogleApiEvent):void
		{
			var stop:Boolean=false
			var teller:int=0;
			var _results:Array=new Array;
			
			for each( var video:GoogleVideo in event.data.results)
			{
				teller++;
				if(teller <= _nbResult){        
					_results.push(video)
				}else{
					stop=true
				}
			}
			
			if((teller<=(_nbResult)) && !stop){
				searchVideos()
			}
			
			if(stop){
				pbr.visible=false;
				hListVideo.dataProvider=_results
			}
			
		}
	}
}