package com.importCSV.controller
{
	import com.importCSV.model.proxy.FileImportProxy;
	import com.importCSV.view.ApplicationFacade;
	import com.importCSV.view.MainMediator;
	import com.importCSV.view.mycomponents.Main;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class FileDropedCommand extends SimpleCommand implements ICommand
	{
		override public function execute( note:INotification ):void
		{
			var fileImportProxy:FileImportProxy = facade.retrieveProxy( FileImportProxy.NAME ) as FileImportProxy;
			
			//assign the file to import to the proxy
			var myFile:File=note.getBody() as File
			
			if (myFile.extension=="csv"){	
				
				fileImportProxy.f=myFile;			
				//do the import
				fileImportProxy.fileImport();
				
				//go to step2
				//var medMain:MainMediator=facade.retrieveMediator(MainMediator.NAME) as MainMediator;
				//var e:Event=new Event('test', true );
				//medMain.onNext(e)			
			}
		}
		
	}
}