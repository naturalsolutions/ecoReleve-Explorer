package org.ns.genericComponents.CollapsiblePanel
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	
	import org.ns.genericComponents.CollapsiblePanel.skin.CollapsiblePanelSkin;
	
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.Panel;
		
		public class CollapsiblePanel extends Panel
		{
			[SkinPart] public var collapseButton:Button
			[SkinPart] public var minButton:Button
			[SkinPart] public var maxButton:Button
			
			[SkinState("normalAndCollapsed")]
			[SkinState("normalAndMaximized")]
			
			public static const COLLAPSED:String= "collapsed";
			public static const MAXIMIZED:String= "maximized";
			public static const NORMAL:String= "normal";
			
			private var value:String;

			private var _collapsedYPosition:Number=0
			
			protected var uncollapsedPercentWidth:Number = NaN;
			protected var uncollapsedExplicitWidth:Number = NaN;
			protected var uncollapsedExplicitHeight:Number = NaN;
			protected var uncollapsedPercentHeight:Number = NaN;
			protected var uncollapsedYPosition:Number=NaN;
			
			
			[Inspectable(category="General", type="Number", defaultValue="0")]
			public function get collapsedYPosition():Number 
			{
				return _collapsedYPosition;
			}
			
			public function set collapsedYPosition(data:Number) : void 
			{
				_collapsedYPosition=data
			}
			
			public function CollapsiblePanel()
			{
				super();setStyle("skinClass",CollapsiblePanelSkin);
				addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
			}
			
			private function initComponent(pEvent:FlexEvent):void
			{
				this.titleDisplay.addEventListener(MouseEvent.CLICK,clickTitleHandler)
				
				collapseButton.addEventListener(MouseEvent.CLICK,clickCollapseHandler)
				minButton.addEventListener(MouseEvent.CLICK,clickMinHandler)
				maxButton.addEventListener(MouseEvent.CLICK,clickMaxHandler)
					
					
				//store with and percent width
				uncollapsedExplicitWidth = explicitWidth;
				uncollapsedPercentWidth = percentWidth;
				uncollapsedExplicitHeight=explicitHeight;
				uncollapsedPercentHeight = percentHeight;
				uncollapsedYPosition=y;

			}
			
			//OVERRIDES----------------------------------------------------------------------------------------------------
			
			override protected function getCurrentSkinState():String
			{
				var skinState:String = super.getCurrentSkinState();
				
				switch(value)
				{
					case COLLAPSED:
						this.explicitWidth=NaN
						this.percentWidth=NaN
						this.y=uncollapsedYPosition;
						this.explicitHeight=100
						this.percentHeight=NaN
						skinState+="AndCollapsed";
						break;
					case MAXIMIZED:
						this.y=_collapsedYPosition
						this.explicitWidth=uncollapsedExplicitWidth
						this.percentWidth=100
						this.explicitHeight=uncollapsedExplicitHeight
						this.percentHeight=uncollapsedPercentHeight
						skinState+="AndMaximized";
						break;
					case NORMAL:
						this.y=_collapsedYPosition
						this.explicitWidth=uncollapsedExplicitWidth
						this.percentWidth=uncollapsedPercentWidth
						this.explicitHeight=uncollapsedExplicitHeight
						this.percentHeight=uncollapsedPercentHeight
						
						//put in front
						var container:IVisualElementContainer=this.parent.parent.parent as IVisualElementContainer
						container.setElementIndex(this,container.numElements-1)
						break;
				}
				
				return skinState;
			}	
			
			//Private----------------------------------------------------------------------------------------------
			private function clickTitleHandler(event:MouseEvent):void
			{
				if (value==COLLAPSED){	
					uncollapsedYPosition=y;
					value=NORMAL
					invalidateSkinState();
				}
			}
			
			private function clickCollapseHandler(event:MouseEvent):void
			{

				value=COLLAPSED
				invalidateSkinState();
			}
			
			private function clickMinHandler(event:MouseEvent):void
			{
				value=NORMAL
				invalidateSkinState();
			}
			
			private function clickMaxHandler(event:MouseEvent):void
			{
				value=MAXIMIZED
				invalidateSkinState();
			}
			
		}
}
