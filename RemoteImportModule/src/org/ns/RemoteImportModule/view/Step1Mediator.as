package org.ns.RemoteImportModule.view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import org.ns.RemoteImportModule.controller.*;
	import org.ns.RemoteImportModule.view.QueryCreatorMediator;
	import org.ns.RemoteImportModule.view.components.QueryCreator;
	import org.ns.RemoteImportModule.view.components.steps.Step1;
	import org.ns.common.model.VO.QueryVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.components.TitleWindow;
	
	public class Step1Mediator extends FlexMediator
	{
		//mediator NAME
		public static const NAME:String = "Step1Mediator";
		
		public function Step1Mediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		} 		
		
		override public function onRegister():void 
		{
			super.onRegister();
			step1.addEventListener("NEWQUERY",HandleNewQueryClick)
		}

		
		//RESPOND	
		public function respondToQueriesLoaded(note:INotification):void
		{
			step1.queries=note.getBody() as ArrayCollection
		}
		
		public function respondToRefresh(note:INotification):void
		{
			step1.queries=note.getBody() as ArrayCollection
		}
		
		//REACTION
		private function HandleNewQueryClick(event:Event):void
		{		
			var window:IFlexDisplayObject = PopUpManager.createPopUp(step1 as DisplayObject, QueryCreator, true );
			window.width=500;
			window.height=400;
			
			registerMediator(new QueryCreatorMediator(window));
			PopUpManager.centerPopUp(window);
			PopUpManager.bringToFront(window);
		}
		
		
		//GETTER		
		public function get step1():Step1
		{
			return viewComponent as Step1;
		}
	}
}