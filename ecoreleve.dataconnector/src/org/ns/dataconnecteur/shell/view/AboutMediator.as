package org.ns.dataconnecteur.shell.view
{

	import flash.desktop.NativeApplication;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.ribbon.About;
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