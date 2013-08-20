package Ribbon.components
{
	
	import mx.controls.PopUpButton;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	import mx.events.ToolTipEvent;
	
	public class RibbonPopUpButton extends PopUpButton
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
		
		public function RibbonPopUpButton()
		{
			super();
			this.useHandCursor=true
			this.buttonMode=true
			this.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,onCreateToolTip)
			this.addEventListener(ToolTipEvent.TOOL_TIP_SHOW,onShowTooltip)
		}
		
		private function onCreateToolTip(event:ToolTipEvent):void 
		{
			var tip:ribbonPanelToolTip = new ribbonPanelToolTip();
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

