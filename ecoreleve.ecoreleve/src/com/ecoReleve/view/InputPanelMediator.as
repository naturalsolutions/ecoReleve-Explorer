package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.ribbon.IOPanel.InputPanel;
	
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.FileFilter;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class InputPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "InputPanelMediator";	
		
		public function InputPanelMediator(viewComponent:InputPanel)
		{
			super(NAME, viewComponent);
		}   
        
		override public function onRegister():void
		{
			super.onRegister();
		
			inputpanel.addEventListener(InputPanel.IMPORT_NSML,onBrowse);
		}
		
        // Evenement UPLOAD: ouvre un browser de fichier 
		private function onBrowse(event:Event) : void 
		{
			var file:File=new File();
			var nsmlFilter:FileFilter = new FileFilter("NSML", "*.nsml");
			file.addEventListener(Event.SELECT,fileSelectHandler);
			file.browseForOpen("Select an NSML file to upload",[nsmlFilter])
		}      

             
        private function fileSelectHandler(event:Event):void
        {
        	readFile(event.target.nativePath);	
        }     
        
        private function readFile(strFile:String):void
        {
        	var myFile:File=File.desktopDirectory.resolvePath(strFile);
        	var fileStream:FileStream=new FileStream();
        	fileStream.open(myFile,FileMode.READ);
        	try
	        	{
	        	var xmlFile:XML=XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
	        	sendNotification(NotificationConstants.CONVERT_NSML_TO_XML_NOTIFICATION,xmlFile.toString());
	        	} catch(e:Error)
	        	{
	        		sendNotification(NotificationConstants.SHOW_ERROR_NOTIFICATION,"NSML mal formatted");
	        		return;
	        	}
        	fileStream.close();	
        } 
             
        protected function get inputpanel():InputPanel
        {
            return viewComponent as InputPanel;
        }
		

		
	}
}