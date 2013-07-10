package HierachicalADG.controls
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextLineMetrics;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.core.UIComponent;
	
	public class AutoResizableADG extends AdvancedDataGrid
	{
		public function AutoResizableADG()
		{
			super();
		}

		override protected function getSeparator(i:int, seperators:Array, headerLines:UIComponent):UIComponent
		{
			var sep:UIComponent=super.getSeparator(i, seperators, headerLines);
			sep.doubleClickEnabled=true;
			// Add listener for Double Click
			DisplayObject(sep).addEventListener(MouseEvent.DOUBLE_CLICK, columnResizeDoubleClickHandler);
			return sep;
		}

		private function columnResizeDoubleClickHandler(event:MouseEvent):void
		{
			// check if the ADG is enabled and the columns are resizable
			if (!enabled || !resizableColumns)
				return;

			var target:DisplayObject=DisplayObject(event.target);
			var index:int=target.parent.getChildIndex(target);
			// get the columns array
			var optimumColumns:Array=getOptimumColumns();

			//get header width
			var headerWidth:TextLineMetrics=measureText(optimumColumns[index].dataField);
			
			// check for resizable column
			if (!optimumColumns[index].resizable)
				return;

			// calculate the maxWidth - we can optimize this calculation
			if (listItems)
			{
				var len:int=listItems.length;
				var maxWidth:int=0;
				for (var i:int=0; i < len; i++)
				{
					if (listItems[i][index] is IDropInListItemRenderer)
					{
						var lineMetrics:TextLineMetrics=measureText(IDropInListItemRenderer(listItems[i][index]).listData.label);
						if (lineMetrics.width > maxWidth)
							maxWidth=Math.max(headerWidth.width,lineMetrics.width);
					}
				}
			}

			// set the column's width
			optimumColumns[index].width=maxWidth + getStyle("paddingLeft") + getStyle("paddingRight") + 8 + 50;
		}
	}
}