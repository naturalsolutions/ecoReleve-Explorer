package org.ns.genericComponents.Updater
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.ProgressBar;
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.Updater.skin.UpdaterPanelSkin;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.Panel;
	
	public class UpdaterPanel extends Panel
	{
		
		[SkinPart(required="true")] public var btnYes:Button;
		[SkinPart(required="true")] public var btnNo:Button;
		[SkinPart(required="true")] public var prgBar:ProgressBar;
		[SkinPart(required="true")] public var lblInstall:Label;
		[SkinPart(required="true")] public var app:Label;
		[SkinPart(required="true")] public var curVer:Label;
		[SkinPart(required="true")] public var upVer:Label;
			
		[SkinState("normalAndBeforeInstall")]
		[SkinState("normalAndError")]
		[SkinState("normalAndDownloading")]
		[SkinState("normalAndInstall")]
		
		public static var EVENT_DOWNLOAD_UPDATE:String 	= "downloadUpdate";
		public static var EVENT_INSTALL_UPDATE:String 	= "installUpdate";
		public static var EVENT_CANCEL_UPDATE:String 	= "cancelUpdate";
		
		public static const BEFORE_INSTALL:String 		= "beforeInstall";
		public static const ERROR:String 				= "error";	 
		public static const DOWNLOADING:String 			= "downloading";
		public static const INSTALL:String 				= "install";
		
		private var value:String;
		
		public function set installedVersion(value:String):void
		{
			curVer.text='Installed version: ' + value;
		}
		public function set updateVersion(value:String):void
		{
			upVer.text = 'Update version: ' + value;
		}
		
		public function set applicationName(value:String):void
		{
			app.text = 'Application: ' + value;
		}

		
		public function UpdaterPanel()
		{
			super();
			setStyle("skinClass",UpdaterPanelSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			btnYes.addEventListener(MouseEvent.CLICK,btnYesHandler)
			btnNo.addEventListener(MouseEvent.CLICK,btnNoHandler)
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function getCurrentSkinState():String
		{
			var skinState:String = super.getCurrentSkinState();
			
			switch(value)
			{
				case DOWNLOADING:
					skinState+="AndDownloading";
					break;	
				case BEFORE_INSTALL:
					skinState+="AndBeforeInstall";
					break;	
				case ERROR:
					skinState+="AndError";
					break;
			}
			
			return skinState;
		}
		
		//HANDLERS----------------------------------------------------------------------------------------------------
		
		private function btnYesHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new Event(EVENT_DOWNLOAD_UPDATE));
		}
		
		private function btnNoHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new Event(EVENT_CANCEL_UPDATE));
		}
		
		//---------------------------------------------------------------
		
		public function updateState(state:String):void
		{
			value=state
			this.invalidateSkinState();
		}
		
		public function downloadProgress(value:Number):void
		{
			if(prgBar){
				prgBar.setProgress(value, 100);
			} 
		}
		
		public function installCountDown(value:Number):void
		{
			lblInstall.text="The new release will be install in " + String(value) + " s "
		}
		
	}
}