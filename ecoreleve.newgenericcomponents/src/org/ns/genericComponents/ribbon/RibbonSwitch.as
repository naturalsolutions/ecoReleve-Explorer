package org.ns.genericComponents.ribbon
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	
	import org.ns.genericComponents.ribbon.RibbonNavigator;
	import org.ns.genericComponents.ribbon.skin.RibbonSwitchSkin;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	
	[Event(name="selected", type="flash.events.Event")]
	[Event(name="unselected", type="flash.events.Event")]
	public class RibbonSwitch extends SkinnableContainer
	{
		[SkinPart(required="true")] public var lblNormal:Label;
		[SkinPart(required="true")] public var lblSelected:Label;
		[SkinPart(required="true")] public var labelDisplay:Label;
		
		
		[SkinState("normalAndSelected")]
		
		public static const NORMAL_SELECTED:String 	= "Selected";
		
		private var value:String='normal';
		
		[Inspectable(category="General", type="Boolean", defaultValue="")]
		private var _selected:Boolean=false;
		
		[Bindable]
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean) : void 
		{
			_selected=value
		}
		
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _strLabel:String;
		
		[Bindable]
		public function get label():String
		{
			return _strLabel;
		}
		
		public function set label(value:String) : void 
		{
			_strLabel=value
		}
		
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _strToolTipTitle:String;
		
		[Bindable]
		public function get toolTipTitle():String
		{
			return _strToolTipTitle;
		}
		
		public function set toolTipTitle(value:String) : void 
		{
			_strToolTipTitle=value
		}
		
		
		public function RibbonSwitch()
		{
			super();
			setStyle("skinClass",RibbonSwitchSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			labelDisplay.text=_strLabel;
			this.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,onCreateToolTip)
			this.addEventListener(ToolTipEvent.TOOL_TIP_SHOW,onShowTooltip)
			this.lblNormal.addEventListener(MouseEvent.CLICK,goToNormalState)
			this.lblSelected.addEventListener(MouseEvent.CLICK,goToSelectedState)	
				
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		
		override protected function getCurrentSkinState():String
		{
			var skinState:String = super.getCurrentSkinState();

			switch(value)
			{
				case NORMAL_SELECTED:
					skinState+="AndSelected";
					break;
			}

			return skinState;
		}
		
		
		//PRIVATE----------------------------------------------------------------------------------------------------
		
		//on/off state
		private function goToNormalState(event:MouseEvent):void 
		{
			value='normal';
			invalidateSkinState();
			_selected=false;
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		}
		
		private function goToSelectedState(event:MouseEvent):void 
		{
			value=NORMAL_SELECTED;
			invalidateSkinState();
			_selected=true;
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		}
		
		
		//tootltip
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
			
			//la coordonnée y et celle de l'objet de la classe ribbonNavigator
			var obj:DisplayObject=getAncestorByClass(this,RibbonNavigator)
			event.toolTip.y= obj.height; 
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