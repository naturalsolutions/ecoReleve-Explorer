package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.PrintMapPanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	

	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class PrintMapPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "PrintMapPanelMediator";	
		
		private var objData:Object;
		
		public function PrintMapPanelMediator(viewComponent:PrintMapPanel)
		{
			super(NAME, viewComponent);
		}   
 
		override public function onRegister():void
		{
			super.onRegister();
			
			printmappanel.addEventListener(PrintMapPanel.PRINT_PNG,onPrintMap);
		}
        
        protected function onPrintMap(event:Event):void
		{
			//récupère l'objet carte
			var MapMed:DisplayMapMediator=retrieveMediator(DisplayMapMediator.NAME) as DisplayMapMediator;
			objData= MapMed.getMapAsImage() as Object
			onBrowse();
		}


       // Evenement UPLOAD: ouvre un browser de fichier 
		private function onBrowse() : void 
		{
			var file:File=new File();
			//var nsmlFilter:FileFilter = new FileFilter("NSML", "*.nsml");
			file.addEventListener(Event.SELECT,fileSelectHandler);
			file.browseForSave("Save as...")
		} 
		
		private function fileSelectHandler(event:Event):void
        {
        	saveFile(event.target.nativePath);	
        }     
        
        private function saveFile(strFile:String):void
        {
			//test si l'extension est ajoutée sinon ajoute la bonne extension
			if(strFile.substring(strFile.lastIndexOf("."),strFile.length) != ".png"){  
				strFile+=".png";
			}
			
			
        	var myFile:File=File.desktopDirectory.resolvePath(strFile);
        	var fileStream:FileStream=new FileStream();
        	fileStream.open(myFile,FileMode.WRITE);
        	//traitement en fonction du type d'objet
			try
	        	{
	        		var arrByteData:ByteArray=objData as ByteArray
	        		fileStream.writeBytes(arrByteData);
	        	} catch(e:Error)
	        	{
	        		sendNotification(NotificationConstants.SHOW_ERROR_NOTIFICATION,"Error on create image");
	        		return;
	        	}
			
        	fileStream.close();	
        } 
        
        protected function get printmappanel():PrintMapPanel
        {
            return viewComponent as PrintMapPanel;
        }
		

		
	}
}