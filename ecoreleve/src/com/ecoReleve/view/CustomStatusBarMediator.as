package com.ecoReleve.view
{
	import air.net.URLMonitor;
	
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.CustomStatusBar;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.filesystem.*;
	import flash.net.URLRequest;
	import com.ecoReleve.utils.Debug;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class CustomStatusBarMediator extends Mediator implements IMediator
	{        	 

	    private var strServerURLMonitor: String = 'https://r21854.ovh.net:8443/';
	    private var strGeoServerURLMonitor: String = 'https://r21854.ovh.net:8443/geoserver/web/';  
	
	    private var urlSrvMonitor:URLMonitor;
	    private var urlGeoSrvMonitor:URLMonitor;
		
		//nom du médiator
	    public static const NAME:String = "CustomStatusBarMediator";	
		private var MapMediator:DisplayMapMediator;
		
		public function CustomStatusBarMediator(viewComponent:CustomStatusBar)
		{
			super(NAME, viewComponent);			
		}  

		override public function onRegister():void
		{
			super.onRegister();
			
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange); 
			
			// run monitorConnection 
			monitorConnection();
			
		}
		
		
		/* 
         This function checks the online status by attempting 
         to resolve a connection to a remote address 
         */ 
         private function monitorConnection():void 
         { 
         	//Server monitor
             var urlSrv:URLRequest = new URLRequest(strServerURLMonitor);   
			 urlSrv.method = "HEAD";  
             urlSrvMonitor = new URLMonitor(urlSrv); 
             urlSrvMonitor.pollInterval=1000
             urlSrvMonitor.addEventListener(StatusEvent.STATUS,announceStatus); 
             urlSrvMonitor.start();
             
             //Geoserver monitor
             var urlGeoSrv:URLRequest = new URLRequest(strGeoServerURLMonitor);   
			 urlGeoSrv.method = "HEAD";  
             urlGeoSrvMonitor = new URLMonitor(urlGeoSrv); 
             urlGeoSrvMonitor.pollInterval=1000
             urlGeoSrvMonitor.addEventListener(StatusEvent.STATUS,announceStatus); 
             urlGeoSrvMonitor.start();
         } 
  
         /* 
         Declare the status from the monitorConnection function 
         and set the value to the variable isOnline 
         */ 
         private function announceStatus(e:StatusEvent):void 
         { 
             //Debug.doTrace(this,"Status change. Current status: " + monitor.available);
             Debug.doTrace(this,e.target.toString()) 
             
             if (urlSrvMonitor.available==true) {
             	customstatusbar.lblServerStatus.setStyle("color","green");
             } else {
             	customstatusbar.lblServerStatus.setStyle("color","red");
             	//32768:16711681
             }
             
             if (urlGeoSrvMonitor.available==true) {
             	customstatusbar.lblGeoserverStatus.setStyle("color","green");
             } else {
             	customstatusbar.lblGeoserverStatus.setStyle("color","red");
             	//32768:16711681
             } 
             
         } 
  
         /* 
         The network connection has changed. 
         Run the monitorConnection function to check status 
         */ 
         private function onNetworkChange(event:Event):void 
         { 
             Debug.doTrace(this,'network change'); 
             monitorConnection(); 
         }
		      
        protected function get customstatusbar():CustomStatusBar
        {
            return viewComponent as CustomStatusBar;
        }
		

		
	}
}