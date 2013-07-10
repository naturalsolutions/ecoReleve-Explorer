package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.*;
	import com.ecoReleve.model.VO.ClassColorVO;
	import com.ecoReleve.openscales_extend.layer.Cluster.ClusterLabelMarker;
	import com.ecoReleve.openscales_extend.layer.Cluster.ClusterLayer;
	import com.ecoReleve.openscales_extend.layer.Graticule.GraticuleLabelMarker;
	import com.ecoReleve.openscales_extend.layer.Graticule.GraticuleLayer;
	import com.ecoReleve.openscales_extend.layer.VE.FxVESatellite;
	import com.ecoReleve.openscales_extend.layer.VE.VESatellite;
	import com.ecoReleve.utils.*;
	import com.ecoReleve.view.expression.CircleSizeExpression;
	import com.ecoReleve.view.myFilter.AttributeEqualityFilter;
	import com.ecoReleve.view.myFilter.AttributesFilter;
	import com.ecoReleve.view.myFilter.ClusterLengthFilter;
	import com.ecoReleve.view.mycomponents.Display.map.DisplayMap;
	import com.ecoReleve.view.mycomponents.Display.map.selection.Selection;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	import mx.graphics.codec.PNGEncoder;
	
	import org.ns.common.model.VO.StationVO;
	import org.ns.common.model.utils.StationVOCast;
	import org.openscales.core.Map;
	import org.openscales.core.events.*;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.filter.ElseFilter;
	import org.openscales.core.filter.expression.IExpression;
	import org.openscales.core.handler.feature.SelectFeaturesHandler;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.ogc.WMSC;
	import org.openscales.core.layer.osm.CycleMap;
	import org.openscales.core.layer.osm.Mapnik;
	import org.openscales.core.style.*;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.marker.Marker;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.LineSymbolizer;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;
	import org.openscales.geometry.basetypes.Bounds;
	import org.openscales.geometry.basetypes.Location;
	import org.openscales.geometry.basetypes.Pixel;
	import org.openscales.proj4as.ProjProjection;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;


	public class DisplayMapMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "DataStationsMapMediator";		
		
		public static const MODE_CLUSTER:String = 'cluster';
		public static const MODE_RAW:String ='raw';
		
		private var _mode:String=MODE_RAW;
		
		public var myMap:Map;
		public var mySelectionHandler:SelectFeaturesHandler;

		private var stations:ArrayCollection=new ArrayCollection();
		
		private var _dataProxy:StationEnhanceProxy
		private var _baseLayers:Array=new Array()
		
		//click and dblclick handlher
		private var click:ClickHandler;
		private var dblclick:ClickHandler;
		
		/**
		 * CONSTRUCTEUR
		 **/
		public function DisplayMapMediator(viewComponent:DisplayMap)
		{
			super(NAME, viewComponent);												
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			//registerMediator(new SelectionMediator(MapSta.viewSelection));
			
			myMap=MapSta.fxmap.map;
			mySelectionHandler=MapSta.selectFeaturesHandler.handler as SelectFeaturesHandler;
			
			//Data Listeners
			stations.addEventListener(CollectionEvent.COLLECTION_CHANGE,dataChangeHandler)
				
			//Tool listener
			MapSta.addEventListener(DisplayMap.CLEAR_SELECTION,onClearSelection)
				
			//MAP listeners	
			//myMap.addEventListener(GetFeatureInfoEvent.GET_FEATURE_INFO_DATA,onGetWmsFeatureInfo)
			myMap.addEventListener(FeatureEvent.FEATURE_SELECTED, onFeatureSelected);
			myMap.addEventListener(FeatureEvent.FEATURE_UNSELECTED, onFeatureUnSelected);
			myMap.addEventListener(LayerEvent.LAYER_ADDED, onLayerAdded);
			myMap.addEventListener(LayerEvent.LAYER_REMOVED, onLayerRemoved);
			myMap.addEventListener(LayerEvent.LAYER_LOAD_END, onLayerLoadEnd);
			
			//création de l'évenement double click sur la carte
			dblclick=new ClickHandler(MapSta.fxmap.map,true);
			dblclick.doubleClick=mapCenterAndZoomOnPixel;
			
			//création de l'évenement simple click sur la carte
			click=new ClickHandler(MapSta.fxmap.map,true);
			click.click=onGetWmsFeatureInfo;
			
			//récupération du proxy
			_dataProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy
			
			//création des couches de bases
			var veLayer:VESatellite=new VESatellite("world_ortho",VESatellite.HYBRID)
			veLayer.minZoomLevel=3;
				
			var mpkLayer:Mapnik=new Mapnik("world_map")
			mpkLayer.minZoomLevel=3;
			
			var cyLayer:CycleMap=new CycleMap("world_topo")
			cyLayer.minZoomLevel=3;
			
			_baseLayers.push(veLayer as Layer)
			_baseLayers.push(mpkLayer as Layer)
			_baseLayers.push(cyLayer as Layer)
				
			ChangeBaseLayer("world_ortho");
			
			//Liaison entre les Tools et la Carte principale
			MapSta.ToolZoomBoxMap.map=myMap;
			MapSta.ToolZoomSlideMap.map=myMap;
			MapSta.ToolOverViewMap.map=myMap;
			
			//center and zoom initial
			var loc:Location=new Location(538850.47459,538850.47459,myMap.baseLayer.projection)
			myMap.moveTo(loc,3)

				
			//TEST GRATICULE LAYER ************************	
			/*var s:Style = new Style();
			s.rules.push(new Rule());
			(s.rules[0] as Rule).symbolizers.push(new LineSymbolizer(new Stroke(0xFFFFFF,2)));
			var graticule:GraticuleLayer=new GraticuleLayer('graticule')	
			graticule.style=s
			myMap.addLayer(graticule)	
				*/
			//***********************************************	
			
			//notification de creation de la carte
			sendNotification(NotificationConstants.MAP_CREATED_NOTIFICATION);
		}
		
		private function onLayerLoadEnd(evt:LayerEvent):void
		{
			Debug.doTrace(evt.layer.name);	
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATIONS_ADDED_NOTIFICATION,
					NotificationConstants.STATIONS_FILTERED_NOTIFICATION,
					NotificationConstants.STATION_LAYER_MODE_NOTIFICATION,
					NotificationConstants.DECONNEXION_NOTIFICATION,
					NotificationConstants.STATIONS_DELETED_NOTIFICATION,
					NotificationConstants.STATIONS_ALL_DELETED_NOTIFICATION,
					NotificationConstants.STATION_COLOR_CHANGED_NOTIFICATION,
					NotificationConstants.STATION_OPACITY_CHANGED_NOTIFICATION,
					NotificationConstants.STATION_SIZE_CHANGED_NOTIFICATION,
					NotificationConstants.STATION_CLASS_CHANGED_NOTIFICATION,
					NotificationConstants.STATION_PROPORTIONALSIZE_CHANGED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			var vect:FeatureLayer
			
			switch ( note.getName() ) 
			{	
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:					
					 redrawStations()
					 break;
				case NotificationConstants.STATIONS_FILTERED_NOTIFICATION:
					 redrawStations()
					 break;
				case NotificationConstants.STATION_LAYER_MODE_NOTIFICATION:
					 _mode=note.getBody() as String
					 redrawStations()
					 break;
				case NotificationConstants.STATION_SIZE_CHANGED_NOTIFICATION:
					 changeStationSize(note.getBody() as uint);
					 break;
				case NotificationConstants.STATION_COLOR_CHANGED_NOTIFICATION:
					 changeStationColor(note.getBody() as uint);
					 break;
				case NotificationConstants.STATION_OPACITY_CHANGED_NOTIFICATION:
					 changeStationOpacity(note.getBody() as Number);
					 break;
				case NotificationConstants.STATION_PROPORTIONALSIZE_CHANGED_NOTIFICATION:
					 var arr:Array=note.getBody() as Array
					 changeProportionalSize(arr[2],arr[0],arr[1],arr[3]);
					 break;
				case NotificationConstants.STATION_CLASS_CHANGED_NOTIFICATION:
					 var type:String=note.getType()
					 if (type=="classes"){
					 	var arrClass:ArrayCollection=note.getBody() as ArrayCollection
					 	changeAllClass(arrClass);
					 }else if (type=="class"){
					 	var classColor:ClassColorVO=note.getBody() as ClassColorVO
					 	changeClass(classColor);	
					 }
					 break;
				case NotificationConstants.STATIONS_DELETED_NOTIFICATION:					 
					 if (myMap.getLayerByName("Stations")!= null){
						 vect=myMap.getLayerByName("Stations") as FeatureLayer;
						 vect.removeFeatures(vect.features);
					 }
							 
					 break;
				case NotificationConstants.STATIONS_ALL_DELETED_NOTIFICATION:					 
					 if (myMap.getLayerByName("Stations")!= null){
						 vect=myMap.getLayerByName("Stations") as FeatureLayer;
						 vect.removeFeatures(vect.features);
					 }			 
					 break;
				case NotificationConstants.DECONNEXION_NOTIFICATION:
					 RemoveNotBaseLayers()
					 break;
			}
		}
		
		private function redrawStations():void
		{
			if (_mode==MODE_CLUSTER){
				
				if (myMap.getLayerByName('Stations')){myMap.removeLayer(myMap.getLayerByName('Stations'))}
				
				this.getClusterLayer().addFeaturesToCluster(getFeaturesFromStations())
			} else {
				
				if (myMap.getLayerByName('Stations (clustered)')){myMap.removeLayer(myMap.getLayerByName('Stations (clustered)'))}
				
				stations.removeAll();
				stations.addAll(_dataProxy.stations as ArrayCollection)
			}
		}
		
		private function getClusterLayer():ClusterLayer
		{
			var cluster:ClusterLayer
			
			if (myMap.getLayerByName('Stations (clustered)')){
				cluster=myMap.getLayerByName('Stations (clustered)') as ClusterLayer
			}else{
				cluster=new ClusterLayer('Stations (clustered)',60,15);
				cluster.projection=ProjProjection.getProjProjection('EPSG:4326');
				myMap.addLayer(cluster,false,true)
			}
			return cluster
		}
		
		private function getFeaturesFromStations():Vector.<Feature>
		{
			var station:StationVO;
			var pointFeat:PointFeature
			var features:Vector.<Feature>=new Vector.<Feature>
			for each(station in _dataProxy.stations){
				pointFeat=StationVOCast.toPointFeature(station) as PointFeature;
				features.push(pointFeat);
			} 
			
			return features
		}
		
		private function onMapLoaded(event:MapEvent):void
        {
              //sendNotification(ApplicationFacade.MAP_CREATED_NOTIFICATION);
        }

        private function mapCenterAndZoomOnPixel(pixel:Pixel):void
        {
                var loc:Location = myMap.getLocationFromMapPx(pixel);
                //myMap.moveTo(loc,myMap.zoom +2);
				myMap.center=loc
        } 
		
		private function onGetWmsFeatureInfo(pixel:Pixel):void
		{
			var arrWmsLayer:Array=new Array();
			var layer:Layer;
			var GetFeatureInfoHttpRequest:String;
			
			//get all wmsc layer of the map
			for each(layer in myMap.layers){
				if (layer is WMSC){
					arrWmsLayer.push(layer.name);	
				}
			}			
			if (arrWmsLayer.length!=0){
			
			//create getFeatureinfo request
				GetFeatureInfoHttpRequest="https://natural01.gn-noc.com:8443/geoserver/wms?"
				GetFeatureInfoHttpRequest +="REQUEST=GetFeatureInfo"
				GetFeatureInfoHttpRequest +="&X="+ pixel.x
				GetFeatureInfoHttpRequest +="&Y="+ pixel.y
				GetFeatureInfoHttpRequest +="&WIDTH=" + myMap.width
				GetFeatureInfoHttpRequest +="&HEIGHT=" + myMap.height
				GetFeatureInfoHttpRequest +="&INFO_FORMAT=application/vnd.ogc.gml"
				GetFeatureInfoHttpRequest +="&SRS=" + myMap.baseLayer.projection.srsCode
				GetFeatureInfoHttpRequest +="&BBOX="+ myMap.extent.boundsToString()
				GetFeatureInfoHttpRequest +="&VERSION=1.1.1"
				GetFeatureInfoHttpRequest +="&LAYERS="+arrWmsLayer.toString()
				GetFeatureInfoHttpRequest +="&QUERY_LAYERS="+arrWmsLayer.toString()
				GetFeatureInfoHttpRequest +="&FEATURE_COUNT=10"
			} else {
				GetFeatureInfoHttpRequest=""
			}
			sendNotification(NotificationConstants.GET_WMS_FEATURE_INFO_NOTIFICATION,GetFeatureInfoHttpRequest);
		}
		
		private function onClearSelection(event:Event):void
		{
			var pxySelection:SelectionProxy;
			pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;			
			pxySelection.removeAll();
			
			(MapSta.selectFeaturesHandler.handler as SelectFeaturesHandler).clearSelection();
			sendNotification(NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION);
		}
		
		private function onFeatureUnSelected(event:Event):void
		{
			//envoit la notification pour la selection
			var pxySelection:SelectionProxy;
			pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
			
			pxySelection.removeAll();
			
			sendNotification(NotificationConstants.STATIONS_UNSELECTED_NOTIFICATION);			
		}		
					
		private function onFeatureSelected(event:FeatureEvent):void
		{	
			//if (event.feature.layer.name=="Stations"){
				var pxySelection:SelectionProxy;
				pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
				
				//pxySelection.selection=new ArrayCollection(getStationFromSelection(event) as Array)
				var newArray:Array=new Array()
				var f:Feature
				for each(f in event.features){
					newArray.push(f)
				}
				pxySelection.selection=new ArrayCollection(newArray)
				pxySelection.changeCurrentItem(0);

			//} else {			
				//envoit la notification de selection d'un objet (hors stations)
			//	sendNotification(NotificationConstants.FEATURE_SELECTED_NOTIFICATION,event.features);
			//}
		}
		
		private function dataChangeHandler(event:CollectionEvent):void
		{
			switch(event.kind)
			{
				case 'add':
					DrawStation(event.items[0] as StationVO)
					break;
				case 'reset':
					if (myMap.getLayerByName("Stations")!= null){
						var vect:FeatureLayer=myMap.getLayerByName("Stations") as FeatureLayer
						vect.removeFeatures(vect.features)
					}
					break;
			}
		}
		
		private function DrawStation(station:StationVO):void
		{
			var vect:FeatureLayer 
			var station:org.ns.common.model.VO.StationVO
			var pointFeat:PointFeature              
			
			var i:Number=0;
			
			//if layer not exist ==> create it
			if (myMap.getLayerByName("Stations")== null){
				vect=new FeatureLayer("Stations")
				vect.projection=ProjProjection.getProjProjection('EPSG:4326')
				
				myMap.addLayer(vect);   
				(MapSta.selectFeaturesHandler.handler as SelectFeaturesHandler).layers.push(vect);
			}
			
			//add station to map
			vect=myMap.getLayerByName("Stations") as FeatureLayer;
			
			//ajoute l'objet geographique point à la couche
			pointFeat=StationVOCast.toPointFeature(station) as PointFeature;
			vect.addFeature(pointFeat);

		}

        public function zoomToAllStation():void
        {
			var vect:FeatureLayer;
			vect=myMap.getLayerByName("Stations") as FeatureLayer;
			
			var bounds:Bounds=new Bounds();
			bounds=vect.featuresBbox
			bounds.transform(vect.projection,new ProjProjection('4326'))
			myMap.zoomToExtent(bounds)

        }
        
        
		/**  
		 * ZEMBRA STYLE
		**/		
		private function createStyleZembra(lay:Layer):void 
		{
			var vect:FeatureLayer=lay as FeatureLayer;

            var style:Style = new Style();
            style.name = "Habitat";
            var fill:SolidFill, stroke:Stroke, symbolizer:Symbolizer, rule:Rule;
			var color:uint; 

            rule = new Rule();
            rule.name = "Végétation côtière à Crithmum maritimum";  
            color=(224<<16 | 224<<8 | 224);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x0A2C33, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EB9");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série nitrophile ventée de l'oléo-lentisque à faciès avec Génévrier de Phénicie";
            color=(152<<16 | 231<<8 | 2);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EBB");
            style.rules.push(rule);
 
            rule = new Rule();
            rule.name = "Série nitrophile ventée de l'oléo-lentisque à faciès sans Génévrier de Phénicie";
            color=(209<<16 | 253<<8 | 114);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EBA");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série nitrophile ventée de l'oléo-lentisque, série très chaude à Périploca laevigata";
            color=(40<<16 | 114<<8 | 0);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EBC");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série de l'oléo-lentisque, série chaude à faciès normal à Myrte";
            color=(253<<16 | 191<<8 | 230);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EBD");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série de l'oléo-lentisque, série calcaire à Galactites tomentosa";
            color=(255<<16 | 255<<8 | 255);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EBE");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série de l'oléo-lentisque, série très chaude à faciès de versant à Periploca laevigata";
            color=(255<<16 | 127<<8 | 126);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EBF");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série de l'oléo-lentisque, série très chaude à faciès de talweg et plaine à Myrte";
            color=(229<<16 | 1<<8 | 0);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EC2");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série de l'Arbousier et de la Bruyère arborescente à faciès rocheux";
            color=(255<<16 | 213<<8 | 129);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EC0");
            style.rules.push(rule);      

            rule = new Rule();
            rule.name = "Série de l'Arbousier et de la Bruyère arborescente à faciès chaud mixte";
            color=(113<<16 | 38<<8 | 0);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EC3");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série de l'Arbousier et de la Bruyère arborescente à faciès chaud colluvial";
            color=(230<<16 | 152<<8 | 2);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EC1");
            style.rules.push(rule);
            
            rule = new Rule();
            rule.name = "Série de l'oléo-lentisque, série chaude à faciès de transition à Erica arborea";
            color=(254<<16 | 0<<8 | 194);
            fill = new SolidFill(color, .8);
            stroke = new Stroke(0x2D3303, 1);
            symbolizer = new PolygonSymbolizer(fill, stroke);
            rule.symbolizers.push(symbolizer);
            rule.filter=new AttributesFilter("4EC5");
            style.rules.push(rule); 

			//applique le style	
            vect.style=style;
            vect.redraw();
            
            //génére la légende
            sendNotification(NotificationConstants.LEGEND_NOTIFICATION,style,"Style");
        }

		/** 
		 * ZOOM ET CENTRE SUR UN POINT DE LA CARTE
		 *  @param lonlat point sur lequel centrer
		 * 	@param prjSrc Projection du point
		 * 	@param nbZoom Zoom à effectuer
		**/
		public function CenterAndZoom(loc:Location,prjSrc:ProjProjection,nbZoom:Number):void
		{
			//convertit le point de la projection source à celle de la BaseMap
			var projBaseLayer:ProjProjection = new ProjProjection(myMap.baseLayer.projection.srsCode); 
			loc.reprojectTo(projBaseLayer);
			//Recentre
			myMap.moveTo(loc,nbZoom)
		}
		
		/** 
		 * CHANGEMENT DU LAYER DE BASE
		 * @param strLayerName nom du layer
		**/
		public function ChangeBaseLayer(strLayerName:String):void
		{
			var newBaseLay:Layer=myMap.getLayerByName(strLayerName) as Layer;                       
			
			var layer:Layer
			
			//add new baselayer
			for each (layer in _baseLayers){
				if (layer.name==strLayerName){
					if (myMap.getLayerByName(layer.name)==null){
						myMap.addLayer(layer,true,true)
					}
				}
			}
			
			//delete all other base layer
			for each (layer in _baseLayers){
				if (layer.name!=strLayerName){
					if (myMap.getLayerByName(layer.name)!=null){
						myMap.removeLayer(layer)
					}
				}       
			}    

		}	
		
		/** 
		 * ENLEVE TOUS LES LAYERS (HORS BASE LAYER) DE LA CARTE
		**/
		public function RemoveNotBaseLayers():void
		{
			var ly:Layer;
			for each(ly in myMap.layers) 
			{
				if (ly.isBaseLayer==false)
				{
					myMap.removeLayer(ly);
				}                                       
			}
		}
		
		/** 
		 * LAYER REMOVED
		 * 
		 **/
		private function onLayerRemoved(event:LayerEvent):void
		{
			sendNotification(NotificationConstants.LAYER_REMOVED_NOTIFICATION,event.layer,"layer");
		}
		
		/** 
		 * LAYER ADDED: APPLIQUE LE STYLE EN FONCTION DE LA COUCHE
		 * 
		 **/
		private function onLayerAdded(event:LayerEvent):void
		{
			var vect:FeatureLayer
			var fill:SolidFill, stroke:Stroke, symbolizer:Symbolizer, rule:Rule;
			
			//************* ZINDEX ***************************
			//if it is not the stations layer and if the stations layer exist
			if (event.layer.name!="Stations"){
				if (myMap.getLayerByName("Stations")!= null){
					event.layer.zindex=event.layer.zindex-1					
				}
			}
	
			//************* ADD STYLE ***************************
			//ajoute le style de la couche habitat de zembra
			if (event.layer.name=="PIM:SecteursEcologiques_Project3_LatLon"){
				createStyleZembra(event.layer)	
			}

			//ajoute le style de la couche station
			if (event.layer.name=="Stations"){
				
				var sNormal:Style= new Style();
				
				sNormal.name="Stations"
				rule = new Rule(); 
				rule.symbolizers.push(new PointSymbolizer(new WellKnownMarker(WellKnownMarker.WKN_CIRCLE,new SolidFill(0xFF9900,0.7),new Stroke(0xFFFFFF,1,1),12)));
				sNormal.rules.push(rule);
				vect=event.layer as FeatureLayer;
				vect.style=sNormal;
				
				vect.redraw(true)
				
				//envoit la notification pour signifier que la couche station est ajouté
				sendNotification(NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION,MODE_RAW);	
			} 
			if (event.layer.name=="Stations (clustered)"){
				
				var style:Style = new Style();
				style.name = "stations (clustered)";
				
				rule = new Rule();
				rule.name = "station";
				fill = new SolidFill(0x2ff409, .8);
				stroke = new Stroke(0xFFFFFF,1);
				rule.symbolizers.push(new PointSymbolizer(new WellKnownMarker(WellKnownMarker.WKN_CIRCLE,fill, stroke,12)));
				rule.symbolizers.push(new PointSymbolizer(new ClusterLabelMarker(0,0,12,1,0)))
				rule.filter = new ClusterLengthFilter(0, 1);
				style.rules.push(rule);
				
				rule = new Rule();
				rule.name = "nb stations [1;10]";
				fill = new SolidFill(0x2ff409, .8);
				stroke = new Stroke(0xFFFFFF,1); 
				rule.symbolizers.push(new PointSymbolizer(new WellKnownMarker(WellKnownMarker.WKN_SQUARE,fill, stroke,20)));
				rule.symbolizers.push(new PointSymbolizer(new ClusterLabelMarker(0,0,12,1,0)))
				rule.filter = new ClusterLengthFilter(1, 10);
				style.rules.push(rule);
				
				rule = new Rule();
				rule.name = "nb stations [10;50]";
				fill = new SolidFill(0xe6f409, .8);
				stroke = new Stroke(0xFFFFFF,1);
				rule.symbolizers.push(new PointSymbolizer(new WellKnownMarker(WellKnownMarker.WKN_SQUARE,fill, stroke,20)));
				rule.symbolizers.push(new PointSymbolizer(new ClusterLabelMarker(0,0,12,1,0)))
				rule.filter = new ClusterLengthFilter(10, 50);
				style.rules.push(rule);
				
				rule = new Rule();
				rule.name = "nb stations [50;500]";
				fill = new SolidFill(0xf4c509, .8);
				stroke = new Stroke(0xFFFFFF,1);
				rule.symbolizers.push(new PointSymbolizer(new WellKnownMarker(WellKnownMarker.WKN_SQUARE,fill, stroke,20)));
				rule.symbolizers.push(new PointSymbolizer(new ClusterLabelMarker(0,0,12,1,0)))
				rule.filter = new ClusterLengthFilter(50, 500);
				style.rules.push(rule);
				
				rule = new Rule();
				rule.name = "nb stations >500";
				fill = new SolidFill(0xf44009, .8);
				stroke = new Stroke(0xFFFFFF,1);
				rule.symbolizers.push(new PointSymbolizer(new WellKnownMarker(WellKnownMarker.WKN_SQUARE,fill, stroke,20)));
				rule.symbolizers.push(new PointSymbolizer(new ClusterLabelMarker(0,0,12,1,0)))
				rule.filter = new ElseFilter();
				style.rules.push(rule);
				
				vect=event.layer as FeatureLayer;
				vect.style=style;				
				vect.redraw(true)
				sendNotification(NotificationConstants.LAYER_ADDED_NOTIFICATION,event.layer,"layer");
			}else {
				//envoit la notification pour signifier que'une couche à été ajouté
				sendNotification(NotificationConstants.LAYER_ADDED_NOTIFICATION,event.layer,"layer");
			}
			
		}
		
		/** 
		 * Renvoit la carte sous form d'image
		 * 		  
		**/
		public function getMapAsImage():ByteArray
		{
			//Création d'un bitmap à partir de l'objet carte
			var bmpd:BitmapData = new BitmapData(MapSta.fxmap.width,MapSta.fxmap.height);
			bmpd.draw(MapSta.fxmap);
			
			//ByteArray de l'image final
			var imgByteArray:ByteArray;

			var pngenc:PNGEncoder = new PNGEncoder();
			imgByteArray = pngenc.encode(bmpd);
			return imgByteArray;
			
		}
		
		/** 
		 * Recupre le Symbol de la couche passée en paramêtre
		 * @param strLayerName Layer's name wich getting the symbol
		 **/
		private function getSymbolizerFromLayer(strLayerName:String):WellKnownMarker
		{
			var vect:FeatureLayer=myMap.getLayerByName(strLayerName) as FeatureLayer;
			var pf:PointFeature;
			
			//récupère l'objet wellknownmarker du pointSymbolizer de la couche
			var layPtSymb:PointSymbolizer=vect.style.rules[0].symbolizers[0] as PointSymbolizer;
			var layWkm:WellKnownMarker =layPtSymb.graphic as WellKnownMarker;
			
			return layWkm
		}
		
		/** 
		 * CHANGE STATION COLOR
		 * @param color color for the station
		**/
		private function changeStationColor(color:uint):void
		{
			//recupère la couche station
			var vect:FeatureLayer=myMap.getLayerByName("Stations") as FeatureLayer;
			
			//récupère l'objet wellknownmarker du pointSymbolizer de la couche
			var layPtSymb:PointSymbolizer=vect.style.rules[0].symbolizers[0] as PointSymbolizer
			var layWkm:WellKnownMarker =layPtSymb.graphic as WellKnownMarker
			
			//new style
			vect.style=new Style();
			vect.style.name="Stations"
			//new rule
			var rule:Rule=new Rule();
			rule.name=""
			//solid color
			var myFill:SolidFill=new SolidFill
			myFill.color=color
			//add rule to style
        	rule.symbolizers.push(new PointSymbolizer(new WellKnownMarker(layWkm.wellKnownName,myFill,layWkm.stroke,layWkm.size)));
			vect.style.rules.push(rule);
			//redraw
			vect.redraw();
			sendNotification(NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION,"simple")
		}
		
		/** 
		 * CHANGE STATION OPACITY
		 * @param opacity opacity for the station
		**/
		private function changeStationOpacity(opacity:Number):void
		{
			//recupère la couche station
			var vect:FeatureLayer=myMap.getLayerByName("Stations") as FeatureLayer;
			
			//récupère l'objet wellknownmarker du pointSymbolizer de la couche
			var layPtSymb:PointSymbolizer=vect.style.rules[0].symbolizers[0] as PointSymbolizer
			var layWkm:WellKnownMarker =layPtSymb.graphic as WellKnownMarker
			
			var rule:Rule;
			for each(rule in vect.style.rules){
				var pSymb:PointSymbolizer=rule.symbolizers[0] as PointSymbolizer;
				//opacity only on fill ==> possible on symbolizer
				var wkn:WellKnownMarker=pSymb.graphic as WellKnownMarker
				wkn.fill.opacity=opacity			
			}

			vect.redraw();
			sendNotification(NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION,"simple")
		}
		
		/** 
		 * CHANGE STATION SIZE
		 * @param size size for the station
		**/
		private function changeStationSize(size:uint):void
		{
			
			//recupère la couche station
			var vect:FeatureLayer=myMap.getLayerByName("Stations") as FeatureLayer;
			
			//récupère l'objet wellknownmarker du pointSymbolizer de la couche
			var layPtSymb:PointSymbolizer=vect.style.rules[0].symbolizers[0] as PointSymbolizer
			var layWkm:WellKnownMarker =layPtSymb.graphic as WellKnownMarker
			
			var rule:Rule;
			for each(rule in vect.style.rules){
				var pSymb:PointSymbolizer=rule.symbolizers[0] as PointSymbolizer;
				pSymb.graphic.size=size			
			}

			vect.redraw();

			sendNotification(NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION,"simple")
		}
		
		/** 
		 * CHANGE STATION WITH PROPORTIONAL SIZE
		 * @param strFieldName Field to compute
		 * @param maxValue Maximum value for the field
		 * @param maxSize Size for the maximmum value
		**/
		private function changeProportionalSize(strFieldName:String,minValue:Number,maxValue:Number,maxSize:Number):void
		{
			//recupère la couche station
			var vect:FeatureLayer=myMap.getLayerByName("Stations") as FeatureLayer;
			
			//récupère l'objet wellknownmarker du pointSymbolizer de la couche
			var layPtSymb:PointSymbolizer=vect.style.rules[0].symbolizers[0] as PointSymbolizer
			var layWkm:WellKnownMarker =layPtSymb.graphic as WellKnownMarker
				
			var exp:IExpression=new CircleSizeExpression(strFieldName,10,maxSize,minValue,maxValue)			

			//Find and change the rule
			var rule:Rule;
			for each(rule in vect.style.rules){			
				//apply expression 
				((rule.symbolizers[0] as PointSymbolizer).graphic as WellKnownMarker).size=exp
			}
				
			vect.redraw();
			sendNotification(NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION,"proportional")			
		}
		
		/** 
		 * CHANGE ONE CLASS FOR ALL STATIONS
		 * @param obj Object class
		**/
		private function changeClass(classColor:ClassColorVO):void
		{			
			//recupère la couche station
			var vect:FeatureLayer=myMap.getLayerByName("Stations") as FeatureLayer;
			
			//récupère l'objet wellknownmarker du pointSymbolizer de la couche
			var layPtSymb:PointSymbolizer=vect.style.rules[0].symbolizers[0] as PointSymbolizer
			var layWkm:WellKnownMarker =layPtSymb.graphic as WellKnownMarker
			
			//Find and change the rule
			var rule:Rule;
			for each(rule in vect.style.rules){
				if (rule.name==classColor.value){
					//solid color
					var myFill:SolidFill=new SolidFill(classColor.color,1); 	
					((rule.symbolizers[0] as PointSymbolizer).graphic as WellKnownMarker).fill=myFill	
					rule.filter=new AttributeEqualityFilter(classColor.field,classColor.value)
				}
			}
			vect.redraw();
			sendNotification(NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION,"oneclass")
		}
		
		/** 
		 * CHANGE ALL CLASS FOR ALL STATIONS
		 * @param arr Arraycollection with all classes
		**/
		private function changeAllClass(arr:ArrayCollection):void
		{			
			//recupère la couche station
			var vect:FeatureLayer=myMap.getLayerByName("Stations") as FeatureLayer;
			
			//récupère l'objet wellknownmarker du pointSymbolizer de la couche
			var layPtSymb:PointSymbolizer=vect.style.rules[0].symbolizers[0] as PointSymbolizer
			var layWkm:WellKnownMarker =layPtSymb.graphic as WellKnownMarker
			
			//new style
			vect.style=new Style();			
			var classColor:ClassColorVO;
			for each(classColor in arr){
				//style name
				vect.style.name="Stations: classed by " + String(classColor.field)
				//rule name
				var rule:Rule=new Rule();
				rule.name=classColor.value
				//solid color
				var myFill:SolidFill=new SolidFill(classColor.color,1)

				//add rule
				rule.symbolizers.push(new PointSymbolizer(new WellKnownMarker(layWkm.wellKnownName,myFill,layWkm.stroke,layWkm.size)));
				rule.filter=new AttributeEqualityFilter(classColor.field,classColor.value)
				vect.style.rules.push(rule);
			}	
			vect.redraw();
			sendNotification(NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION,"allclass")

		}
			
		protected function get MapSta():DisplayMap
        {
            return viewComponent as DisplayMap;
        }
		
	}
}