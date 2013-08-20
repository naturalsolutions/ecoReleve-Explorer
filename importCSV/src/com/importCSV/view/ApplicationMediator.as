package com.importCSV.view
{
	import air.net.URLMonitor;
	
	import com.importCSV.controller.*;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NativeDragEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ApplicationMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "ApplicationMediator";		

 				
 		//constructeur
        public function ApplicationMediator(viewComponent:Object)
        {
            super(NAME, viewComponent);
			facade.registerMediator(new MainMediator(app.main));
			
			//register for the drag enter event
			app.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);			
			//register for the drag drop event
			app.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
        }
        
        // Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			var strObjet:String="";
			
			switch ( note.getName() ) 
			{
				
			}
		}  
		
		//called when the user drags an item into the component area
		private function onDragIn(e:NativeDragEvent):void
		{
			//check and see if files are being drug in
			if(e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				//get the array of files
				var files:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				
				//make sure only one file is dragged in (i.e. this app doesn't
				//support dragging in multiple files)
				if(files.length == 1)
				{
					var myFile:File=files[0] as File
					//if extension is csv or nsml
					if (myFile.extension=="csv" || myFile.extension=="nsml" ){
						//accept the drag action
						NativeDragManager.acceptDragDrop(app);
					}
				}
			}
		}
		
		//called when the user drops an item over the component
		private function onDragDrop(e:NativeDragEvent):void
		{
			//get the array of files being drug into the app
			var arr:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			//grab the files file
			var myFile:File = File(arr[0]);
			sendNotification(ApplicationFacade.FILE_DROPED_NOTIFICATION,myFile)	
			
		}
		
        protected function get app():importCSV
        {
            return viewComponent as importCSV;
        }
    }
}