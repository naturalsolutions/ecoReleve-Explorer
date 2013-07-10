package com.pocketListGenerator.view
{
	import com.pocketListGenerator.controller.*;
	import com.pocketListGenerator.model.VO.SiteVO;
	import com.pocketListGenerator.view.mycomponents.Site;
	import com.pocketListGenerator.utils.Export;
	
	import flash.events.Event;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class SiteMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "SiteMediator";		
 				
 		//constructeur
        public function SiteMediator(viewComponent:Site)
        {
            super(NAME, viewComponent);         
			site.addEventListener(Site.EXPORT_CSV,exportCSVHandler);                          	            
        }    

		/**
		 * Liste les notifications attendues
		 * @return 
		 */
		override public function listNotificationInterests( ) : Array 
		{
			return [ApplicationFacade.SITES_LOADED_NOTIFICATION];
		}
		
		/**
		 * Gère les notifications
		 * @param note
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case ApplicationFacade.SITES_LOADED_NOTIFICATION:
					site.sites=note.getBody() as ArrayCollection		
					break;
			}
		}
		
		/**
		 * EXPORT SELECTED ITEM IN CSV
		 * @param event
		 */
		private function exportCSVHandler(event:Event) : void 
		{
			var strResult:String
			
			//add header
			strResult="id;nom;lat;lon;ele\n";
			
			for each(var item:SiteVO in site.sites){
				strResult+=SiteVO.toCSV(item,";") + "\n";	
			}
			
			Export.WriteData(strResult,"CSV");
		}
		
        protected function get site():Site
        {
            return viewComponent as Site;
        }
    }
}