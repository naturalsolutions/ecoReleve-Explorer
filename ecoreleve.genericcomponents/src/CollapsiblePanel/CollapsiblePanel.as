package CollapsiblePanel
{
	import ResizableCanvas.ResizableCanvas;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.events.ResizeEvent;
	
	public class CollapsiblePanel extends Canvas
	{
		private var btnOpen:Button=new Button;
		private var panel:ResizableCanvas=new ResizableCanvas;
		
		public function CollapsiblePanel()
		{
			super();

			btnOpen.label="time";
			btnOpen.move(0,this.height-btnOpen.height/2);
			btnOpen.addEventListener(MouseEvent.CLICK,onOpenPanel)
			
			
			panel.minWidth=300;
			panel.maxWidth=this.width;
			panel.addEventListener(ResizeEvent.RESIZE,onResizePanel)
			
			this.addChild(btnOpen)
			this.addChild(panel)
		}
		
		
		protected function onOpenPanel(event:MouseEvent):void
		{
			panel.width=this.minWidth;
			btnOpen.visible=false;	
		}
		
		protected function onResizePanel(event:ResizeEvent):void
		{
			if (panel.width==0){
				btnOpen.visible=true;	
			}
		}
	}
}