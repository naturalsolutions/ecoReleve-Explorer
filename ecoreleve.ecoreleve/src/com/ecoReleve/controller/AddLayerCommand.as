package com.ecoReleve.controller
{
	
	import com.ecoReleve.view.DisplayMapMediator;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.openscales.core.Map;
	import org.openscales.core.handler.feature.SelectFeaturesHandler;
	import org.openscales.core.layer.FeatureLayer;
	import org.openscales.core.style.Style;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class AddLayerCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			//get Map Mediator
			var mapMediator:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
			var map:Map=mapMediator.myMap;
			var selectionHandler:SelectFeaturesHandler=mapMediator.mySelectionHandler;
				
			//get layer from note	
			var layer:FeatureLayer=note.getBody() as FeatureLayer;
			
			//add style
			var style:Style = Style.getDefaultSurfaceStyle()		
			layer.style=style			
				
			//add layer
			map.addLayer(layer,false,true)
				
			//add to selectionHandler
			selectionHandler.layers.push(layer)
		}
    }

}