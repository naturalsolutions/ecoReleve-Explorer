package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.*;
	import com.ecoReleve.view.mycomponents.Display.map.selection.QuickInfo;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	
	import org.ns.common.model.VO.StationVO;
	import org.openscales.core.feature.Feature;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class QuickInfoMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "QuickInfoMediator";	
		
		public function QuickInfoMediator(viewComponent:QuickInfo)
		{
			super(NAME, viewComponent);			
		} 

		override public function onRegister():void
		{
			super.onRegister();
			quickinfo.isVisible=false
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION,
					NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION,
					NotificationConstants.SELECTION_RESET_NOTIFICATION,
					NotificationConstants.GET_WMS_FEATURE_INFO_NOTIFICATION,
					NotificationConstants.WIDGET_ACTIVATE_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.SELECTION_RESET_NOTIFICATION:
					quickinfo.feature = null
					quickinfo.isVisible=false
					break;
				case NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION:						 
					quickinfo.feature = null
					quickinfo.isVisible=false
					 break;
				case NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION:						 
					 var feature:Feature=note.getBody() as Feature
					 showFeatureInfo(feature)
					 break;
				case NotificationConstants.WIDGET_ACTIVATE_NOTIFICATION:						 
					if (note.getType()=="info"){
						quickinfo.isActivate=note.getBody() as Boolean
					}
					break;
			}
		}    
        
		private function showFeatureInfo(feature:Feature):void
		{
			quickinfo.isVisible=true
			var properties:Array = []
				
			for (var key:String in feature.attributes) {	
				var property:Object = {};
				property.Name = key;
				property.Value = feature.attributes[key];
				properties.push(property);				
			}	
			
			if (properties.length>0){	
				quickinfo.feature = new ArrayCollection(properties);
			}
			
			quickinfo.lblLayerName.text="Layer name: " + feature.layer.name
		}

        protected function get quickinfo():QuickInfo
        {
            return viewComponent as QuickInfo;
        }
		
	}
}