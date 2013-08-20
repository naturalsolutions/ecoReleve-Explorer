package org.ns.dataconnecteur.shell.view
{	

	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import flash.display.DisplayObject;
	import mx.managers.PopUpManager;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.enhancer.AttributeEnhance;
	import org.ns.dataconnecteur.shell.view.components.ribbon.EnhancePanel;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class EnhancePanelMediator extends FlexMediator
	{
		public static const NAME:String = 'EnhancePanelMediator';
		
		public function EnhancePanelMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);	
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER

		
		//REACTIONS
		public function reactToBtnEnhance$Click(event:MouseEvent):void
		{
			
			var window:IFlexDisplayObject = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, AttributeEnhance, true );
			
			if (hasMediator(AttributeEnhanceMediator.NAME)){
				removeMediator(AttributeEnhanceMediator.NAME)
			}
			registerMediator(new AttributeEnhanceMediator(window));
			PopUpManager.centerPopUp( window );
			
		}
		
		//GETTER		
		public function get pnlEnhance():EnhancePanel
		{
			return this.viewComponent as EnhancePanel;
		}
		
	}
}