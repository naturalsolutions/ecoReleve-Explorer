package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.manager.PopManager;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.LayerManager.LayerManager;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.LayerManagerPanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class LayerManagerPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "LayerManagerPanelMediator";	
		
		public function LayerManagerPanelMediator(viewComponent:LayerManagerPanel)
		{
			super(NAME, viewComponent);
		} 

		override public function onRegister():void
		{
			super.onRegister();
			layermanagerpanel.addEventListener(LayerManagerPanel.MANAGER_CLICK,onManagerClick)
			
		}
		
		
        /** Ouvre le layer manager en popup
         *
         **/
		private function onManagerClick(event:Event):void 
		{	
			var facade:FabricationFacade=this.facade as FabricationFacade
			PopManager.openPopUpWindow(facade,LayerManager,LayerManagerMediator);	
		}
		
        protected function get layermanagerpanel():LayerManagerPanel
        {
            return viewComponent as LayerManagerPanel;
        }
		

		
	}
}