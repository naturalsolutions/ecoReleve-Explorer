package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.MainDisplay;
	import com.ecoReleve.view.mycomponents.Message;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.ns.genericComponents.MDI.components.MDIWindow;
	import org.ns.genericComponents.MDI.events.MDIManagerEvent;
	import org.ns.genericComponents.Updater.UpdaterManager;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	import spark.components.Label;


	public class MainDisplayMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "maindisplaymediator";		
 		
		private var msgBox:Message
		
 		//constructeur
        public function MainDisplayMediator(viewComponent:MainDisplay)
        {
            super(NAME, viewComponent);       
        }
        
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new DisplayMapMediator(mainDisplay.MyStaMap)); 
			registerMediator(new RibbonMediator(mainDisplay.MyRibbon)); 
			registerMediator(new DisplayTableMediator(mainDisplay.MyPanelStationList));
			registerMediator(new LegendMediator(mainDisplay.MyPanelLegend));
			registerMediator(new DisplayChartMediator(mainDisplay.MyTimeLine));
			registerMediator(new FilterPanelMediator(mainDisplay.MyFilterPanel));
			registerMediator(new SelectionMediator(mainDisplay.selection));
			
			mainDisplay.cnvMDI.windowManager.addEventListener(MDIManagerEvent.WINDOW_SHOW,windowManager_showHandler)
			mainDisplay.addEventListener(MainDisplay.CHANGE_DISPLAY,changeTabBarHandler)
			
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.SHOW_MDIWINDOW,
					NotificationConstants.SELECT_STATIONS_NOTIFICATION,
					NotificationConstants.STATIONS_ADDED_NOTIFICATION,
					NotificationConstants.EXPORT_FILE_NOTIFICATION,
					NotificationConstants.STATIONS_EXPORTED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.SELECT_STATIONS_NOTIFICATION:
					showMessage("Loading stations");
					break;
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:
					//masque le panel message aprés 3 sec
					var arrCol:ArrayCollection=note.getBody() as ArrayCollection
					if(arrCol!=null){ 
						if (arrCol.length==0){
							changeMessage("No station(s) in database")
						}else{
							changeMessage(String(arrCol.length) +  " station(s) loaded")
						}
					}
					setTimeout(hideMessage,3000)					
					break;
				case NotificationConstants.EXPORT_FILE_NOTIFICATION:
					// affiche le panel message
					showMessage("Exporting stations")
					break;
				case NotificationConstants.STATIONS_EXPORTED_NOTIFICATION:
					//masque le panel message aprés 3 sec
					changeMessage(note.getBody() as String)
					setTimeout(hideMessage,3000)					
					break;
				case NotificationConstants.SHOW_MDIWINDOW:
					var display:String=note.getBody() as String
					var win:MDIWindow
					switch (display)
					{
						case 'table':
							win=mainDisplay.winTable
							break;
						case 'map':
							win=mainDisplay.winMap
							break;
						case 'chart':
							win=mainDisplay.winChart
							break;
					}
					mainDisplay.cnvMDI.windowManager.showWindow(win)
					break;
			}
		}
		
		private function changeTabBarHandler(event:Event):void
		{
			switch (mainDisplay.tabBar.selectedIndex){
				case 0:
					sendNotification(NotificationConstants.SHOW_MDIWINDOW,"map","windowName")
					break;
				case 1:
					sendNotification(NotificationConstants.SHOW_MDIWINDOW,"table","windowName")
					break;
				case 2:
					sendNotification(NotificationConstants.SHOW_MDIWINDOW,"chart","windowName")
					break;
			}	
		}
		
		private function windowManager_showHandler(event:MDIManagerEvent):void
		{	
			sendNotification(NotificationConstants.MDIWINDOW_SHOWED,event.window.title,"windowName")
		}
        
		private function hideMessage():void
		{
			PopUpManager.removePopUp(msgBox);
		}
		
		private function showMessage(msg:String):void
		{
			msgBox=new Message
			msgBox=PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,Message,false) as Message
			msgBox.msg.text= msg;
			PopUpManager.centerPopUp(msgBox)
		}
		
		private function changeMessage(msg:String):void
		{
			msgBox.msg.text=msg
		}
		
        protected function get mainDisplay():MainDisplay
        {
            return viewComponent as MainDisplay;
        }
    }
}