package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.openscales_extend.layer.GPX;
	import com.ecoReleve.openscales_extend.layer.SHP;
	import com.ecoReleve.view.mycomponents.ribbon.IOPanel.OpenPanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.FileFilter;
	
	import org.openscales.core.Map;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class OpenPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "OpenPanelMediator";	
		private var _extension:String='';
		private var map:Map;
		
		public function OpenPanelMediator(viewComponent:OpenPanel)
		{
			super(NAME, viewComponent);
		}   
        
		override public function onRegister():void
		{
			super.onRegister();
			
			openpanel.addEventListener(OpenPanel.OPEN_GPX,onOpenGpx);
			openpanel.addEventListener(OpenPanel.OPEN_SHP,onOpenShp);
			
			var mapMediator:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
			map=mapMediator.myMap
		}

		
		private function onOpenShp(event:Event) : void 
		{
			_extension='SHP'
			browse()
		}
		
		private function onOpenGpx(event:Event) : void 
		{
			_extension='GPX'
			browse()
		}
		
		private function browse() : void 
		{
			var file:File=new File();
			var filter:FileFilter = new FileFilter(_extension, "*." + _extension.toLowerCase());
			file.addEventListener(Event.SELECT,fileSelectHandler);
			file.browseForOpen("Select a " + _extension + " file to open",[filter])
		}
		
		private function fileSelectHandler(event:Event):void
		{
			readFile(event.target.nativePath);	
		}     
		
		private function readFile(strFile:String):void
		{
			var myFile:File=File.desktopDirectory.resolvePath(strFile);
			var layName:String=myFile.nativePath.slice(myFile.nativePath.lastIndexOf('\\')+1,myFile.nativePath.lastIndexOf('.'))
			
			if (_extension=='GPX'){
				var gpxLay:GPX=new GPX(layName,myFile.nativePath)					
				sendNotification(NotificationConstants.LAYER_ADD_NOTIFICATION,gpxLay,"gpx")
			}else if (_extension=='SHP'){
				var shpLay:SHP=new SHP(layName,myFile.nativePath)
				sendNotification(NotificationConstants.LAYER_ADD_NOTIFICATION,shpLay,"shp")
			}
		} 
     
        protected function get openpanel():OpenPanel
        {
            return viewComponent as OpenPanel;
        }
		

		
	}
}