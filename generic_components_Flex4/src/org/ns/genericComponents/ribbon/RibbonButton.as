package org.ns.genericComponents.ribbon
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.ToolTipEvent;
	
	import org.ns.genericComponents.ribbon.skin.RibbonButtonSkin;
	
	import spark.components.Button;
	import spark.components.Image;
	import spark.components.PopUpAnchor;
	
	public class RibbonButton extends Button
	{	
		[SkinPart(required="true")] public var imgPopUp:Image;
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _strToolTipTitle:String;
		
		[Inspectable(category="General", type="Class")]
		private var _AncestorToolTip:Class;
		
		[Inspectable(category="General", type="Class")]
		private var _PopUp:PopUpAnchor;
		
		[Bindable]
		public function get toolTipTitle():String
		{
			return _strToolTipTitle;
		}
		
		public function set toolTipTitle(value:String) : void 
		{
			_strToolTipTitle=value
		}
		
		public function get AncestorToolTip():Class
		{
			return _AncestorToolTip;
		}
		
		public function set AncestorToolTip(value:Class) : void 
		{
			_AncestorToolTip=value
		}
		
		public function get PopUp():PopUpAnchor
		{
			return _PopUp;
		}
		
		public function set PopUp(value:PopUpAnchor) : void 
		{
			_PopUp=value
		}
		
		
		public function RibbonButton()
		{
			super();
			setStyle("skinClass",RibbonButtonSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			this.useHandCursor=true
			this.buttonMode=true
			imgPopUp.visible=false
			if (_PopUp!=null){
				imgPopUp.visible=true;
				this.addEventListener(MouseEvent.CLICK,openPopUpHandler);
				_PopUp.popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,closePopUpHandler);
			}
			this.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,onCreateToolTip)
			this.addEventListener(ToolTipEvent.TOOL_TIP_SHOW,onShowTooltip)
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function createChildren():void 
		{
			super.createChildren();		
		}

		override protected function getCurrentSkinState():String 
		{		

			if (_PopUp!=null){
				if (_PopUp.displayPopUp==true){
					return "down"
				}else if(_PopUp.displayPopUp==false){
					if (super.getCurrentSkinState()=="down"){
						return "up"
					}
				}
			}
			
			return super.getCurrentSkinState();
		}
		
		override protected function measure():void 
		{
			super.measure();
			
			if (_PopUp!=null){
				measuredHeight=measuredHeight + 20;
			}
		}
		
		//PRIVATE----------------------------------------------------------------------------------------------------

		public function closePopUpHandler(event:Event):void 
		{ 
			if (_PopUp.displayPopUp==true){
				_PopUp.displayPopUp=false
				invalidateSkinState();
			} 
		}
		
		public function openPopUpHandler(event:MouseEvent):void 
		{ 
			if (_PopUp.displayPopUp==false){
				_PopUp.displayPopUp=true
				invalidateSkinState();
			} 
		}
		
		private function onCreateToolTip(event:ToolTipEvent):void 
		{
			var tip:RibbonToolTip = new RibbonToolTip();
			tip.bodyText = event.currentTarget.toolTip;
			tip.TitleText=_strToolTipTitle;
			tip.styleName="ribbonToolTip";
			event.toolTip = tip;      	   
		}
		
		private function onShowTooltip(event:ToolTipEvent):void
		{
			//récupère la coordonnée X globale
			var pt:Point = new Point(event.currentTarget.x,event.currentTarget.y);
			pt = event.currentTarget.contentToGlobal(pt);
			
			//la coordonnée X correspond à la position globale - la position locale
			event.toolTip.x=pt.x - event.currentTarget.x;
			
			//la coordonnée y et celle de l'objet de la classe passé en paramètre si non nulle
			//sinon y correspond sous le bouton
			if (_AncestorToolTip!=null){
				var obj:DisplayObject=getAncestorByClass(this,_AncestorToolTip)
				event.toolTip.y= obj.height; 
			}else{
				event.toolTip.y=pt.y + this.height
			}
		}
		
		private function getAncestorByName(d:DisplayObject, name:String):DisplayObject
		{
			var p:DisplayObject = d;
			while ((p != null) && (p.name != name)){
				p = p.parent;
			}
			return p;
		}
		
		private function getAncestorByClass(d:DisplayObject, clazz:Class):DisplayObject
		{
			var p:DisplayObject = d;
			while ((p != null) && !(p is clazz)){
				p = p.parent;
			}
			return p;
		}
	}
}