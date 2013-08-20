package Ribbon.components
{    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.containers.TabNavigator;
    import mx.controls.Image;
    import mx.core.mx_internal;
    import mx.effects.Resize;

	use namespace mx_internal;

	[Event(name="onLogoClick", type="flash.events.Event")]
	[Event(name="isMinimized", type="flash.events.Event")]
	[Event(name="isMaximized", type="flash.events.Event")]
	public class RibbonNavigator extends TabNavigator
	{
		private var myLogo:Image;
    	private var boShowLogo:Boolean;
		private var defaultStyleName:String="styleRibbonTabNavigator";
		private var TabStyleName:String="styleRibbonTabBar";
		
		private var _LogoSource : String = '';

 		
		[Bindable]
		public function get LogoSource() : String 
		{
			return _LogoSource;
		}
		
		public function set LogoSource(str : String) : void 
		{
			_LogoSource=str
		}
	
		[Bindable]
        public function get showLogo():Boolean
        {
            return boShowLogo;
        }

	    public function set showLogo(Value:Boolean):void
	    {
	        boShowLogo = Value;
	    }
		
		public function RibbonNavigator()
		{
			super();
			//skin
			this.styleName=defaultStyleName
		}
		
		/**
         * 
        **/
        override protected function createChildren():void
        {
        	if (boShowLogo==true){
				//ajoute le logo
				myLogo=new Image();
				myLogo.source=_LogoSource
				myLogo.buttonMode=true
				myLogo.useHandCursor=true
				myLogo.visible=true
				myLogo.width=50;
				myLogo.height=50;
				myLogo.move(5, -5);
				myLogo.addEventListener(MouseEvent.CLICK,onLogoClick)
				rawChildren.addChildAt(myLogo,0)
				
        	}
			
 			//ajoute le menu tabBar
            tabBar = new RibbonTabBar();
            tabBar.name = "tabBar";
            tabBar.focusEnabled = false;
            tabBar.styleName=TabStyleName;
                       
            rawChildren.addChild(tabBar);            
            
            super.createChildren();
          
        }  
        
        
        /** Dispatch event sur click du logo
         * 
        **/
		public function onLogoClick(event:MouseEvent):void
		{
			//dispatch l'evenement click du controlbar
			this.dispatchEvent(new Event("onLogoClick",true));  
		}     

	}
}