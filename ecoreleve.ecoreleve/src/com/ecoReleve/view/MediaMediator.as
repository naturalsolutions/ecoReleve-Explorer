package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.*;
	import com.ecoReleve.view.mycomponents.Display.map.selection.Media;
	
	import org.ns.common.model.VO.StationVO;
	import org.openscales.core.feature.Feature;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class MediaMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "MediaMediator";	
		
		public function MediaMediator(viewComponent:Media)
		{
			super(NAME, viewComponent);			
		} 

		override public function onRegister():void
		{
			super.onRegister();
			media.isVisible=false;
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION,
					NotificationConstants.SELECTION_RESET_NOTIFICATION,
					NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION,
					NotificationConstants.WIDGET_ACTIVATE_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.SELECTION_RESET_NOTIFICATION:
					media.isVisible=false;
					break;
				case NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION:						 
					media.isVisible=false;
					 break;
				case NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION:						 
					var feature:Feature=note.getBody() as Feature
					if (feature.layer.name=="Stations"){
						media.txtSpeciesName=cleanSpeciesNames(feature.attributes['sta_speciesName'])
						media.isVisible=true;
					} else{
						media.isVisible=false;
					}
					 break;
					case NotificationConstants.WIDGET_ACTIVATE_NOTIFICATION:						 
						if (note.getType()=="media"){
							media.isActivate=note.getBody() as Boolean
						}
					break;
				
			}
		}    
		
		private function cleanSpeciesNames(str:String):String
		{
			if (str.indexOf("(")>0){
				return str.substring(0,str.indexOf("("));
			} else {
				return str;
			}
		}
		
        protected function get media():Media
        {
            return viewComponent as Media;
        }
		
	}
}