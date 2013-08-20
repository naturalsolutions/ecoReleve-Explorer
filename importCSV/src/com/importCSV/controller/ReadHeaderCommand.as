package com.importCSV.controller
{
	import com.importCSV.model.proxy.FileImportProxy;
	import com.importCSV.view.ApplicationFacade;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ReadHeaderCommand extends SimpleCommand implements ICommand
	{
		override public function execute( note:INotification ):void
		{
			var fileImportProxy:FileImportProxy = facade.retrieveProxy( FileImportProxy.NAME ) as FileImportProxy;
			var arrHeaderField:ArrayCollection=new ArrayCollection;
			
			//get parameters (headerRow and separator) from body notification
			var arrParameters:Array=note.getBody() as Array
			var headerRow:uint=uint(arrParameters[0]);	
			var separator:String=String(arrParameters[1]);	
			
			//define header row in proxy
			fileImportProxy.headerRow=headerRow;
			fileImportProxy.separator=separator;
			
			//add NONE value to the begining of the arrayCollection
			var arr:Array=fileImportProxy.getHeader();
			arr.unshift("NONE");
			arrHeaderField=new ArrayCollection(arr);
			
			
			sendNotification(ApplicationFacade.HEADER_READED_NOTIFICATION,arrHeaderField);
		}
		
	}
}