package com.ecoReleve.view
{

	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.events.MetadataEvent;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.LayerWMSPanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.maps.HashMap;
	import org.openscales.core.events.LayerEvent;
	import org.openscales.core.handler.mouse.WMSGetFeatureInfo;
	import org.openscales.core.layer.capabilities.GetCapabilities;
	import org.openscales.core.layer.ogc.WMSC;
	import org.openscales.core.layer.params.ogc.WMSGetFeatureInfoParams;
	import org.openscales.core.layer.params.ogc.WMSParams;
	import org.openscales.geometry.basetypes.Bounds;
	import org.openscales.proj4as.ProjProjection;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;


	public class LayerWMSPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "LayerWMSPanelMediator";	
		private var capabilities:HashMap = null;
		private var featureCap:HashMap = null;
		private var map:Map;
		private var strNsUrl:String;
		private var strGroup:String;
		private var addedLayers:HashMap = new HashMap();
		private var AppMed:ApplicationMediator
		
		public function LayerWMSPanelMediator(viewComponent:LayerWMSPanel)
		{
			super(NAME, viewComponent);
		} 

		override public function onRegister():void
		{
			super.onRegister();
			layerWms.addEventListener(LayerWMSPanel.SELECT_ADM_WMS_LAYER,onSelectADMLayer);
			layerWms.addEventListener(LayerWMSPanel.SELECT_BIO_WMS_LAYER,onSelectBIOLayer);
			layerWms.addEventListener(LayerWMSPanel.SELECT_PHY_WMS_LAYER,onSelectPHYLayer);
			layerWms.addEventListener(MetadataEvent.GET_URLS,onInfoClicked);
			
			//récupère l'url de geoserver
			AppMed=retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			strNsUrl="https://natural01.gn-noc.com:8443/geoserver/wms"
			strGroup="NS"
			createNsList()
		}
		
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.DECONNEXION_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.DECONNEXION_NOTIFICATION:
					layerWms.admLayerArrCol.removeAll();
					layerWms.bioLayerArrCol.removeAll();
					layerWms.phyLayerArrCol.removeAll()
					break;
			}
		}



		/**
		 * Called when a LAYER_REMOVED event is dispatched.
		 * It will remove the layer from the added layers.
		 */
		public function deleteLayer(event:LayerEvent):void
		{
			event.layer.destroy();
			addedLayers.remove(event.layer.name);
		}
		
		/** AJOUTE UN NOUVEAU WFS LAYER A PARTIR D'UN ITEM
		 * 
		**/
		private function addWMSLayer(item:Object):void
		{
			//We add the layer to the map
			if (!addedLayers.containsKey(item.layer)) {

				var typename:String= item.layer as String;
				//var typename:String= item.title as String;
				
				var srs:String = "EPSG:900913";
				
				//var strNsUrl:String=AppMed.currentConfig.geoServerURL + "/gwc/service/wms"
				
				var newLayer:WMSC = new WMSC(typename,strNsUrl,typename)
				newLayer.projection=ProjProjection.getProjProjection(srs)
				
				var dd:WMSParams=new WMSParams(typename);
				dd.transparent= true; 
				dd.format="image/png";
				dd.tiled=true;
				//dd.width=Number(this.map.width)
				//dd.height=Number(this.map.height)
				
				newLayer.params=dd
				
				if (item.srs=="EPSG:2154"){srs = "EPSG:4326";} 
				(newLayer.params as WMSParams).srs=srs;
				
				var prj:ProjProjection = new ProjProjection(srs);
				var bound:Bounds=map.extent
				//bound.transform(map.projection,prj);			
				//newLayer.params.bbox=bound.boundsToString(1)
								
				trace(newLayer.url + "?" + newLayer.params.toGETString())
				
				this.map.addLayer(newLayer,false,true);
				addedLayers.put(item.layer,null);
				
				
			}
			else {
				Alert.show("This layer is already added", "Message");
			}	
		}

		
		//********************************************************************
		//	NS
		//********************************************************************

 		protected function onSelectBIOLayer(event:Event):void
        {       
        	addWMSLayer(layerWms.lstBio.selectedItem)
			layerWms.lstBio.selectedIndex=-1
        }
        
        protected function onSelectADMLayer(event:Event):void
        {       
        	addWMSLayer(layerWms.lstAdm.selectedItem)
			layerWms.lstAdm.selectedIndex=-1
        }
        
        protected function onSelectPHYLayer(event:Event):void
        {       
        	addWMSLayer(layerWms.lstPhy.selectedItem)
			layerWms.lstPhy.selectedIndex=-1
        }
		
		/** RECUPERATION DES COUCHES PUBLIC GEOSERVER
		 * 
		**/
		private function createNsList():void 
		{
			//récupère l'objet map
			var mapMediator:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
			map=mapMediator.myMap
			
			map.addEventListener(LayerEvent.LAYER_REMOVED,deleteLayer);


			//lance le getCapabilities
			var getCap:GetCapabilities = new GetCapabilities("wfs",strNsUrl,this.NATURALcapabilitiesGetter, "1.1.0", map.proxy);
		}
		
	
		/** Callback method to retrieve the capabilities from the GetCapabilities instance.
		 * TODO: Refactor this to use events
		 * @param getCap The GetCapabilities instance that received the capabilities.
		 */
		public function NATURALcapabilitiesGetter(getCap:GetCapabilities):void 
		{
			var featureCap:HashMap;
			var arrBio:ArrayCollection=new ArrayCollection();
			var arrPhy:ArrayCollection=new ArrayCollection();
			var arrAdm:ArrayCollection=new ArrayCollection();
			
			//récupère le resultat du capabilities
			capabilities = getCap.getAllCapabilities();
			var arrResult:Array=capabilities.getKeys().sort();
			
			//création du tableau avec tous les layers
			for (var i:uint; i < arrResult.length; i++) {
			   featureCap = capabilities.getValue(arrResult[i]);
			   var item:Object=new Object()
			   item.layer=arrResult[i]
			   item.title=featureCap.getValue("Title")
			   item.abstract=featureCap.getValue("Abstract")
			   item.srs=featureCap.getValue("SRS")
			   item.name=featureCap.getValue("Name")
			   item.extent=featureCap.getValue("Extent")
			   item.ServerUrl=strNsUrl
			   arrBio.addItem(item)
			   arrPhy.addItem(item)
			   arrAdm.addItem(item)
			}				
	
			//LAYER BIOLOGIQUE : public et group 
			arrBio.filterFunction=filterByBio
			arrBio.refresh()
			layerWms.bioLayerArrCol=arrBio

			
			//LAYER PHYSIQUE : public et group 
			arrPhy.filterFunction=filterByPhy
			arrPhy.refresh()
			layerWms.phyLayerArrCol=arrPhy

			
			//LAYER ADMINISTRATIF : public et group 
			arrAdm.filterFunction=filterByAdm
			arrAdm.refresh()
			layerWms.admLayerArrCol=arrAdm
		}
		
		/** FILTRE BIOLOGIQUE: ne garde que les layer biologique
		 * 
		 **/
		private function filterByBio(item:Object):Boolean 
		{
			var strItem:String=String(item.layer)
			
			//récupère le type de données
			var strType:String=strItem.substring(strItem.indexOf(":")+1 ,strItem.indexOf("_"))	
           	//récupère le namespace
           	var strNameSpace:String=strItem.substr(0,strItem.indexOf(":"))
           
           if (strType=="BIOLOGIQUE"){
	            if (strNameSpace=="public" || strNameSpace==strGroup) {
	                return true;
	            } else {
	            	return false;
	            }
            } else {
                return false;
            }
		}
		
		/** FILTRE PHYSIQUE: ne garde que les layer physique
		 * 
		 **/
		private function filterByPhy(item:Object):Boolean 
		{
			var strItem:String=String(item.layer)
			
			//récupère le type de données
			var strType:String=strItem.substring(strItem.indexOf(":")+1 ,strItem.indexOf("_"))	
           	//récupère le namespace
           	var strNameSpace:String=strItem.substr(0,strItem.indexOf(":"))
           	
            if (strType=="PHYSIQUE"){
	            if (strNameSpace=="public" || strNameSpace==strGroup) {
	                return true;
	            } else {
	            	return false;
	            }
            } else {
                return false;
            }
		}
		
		/** FILTRE ADMINISTRATIF: ne garde que les layer administratif
		 * 
		 **/
		private function filterByAdm(item:Object):Boolean 
		{
			var strItem:String=String(item.layer)
			
			//récupère le type de données
			var strType:String=strItem.substring(strItem.indexOf(":") + 1,strItem.indexOf("_"))	
           	//récupère le namespace
           	var strNameSpace:String=strItem.substr(0,strItem.indexOf(":"))
           	
            if (strType=="ADMINISTRATION"){
	            if (strNameSpace=="public" || strNameSpace.toUpperCase()==strGroup.toUpperCase()) {
	                return true;
	            } else {
	            	return false;
	            }
            } else {
                return false;
            }
		}
		
		
		private function onInfoClicked(event:MetadataEvent):void
		{
			trace("cool");
		}
		
					
        protected function get layerWms():LayerWMSPanel
        {
            return viewComponent as LayerWMSPanel;
        }
		

		
	}
}