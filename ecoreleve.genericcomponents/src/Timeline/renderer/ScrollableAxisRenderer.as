package Timeline.renderer
{
    import Timeline.event.TimeScaleEvent;
    import Timeline.renderer.MyLabelRenderer;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.charts.AxisRenderer;
    import mx.charts.DateTimeAxis;
    import mx.charts.LinearAxis;
    import mx.core.ClassFactory;
    import mx.graphics.Stroke;

    [Style(name="axisStrokeColor", type="uint", format="Color", inherit="yes")]
    [Style(name="axisStrokeWeight", type="Number", format="Length", inherit="yes")]
    [Style(name="axisAlpha", type="Number", format="Number", inherit="yes")]

    [Style(name="minorTickStrokeColor", type="uint", format="Color", inherit="yes")]
    [Style(name="minorTickStrokeWeight", type="Number", format="Length", inherit="yes")]

    [Style(name="tickStrokeColor", type="uint", format="Color", inherit="yes")]
    [Style(name="tickStrokeWeight", type="Number", format="Length", inherit="yes")]


	[Event(name="TimeScaleEvent", type="Timeline.event.TimeScaleEvent")]
    public class ScrollableAxisRenderer extends AxisRenderer
    {
    	public var zoomSpeed:Number = 10;
        protected var previusMousePos:Point;
        protected var cachedMin:Number;
        protected var cachedMax:Number;
		protected const MS_PER_DAY:uint = 1000 * 60 * 60 * 24;

        public function ScrollableAxisRenderer()
        {
            super();
            mouseChildren = false;
            useHandCursor = true;
            buttonMode = true;

            //labelRenderer=new ClassFactory(Timeline.renderer.MyLabelRenderer)
            
            //to put on a css
            var axisStroke:Stroke = new Stroke(12345,15,1,false,"normal","square")
            setStyle("axisStroke", axisStroke);      
  
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            addEventListener(Event.DEACTIVATE, deactivateHandler);
        }

		override public function styleChanged(styleProp:String):void
	    {
	    	super.styleChanged(styleProp);
	
	     	var stylesUpdated:Boolean = false;
	        
	     	if ((styleProp != "axisStroke") && (styleProp != "minorTickStroke") && (styleProp != "tickStroke"))
	      	{
	      		if ((getStyle("axisStrokeColor") != null) && (getStyle("axisStrokeWeight") != null) && (getStyle("axisAlpha") != null))
	        	{
		            var axisStroke:Stroke = new Stroke(getStyle("axisStrokeColor"), getStyle("axisStrokeWeight"),getStyle("axisAlpha"),false,"normal","square");
		            setStyle("axisStroke", axisStroke);		
		            stylesUpdated = true;
	        	}
	
		        if ((getStyle("minorTickStrokeColor") != null) && (getStyle("minorTickStrokeWeight") != null))
		        {
		        	var minorTickStroke:Stroke = new Stroke(getStyle("minorTickStrokeColor"), getStyle("minorTickStrokeWeight"),1,false,"normal","square");
		            setStyle("minorTickStroke", minorTickStroke);
		            stylesUpdated = true;
		         }
	
		         if ((getStyle("tickStrokeColor") != null) && (getStyle("tickStrokeWeight") != null))
		         {
		            var tickStroke:Stroke = new Stroke(getStyle("tickStrokeColor"), getStyle("tickStrokeWeight"),1,false,"normal","square");
		            setStyle("tickStroke", tickStroke);
		            stylesUpdated = true;
		         }
	
		         if (stylesUpdated)
		         {
		          	invalidateDisplayList();
		         }
	     	 }
	    }

        protected function mouseDownHandler(event:MouseEvent):void
        {
            previusMousePos = new Point(event.localX, event.localY);
            
            systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }
        

        protected function mouseMoveHandler(event:MouseEvent):void
        {
            var mousePos:Point = globalToLocal(new Point(event.stageX, event.stageY));
            
            var delta:Number;
            
            if (horizontal)
            {
                delta = getDataRange() * (previusMousePos.x - mousePos.x) / (width - gutters.left - gutters.right);
            }
            else
            {
                // Vertical axis renderer is rotated 90; that is why width and not height is used. 
                // -1 is needed because minimum is at the bottom.
                delta = -1 * getDataRange() * (previusMousePos.x - mousePos.x) / (width - gutters.top - gutters.bottom);
            }
            

            setMinimum(getMinimum() + delta);
            setMaximum(getMaximum() + delta);
            
            previusMousePos = mousePos;
        }
        

        protected function mouseUpHandler(event:MouseEvent):void
        {
            endDrag();
        }

        protected function deactivateHandler(event:Event):void
        {
            endDrag();
        }
        

        protected function mouseWheelHandler(event:MouseEvent):void
        {
            var rel:Number = getRelativePos(new Point(event.localX, event.localY));
            var range:Number = getDataRange();	
            var speed:Number = zoomSpeed / 100; // divide by 100 to keep the value of zoomSpeed in reasonable range
            
            var delta:Number = getDataRange() * event.delta * speed;
            if (delta > range / 2) // prevent from zooming in to fast
            {
                delta = range / 2;
            }

			var interval:Number=(getMaximum() - (1 - rel) * delta)-(getMinimum() + rel * delta)
			var nbDay:Number=Math.round((interval / MS_PER_DAY) + 1);


			if (nbDay>1 && nbDay<10000){

	            setMinimum(getMinimum() + rel * delta);
	            setMaximum(getMaximum() - (1 - rel) * delta);
	            
	            this.dispatchEvent(new TimeScaleEvent("ScaleChange",true,true,nbDay));
   			} 
     
            // stop event propagation to prevent page from being scrolled
            event.stopPropagation();
            
            // this should be delayed to reset cache when one is finished with zooming
            clearCachedMinMax();
          	
        }
        
        protected function getRelativePos(localPos:Point):Number
        {
            if (horizontal)
            {
                return (localPos.x - gutters.left) / (width - gutters.left - gutters.right);
            }
            else
            {
                return (width - localPos.x - gutters.bottom) / (width - gutters.top - gutters.bottom);
            }
        }

        protected function endDrag():void
        {
            systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            
            clearCachedMinMax();
        }

        protected function getMinimum():Number
        {
            if (!isNaN(cachedMin))
            {
                return cachedMin;
            }
            else if (axis is DateTimeAxis)
            {
                return DateTimeAxis(axis).minimum.time;
            }
            else if (axis is LinearAxis)
            {
                return LinearAxis(axis).minimum;
            }
            return NaN;
        }

        protected function setMinimum(value:Number):void
        {
            cachedMin = value;
            if (axis is DateTimeAxis)
            {
                DateTimeAxis(axis).minimum = new Date(value);
            }
            else if (axis is LinearAxis)
            {
                LinearAxis(axis).minimum = value;
            }
        }

        protected function getMaximum():Number
        {
            if (!isNaN(cachedMax))
            {
                return cachedMax;
            }
            else if (axis is DateTimeAxis)
            {
                return DateTimeAxis(axis).maximum.time;
            }
            else if (axis is LinearAxis)
            {
                return LinearAxis(axis).maximum;
            }
            return NaN;
        }

        protected function setMaximum(value:Number):void
        {
            cachedMax = value;
            if (axis is DateTimeAxis)
            {
                DateTimeAxis(axis).maximum = new Date(value);
            }
            else if (axis is LinearAxis)
            {
                LinearAxis(axis).maximum = value;
            }
        }
        
        protected function clearCachedMinMax():void
        {
            cachedMin = NaN;
            cachedMax = NaN;
        }
        
        protected function getDataRange():Number
        {
            return getMaximum() - getMinimum();
        }        
    }
}
