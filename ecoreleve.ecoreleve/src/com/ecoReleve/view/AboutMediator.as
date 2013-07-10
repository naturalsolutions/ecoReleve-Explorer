package com.ecoReleve.view
{

	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.ribbon.Ribbon;
	import com.ecoReleve.view.mycomponents.ribbon.About;
	
	import flash.desktop.NativeApplication;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class AboutMediator extends FlexMediator
	{
		public static const NAME:String = 'AboutMediator';
		
		public function AboutMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);	
		}
		
		override public function onRegister():void
		{
			super.onRegister();
				
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespaceDeclarations()[0];
			about.appRelease= appXml.ns::versionNumber;
		}
		
		//RESPONDER
		
		
		//REACTIONS
		public function reactToAboutClose(event:CloseEvent):void 
		{
			PopUpManager.removePopUp(about);
			removeMediator(AboutMediator.NAME);
		}
		
		
		//GETTER		
		public function get about():About
		{
			return this.viewComponent as About;
		}
		
	}
}