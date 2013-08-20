package org.ns.genericComponents.Updater
{
	import air.update.ApplicationUpdater;
	import air.update.events.DownloadErrorEvent;
	import air.update.events.StatusFileUpdateErrorEvent;
	import air.update.events.StatusFileUpdateEvent;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.osmf.events.TimeEvent;
	
	public class UpdaterManager
	{
		private var appUpdater:ApplicationUpdater;
		private var appVersion:String;
		private var baseURL:String;
		private var pnlUpdater:UpdaterPanel;
		private var updateURL:String
		private var isFirstRun:String;
		private var upateVersion:String;
		private var applicationName:String;
		private var installedVersion:String;
		private var description:String;
		
		private var initializeCheckNow:Boolean = false;
		private var isInstallPostponed:Boolean = false;
		private var showCheckState:Boolean = true;
		
		/**
		 * Constructer for UpdateManager Class
		 *
		 * @param showCheckState Boolean value to show the Check Now dialog box
		 * @param initializeCheckNow Boolean value to initialize application and run check on instantiation of the Class
		 * */
		public function UpdaterManager(url:String)
		{
			this.updateURL = url;
			initialize();
		}
		
		public function updateCheckNow(event:UpdateEvent):void
		{
			appUpdater.checkNow();
		}
		
		//---------- ApplicationUpdater ----------------//
		
		private function initialize():void
		{
			if(!appUpdater){
				appUpdater = new ApplicationUpdater();
				appUpdater.updateURL=updateURL;
				appUpdater.addEventListener(UpdateEvent.INITIALIZED, updaterInitialized);
				appUpdater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, statusUpdate);
				//appUpdater.addEventListener(UpdateEvent.BEFORE_INSTALL, beforeInstall);
				appUpdater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, statusUpdateError);
				//appUpdater.addEventListener(UpdateEvent.DOWNLOAD_START, downloadStarted);
				appUpdater.addEventListener(ProgressEvent.PROGRESS, downloadProgress);
				appUpdater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, downloadComplete);
				appUpdater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, downloadError);
				//appUpdater.addEventListener(ErrorEvent.ERROR, updaterError);
				appUpdater.initialize();
			}
		}

		private function updaterInitialized(event:UpdateEvent):void
		{
			this.isFirstRun = event.target.isFirstRun;
			this.applicationName = getApplicationName();
			this.installedVersion = getApplicationVersion();
			
			appUpdater.checkNow();
		}
		
		private function statusUpdate(event:StatusUpdateEvent):void
		{
			event.preventDefault();
			if(event.available){
				this.description = getUpdateDescription(event.details);
				this.upateVersion = event.version;
				
				createWindow()
			}
		}

		private function downloadProgress(event:ProgressEvent):void
		{
			pnlUpdater.updateState(UpdaterPanel.DOWNLOADING);
			var num:Number = (event.bytesLoaded/event.bytesTotal)*100;
			pnlUpdater.downloadProgress(num);
		}
		
		private function downloadComplete(event:UpdateEvent):void
		{
			var timer:Timer=new Timer(1000,3);
			timer.addEventListener(TimerEvent.TIMER,timerHandler)
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,installUpdate)
			timer.start()
			pnlUpdater.updateState(UpdaterPanel.BEFORE_INSTALL)
		}
		
		/** Timer handler
		 **/
		private function timerHandler(event:TimerEvent):void
		{
			var timer:Timer=event.currentTarget as Timer
			pnlUpdater.installCountDown(timer.repeatCount - timer.currentCount)
		}
		
		private function statusUpdateError(event:StatusUpdateErrorEvent):void
		{
			//ATTENTION pnlUpdater not create yet
			//pnlUpdater.updateState(UpdaterPanel.ERROR)
		}
		
		private function downloadError(event:DownloadErrorEvent):void
		{
			pnlUpdater.updateState(UpdaterPanel.ERROR)
		}
		
		private function createWindow():void
		{
			if(!pnlUpdater) {
				pnlUpdater = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,UpdaterPanel,false) as UpdaterPanel
				PopUpManager.centerPopUp(pnlUpdater);
				
				pnlUpdater.applicationName = this.applicationName;
				pnlUpdater.installedVersion = this.installedVersion;
				pnlUpdater.updateVersion = this.upateVersion;
				//pnlUpdater.updateState = state;
				//pnlUpdater.description = this.description;
				pnlUpdater.addEventListener(UpdaterPanel.EVENT_INSTALL_UPDATE, installUpdate);
				pnlUpdater.addEventListener(UpdaterPanel.EVENT_DOWNLOAD_UPDATE, downloadUpdate);
				pnlUpdater.addEventListener(UpdaterPanel.EVENT_CANCEL_UPDATE, cancelUpdate);

			}
		}
		
		/**
		 * Download the update.
		 * */
		private function downloadUpdate(event:Event):void
		{
			appUpdater.downloadUpdate();
		}
		
		/**
		 * Install the update.
		 * */
		private function installUpdate(event:Event):void
		{
			appUpdater.installUpdate();
		}
		
		
		/**
		 * Cancel the update.
		 * */
		private function cancelUpdate(event:Event):void
		{
			appUpdater.cancelUpdate();
			destroy()
		}
		
		//---------- Destroy All ----------------//
		
		private function destroy():void
		{
			if (appUpdater) {
				
				appUpdater.removeEventListener(UpdateEvent.INITIALIZED, updaterInitialized);
				appUpdater.removeEventListener(StatusUpdateEvent.UPDATE_STATUS, statusUpdate);
				//appUpdater.removeEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, statusUpdateError);
				//appUpdater.removeEventListener(UpdateEvent.DOWNLOAD_START, downloadStarted);
				appUpdater.removeEventListener(ProgressEvent.PROGRESS, downloadProgress);
				//appUpdater.removeEventListener(UpdateEvent.DOWNLOAD_COMPLETE, downloadComplete);
				//appUpdater.removeEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, downloadError);
				//appUpdater.removeEventListener(UpdateEvent.BEFORE_INSTALL, beforeInstall);
				//appUpdater.removeEventListener(ErrorEvent.ERROR, updaterError);
				
				
				appUpdater = null;
			}
			
			destroyUpdater();
		}
		
		private function destroyUpdater():void
		{
			if(pnlUpdater) {
				pnlUpdater.removeEventListener(UpdaterPanel.EVENT_INSTALL_UPDATE, installUpdate);
				pnlUpdater.removeEventListener(UpdaterPanel.EVENT_CANCEL_UPDATE, cancelUpdate);				
				PopUpManager.removePopUp(pnlUpdater)
				
			}
		}
		
		//---------- Utilities ----------------//
		
		/**
		 * Getter method to get the version of the application
		 * Based on Jens Krause blog post: http://www.websector.de/blog/2009/09/09/custom-applicationupdaterui-for-using-air-updater-framework-in-flex-4/
		 *
		 * @return String Version of application
		 *
		 */
		private function getApplicationVersion():String
		{
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			return appXML.ns::versionNumber;
		}
		
		/**
		 * Getter method to get the name of the application file
		 * Based on Jens Krause blog post: http://www.websector.de/blog/2009/09/09/custom-applicationupdaterui-for-using-air-updater-framework-in-flex-4/
		 *
		 * @return String name of application
		 *
		 */
		private function getApplicationFileName():String
		{
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			return appXML.ns::filename;
		}
		
		/**
		 * Getter method to get the name of the application, this does not support multi-language.
		 * Based on a method from Adobes ApplicationUpdateDialogs.mxml, which is part of Adobes AIR Updater Framework
		 * Also based on Jens Krause blog post: http://www.websector.de/blog/2009/09/09/custom-applicationupdaterui-for-using-air-updater-framework-in-flex-4/
		 *
		 * @return String name of application
		 *
		 */
		private function getApplicationName():String
		{
			var applicationName:String;
			var xmlNS:Namespace=new Namespace("http://www.w3.org/XML/1998/namespace");
			var appXML:XML=NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace=appXML.namespace();
			
			// filename is mandatory
			var elem:XMLList=appXML.ns::filename;
			
			// use name is if it exists in the application descriptor
			if ((appXML.ns::name).length() != 0)
			{
				elem=appXML.ns::name;
			}
			
			// See if element contains simple content
			if (elem.hasSimpleContent())
			{
				applicationName=elem.toString();
			}
			
			return applicationName;
		}
		
		/**
		 * Helper method to get release notes, this does not support multi-language.
		 * Based on a method from Adobes ApplicationUpdaterDialogs.mxml, which is part of Adobes AIR Updater Framework
		 * Also based on Jens Krause blog post: http://www.websector.de/blog/2009/09/09/custom-applicationupdaterui-for-using-air-updater-framework-in-flex-4/
		 *
		 * @param detail Array of details
		 * @return String Release notes depending on locale chain
		 *
		 */
		protected function getUpdateDescription(details:Array):String
		{
			var text:String="";
			
			if (details.length == 1)
			{
				text=details[0][1];
			}
			return text;
		}
	}
}
