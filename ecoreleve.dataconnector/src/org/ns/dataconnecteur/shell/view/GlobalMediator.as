package org.ns.dataconnecteur.shell.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.view.components.managers.Global;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class GlobalMediator extends FlexMediator
	{
		public static const NAME:String = 'GlobalMediator';
		private var pxyDB:DatabaseProxy;
		
		public function GlobalMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			global.btnCompact.addEventListener(MouseEvent.CLICK,btnCompactClickHandler)
			pxyDB=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy
			global.dbFile=pxyDB.getSqlFile
				
			global.dbRelease= DatabaseProxy.DB_RELEASE
		}
		
		//RESPONDER
		public function respondToSqliteCompacted(note:INotification):void
		{
			global.dbFile=pxyDB.getSqlFile
		}
		
		//REACTIONS
		public function reactToGlobalClose(event:CloseEvent):void 
		{
			PopUpManager.removePopUp(global);
			removeMediator(GlobalMediator.NAME);
		}
		
		public function btnCompactClickHandler(event:MouseEvent):void
		{
			sendNotification(NotificationConstants.SQLITE_COMPACT_NOTIFICATION)
		}
		
		//GETTER		
		public function get global():Global
		{
			return this.viewComponent as Global;
		}
		
	}
}