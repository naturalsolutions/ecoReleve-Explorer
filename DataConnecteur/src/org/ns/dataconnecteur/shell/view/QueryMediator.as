package org.ns.dataconnecteur.shell.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.*;
	import mx.managers.PopUpManager;
	
	import org.ns.common.model.VO.QueryVO;
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.model.proxy.QueryProxy;
	import org.ns.dataconnecteur.shell.view.components.managers.Query;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class QueryMediator extends FlexMediator
	{
		public static const NAME:String = 'QueryMediator';
		
		public function QueryMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			//event listener
			query.lstQueries.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,queriesChangeHandler)
			query.addEventListener("deleteButtonClicked",deleteButtonClickHandler)
			
			//get queries
			var pxyQueries:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy;
			
			query.queries.removeAll();
			
			for each(var qry:QueryVO in pxyQueries.getQueryCollection){
				query.queries.addItem(qry)
			}
		}
		
		//RESPONDER

		
		//REACTIONS

		public function reactToQueryClose(event:CloseEvent):void 
		{
			PopUpManager.removePopUp(query);
			removeMediator(QueryMediator.NAME);
		}
		
		private function deleteButtonClickHandler(event:Event):void
		{
			trace(event)
		}
		
		private function queriesChangeHandler(event:CollectionEvent):void
		{
			switch (event.kind) 
			{		
				case CollectionEventKind.UPDATE:
					for (var i:uint = 0; i < event.items.length; i++) {
						if (event.items[i] is PropertyChangeEvent) {
							if (PropertyChangeEvent(event.items[i]) != null) {
								sendNotification(NotificationConstants.UPDATE_QUERY_NOTIFICATION,event.items[i].source as QueryVO)
							}
						}
					}
					break;
				case CollectionEventKind.REMOVE:
					sendNotification(NotificationConstants.DELETE_QUERY_NOTIFICATION,event.items[0] as QueryVO)
					break;
			}
		}
		
		//GETTER		
		public function get query():Query
		{
			return this.viewComponent as Query;
		}
		
	}
}