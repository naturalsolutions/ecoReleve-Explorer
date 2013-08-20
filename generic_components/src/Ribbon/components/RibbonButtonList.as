package Ribbon.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	
	import mx.binding.utils.*;
	import mx.collections.ArrayCollection;
	import mx.controls.List;
	import mx.core.IFactory;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	
	[Event(name="onSelect", type="flash.events.Event")]
	public class RibbonButtonList extends RibbonButton
	{
		
		private var lst:List;
		
		private var objTextInput:DisplayObject;
		private var defaultStyleName:String="styleGrdSearchPopUp";
		
		[Inspectable(category="General", type="ArrayCollection", defaultValue="null")]
		private var _PopUpSource:ArrayCollection;
		private var PopUpSourceChanged : Boolean = false;
		private var _ListRenderer:IFactory;
		
		[Inspectable(category="General", type="Object", defaultValue="null")]
		public var _SelectedItem:Object;
 
 		[Bindable]
		public function get ListRenderer() :IFactory
		{
			return _ListRenderer;
		}
		
		public function set ListRenderer(value:IFactory) : void 
		{
			_ListRenderer=value
			this.invalidateProperties();
		}
 
		
		[Bindable]
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
		
		public function RibbonButtonList()
		{
			super();
			this.useHandCursor=true
			this.buttonMode=true
			this.addEventListener("click", handleClickEvent);
		}
		
		/** CONSTRUCTEUR
		 *  
		**/
		override protected function createChildren():void 
		{
			super.createChildren();
			
    		//CREATE DATAGRID POUR LE POPUP
    		lst=new List;
    		lst.width=400;
    		lst.itemRenderer=_ListRenderer;
    		lst.addEventListener("change", handleLstChangeEvent);
    		lst.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,onMoveOutsidePopUp);    		
		}    				
		
		override protected function commitProperties():void
		{
		 	super.commitProperties();
		 	//modifie la source de la liste du popup dès que la source change
		 	if(PopUpSourceChanged == true){
		 		if (_PopUpSource.length!=0) {
			  		lst.dataProvider=_PopUpSource;
			  		PopUpSourceChanged = false;
			  	}
		  	}
		}
		
		//Overrides focusInHandler
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler( event );
		}
 
		//Overrides focusOutHandler
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler( event );
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	    {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//déplace la liste
			var pt:Point = new Point(this.x, this.y);
			var pt_global:Point = this.parent.localToGlobal(pt);
			
			lst.move(pt_global.x,pt_global.y + this.height)
			
			//définit la taille en fonction des données
			if (_PopUpSource!=null){
				lst.rowCount=Math.min(_PopUpSource.length,5)
				
				if (_PopUpSource.length==0) {
					this.enabled=false
				} else {
					this.enabled=true
				}
			}
	    }
		
		private function handleClickEvent(event:Event):void
		{
			AddPopUp()
		}
		
		private function AddPopUp():void
		{
			PopUpManager.addPopUp(lst,this,false); 
			lst.selectedItem=null;
						
		}
		
		private function ClosePopUp():void
		{
			if (lst){
				PopUpManager.removePopUp(lst);	
			}
			
		}
		
		private function onMoveOutsidePopUp(event:Event):void
		{
			ClosePopUp()
			this.selected=false
		}
		
		private function handleLstChangeEvent(event:Event):void
		{		
			_SelectedItem=lst.selectedItem as Object;
			ClosePopUp()
			this.selected=false
			this.dispatchEvent(new Event("onSelect",true));
		}
		
	}
}