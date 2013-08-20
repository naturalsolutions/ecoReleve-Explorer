package com.importCSV.controller
{
	import com.importCSV.model.VO.CsvMappingVO;
	import com.importCSV.model.VO.StationVO;
	import com.importCSV.model.proxy.FileImportProxy;
	import com.importCSV.view.ApplicationFacade;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GetCsvCommand extends SimpleCommand implements ICommand
	{
		override public function execute( note:INotification ):void
		{
			var fileImportProxy:FileImportProxy = facade.retrieveProxy( FileImportProxy.NAME ) as FileImportProxy;
			
			//get the mapped field object from notification body 
			var arrFieldMapping:ArrayCollection=note.getBody() as ArrayCollection
				
			//arraycollection fo stations
			var arrStations:ArrayCollection=new ArrayCollection;
			
			//replace csv name field by position (NONE ==> -1)
			var arrHeaderField:Array=new Array;
			arrHeaderField=fileImportProxy.getHeader();
			
			for each(var csvMapping:CsvMappingVO in arrFieldMapping) {				
				csvMapping.CSV_INDEX=arrHeaderField.indexOf(csvMapping.CSV_FIELD);
			}
			
			//loop through each line to create station
			
			var separator:String=fileImportProxy.getSeparator();
			var csvLines:ArrayCollection=fileImportProxy.getCsvLines(false);
			
			for (var i:uint=0;i<csvLines.length;i++){
				arrStations.addItem(StationVO.fromCSV(csvLines[i],separator,arrFieldMapping));
			}	
			
			//add to StationProxy
			
		}
		
	}
}