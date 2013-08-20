package Ribbon.components
{
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.events.ToolTipEvent;

	public class RibbonButton extends Button
	{
		private var img:Image=new Image();
		
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
	
	
		public function RibbonButton()
		{
			super();
			this.useHandCursor=true
			this.buttonMode=true
			this.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,onCreateToolTip)
			this.addEventListener(ToolTipEvent.TOOL_TIP_SHOW,onShowTooltip)
		}

		/** CONSTRUCTEUR
		 *  
		**/
		override protected function createChildren():void 
		{
			//img.source="@Embed('/Ribbon/asset/arrow_down.png')";
			//this.addChild(img);
			
			super.createChildren();
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

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
		   super.updateDisplayList(unscaledWidth, unscaledHeight);
		   if(super.data)
		   {
		   	// Set the default size to img
     		 img.height = img.contentHeight;
      		 img.width = img.contentWidth;
		
			 img.x=this.x
			 img.y=unscaledHeight + 5
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