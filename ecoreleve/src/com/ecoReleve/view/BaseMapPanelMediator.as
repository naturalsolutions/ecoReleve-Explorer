package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.BaseMapPanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class BaseMapPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "BaseMapPanelMediator";	
		private var MapMediator:DisplayMapMediator;
		
		public function BaseMapPanelMediator(viewComponent:BaseMapPanel)
		{
			super(NAME, viewComponent);
		}   
		
		override public function onRegister():void
		{
			super.onRegister();
			
			basemappanel.addEventListener(BaseMapPanel.SHOW_WORLD_MAP, onShowWorldMap );
			basemappanel.addEventListener(BaseMapPanel.SHOW_WORLD_ORTHO, onShowWorldOrtho );
			basemappanel.addEventListener(BaseMapPanel.SHOW_WORLD_TOPO, onShowWorldTopo );
			
			MapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
			
		}
		
		
		// Evenement SHOW_WORLD_MAP: change le baseMap
		private function onShowWorldMap(event:Event) : void 
		{
			MapMediator.ChangeBaseLayer("world_map");
		}
		
		// Evenement SHOW_WORLD_ORTHO: change le baseMap
		private function onShowWorldOrtho(event:Event) : void 
		{
			MapMediator.ChangeBaseLayer("world_ortho");
		}
		
		// Evenement SHOW_WORLD_TOPO: change le baseMap
		private function onShowWorldTopo(event:Event) : void 
		{
			MapMediator.ChangeBaseLayer("world_topo");
		}
             
        protected function get basemappanel():BaseMapPanel
        {
            return viewComponent as BaseMapPanel;
        }
		

		
	}
}