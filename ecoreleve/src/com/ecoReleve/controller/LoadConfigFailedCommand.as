package com.ecoReleve.controller
{
	import com.ecoReleve.model.VO.MyAppConfigVO;
	import com.ecoReleve.utils.Debug;
	import com.ecoReleve.view.ApplicationFacade;
	import com.ecoReleve.view.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;


	public class LoadConfigFailedCommand extends SimpleFabricationCommand
	{
		override public function execute(notification:INotification):void
		{
			//ERROR DURING LOADING CONFIG FILE ==> CAN'T LUNCH APP
			sendNotification(ApplicationERROR_MSG_NOTIFICATION,"Loading config file failed")
			Debug.doTrace(this,notification.getBody())
		}
		
	}
}