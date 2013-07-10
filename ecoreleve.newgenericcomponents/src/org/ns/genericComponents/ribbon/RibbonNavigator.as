package org.ns.genericComponents.ribbon
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.ViewStack;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.ribbon.RibbonPage;
	import org.ns.genericComponents.ribbon.skin.RibbonNavigatorSkin;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.NavigatorContent;
	import spark.components.SkinnableContainer;
	import spark.components.TabBar;
	import spark.events.IndexChangeEvent;
	
	[Event(name="aboutClick", type="flash.events.Event")]
	public class RibbonNavigator extends SkinnableContainer
	{
		
		[SkinPart(required="true")] public var tabBar:TabBar;
		[SkinPart(required="true")] public var vs:ViewStack;
		[SkinPart(required="true")] public var imgSize:Image;
		[SkinPart(required="true")] public var imgAbout:Image;
		
		[SkinState("normalAndMinimized")]
		[SkinState("normalAndMaximized")]
		
		public static const MAXIMIZED:String 	= "maximized";
		public static const MINIMIZED:String 	= "minimized";
		
		private var value:String;
		
		[Bindable]
		public var content:Array;
		
		public function RibbonNavigator()
		{
			super();
			setStyle("skinClass",RibbonNavigatorSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			this.imgSize.addEventListener(MouseEvent.CLICK,changeSize)
			this.tabBar.addEventListener(IndexChangeEvent.CHANGE,Maximize)
			this.imgAbout.addEventListener(MouseEvent.CLICK,aboutClick)
			value=MAXIMIZED
			invalidateSkinState();
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function createChildren():void 
		{
			super.createChildren();
			
			//add element to viewstack
			var i:int=0
			var element:IVisualElement
			for (i;i<this.numElements ;i++){	
				vs.addElement(this.getElementAt(i) as RibbonPage)
			}
	
		}		
	
		override protected function getCurrentSkinState():String
		{
			var skinState:String = super.getCurrentSkinState();
			
			switch(value)
			{
				case MAXIMIZED:
					skinState+="AndMaximized";
					break;
				case MINIMIZED:
					skinState+="AndMinimized";
					break;			
			}
			
			return skinState;
		}
		
		//PRIVATE----------------------------------------------------------------------------------------------------
		private function aboutClick(event:MouseEvent):void
		{
			//dispatchEvent
			this.dispatchEvent(new Event("aboutClick"));
		}
		
		
		private function changeSize(event:MouseEvent):void
		{
			if (value==MAXIMIZED){
				value=MINIMIZED
				invalidateSkinState();
			}else{
				value=MAXIMIZED
				invalidateSkinState();
			}
		}
		
		private function Maximize(event:IndexChangeEvent):void
		{
			value=MAXIMIZED
			invalidateSkinState();
		}
		
	}
}