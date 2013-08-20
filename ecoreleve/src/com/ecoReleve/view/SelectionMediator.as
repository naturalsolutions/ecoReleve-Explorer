package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.SelectionProxy;
	import com.ecoReleve.view.mycomponents.Display.map.selection.Selection;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class SelectionMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "SelectionMediator";	
			
		public function SelectionMediator(viewComponent:Selection)
		{
			super(NAME, viewComponent);
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			registerMediator(new SelectionNavigatorMediator(selection.MySelectionNavigator));
			registerMediator(new RedListMediator(selection.MyPanelRedList));
			registerMediator(new MediaMediator(selection.MyPanelMedia));
			registerMediator(new QuickInfoMediator(selection.MyPanelInfos));
		}
		
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.SELECTION_RESET_NOTIFICATION,
				NotificationConstants.SELECTION_NEW_NOTIFICATION];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch (note.getName()) 
			{
				case NotificationConstants.SELECTION_RESET_NOTIFICATION:
					break;
				case NotificationConstants.SELECTION_NEW_NOTIFICATION:	
					var pxySelection:SelectionProxy;
					pxySelection=this.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
					
					break;
			}
		}
		
        protected function get selection():Selection
        {
            return viewComponent as Selection;
        }
		

		
	}
}