package org.ns.dataconnecteur.shell.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.*;
	import mx.events.CloseEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.PopUpManager;
	
	import org.ns.common.model.VO.ModuleVO;
	import org.ns.common.model.VO.RemoteDatasourceVO;
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteDatasourceProxy;
	import org.ns.dataconnecteur.shell.view.components.managers.Account;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class AccountMediator extends FlexMediator
	{
		public static const NAME:String = 'AccountMediator';
		
		public function AccountMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			//listener
			account.lstDatasources.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,datasourcesChangeHandler)
			
			refreshDatasources()
		}
		
		//RESPONDER
		public function respondToDatasourceInserted(note:Notification):void
		{
			refreshDatasources()
			account.currentState='default'
		}
		
		//REACTIONS		
		
		public function reactToAccountClose(event:CloseEvent):void 
		{
			PopUpManager.removePopUp(account);
			removeMediator(AccountMediator.NAME);
		}
		
		public function reactToBtnAddDatasource$Click(event:MouseEvent):void
		{
			var datasource:RemoteDatasourceVO=new RemoteDatasourceVO();
			datasource.rd_name=account.frmItmName.text
			datasource.rd_url=account.frmItmUrl.text
			datasource.rd_authRequired=account.frmItmAuth.selected
			if (account.frmItmAuth.selected==true){
				datasource.rd_login=account.frmItmLogin.text
				datasource.rd_password=account.frmItmPassword.text
			}
			var o:Object=account.frmItmLstData.selectedItem
			datasource.rd_logo=o.logo
			datasource.rd_type=o.type
			datasource.rd_format=o.format
			datasource.rd_fkModule=Number(o.module)
			
			sendNotification(NotificationConstants.INSERT_DATASOURCE_NOTIFICATION,datasource);
				
		}
		
		private function datasourcesChangeHandler(event:CollectionEvent):void
		{
			switch (event.kind) 
			{		
				case CollectionEventKind.UPDATE:
					for (var i:uint = 0; i < event.items.length; i++) {
						if (event.items[i] is PropertyChangeEvent) {
							if (PropertyChangeEvent(event.items[i]) != null) {
								sendNotification(NotificationConstants.UPDATE_DATASOURCE,event.items[i].source as RemoteDatasourceVO)
							}
						}
					}
					break;
				case CollectionEventKind.REMOVE:
					sendNotification(NotificationConstants.DELETE_DATASOURCE_NOTIFICATION,event.items[0] as RemoteDatasourceVO)
					break;
			}
		}
		
		//FUNCTIONS
		private function refreshDatasources():void
		{
			//get modules
			var pxyDatasource:RemoteDatasourceProxy=retrieveProxy(RemoteDatasourceProxy.NAME) as RemoteDatasourceProxy;
			
			account.arrDatasources.removeAll();
			
			for each(var datasource:RemoteDatasourceVO in pxyDatasource.getDatasources){
				account.arrDatasources.addItem(datasource)
			}
		}
		
		
		//GETTER		
		public function get account():Account
		{
			return this.viewComponent as Account;
		}
		
	}
}