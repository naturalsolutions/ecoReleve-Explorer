package Timeline.renderer
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.charts.AxisLabel;
	import mx.controls.Label;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent; 

	public class MyLabelRenderer extends UIComponent implements IDataRenderer
	{
		private var _data:AxisLabel; 
		private var _label:Label;
		
		public function MyLabelRenderer()
		{
			super();
			_label = new Label();
			addChild(_label);
			_label.setStyle("color",0x000000);
			_label.setStyle("fontWeight",12);
		}

        public function get data():Object
        {
                return _data;
        }

        public function set data(value:Object):void
        {
            if(value != null) 
            {
               _label.text=(value as AxisLabel).text 
            }
        } 
        
        override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
				
			var fill:Number = 0xA5BC4E;
		
		
			var rc:Rectangle = new Rectangle(0, 0, unscaledWidth , unscaledHeight );
		
			var g:Graphics = graphics;
			g.clear();		
			g.moveTo(rc.left,rc.top);
			g.beginFill(fill);
			g.lineTo(rc.right,rc.top);
			g.lineTo(rc.right,rc.bottom);
			g.lineTo(rc.left,rc.bottom);
			g.lineTo(rc.left,rc.top);
			g.endFill();
		
			_label.setActualSize(_label.getExplicitOrMeasuredWidth(),_label.getExplicitOrMeasuredHeight());
			_label.move(unscaledWidth/2 - _label.getExplicitOrMeasuredWidth()/2,rc.top - _label.getExplicitOrMeasuredHeight() - 5);
		}
		
	}
}