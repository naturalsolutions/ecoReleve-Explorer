package org.ns.dataconnecteur.shell.view
{	
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import flash.display.DisplayObject;
	import mx.managers.PopUpManager;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.managers.Account;
	import org.ns.dataconnecteur.shell.view.components.managers.Global;
	import org.ns.dataconnecteur.shell.view.components.managers.Query;
	import org.ns.dataconnecteur.shell.view.components.ribbon.SettingsPanel;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class SettingsPanelMediator extends FlexMediator
	{
		public static const NAME:String = 'SettingsPanelMediator';
		
		public function SettingsPanelMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);	
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER
		
		
		//REACTIONS
		public function reactToBtnQueries$Click(event:MouseEvent):void
		{
			//open popup settings
			var window:IFlexDisplayObject = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, Query, true );
			
			if (hasMediator(QueryMediator.NAME)){
				removeMediator(QueryMediator.NAME)
			}
			registerMediator(new QueryMediator(window))
			PopUpManager.centerPopUp( window );
		}
		
		public function reactToBtnDatasources$Click(event:MouseEvent):void
		{
			//open popup settings
			var window:IFlexDisplayObject = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, Account, true );
			
			if (hasMediator(AccountMediator.NAME)){
				removeMediator(AccountMediator.NAME)
			}
			registerMediator(new AccountMediator(window))
			PopUpManager.centerPopUp( window );
		}
		
		public function reactToBtnDatabase$Click(event:MouseEvent):void
		{
			//open popup settings
			var window:IFlexDisplayObject = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, Global, true );
			
			if (hasMediator(GlobalMediator.NAME)){
				removeMediator(GlobalMediator.NAME)
			}
			registerMediator(new GlobalMediator(window))
			PopUpManager.centerPopUp( window );
		}
	
		//GETTER		
		public function get pnlSettings():SettingsPanel
		{
			return this.viewComponent as SettingsPanel;
		}
		
	}
}