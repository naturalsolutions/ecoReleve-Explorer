package org.ns.dataconnecteur.shell.controller
{
	
	import flash.display.DisplayObject;
	
	import mx.effects.Parallel;
	import mx.managers.*;
	
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.ns.dataconnecteur.shell.view.ApplicationMediator;
	import org.ns.dataconnecteur.shell.view.RibbonMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationModuleLoader;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	import spark.components.SkinnableContainer;
	import spark.effects.Fade;
	import spark.effects.Scale;
    
    public class ModuleShowCommand extends SimpleFabricationCommand
    {
		private var moduleLoader:FabricationModuleLoader=null;
		private var moduleContainer:SkinnableContainer
		private var params:Object;
		
		override public function execute(note:INotification):void 
    	{    
			var shellMed:RibbonMediator=retrieveMediator(RibbonMediator.NAME) as RibbonMediator
			var moduleContainer:SkinnableContainer=note.getBody() as SkinnableContainer
			
			var showEffect:Parallel=new Parallel;
			var fade:Fade=new Fade();
			fade.alphaFrom=0.0
			fade.alphaTo=1.0;
			fade.duration=500;
			
			var scale:Scale=new Scale
			scale.autoCenterTransform=true
			scale.scaleXFrom=0.1;
			scale.scaleXTo=1.0;
			scale.scaleYFrom=0.1;
			scale.scaleYTo=1.0;
			scale.duration=500;

			//give a name to retrieve it later
			moduleContainer.name="moduleContainer"
			
			//set scale to 0 for effect
			moduleContainer.scaleX=0;
			moduleContainer.scaleY=0;
			
			showEffect.children=[fade,scale]
			showEffect.target=moduleContainer
				
			PopUpManager.addPopUp(moduleContainer,shellMed.ribbon.parentApplication as DisplayObject,true,PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(moduleContainer);
			
			//center popup ==> PopUpManager.centerPopUp not possible with effect
			moduleContainer.move(shellMed.ribbon.parentApplication.width/2,shellMed.ribbon.parentApplication.height/2)
			
			showEffect.play();
			
			routeNotification(CommonNotificationConstants.MODULE_SHOWED_NOTIFICATION, null,"module showed", "*")
			sendNotification(NotificationConstants.LOG_NOTIFICATION,"module Showed","log")
		}
		
		
    }

}