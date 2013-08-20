package Ribbon.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.ControlBar;
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.EdgeMetrics;
    import mx.utils.ColorUtil;
    import mx.utils.GraphicsUtil;

	[Event(name="onPropertiesClick", type="flash.events.Event")]	
	public class RibbonPanel extends Panel
	{
		private var rbPnlLabel:String;
    	private var boShowProperties:Boolean;
    	
    	private var defaultStyleName:String="styleRibbonPanel";
    	private var overStyleName:String="styleRibbonPanelOver";
    	private var labelCtlBarStyleName:String="styleRibbonPanelControlBarLabel";

		private var _LogoProperties : String = '';
 
		[Bindable]
		public function get LogoProperties() : String 
		{
			return _LogoProperties;
		} 
		
		public function set LogoProperties(str : String) : void 
		{
			_LogoProperties=str
		}

        [Bindable]
        public function get ribbonPanelLabel():String
        {
            return rbPnlLabel;
        }

	    public function set ribbonPanelLabel(Value:String):void
	    {
	        rbPnlLabel = Value;
	    }
	    
    	[Bindable]
        public function get showPropertiesButton():Boolean
        {
            return boShowProperties;
        }

	    public function set showPropertiesButton(Value:Boolean):void
	    {
	        boShowProperties = Value;
	    }
    		
		public function RibbonPanel()
		{
			super();
			//event listener
			this.addEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);

			//remove scrollbar
			this.horizontalScrollPolicy="off"
			this.verticalScrollPolicy="off"
			
			//skin
			this.styleName=defaultStyleName	

		}		
		
		/**
         * 
        **/
        override protected function createChildren():void
        {            
            super.createChildren();
            //ajoute une barre de controle
			var cb:ControlBar = new ControlBar();
			//il faut donner une valeur à la largeur de la controlbar sinon pb d'affichage!!
			cb.width=200;
			cb.height=20;
			
			//création du label
			var myLabel:Label=new Label();
			myLabel.text=rbPnlLabel;
			myLabel.percentWidth=100;
			myLabel.styleName=labelCtlBarStyleName
			
			//crétaion d'une Hbox pour le label et le bouton
			var myHbox:HBox=new HBox();
			myHbox.percentWidth=100
			myHbox.setStyle("verticalAlign","middle")
			myHbox.setStyle("horizontalAlign","center")
			myHbox.addChild(myLabel)

			if (boShowProperties==true){
				var myBtn:Image=new Image();
				myBtn.source=_LogoProperties
				myBtn.buttonMode=true
				myBtn.useHandCursor=true
				myBtn.addEventListener(MouseEvent.CLICK,onShowProperties)
				myHbox.addChild(myBtn)
			}
	
			cb.addChild(myHbox);
            addChild(cb);
            
            //fonction qui retarde l'instanciation et permet d'avoir le controlbar crée en dernier (indispensable pour le panel)
            createComponentsFromDescriptors()
        }
        
        /** Dispatch event sur click de la controlbar
         * 
        **/
		public function onShowProperties(event:MouseEvent):void
		{
			//dispatch l'evenement click du controlbar
			this.dispatchEvent(new Event("onPropertiesClick",true));  
		}
			
		private function handleMouseOver(event:MouseEvent):void
		{
			this.styleName=overStyleName
		}		
		
		private function handleMouseOut(event:MouseEvent):void
		{
			this.styleName=defaultStyleName
		}

	}
}