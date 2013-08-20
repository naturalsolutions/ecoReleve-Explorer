package org.ns.XmlImportModule.controller
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.managers.CursorManager;
	
	import org.ns.XmlImportModule.model.proxy.FileXMLProxy;
	import org.ns.common.model.VO.StationVO;
	import org.ns.common.model.utils.StationVOCast;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class ImportStationsCommand extends SimpleFabricationCommand
	{
		
		override public function execute( note:INotification ):void
		{
			CursorManager.setBusyCursor();
			
			var xml:XML=note.getBody() as XML
			
			var fileXmlProxy:FileXMLProxy=retrieveProxy(FileXMLProxy.NAME) as FileXMLProxy;
			
			var extension:String=fileXmlProxy.extension;
			var file:File=fileXmlProxy.f;
			
			//arraycollection for stations
			var arrStations:ArrayCollection=new ArrayCollection;
			
			var station:StationVO
			switch (extension)
			{
				case "xml":	
					var sighting:XML
					for each(sighting in xml.sightings.children()){
					station=StationVOCast.fromFauneML(sighting,file.nativePath) as StationVO;
						if (station!=null){
							arrStations.addItem(station);
						}
					}					 
					break;
				case "nsml":
					var RELEVE:XML
					var WHAT:XML
					var WHERE:XML
					var WHEN:XML
					var WHO:XML
					for each(RELEVE in xml.children()){
						WHERE=new XML(RELEVE.WHERE)
						WHEN=new XML(RELEVE.WHEN)
						WHO	=new XML(RELEVE.WHO)			
						for each(WHAT in RELEVE.WHAT){
							station=StationVOCast.fromNSML(WHEN,WHERE,WHO,WHAT,file.nativePath) as StationVO;
							if (station!=null){
								arrStations.addItem(station);
							}
						}
				}
					break;
			}
			
			if (arrStations.length!=0){
				//notify everybody with collection of stationVO
				routeNotification(CommonNotificationConstants.STATIONS_IMPORTED,arrStations, "stations", "*")
			}else{
				//notify everybody that no stations will be loaded
				routeNotification(CommonNotificationConstants.STATIONS_IMPORTED_FAILED,"0 stations imported because of unknown error(s)","xml import failed", "*")
			}
			
			//notify module of the end of import
			sendNotification(NotificationConstants.IMPORT_FINISHED_NOTIFICATION);
			CursorManager.removeBusyCursor();
			
		}

	}
}