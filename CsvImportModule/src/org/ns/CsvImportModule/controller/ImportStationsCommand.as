package org.ns.CsvImportModule.controller
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.managers.CursorManager;
	
	import org.ns.CsvImportModule.model.VO.CsvMappingVO;
	import org.ns.CsvImportModule.model.proxy.FileCSVProxy;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.StationVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class ImportStationsCommand extends SimpleFabricationCommand
	{
		private var fileCsvProxy:FileCSVProxy
		private var dicFieldError:Dictionary=new Dictionary;
		
		override public function execute( note:INotification ):void
		{
			CursorManager.setBusyCursor();
			
			fileCsvProxy= facade.retrieveProxy( FileCSVProxy.NAME ) as FileCSVProxy;
			
			//get the mapped field object from notification body 
			var arrFieldMapping:ArrayCollection=note.getBody() as ArrayCollection
				
			//arraycollection fo stations
			var arrStations:ArrayCollection=new ArrayCollection;
			
			//replace csv name field by position (NONE ==> -1)
			var arrHeaderField:Array=new Array;
			arrHeaderField=fileCsvProxy.getHeader();
			
			for each(var csvMapping:CsvMappingVO in arrFieldMapping) {				
				csvMapping.CSV_INDEX=arrHeaderField.indexOf(csvMapping.CSV_FIELD);
			}
			
			//loop through each line to create array of station
			
			var separator:String=fileCsvProxy.getSeparator();
			var csvLines:ArrayCollection=fileCsvProxy.getCsvLines(false);
			
			for (var i:uint=0;i<csvLines.length-1;i++){
				if (csvLines[i].line!=""){
					var station:StationVO=fromCSV(csvLines[i].line,separator,arrFieldMapping);
					if (station!=null){
						arrStations.addItem(station);
					}
				}
			}	
			
			if (arrStations.length!=0){
				//notify everybody with collection of stationVO
				routeNotification(CommonNotificationConstants.STATIONS_IMPORTED,arrStations, "stations", "*")
			}else{
				//notify everybody that no stations will be loaded
				var msg:String=''
				if (dicFieldError.length!=0){
					msg="0 stations imported because of error(s): "

					for (var key:Object in dicFieldError){
						msg+="\n - field: '" + String(key) + "' ==> " + String(dicFieldError[key]) + " line(s) error(s)"
					}	
				}else{
					msg="0 stations imported because of unknown error(s)"
				}
							
				routeNotification(CommonNotificationConstants.STATIONS_IMPORTED_FAILED,msg,"csv import failed", "*")
			}
			
			//notify module of the end of import
			sendNotification(NotificationConstants.IMPORT_FINISHED_NOTIFICATION);			
			CursorManager.removeBusyCursor();
			
		}
		
		private function fromCSV(csvline:String,separator:String,arrFieldMapping:ArrayCollection):StationVO
		{
			var data:StationVO = new StationVO();
			
			//default value ==> will be override if a mapping column has been choosed
			data.sta_nbIndividual=1
			
			
			var arr:Array=csvline.split(separator);
			
			for each(var csvMapping:CsvMappingVO in arrFieldMapping) {
				if (csvMapping.CSV_INDEX!=-1){	                      //-1 ==> NONE
					try {
						var str:String=arr[csvMapping.CSV_INDEX]
						str=str.replace('"','');
						str=str.replace('"','');
						if (csvMapping.STA_FIELD=="sta_date"){
							var d:Date = DateField.stringToDate(str,csvMapping.FORMAT);	
							data["sta_date"]=d
							data["sta_dateY"]=String(d.fullYear);
							data["sta_dateYM"]=data["sta_dateY"] + "-" + String(d.month);
							data["sta_dateYMD"]=data["sta_dateYM"] + "-" + String(d.date);
						}else {						
							if (csvMapping.FORMAT=='numeric'){							
								data[csvMapping.STA_FIELD]=Number(str.replace(',','.'));
							}else {
								data[csvMapping.STA_FIELD]=str
							}
						}
					}catch (e:Error) {
						//add to tableau of field error if field isn't found
						if (dicFieldError.hasOwnProperty(csvMapping.CSV_FIELD)==false){
							dicFieldError[csvMapping.CSV_FIELD]=1
						}else{
							dicFieldError[csvMapping.CSV_FIELD]+=1
						}
						trace(e.message)
						return null
					}
				}
			}
			
			//add source and query info
			data.sta_fkQuery=null
			data.sta_source=fileCsvProxy.f.nativePath
			
			return data;
		} 
		
	}
}