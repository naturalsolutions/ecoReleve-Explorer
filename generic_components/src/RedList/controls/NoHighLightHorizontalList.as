package RedList.controls
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.HorizontalList;
	import mx.controls.listClasses.IListItemRenderer;
	
	public class NoHighLightHorizontalList extends HorizontalList
	{
		public function NoHighLightHorizontalList()
		{
			super();
		}
		
		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			// ignore
		}
		
		override protected function mouseDownHandler(evt:MouseEvent):void
		{
			//ignore
		}
		
		override protected function drawSelectionIndicator(indicator:Sprite, x:Number,y:Number, width:Number, height:Number, color:uint,itemRenderer:IListItemRenderer):void
		{
			var g:Graphics = Sprite(indicator).graphics;
			g.clear();
			g.beginFill(color);
			
			g.drawCircle(width / 2, width / 2, width / 2 + 7);
			g.endFill();
			
			indicator.x = x;
			indicator.y = y + 7;
		}
	}
}