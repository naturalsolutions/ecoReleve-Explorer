package org.ns.dataconnecteur.shell.view
{
	
	import flash.events.Event;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import flash.display.DisplayObject;
	import mx.managers.PopUpManager;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.ribbon.About;
	import org.ns.dataconnecteur.shell.view.components.Ribbon;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class RibbonMediator extends FlexMediator
	{
		public static const NAME:String = 'RibbonMediator';
		
		public function RibbonMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new DataPanelMediator(ribbon.MyDataPanel));
			registerMediator(new EnhancePanelMediator(ribbon.MyEnhancePanel));
			registerMediator(new DeletePanelMediator(ribbon.MyDeletePanel));
			registerMediator(new SettingsPanelMediator(ribbon.MySettingsPanel));
			ribbon.myRibbon.addEventListener("aboutClick",openAbout);
		}
		
		//RESPONDER
		
		
		//REACTIONS		
		
		//PRIVATE FUNCTION
		private function openAbout(event:Event):void
		{
			//open popup settings
			var window:IFlexDisplayObject = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, About, true );
			
			registerMediator(new AboutMediator(window))
			PopUpManager.centerPopUp( window );
		}
		
		//GETTER		
		public function get ribbon():Ribbon
		{
			return this.viewComponent as Ribbon;
		}
		
	}
}