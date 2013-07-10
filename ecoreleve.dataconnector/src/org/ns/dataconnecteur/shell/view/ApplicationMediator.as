package org.ns.dataconnecteur.shell.view
{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElement;
	import mx.effects.Parallel;
	import mx.events.CloseEvent;
	import mx.managers.*;
	import flash.utils.*;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.genericComponents.Updater.UpdaterManager;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.TitleWindow;
	import spark.effects.Fade;
	import spark.effects.Scale;
	import spark.modules.Module;
	
	public class ApplicationMediator extends FlexMediator
	{
		public static const NAME:String = 'ApplicationMediator';
		
		private var wizardContainer:SkinnableContainer;
		private var closeIsBlocked:Boolean=true;
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);			
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new RibbonMediator(app.Ribbon));
			
			//listener for the drag enter event
			app.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);			
			//listener for the drag drop event
			app.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			
			//listener for the close app event
			app.addEventListener(Event.CLOSING,closeAppHandler)
			
			//notify to init sqlite
			sendNotification(NotificationConstants.INITIALIZE_SQLITE_NOTIFICATION);	
			
			
			//UPDATER
			var mgUpdater:UpdaterManager=new UpdaterManager('http://ecoreleve.googlecode.com/files/update_dataConnecteur.xml');
		}

		
		//called when the user drags an item into the component area
		private function onDragIn(event:NativeDragEvent):void
		{
			//check and see if files are being drug in
			if(event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				//get the array of files
				var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				
				//make sure only one file is dragged in (i.e. this app doesn't
				//support dragging in multiple files)
				if(files.length == 1)
				{
					var myFile:File=files[0] as File
					//if extension is csv or nsml
					if (myFile.extension=="csv" || myFile.extension=="nsml" || myFile.extension=="xml"){
						//accept the drag action
						NativeDragManager.acceptDragDrop(app);
					}
				}
			}
		}
		
		//called when the user drops an item over the component
		private function onDragDrop(event:NativeDragEvent):void
		{
			//get the array of files being drug into the app
			var arr:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			//grab the files file
			var myFile:File = File(arr[0]);
			
			//notify with file as param
			sendNotification(NotificationConstants.FILE_DROPED_NOTIFICATION,myFile,myFile.extension)
				
		}
		
		private function closeAppHandler(event:Event):void
		{
			if (closeIsBlocked==true){
				//cancel closing event
				event.preventDefault()
					
				//notify app to close sqlite (and do some stuff on it)
				sendNotification(NotificationConstants.SQLITE_CLOSE_NOTIFICATION)	
			}
		}
		
		//RESPONDER
		public function respondToSqliteDbIsReady(note:INotification):void
		{
			//registerMediator(new CommandBarMediator(app.Shell));
			registerMediator(new ReportMediator(app.Report));
		}	
		
		public function respondToQueryUnpersistentDeleted(note:INotification):void
		{
			//unblock the close event
			closeIsBlocked=false
			//close app
			app.close()
		}

		public function respondToStationsImportedFailed(note:INotification):void
		{
			//masque le panel message aprés 5 sec
			app.MyMsg.pnl.title=note.getType()
			app.MyMsg.descriptif.text=note.getBody() as String
			app.MyMsg.visible=true
			//setTimeout(hideMessage,5000)
		}
		
		public function respondToHttpRequested(note:INotification):void
		{
			sendNotification(NotificationConstants.LOG_NOTIFICATION,note.getBody() as String,note.getType() as String);
		}
		
		private function hideMessage():void
		{
			app.MyMsg.visible=false
		}
		
		
		//REACTIONS
		
		//GETTER
		public function get app():DataConnecteur
		{
			return this.viewComponent as DataConnecteur;
		}
	}
}