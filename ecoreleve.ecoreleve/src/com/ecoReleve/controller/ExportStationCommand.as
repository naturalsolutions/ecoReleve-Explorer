package com.ecoReleve.controller
{
	import com.ecoReleve.model.StationEnhanceProxy;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.filesystem.*;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.controls.HTML;
	
	import org.hamcrest.mxml.object.Null;
	import org.ns.common.model.VO.StationVO;
	import org.ns.common.model.utils.StationVOCast;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class ExportStationCommand extends SimpleFabricationCommand
    {
		private var xml:XML;
		private var xsl:XML;
		private var myFile:File;
		private var format:String='';
		private var html:HTMLLoader=new HTMLLoader();
		private var nbStation:Number=0;
		
		override public function execute(note:INotification):void 
    	{    		         	
			//get format
			format=note.getBody() as String
			
			var pxyData:StationEnhanceProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy;
			var stations:ArrayCollection=pxyData.stations as ArrayCollection
			
			//Convert stations to NSML
			var station:StationVO
			var strXML:String='<RELEVES>'
			for each(station in stations){
				nbStation+=1;
				strXML+=StationVOCast.toNSML(station) as String	
			}	
			strXML+='</RELEVES>'

			xml=new XML(strXML)	
			onBrowse()	
		}
		
		//Ouvre un browser de fichier 
		private function onBrowse() : void 
		{	var file:File=new File();
			//var nsmlFilter:FileFilter = new FileFilter("NSML", "*.nsml");
			file.addEventListener(Event.SELECT,fileSelectHandler);
			file.browseForSave("Save as...")
		} 
		
		private function fileSelectHandler(event:Event):void
		{
			myFile=File.desktopDirectory.resolvePath(event.target.nativePath);
			
			switch (format){
				case "nsml":
					saveFile(myFile,xml)
					break
				default :
						html.addEventListener(Event.COMPLETE, htmlLoaded);
						html.load(new URLRequest("com/ecoReleve/ressources/html/xslt.html"));
					break
			}
			
		}

		private function htmlLoaded(e:Event):void 
		{
			var result:String='';
			
			switch (format){
				case "kml":
					xsl=new XML
					xsl=readXML("com/ecoReleve/ressources/xslt/KML.xsl")
					result=html.window.transformXML(xml,xsl);
					break
				case "csv":
					xsl=new XML
					xsl=readXML("com/ecoReleve/ressources/xslt/CSV.xsl")
					result=html.window.transformXML(xml,xsl);
					break
				case "gpx":
					xsl=new XML
					xsl=readXML("com/ecoReleve/ressources/xslt/GPX.xsl")
					result=html.window.transformXML(xml,xsl);
					break
			}
	
			xml=new XML(result)
			saveFile(myFile,xml)	
		}
		
		private function saveFile(myFile:File,xml:XML):void
		{		
			var fileStream:FileStream=new FileStream();
			fileStream.addEventListener(Event.CLOSE,closeHandler);
			fileStream.addEventListener(IOErrorEvent.IO_ERROR,onIOerror)
			
			//test si l'extension est ajoutée sinon ajoute la bonne extension
			if (myFile.extension==null){
				myFile.url += "." + format;
			}else{
				//mauvais format
				if(myFile.extension!= format){
					myFile.url=myFile.url.replace(myFile.extension,format)
				}
			}

			fileStream.openAsync(myFile,FileMode.WRITE);
			
			try
			{
				//sendNotification(NotificationConstants.STATIONS_EXPORT_NOTIFICATION,"Export data");
				fileStream.writeUTFBytes(xml.toString());
			} catch(e:Error)
			{
				sendNotification(NotificationConstants.STATIONS_EXPORTED_NOTIFICATION,"Unknown error","error");
				return;
			}
			
			fileStream.close();	
		} 
		
		private function closeHandler(event:Event):void 
		{
			var msg:String=String(nbStation) + " station(s) exported in " + format + " file"
			sendNotification(NotificationConstants.STATIONS_EXPORTED_NOTIFICATION,msg,"done");
		}
		
		
		private function onIOerror(event:IOErrorEvent):void 
		{
			sendNotification(NotificationConstants.STATIONS_EXPORTED_NOTIFICATION,event.text,"error");
		}
		
		private function readXML(url:String):XML
		{
			var file:File = File.applicationDirectory.resolvePath(url);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var xml:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			return xml
		}
		
    }

}