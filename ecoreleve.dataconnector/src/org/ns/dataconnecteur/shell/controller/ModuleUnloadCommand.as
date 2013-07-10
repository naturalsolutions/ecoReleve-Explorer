package org.ns.dataconnecteur.shell.controller
{

	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import org.ns.common.utils.PopupUtils;
	import org.ns.dataconnecteur.shell.view.ApplicationMediator;
	import org.ns.dataconnecteur.shell.view.RibbonMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationModuleLoader;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModule;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	import spark.components.SkinnableContainer;
	import spark.effects.Scale;
	
    public class ModuleUnloadCommand extends SimpleFabricationCommand
    {		
		override public function execute(note:INotification):void 
    	{			
			var shellMed:RibbonMediator=retrieveMediator(RibbonMediator.NAME) as RibbonMediator		
			
				//get modulecontainer with name
			var moduleContainer:SkinnableContainer=FlexGlobals.topLevelApplication.systemManager.getChildByName("moduleContainer") as SkinnableContainer
			
			if (moduleContainer!=null){
				//dispoe module
				var module:FlexModule = moduleContainer.getElementAt(moduleContainer.numElements - 1) as FlexModule;
				moduleContainer.removeElement(module);
				module.dispose();
			
				//remove popup	
				PopupUtils.closeAllPopups(shellMed.ribbon)
					
				sendNotification(NotificationConstants.LOG_NOTIFICATION,'module unloaded',"log");
			}
		}		
    }

}