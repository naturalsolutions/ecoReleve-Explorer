package RedList
{
	import RedList.controls.NoHighLightHorizontalList;
	import RedList.event.*;
	import RedList.renderer.*;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.ProgressBar;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	
	public class RedList extends VBox
	{
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _searchSP:String;
		private var searchSPChanged:Boolean=false;

		private var redList:NoHighLightHorizontalList;
		private var pbr:ProgressBar;
		private var lblYear:Label
		private var lblVersion:Label;
		private var lblDetail:Label
		private var Detailcontainer:HBox
		private var idxSelected:int;
		private var stack:ViewStack;
		
		[Bindable]
		[Embed(source="assets/redlist_logo.gif")]
		private var ico_redlist:Class;
		
		private var liststatus:ArrayCollection = new ArrayCollection([
			{status:"NE",detail:"NOT EVALUATED"},
			{status:"DD",detail:"DATA DEFICIENT"},
			{status:"LC",detail:"LEAST CONCERN"},
			{status:"NT",detail:"NEAR THREATENED"},
			{status:"VU",detail:"VULNERABLE"},
			{status:"EN",detail:"ENDANGERED"},
			{status:"CR",detail:"CRITICALLY ENDANGERED"},
			{status:"EW",detail:"EXTINCT IN THE WILD"},
			{status:"EX",detail:"EXTINCT"}
		]);
		
		[Bindable]
		public function get searchSP():String
		{
			return _searchSP;
		}
		
		public function set searchSP(value:String):void 
		{
			_searchSP=value
			searchSPChanged=true;
			this.invalidateProperties();
		}
				
		
		public function RedList()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var Logocontainer:VBox=new VBox();
			Logocontainer.setStyle("horizontalAlign","center");
			Logocontainer.setStyle("verticalAlign","middle");
			
			var logo:Image=new Image;
			logo.source=ico_redlist;
			logo.height=50;
			logo.width=50;
			
			Logocontainer.addChild(logo);
			
			
			var Statuscontainer:HBox=new HBox();
			Statuscontainer.setStyle("verticalAlign","middle");
			
			redList=new NoHighLightHorizontalList;
			redList.dataProvider=liststatus;
			redList.enabled=false;
			redList.setStyle("useRollOver","false");
			redList.setStyle("selectionColor","red");
			//redList.setStyle("borderColor","red");
			//redList.setStyle("borderThickness","2");
			redList.itemRenderer=new ClassFactory(RedList.renderer.RedListStatusRenderer)
			redList.addEventListener(ListEvent.CHANGE,changeHandler);
			redList.columnCount=9
			
			
			
			stack=new ViewStack(); 
			stack.width=60;
			stack.height=60;
			
			var infoContainer:VBox=new VBox();
			infoContainer.percentWidth=100;
			infoContainer.percentHeight=100;
			infoContainer.setStyle("horizontalAlign","center");
			infoContainer.setStyle("verticalAlign","middle");
			
			lblYear=new Label();
			lblYear.setStyle('fontSize',14);
			lblYear.setStyle('fontWeight', 'bold');
			
			lblVersion=new Label();
			lblVersion.setStyle('fontSize',10);
			
			var loaderContainer:VBox=new VBox();
			loaderContainer.percentWidth=100;
			loaderContainer.percentHeight=100;
			loaderContainer.setStyle("horizontalAlign","center");
			loaderContainer.setStyle("verticalAlign","middle");
			
			pbr=new ProgressBar();
			pbr.indeterminate=true;
			pbr.label="search";
			pbr.labelPlacement="top";
			pbr.width=40;
			
			infoContainer.addChild(lblYear);
			infoContainer.addChild(lblVersion);

			loaderContainer.addChild(pbr);
			
			stack.addChild(infoContainer);		
			stack.addChild(loaderContainer);
			
			Statuscontainer.addChild(Logocontainer);
			Statuscontainer.addChild(redList);
			Statuscontainer.addChild(stack);

			
			Detailcontainer=new HBox();
			Detailcontainer.setStyle("horizontalAlign","center");
			lblDetail=new Label();
			lblDetail.percentWidth=100;
			lblDetail.setStyle('fontSize',12);
			lblDetail.setStyle('fontWeight', 'bold');
			lblDetail.setStyle('textAlign','center');
			Detailcontainer.addChild(lblDetail);
			
			this.addChild(Statuscontainer)
			this.addChild(Detailcontainer)
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			//if searchSP change
			if (searchSPChanged==true){
				searchRedList();
				searchSPChanged==false
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//move detail status label under selectedItem
			var milSelectedX:int=redList.x + (redList.columnWidth*(idxSelected+1))-(redList.columnWidth/2);
			var X:int=milSelectedX -(Detailcontainer.width/2)
			Detailcontainer.move(X,Detailcontainer.y - 10);
		}
		
		private function changeHandler(event:ListEvent):void
		{
			//prevent selection with mouse
			if (redList.selectedIndex!=idxSelected){
				redList.selectedIndex=idxSelected
;			}
		}
		
		private function searchRedList():void
		{
			var redListSearch:RedListSearch=new RedListSearch();
			redListSearch.addEventListener(RedListEvent.REDLIST_SEARCH_RESULT,resultHandler);
			redListSearch.addEventListener(RedListEvent.PARSE_ERROR,parseErrorHandler);
			stack.selectedIndex=1;
			redList.enabled=false;
			redList.selectedIndex=-1;
			lblYear.text="";
			lblDetail.text="";
			lblVersion.text="";
			redListSearch.search(_searchSP);
		}
		
		private function resultHandler(event:RedListEvent):void
		{
			stack.selectedIndex=0
			redList.enabled=true;
			
			var redListItem:RedListItem=event.data as RedListItem

			idxSelected=getItemIndexByProperty(liststatus,"status",redListItem.category_code);
				
			redList.selectedIndex=idxSelected;
			lblYear.text=redListItem.modified_year;
			lblDetail.text=redListItem.category_title;
			lblVersion.text="ver " + redListItem.category_version;
		}
		
		// search an ArrayCollection for a property on an object
		static public function getItemIndexByProperty(array:ArrayCollection, property:String, value:String):Number
		{
			for (var i:Number = 0; i < array.length; i++)
			{
				var obj:Object = Object(array[i])
				if (obj[property] == value)
					return i;
			}
			return -1;
		}
		
		private function parseErrorHandler(event:RedListEvent):void
		{
			stack.selectedIndex=0
			redList.selectedIndex=-1;
			redList.enabled=false;
			lblYear.text="";
			lblDetail.text="";
			lblVersion.text="";
		}
		
	}
}