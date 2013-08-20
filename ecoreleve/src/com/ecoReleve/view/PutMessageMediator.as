package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.manager.PopManager;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.PutMessage;
	
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.FileFilter;
	import flash.xml.XMLNode;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PutMessageMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "PutMessageMediator";	
			
		public function PutMessageMediator(viewComponent:PutMessage)
		{
			super(NAME, viewComponent);
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			putmessage.addEventListener(PutMessage.CANCEL,onCancel)
			putmessage.addEventListener(PutMessage.SAVE,onSave)
		}
		
		override public function listNotificationInterests( ) : Array 
		{
			return [ApplicationSTATIONS_INSERTED_NOTIFICATION];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch (note.getName()) 
			{
				case ApplicationSTATIONS_INSERTED_NOTIFICATION:	
					var xml:XML=note.getBody() as XML
					parseXML(xml)
					break;
			}
		}
		
		/** 
		 * Parse XML result
		 **/
		private function parseXML(xml:XML):void 
		{
			//Test if there is an invalid file error
			if (xml.recordset.length()>0){								//INVALID FILE
				//change state to record state			
				putmessage.currentState="recordset"
			} else {													//VALID FILE
				//change state to record state			
				putmessage.currentState="record"
				
				//get number of stations succesfully imported
				var xmlSuccess:XMLList=xml.record.(success=='yes')
				if (xmlSuccess != null){
					putmessage.strNbSucess=String(xmlSuccess.length())
				}else{
					putmessage.strNbSucess="0"
				}
				
				//get number of station unsuccessfully imported
				var xmlError:XMLList=xml.record.(success=='no')
				if (xmlError != null){
					putmessage.strNbError=String(xmlError.length())
				}else{
					putmessage.strNbError="0"
				}
			}	
			
			//asign xml response
			putmessage.xml=xml
		}
		
		/** 
		 * Evenement Cancel: quitte le popup
		 **/
		private function onCancel(event:Event):void 
		{
			PopManager.closePopUpWindow(putmessage,PutMessageMediator.NAME)
		}
		
		/** 
		 * Evenement Save: save unsuccess import into xml
		 **/
		private function onSave(event:Event):void 
		{
			var file:File=new File();
			file.addEventListener(Event.SELECT,fileSelectHandler);
			file.browseForSave("Save as...");
		}
		
		private function fileSelectHandler(event:Event):void
		{	
			var strFilePath:String=event.target.nativePath
			if (strFilePath.lastIndexOf(".")==-1){
				strFilePath	=strFilePath + ".xml"
			}	
			
			var myFile:File=File.desktopDirectory.resolvePath(strFilePath);   		
			var fileStream:FileStream=new FileStream();
			fileStream.open(myFile,FileMode.WRITE);
			
			try
			{
				var strData:XMLList;
				if (putmessage.xml.recordset.length()>0){
					strData=putmessage.xml.recordset
				} else {
					strData=putmessage.xml.record.(success=='no')
				}
				fileStream.writeUTFBytes(strData);
			} catch(e:Error)
			{
				return;
			}
			
			fileStream.close();	
		}
		
        protected function get putmessage():PutMessage
        {
            return viewComponent as PutMessage;
        }
		

		
	}
}