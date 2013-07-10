package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.*;
	import com.ecoReleve.view.mycomponents.ribbon.About;
	import com.ecoReleve.view.mycomponents.ribbon.Ribbon;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class RibbonMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "RibbonMediator";	
		
		public function RibbonMediator(viewComponent:Ribbon)
		{
			super(NAME, viewComponent);		
		}   
        
		override public function onRegister():void
		{
			super.onRegister();
			
			//registerMediator(new ConnectPanelMediator(ribbondisplay.MyDataPanel));
			registerMediator(new DataPanelMediator(ribbondisplay.MyDataPanel));
			registerMediator(new InputPanelMediator(ribbondisplay.MyInputPanel));
			registerMediator(new OutputPanelMediator(ribbondisplay.MyOutputPanel));
			registerMediator(new PrintMapPanelMediator(ribbondisplay.MyPrintMapPanel));
			registerMediator(new SearchPanelMediator(ribbondisplay.MySearchPanel));
			registerMediator(new BaseMapPanelMediator(ribbondisplay.MyBaseMap));
			//registerMediator(new LayerGroupPanelMediator(ribbondisplay.MyLayersPanel));
			registerMediator(new LayerManagerPanelMediator(ribbondisplay.MyLayerManagerPanel));
			registerMediator(new StyleClassColorPanelMediator(ribbondisplay.MyClassColorPanel));
			registerMediator(new ProportionalSizePanelMediator(ribbondisplay.MyProportionalSizePanel));
			registerMediator(new ViewPanelMediator(ribbondisplay.MyViewPanel));
			registerMediator(new LayerWMSPanelMediator(ribbondisplay.MyWMSPanel));
			registerMediator(new StylePanelMediator(ribbondisplay.MyStyleOpacityPanel));
			registerMediator(new GeoToolPanelMediator(ribbondisplay.MyGeoToolPanel));
			registerMediator(new OpenPanelMediator(ribbondisplay.MyOpenPanel));
			//registerMediator(new FilterPanelMediator(ribbondisplay.MyFilterPanel));
			//registerMediator(new DisplayPanelMediator(ribbondisplay.MyDisplayPanel));
			registerMediator(new ColumnPanelMediator(ribbondisplay.MyColumnPanel));
			registerMediator(new WidgetPanelMediator(ribbondisplay.MyWidgetPanel));
			registerMediator(new ClusterPanelMediator(ribbondisplay.MyClusterPanel));
			
			ribbondisplay.myRibbon.addEventListener("aboutClick",openAbout);

		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.MDIWINDOW_SHOWED];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.MDIWINDOW_SHOWED:
					var windowName:String=note.getBody() as String
					switch (windowName)
					{
						case "map":
							ribbondisplay.boMapEnabled=true
							ribbondisplay.boChartEnabled=false
							ribbondisplay.boTableEnabled=false
							ribbondisplay.myRibbon.selectedIndex=1
							break;
						case "chart":
							ribbondisplay.boChartEnabled=true
							ribbondisplay.boMapEnabled=false
							ribbondisplay.boTableEnabled=false
							ribbondisplay.myRibbon.selectedIndex=4
							break;
						case "table":
							ribbondisplay.boTableEnabled=true
							ribbondisplay.boMapEnabled=false
							ribbondisplay.boChartEnabled=false
							ribbondisplay.myRibbon.selectedIndex=3
							break;
					}
					break;
			}
		}
		
		
		//PRIVATE FUNCTION
		private function openAbout(event:Event):void
		{
			//open popup settings
			var window:IFlexDisplayObject = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, About, true );
			
			registerMediator(new AboutMediator(window))
			PopUpManager.centerPopUp( window );
		}
		
        //fonction de deconnexion     
        protected function onDeconnexion( event:Event ):void
        {
        	//notification de demande de déconnexion
        	sendNotification(NotificationConstants.DECONNEXION_NOTIFICATION,"login"); 
        }
        
        //fonction de deconnexion     
        protected function onMinimizeRibbon( event:Event ):void
        {
        	//notification de demande de déconnexion
        	sendNotification(NotificationConstants.RIBBON_CHANGE_SIZE_NOTIFICATION,"minimize"); 
        }
        
        //fonction de deconnexion     
        protected function onMaximizeRibbon( event:Event ):void
        {
        	//notification de demande de déconnexion
        	sendNotification(NotificationConstants.RIBBON_CHANGE_SIZE_NOTIFICATION,"maximize"); 
        }
           
        protected function get ribbondisplay():Ribbon
        {
            return viewComponent as Ribbon;
        }
		
	}
}