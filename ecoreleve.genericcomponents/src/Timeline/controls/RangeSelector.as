package Timeline.controls
{
	import Timeline.event.TimeIntervalEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import mx.charts.chartClasses.*;
	import mx.controls.*;
	import mx.formatters.DateFormatter;
	
	[Event(name="TimeIntervalEvent", type="Timeline.event.TimeIntervalEvent")]
	public class RangeSelector extends ChartElement 
	{    
		/* The bounds of the selected region. */
		private var dLeft:Number = 20;
		private var dTop:Number = 20;
		private var dRight:Number = 80;
		private var dBottom:Number = 80;
		
		// The width of the rectangle drawn.
		private var rectWidth:Number;
		
		/* The x/y coordinates of the start of the tracking region. */
		private var tX:Number;
		private var tY:Number;
		
		/* Whether or not a region is selected. */
		private var bSet:Boolean = false;
		
		/* Whether or not we're currently tracking. */        
		private var bTracking:Boolean = false;
		
		/* The 2 labels for the data bounds of the selected region. */
		private var _labelLeft:Label;
		private var _labelRight:Label;
		
		private var leftDate:Date;
		private var rightDate:Date;
		
		/* image button for unselect */
		private var _imgClose:Button;
		
		[Bindable]
		[Embed(source="../assets/close.png")]
		private var ico_close:Class;
		
		/* Constructor. */
		public function RangeSelector():void
		{
			super();
			setStyle("color",0);
			/* mousedowns are where we start tracking the selection */
			addEventListener(MouseEvent.MOUSE_DOWN,startTracking);
			
			/* create our labels */
			_labelLeft = new Label();
			_labelRight = new Label();
			addChild(_labelLeft);
			addChild(_labelRight);
			
			/* create close image */
			_imgClose=new Button;
			_imgClose.useHandCursor=true;
			_imgClose.buttonMode=true;
			_imgClose.addEventListener(MouseEvent.CLICK,CloseHandler)
			_imgClose.height=32
			_imgClose.width=32
			_imgClose.setStyle('icon',ico_close);
			_imgClose.setStyle('skin',null);
			addChild(_imgClose);
			
		}
		
		/* Draw the overlay. */
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var g:Graphics = graphics;
			g.clear();
			
			// Draw a big transparent square so Flash Player sees us for mouse eventss */
			g.moveTo(0,0);
			g.lineStyle(0,0,0);
			g.beginFill(0,0);
			g.drawRect(0,0,unscaledWidth,unscaledHeight);
			g.endFill();
			
			/* Draw the selected region, if there is one. */
			if(bSet)
			{
				/* 
				*  The selection is a data selection, so we want to make sure the region stays correct as the chart changes size and/or ranges.
				*  so we store it in data coordinates. So before we draw it, we need to transform it back into screen coordinates.
				*/
				var c:Array = [{dx: dLeft, dy: dTop}, {dx:dRight, dy: dBottom}];
				dataTransform.transformCache(c,"dx","x","dy","y");
				
				/* Now draw the region on screen. */
				g.moveTo(c[0].x,c[0].y);                
				g.beginFill(0xEEEE22,.2);
				g.lineStyle(1,0xBBBB22);
				rectWidth = c[1].x - c[0].x;
				g.drawRect(c[0].x,0,rectWidth, unscaledHeight);
				g.endFill();
				
				/* Now we're going to position the labels at the edges of the box. */
				_labelLeft.visible = _labelRight.visible = true;                
				_labelLeft.setActualSize(_labelLeft.measuredWidth,_labelLeft.measuredHeight);
				_labelLeft.move(c[0].x - _labelLeft.width,unscaledHeight/2);
				_labelRight.setActualSize(_labelRight.measuredWidth,_labelRight.measuredHeight);
				_labelRight.move(c[1].x,unscaledHeight/2);
				
				_labelLeft.setStyle("fontSize",10)
				_labelLeft.setStyle("fontWeight","bold")
				
				_labelRight.setStyle("fontSize",10)
				_labelRight.setStyle("fontWeight","bold")
					
				/* Move and show close button */
				_imgClose.move(c[1].x,0);
				_imgClose.visible=true;
					
			} else {
				_labelLeft.visible = _labelRight.visible = _imgClose.visible= false;
				rectWidth=0;
			}
		}
		
		override protected function commitProperties():void
		{    
			super.commitProperties();
			var formatterLeft:DateFormatter=new DateFormatter;
			var formatterRight:DateFormatter=new DateFormatter;
			var formatString:String="DD MMM(YY) HH:NN"
			
			leftDate = new Date(dLeft);
			rightDate = new Date(dRight);
			
			formatterLeft.formatString=formatString;
			formatterRight.formatString=formatString;
			
			_labelLeft.text=formatterLeft.format(leftDate);
			_labelRight.text=formatterRight.format(rightDate);	
			//_labelLeft.text = ( leftDate.getMonth()+1) + "/" + leftDate.getDate() + "/" +  leftDate.getFullYear() + " " + leftDate.getHours() + ":00";
			//_labelRight.text = ( rightDate.getMonth()+1) + "/" + rightDate.getDate() + "/" +  rightDate.getFullYear() + " " + rightDate.getHours() + ":00";            
		}
		
		
		override public function mappingChanged():void
		{
			/* since we store our selection in data coordinates, we need to redraw when the mapping between data coordinates and screen coordinates changes
			*/
			invalidateDisplayList();
		}
		
		private function CloseHandler(e:MouseEvent):void
		{
			bTracking = false;
			bSet = false;
			rectWidth=0;
			
			this.dispatchEvent(new TimeIntervalEvent("IntervalChange",true,true,null))
			
			invalidateDisplayList();
		}
		
		private function startTracking(e:MouseEvent) :void
		{
			/* if rect exist do nothing */
			if (rectWidth<3) {
				/* the user clicked the mouse down. First, we need to add listeners for the mouse dragging */
				bTracking = true;
				
				this.parent.addEventListener(MouseEvent.MOUSE_UP,endTracking,true);
				this.parent.addEventListener(MouseEvent.MOUSE_MOVE,track,true);
				
				/* now store off the data values where the user clicked the mouse */
				var dataVals:Array = dataTransform.invertTransform(mouseX,mouseY);
				tX = dataVals[0];
				tY = dataVals[1];
				bSet = false;
				rectWidth=0;
				
				updateTrackBounds(dataVals);
			}
		}
		
		private function track(e:MouseEvent):void 
		{
			if(bTracking == false)
				return;
			bSet = true;
			updateTrackBounds(dataTransform.invertTransform(mouseX,mouseY));
			e.stopPropagation();
		}
		
		private function endTracking(e:MouseEvent):void 
		{
			/* The selection is complete, so remove our listeners and update one last time to match the final position of the mouse */
			bTracking = false;
			this.parent.removeEventListener(MouseEvent.MOUSE_UP,endTracking,true);
			this.parent.removeEventListener(MouseEvent.MOUSE_MOVE,track,true);
			e.stopPropagation();
			
			// if the rect is just a click or less than 3 pixels, then ignore
			if (rectWidth>=3) {
				this.dispatchEvent(new TimeIntervalEvent("IntervalChange",true,true,[leftDate,rightDate]))
			}          
		}
		private function updateTrackBounds(dataVals:Array):void
		{
			/* Store the bounding rectangle of the selection, in a normalized data-based rectangle */
			dRight = Math.max(tX,dataVals[0]);
			dLeft = Math.min(tX,dataVals[0]);
			dBottom = Math.min(tY,dataVals[1]);
			dTop = Math.max(tY,dataVals[1]);
			
			/* Invalidate our data, and redraw */
			dataChanged();
			invalidateProperties();
			invalidateDisplayList();            
		}        
	}
}