package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.*;
	import com.ecoReleve.model.VO.*;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.SearchPanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.genericComponents.geonames.VO.ToponymVO;
	import org.ns.genericComponents.geonames.event.ToponymEvent;
	import org.openscales.geometry.basetypes.Location;
	import org.openscales.proj4as.ProjProjection;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class SearchPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "SearchPanelMediator";	
		
		public function SearchPanelMediator(viewComponent:SearchPanel)
		{
			super(NAME, viewComponent);
		}   
        
		override public function onRegister():void
		{
			super.onRegister();
			searchpanel.geoSearch.addEventListener(ToponymEvent.COMPLETE,geonameResultHandler);
		}
		
        // Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{

			}
		} 
		
		private function geonameResultHandler(event:ToponymEvent):void
		{
			var toponym:ToponymVO=event.data as ToponymVO
			
			if (hasMediator(DisplayMapMediator.NAME)) {
				var MapMediator:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
				var myZoom:Number;
				var loc:Location
				
				//récupération du niveau de zoom
				//myZoom=GeonameVO.getZoom(selGeoname);
				
				//récupération d'un jeux de coordonnées lonlat
				var WGS84:ProjProjection = new ProjProjection('EPSG:4326');
				loc=new Location(toponym.lng,toponym.lat,WGS84)
				
				MapMediator.myMap.center=loc	
				//MapMediator.myMap.zoom=12
			}
		}

        protected function get searchpanel():SearchPanel
        {
            return viewComponent as SearchPanel;
        }
		

		
	}
}