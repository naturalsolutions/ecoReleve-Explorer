package org.ns.genericComponents.Search
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ProgressBar;
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	
	import org.ns.genericComponents.Search.skin.SearchSkin;
	
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.List;
	import spark.components.SkinnableContainer;
	import spark.components.TextInput;
	import spark.components.gridClasses.GridColumn;
	import spark.events.*;
	import spark.events.IndexChangeEvent;
	
	[Event(name="onSearch", type="flash.events.Event")]
	[Event(name="onSelect", type="flash.events.Event")]
	[Event(name="onUnSelect", type="flash.events.Event")]
	public class Search extends SkinnableContainer
	{
		[SkinPart(required="true")] public var txtSearch:TextInput;
		[SkinPart(required="true")] public var btnErase:Button;
		
		private var lst:List
		
		private var _PopUpSource:ArrayCollection;
		private var PopUpSourceChanged : Boolean = false;
		
		private var _PopUpRenderer:IFactory;
		private var PopUpRendererChanged : Boolean = false;
		
		private var _SelectedItem:Object;
		
		private var _NbCaracSearch:Number=4;
		
		private var _mode:String="manual";
		
		private var _field:String;
		
		[Inspectable(category="General", type="String", defaultValue="null")]
		public function get field():String 
		{
			return _field;
		}
		
		public function set field(data:String) : void 
		{
			_field=data
		}
			
			
		[Inspectable(category="General", type="String", defaultValue="manual",enumeration="manual,auto")]
		public function get PopUpRenderer():IFactory 
		{
			return _PopUpRenderer;
		}
		
		public function set PopUpRenderer(renderer:IFactory) : void 
		{
			_PopUpRenderer=renderer
			PopUpRendererChanged=true;
			this.invalidateProperties();
		}
		
		public function set mode(data:String) : void 
		{
			_mode=data
		}
		
		[Inspectable(category="General", type="class", defaultValue="null")]
		public function get mode():String 
		{
			return _mode;
		}

		
		[Inspectable(category="General", type="ArrayCollection", defaultValue="null")]
		public function get PopUpSource():ArrayCollection 
		{
			return _PopUpSource;
		}
				
		public function set PopUpSource(arrCol:ArrayCollection) : void 
		{
			_PopUpSource=arrCol
			PopUpSourceChanged=true;
			this.invalidateProperties();
		}
		
		[Inspectable(category="General", type="Object", defaultValue="null")]
		[Bindable("selectedItemChanged")]
		public function get SelectedItem() : Object 
		{
			return _SelectedItem;
		}
		
		public function set SelectedItem(obj:Object) : void 
		{
			_SelectedItem=obj
			dispatchEvent(new Event("selectedItemChanged"));
		}
		
		[Inspectable(category="General", type="Number", defaultValue="3")]
		public function get NbCaracSearch() : Number 
		{
			return _NbCaracSearch;
		}
		
		public function set NbCaracSearch(value:Number) : void 
		{
			_NbCaracSearch=value
		}
		
		
		//constructor
		public function Search()
		{
			super();
			setStyle("skinClass",SearchSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			//search text
			txtSearch.addEventListener("change", ChangeEventHandler);
			txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, txtKeyboardHandler);
			
			//button erase
			btnErase.visible=false;
			btnErase.addEventListener(MouseEvent.CLICK, ClearButtonHandler);
			
			//datagrid
			lst=new List  
			lst.height=100
			lst.width=400
			lst.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,MoveOutsidePopUpHandler);
			lst.addEventListener(MouseEvent.CLICK,lstClickHandler);
			lst.addEventListener(KeyboardEvent.KEY_DOWN, lstKeyboardHandler);
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function createChildren():void 
		{
			super.createChildren();
		}
		
		
		override protected function measure():void 
		{
			super.measure();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			//modifie la source du datagrid du popup dès que la source change
			if(PopUpSourceChanged == true && lst!=null){
				AddPopUp()
				lst.dataProvider=_PopUpSource;
				PopUpSourceChanged = false;
			}
			
			//modifie le renderer si il change
			if(PopUpRendererChanged == true && lst!=null){
				lst.itemRenderer =_PopUpRenderer;
				PopUpRendererChanged = false;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		//PRIVATE----------------------------------------------------------------------------------------------------
		
		private function AddPopUp():void
		{
			PopUpManager.addPopUp(lst,this,false); 
			
			var pt:Point = new Point(txtSearch.x, txtSearch.y);
			var pt_global:Point = txtSearch.parent.localToGlobal(pt);
			
			lst.move(pt_global.x,pt_global.y + txtSearch.height)
			
		}
		
		private function ClosePopUp():void
		{
			if (lst){
				PopUpManager.removePopUp(lst);
				lst.dataProvider=null	
			}			
		}
		
		//PUBLIC --------------------------------------------------------------------------
		public function stopSearch():void
		{
			ClosePopUp()
		}
		
		
		//HANDLERS----------------------------------------------------------------------------------------------------
		
		//textinput handler
		private function ChangeEventHandler(event:Event):void
		{
			btnErase.visible=((txtSearch.text=='')?false:true)
			
			if (mode=='manual'){
				if (txtSearch.text.length==1){
					//txtSearch.text=txtSearch.text.charAt(0).toUpperCase();
				} else if (txtSearch.text.length>=_NbCaracSearch){
					//dispatch l'evenement de recherche
					txtSearch.dispatchEvent(new Event("onSearch",true));
				} else {
					ClosePopUp();
					txtSearch.dispatchEvent(new Event("onUnSelect",true));
				}
			}
			
			if (txtSearch.text.length==0){
				txtSearch.dispatchEvent(new Event("onUnSelect",true));
			}
		}
		
		private function txtKeyboardHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER){
				this.dispatchEvent(new Event("onSearch",true));
				//AddPopUp()				
			}
			if (event.keyCode == Keyboard.DOWN){
				lst.setFocus()
				lst.selectedIndex=0
			}	
		}
		
		//datagrid handler
		private function lstKeyboardHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.ENTER){
				lst.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
			}
			if (event.keyCode == Keyboard.UP){
				if (lst.selectedIndex==0){
					txtSearch.setFocus()
					ClosePopUp()
				}
			}
		}
		
		private function MoveOutsidePopUpHandler(event:FlexMouseEvent):void
		{
			txtSearch.text=""
			ClosePopUp()
		}
		
		private function lstClickHandler(event:MouseEvent):void
		{
			if (lst.dataProvider!=null && lst.selectedIndex>=0){
				var obj:Object=lst.selectedItem  as Object;
				txtSearch.text=obj[_field].toString();
				txtSearch.widthInChars=txtSearch.text.length
				_SelectedItem=obj
				ClosePopUp()
				this.dispatchEvent(new Event("onSelect",true));
			}
		}
		
		//button handler
		private function ClearButtonHandler(event:MouseEvent):void
		{
			txtSearch.text='';
			txtSearch.dispatchEvent(new Event("onUnSelect",true));
			btnErase.visible=false;
		}
		
	}
}