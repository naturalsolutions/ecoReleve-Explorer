package Ribbon.components
{
	import flash.events.MouseEvent;
	
	import mx.binding.utils.*;
	import mx.controls.Image;
	import mx.controls.TabBar;
	import mx.core.UIComponent;
	import mx.effects.Resize;
	
	public class RibbonTabBar extends TabBar
	{
		private var myImage:Image;
		private var strState:String;
		private var intTabNavMaxHeight:Number;
		private var tabNav:UIComponent;
		private var effResize:Resize;
		private var _LogoMinimize : String = '';
 
 
		[Bindable]
		public function get LogoMinimize() : String 
		{
			return _LogoMinimize;
		} 
		
		public function set LogoMinimize(str : String) : void 
		{
			_LogoMinimize=str
		}

		public function RibbonTabBar()
		{
			super();
			
			//intercepte le tab click event
			addEventListener(MouseEvent.CLICK, onTabBarClick, true);
		}
			
		override protected function createChildren():void
		{			
			super.createChildren();
			
			//récupère la hauteur du parent
			tabNav=UIComponent(this.parent)
			intTabNavMaxHeight=tabNav.height;
			strState="maxi"
			
			//resize effect
			effResize=new Resize(tabNav);

			//ajoute un bouton minimize
			myImage=new Image();
			myImage.source="com/ecoReleve/ressources/images/ico_up.png";
			myImage.buttonMode=true
			myImage.useHandCursor=true
			myImage.visible=true
			myImage.width=15;
			myImage.height=15;
			myImage.addEventListener(MouseEvent.CLICK, onClickMinMaxButton, true);
			rawChildren.addChild(myImage);
			//binding de la largeur du tabbar
			BindingUtils.bindSetter(updateImagePosition,this,"width");
		}
		
		public function updateImagePosition(i:int):void
		{	
			myImage.move(i+20,10);
		}

		public function changeRibbonSize():void
		{	
			if (strState=="mini"){
				myImage.source="com/ecoReleve/ressources/images/ico_up.png";
				if (effResize.isPlaying){
					effResize.stop()
				}
				effResize.heightFrom=tabNav.height
				effResize.heightTo=intTabNavMaxHeight
				effResize.play()
				tabNav.dispatchEvent(new Event("isMaximized",true));
				strState="maxi";		
				}
			else if (strState=="maxi"){
				myImage.source="com/ecoReleve/ressources/images/ico_down.png";
				if (effResize.isPlaying){
					effResize.stop()
				}
				effResize.heightFrom=tabNav.height
				effResize.heightTo=this.height + 1
				effResize.play()
				tabNav.dispatchEvent(new Event("isMinimized",true));
				strState="mini";
				}	
		}

		/** Minimize Tabs sur click du bouton min/max
         * 
        **/
		public function onClickMinMaxButton(event:MouseEvent):void
		{		
			changeRibbonSize();
		}
		
		/** Intercepte tous les click sur le tabBar
		 * 
		 **/
		public function onTabBarClick(event:MouseEvent):void
		{	
			//si le parent de la target est un tabBar (donc target est un onglet) et que le ribon est minimsé alors on maximise
			 if (event.target.parent.name=="tabBar" && strState=="mini"){
                   changeRibbonSize();
             }
		}

	}
}