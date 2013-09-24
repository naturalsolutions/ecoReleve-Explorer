package com.ecoReleve.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationAirModuleLoader;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationModuleLoader;
	
	import com.ecoReleve.view.DataPanelMediator;
	import org.ns.common.controller.CommonNotificationConstants;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	import mx.effects.Fade;
	import mx.effects.Parallel;
	import mx.events.ModuleEvent;
	import mx.managers.*;
	import mx.utils.UIDUtil;
	
	import spark.components.SkinnableContainer;
	import spark.effects.Scale;
	
	public class LoadModuleCommand extends SimpleFabricationCommand
	{
		private var moduleLoader:FabricationAirModuleLoader=null;
		private var moduleContainer:SkinnableContainer
		private var showEffect:Parallel;
		private var params:Array;
		private var moduleUrl:String="com/ecoReleve/modules/";
		
		
		override public function execute(note:INotification):void 
		{
			trace("LoadModule : "+note.getBody());
			var shellMed:DataPanelMediator=retrieveMediator(DataPanelMediator.NAME) as DataPanelMediator;
			moduleLoader=new FabricationAirModuleLoader(shellMed.applicationRouter,shellMed.applicationAddress);
			moduleLoader.id = UIDUtil.createUID();
			moduleLoader.addEventListener(ModuleEvent.READY, ModuleLoadedHandler);
			moduleLoader.addEventListener(ModuleEvent.SETUP, ModuleSetupHandler);
			moduleLoader.addEventListener(ModuleEvent.PROGRESS, ModuleProgressHandler);
			moduleLoader.addEventListener(ModuleEvent.ERROR, ModuleErrorHandler);
			
			params=note.getBody() as Array
			trace("param "+params)
			var connector:Object=params[0] as Object;
			trace("connector : "+params[0])
			moduleUrl+=connector.mod_url;
			
			//sendNotification(NotificationConstants.LOG_NOTIFICATION,"try to load module" + moduleUrl,"log");
			trace("Url module connector : "+connector.mod_url+" url module : "+moduleUrl)
			moduleLoader.loadModule(moduleUrl);
			CursorManager.setBusyCursor();
		}
		
		private function ModuleSetupHandler( e:ModuleEvent ):void 
		{
			//sendNotification(NotificationConstants.LOG_NOTIFICATION,'setup',"log");
			trace("module setup")
		}
		
		private function ModuleProgressHandler( e:ModuleEvent ):void 
		{
			//sendNotification(NotificationConstants.LOG_NOTIFICATION,'progress: ' + e.bytesLoaded + "/" + e.bytesTotal,"log");
		}
		
		private function ModuleErrorHandler( e:ModuleEvent ):void 
		{
			trace("module error")
			//sendNotification(NotificationConstants.LOG_NOTIFICATION,'Error: ' + e,"log");
		}
		
		private function ModuleLoadedHandler( e:ModuleEvent ):void 
		{
			trace("ModuleLoadedHandler");
			if (moduleLoader.flexModule!=null){
				//sendNotification(NotificationConstants.LOG_NOTIFICATION,"module loaded","log")
				
				moduleContainer=new SkinnableContainer
				moduleContainer.addElement(moduleLoader.flexModule as IVisualElement)
				
				//notify module with params value for initialisation
				routeNotification(CommonNotificationConstants.INIT_MODULE_NOTIFICATION,[moduleContainer,params],"initParameters", "*")
				
				CursorManager.removeBusyCursor()
			}
		}
	}
}