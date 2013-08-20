package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.*;
	import com.ecoReleve.view.mycomponents.Message;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import org.openscales.core.layer.Layer;
	import org.openscales.core.style.*;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MapToolMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "MapToolMediator";	
		private var MapMediator:DisplayMapMediator;
		
		public function MapToolMediator(viewComponent:Message)
		{
			super(NAME, viewComponent);
		}                

		override public function onRegister():void
		{
			super.onRegister();

			registerMediator(new GeonameMediator(maptool.myGeoname));
			
			maptool.addEventListener(Message.SHOW_MAPNIK, onMapnikBaseMap);
			maptool.addEventListener(Message.SHOW_TOPO, onTopoBaseMap);
			maptool.addEventListener(Message.SHOW_NASA, onNasaBaseMap);
			maptool.addEventListener(Message.CHANGE_VISU, onChangeVisu);
			maptool.addEventListener(Message.SHOW_LAYER_MANAGER, onShowLayerManager);
			maptool.addEventListener(Message.SHOW_WFS_MANAGER, onShowWfsManager);
			maptool.addEventListener(Message.SHOW_VISU_MANAGER, onShowVisuManager);
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [ApplicationLOADING_DATA_COMPLETE_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case ApplicationLOADING_DATA_COMPLETE_NOTIFICATION:	
					if (hasMediator(DisplayMapMediator.NAME)) {
						MapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
					}
					break;
			}
		} 
 
        /** CHANGEMENT DE lA VISUALISATION ==> test
         * 
        **/
        protected function onChangeVisu( event:Event ):void
        {
        	MapMediator.CircleSize();	

        }
         /** AFFICHER LE VISU MANAGER
         * 
        **/
        protected function onShowVisuManager( event:Event ):void
        {
        	//récupère le mileu de WFS Tool pour afficher le manager en dessous
        	var nbMilX:Number=maptool.VisuTool.x + maptool.VisuTool.width/2;
        	MapMediator.ShowManager("VisuManager",nbMilX)
        }
        
        /** AFFICHER LE WFS MANAGER
         * 
        **/
        protected function onShowWfsManager( event:Event ):void
        {
        	//récupère le mileu de WFS Tool pour afficher le manager en dessous
        	var nbMilX:Number=maptool.WFSTool.x + maptool.WFSTool.width/2;
        	MapMediator.ShowManager("WFSManager",nbMilX)
        }
        
        /** AFFICHER LE LAYER MANAGER
         * 
        **/
        protected function onShowLayerManager( event:Event ):void
        {
        	//récupère le mileu de Layer Tool pour afficher le manager en dessous
        	var nbMilX:Number=maptool.LayerTool.x + maptool.LayerTool.width/2
        	MapMediator.ShowManager("LayerManager",nbMilX)
        }    
     
        /** CHANGEMENT DU LAYER DE BASE ==> MAPNIK
         * 
        **/
        protected function onMapnikBaseMap( event:Event ):void
        {
        	MapMediator.ChangeBaseLayer("Carte");
        }
        
        /** CHANGEMENT DU LAYER DE BASE ==> TOPO
         * 
        **/
        protected function onTopoBaseMap( event:Event ):void
        {
        	MapMediator.ChangeBaseLayer("Topo");
        }
        
        /** CHANGEMENT DU LAYER DE BASE ==> Metacarta
         * 
        **/
        protected function onNasaBaseMap( event:Event ):void
        {
        	MapMediator.ChangeBaseLayer("Aerial");
        }
               
        protected function get maptool():Message
        {
            return viewComponent as Message;
        }
		
	}
}