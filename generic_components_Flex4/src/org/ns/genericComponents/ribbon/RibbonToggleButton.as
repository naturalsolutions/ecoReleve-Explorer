package org.ns.genericComponents.ribbon
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	
	import org.ns.genericComponents.ribbon.RibbonNavigator;
	import org.ns.genericComponents.ribbon.skin.RibbonToggleButtonSkin
	
	import spark.components.Button;
	import spark.components.ToggleButton;
	
	public class RibbonToggleButton extends ToggleButton
	{
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
		
		
		public function RibbonToggleButton()
		{
			super();
			setStyle("skinClass",RibbonToggleButtonSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			this.useHandCursor=true
			this.buttonMode=true
			this.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,onCreateToolTip)
			this.addEventListener(ToolTipEvent.TOOL_TIP_SHOW,onShowTooltip)
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function createChildren():void 
		{
			super.createChildren();
		}
		
		//PRIVATE----------------------------------------------------------------------------------------------------
		
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