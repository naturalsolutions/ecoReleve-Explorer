package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.*;
	import com.ecoReleve.openscales_extend.layer.Cluster.ClusterLabelMarker;
	import com.ecoReleve.view.expression.CircleSizeExpression;
	import com.ecoReleve.view.mycomponents.Display.map.Legend;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import org.openscales.core.Map;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.ogc.WMS;
	import org.openscales.core.layer.ogc.WMSC;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.LineSymbolizer;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.core.style.symbolizer.Symbolizer;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	import spark.components.HGroup;
	import spark.components.VGroup;

	public class LegendMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "LegendMediator";	
		private var map:Map
		private var legStation:VGroup=new VGroup();
		private var layer:Layer;
		
		public function LegendMediator(viewComponent:Legend)
		{
			super(NAME, viewComponent);
		} 

		override public function onRegister():void
		{
			super.onRegister();
			
			var mapMediator:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
			map=mapMediator.myMap
		
		}
		
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.LAYER_ADDED_NOTIFICATION,
					NotificationConstants.LAYER_REMOVED_NOTIFICATION,
					NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION,
					NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION,
					NotificationConstants.DECONNEXION_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.LAYER_REMOVED_NOTIFICATION:	
					layer=note.getBody() as Layer
					removeLegend(layer.name)			
					break;
				case NotificationConstants.LAYER_ADDED_NOTIFICATION:					
					layer=note.getBody() as Layer										 
					 if (layer is org.openscales.core.layer.ogc.WMSC){
						 generateWMSLegend()
					 } else if (layer is FeatureLayer && layer.name=="Stations (clustered)"){
						 generateClusterLegend(layer)
					 } else if (layer is FeatureLayer && layer.name!="Stations"){
					 	generateFeatureLegend(layer)
					 }				
					break;
				case NotificationConstants.STATION_LAYER_ADDED_NOTIFICATION:					
					generateStationLegend()				
					break;
				case NotificationConstants.STATION_STYLE_CHANGED_NOTIFICATION:					
					generateStationLegend()				
					break;
				case NotificationConstants.DECONNEXION_NOTIFICATION:	
					removeAllLegend()
					break;
			}
		}  
		
		/**
		 *   GENERATE LEGEND FOR STATION LAYER
		 **/
		private function generateStationLegend():void 
	    {
			var boPropSize:Boolean=false;
			
	    	//remove station legend
			removeLegend("Stations") 
			
			var vect:FeatureLayer=map.getLayerByName("Stations") as FeatureLayer
				
			var label:Label = new Label();
            label.text = vect.style.name;
            label.styleName="labelLegendStyle"

            legStation=new VGroup	
			legStation.name="leg_" + vect.name;
            legStation.addElement(label);
			
			 for each (var rule:Rule in vect.style.rules) {
                for each (var sym:Symbolizer in rule.symbolizers){					
					var hb:HGroup = new HGroup;
                    hb.height=30;
                    hb.setStyle("verticalAlign", "middle");
                    hb.setStyle("paddingLeft", "20");
                    
                    var leg:UIComponent = new UIComponent();
                    leg.height = 30;
                    leg.width = 30;
                    
					var ptSym:PointSymbolizer=sym as PointSymbolizer
					
					if (ptSym.graphic.size is CircleSizeExpression){
						var objPropSize:Object=new Object
						
						objPropSize.minSize=ptSym.graphic.size._minSize
						objPropSize.maxSize=ptSym.graphic.size._maxSize
						objPropSize.minValue=ptSym.graphic.size._minValue
						objPropSize.maxValue=ptSym.graphic.size._maxValue
						objPropSize.attribute=ptSym.graphic.size._attribute
							
						var ovrRule:Rule=new Rule()		
						var wkm:WellKnownMarker=ptSym.graphic as WellKnownMarker
						var ovrSym:PointSymbolizer=new PointSymbolizer(new WellKnownMarker(wkm.wellKnownName,wkm.fill,wkm.stroke,12,wkm.opacity,wkm.rotation))
						ovrRule.symbolizers.push(ovrSym)
						leg.addChild(ovrRule.getLegendGraphic(Rule.LEGEND_POINT));	
						boPropSize=true;
					}	else {	
						leg.addChild(rule.getLegendGraphic(Rule.LEGEND_POINT));
					}
					
					hb.addElement(leg);
                    
                    var ruleLabel:Label = new Label();
                    ruleLabel.text = rule.name;
                	ruleLabel.styleName="labelLegendRule"
                    hb.addElement(ruleLabel);
                    ruleLabel.height = 30;
                    ruleLabel.setStyle("verticalAlign", "middle");
                    legStation.addElement(hb);
                }
                legend.addElement(legStation);
	          }
			 
			 if (boPropSize==true){
			 	generateProportionalSizeLegend(legStation,objPropSize)	 
			 }
	    }

		/**
		 *   GENERATE LEGEND FOR Proportional size
		 **/
		private function generateProportionalSizeLegend(container:VGroup,objPropSize:Object):void 
		{
			var hb:HGroup = new HGroup();
			hb.height=30;
			hb.setStyle("verticalAlign", "bottom");
			hb.setStyle("paddingLeft", "20");
			
			var ovrRule:Rule
			var leg:UIComponent 
			
			//create min display object
			ovrRule=new Rule()
			var ovrSymSizeMin:PointSymbolizer=new PointSymbolizer(new WellKnownMarker(WellKnownMarker.WKN_CIRCLE,new SolidFill(0xFF9900,0.0),new Stroke(1,1,1),objPropSize.minSize))	
			ovrRule.symbolizers.push(ovrSymSizeMin)
			var doMin:DisplayObject=ovrRule.getLegendGraphic(Rule.LEGEND_POINT)
			
			//create max display object
			ovrRule=new Rule()
			var ovrSymSizeMax:PointSymbolizer=new PointSymbolizer(new WellKnownMarker(WellKnownMarker.WKN_CIRCLE,new SolidFill(0xFF9900,0.0),new Stroke(1,1,1),objPropSize.maxSize))
			ovrRule.symbolizers.push(ovrSymSizeMax)
			var doMax:DisplayObject=ovrRule.getLegendGraphic(Rule.LEGEND_POINT)
			
			//add minDO  and maxDO to horizontal container(move minDo to be in middle bottom of maxDO)
			leg= new UIComponent();
			leg.height = 30;
			leg.width = 30;
			
			doMin.y=doMin.y+doMax.width/2 - doMin.width/2
			
			leg.addChild(doMin);	
			leg.addChild(doMax);
			
			hb.addElement(leg);
			
			//add label 
			var lbl:Label = new Label();
			lbl.text=objPropSize.attribute  + " (" + objPropSize.minValue + "-" + objPropSize.maxValue + ")";
			hb.addElement(lbl);
			
			//ad to station legend
			container.addElement(hb);
		
		}
		
		
		/**
		 *   GENERATE LEGEND FOR CLUSTER LAYER
		 **/
		private function generateClusterLegend(layer:Layer):void 
		{
			//remove feature legend if exist
			removeLegend(layer.name)   
			
			//get layer as feature layer
			var vect:FeatureLayer=layer as FeatureLayer;
			
			if (vect.style!=null){
				var label:Label = new Label();
				label.text = vect.style.name;
				label.styleName="labelLegendStyle"
				
				var legFeature:VGroup=new VGroup();
				legFeature.name="leg_" + vect.name;
				legFeature.addElement(label);
				
				for each (var rule:Rule in vect.style.rules) {
					for each (var sym:Symbolizer in rule.symbolizers){					
						var hb:HGroup = new HGroup();
						hb.height=30;
						hb.setStyle("verticalAlign", "middle");
						hb.setStyle("paddingLeft", "20");
						
						var legendType:String;
						
						if (sym is PointSymbolizer){
							
							var ptSym:PointSymbolizer=sym as PointSymbolizer

							if (ptSym.graphic is ClusterLabelMarker){
							}else{
								legendType = Rule.LEGEND_POINT;
								
								var leg:UIComponent = new UIComponent();
								leg.height = 30;
								leg.width = 30;
								leg.addChild(rule.getLegendGraphic(legendType));
								hb.addElement(leg);
								
								var ruleLabel:Label = new Label();
								ruleLabel.text = rule.name;
								ruleLabel.styleName="labelLegendRule"
								hb.addElement(ruleLabel);
								ruleLabel.height = 30;
								ruleLabel.setStyle("verticalAlign", "middle");
								legFeature.addElement(hb);
						}	
						}
					}
					legend.addElement(legFeature);
				}  
			}
		}
		
		
		/**
		 *   GENERATE LEGEND FOR FEATURE LAYER
		 **/
		private function generateFeatureLegend(layer:Layer):void 
		{
 
		   //remove feature legend if exist
		   removeLegend(layer.name)   
		   
		   //get layer as feature layer
		   var vect:FeatureLayer=layer as FeatureLayer;
			
		   if (vect.style!=null){
			   var label:Label = new Label();
			   label.text = vect.style.name;
			   label.styleName="labelLegendStyle"
			   
			   var legFeature:VGroup=new VGroup();
			   legFeature.name="leg_" + vect.name;
			   legFeature.addElement(label);
			   
			   for each (var rule:Rule in vect.style.rules) {
				   for each (var sym:Symbolizer in rule.symbolizers){					
					   var hb:HGroup = new HGroup();
					   hb.height=30;
					   hb.setStyle("verticalAlign", "middle");
					   hb.setStyle("paddingLeft", "20");
					   
					   var legendType:String;
					   if (sym is PointSymbolizer){
						   legendType = Rule.LEGEND_POINT;
					   } else if (sym is PolygonSymbolizer){
						   legendType = Rule.LEGENT_POLYGON;
					   } else if (sym is LineSymbolizer){
						   legendType = Rule.LEGEND_LINE;
					   }
					   
					   var leg:UIComponent = new UIComponent();
					   leg.height = 30;
					   leg.width = 30;
					   leg.addChild(rule.getLegendGraphic(legendType));
					   hb.addElement(leg);
					   
					   var ruleLabel:Label = new Label();
					   ruleLabel.text = rule.name;
					   ruleLabel.styleName="labelLegendRule"
					   hb.addElement(ruleLabel);
					   ruleLabel.height = 30;
					   ruleLabel.setStyle("verticalAlign", "middle");
					   legFeature.addElement(hb);
				   }
				   legend.addElement(legFeature);
			   }  
		   }
	 	}

		/**
		 *   GENERATE LEGEND FOR WMS LAYER
		 **/		
		 private function generateWMSLegend():void
	     {
	            //LEGENDE POUR LES WMS(IMAGE FROM URL)
	            var lay:Layer;
	            
	            for each(lay in map.layers){
					//WMS Layer (not baselayer)
					if (lay is WMS){
						var wms:WMS=lay as WMS
						var loader:Loader=new Loader()
						var request:URLRequest=new URLRequest(wms.url + "?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&LAYER=" + wms.name);
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLegendLoaded)
						loader.load(request);
					}
				} 
	     
	     }
	     
	     private function onLegendLoaded(event:Event):void
	     {
	     	var loader:Loader = (event.target as LoaderInfo).loader;
			var str:String=(event.target as LoaderInfo).url
			str=str.substring(str.lastIndexOf("LAYER=") + 6 ,str.length)
			
			//remove legend
			removeLegend(str) 				
				
			//LABEL
			var label:Label = new Label();
	        label.text = str;
	        label.styleName="labelLegendStyle"
			
			var legWMS:VGroup=new VGroup();
			legWMS.name="leg_" + str;
			legWMS.addElement(label);
	
			//IMAGE
			var myImage:Image=new Image;
			myImage.data   = loader.content;
			myImage.width  = loader.width;
			myImage.height = loader.height;
			legWMS.addElement(myImage);
			
	        legend.addElement(legWMS);	
	     }
        
		 private function removeLegend(legName:String):void
		 {
			 //remove feature legend if exist
			 var i:int;
			 for (i=0; i < legend.numElements; i++){
				 var DO:DisplayObject=legend.getElementAt(i) as DisplayObject
				 if (DO.name=="leg_" + legName){
					legend.removeElementAt(i)
				 }
			 }
		 }
		 
		 private function removeAllLegend():void
		 {
			 //remove feature legend if exist
			legend.removeAllElements()

		 }
             
        protected function get legend():Legend
        {
            return viewComponent as Legend;
        }
		
	}
}