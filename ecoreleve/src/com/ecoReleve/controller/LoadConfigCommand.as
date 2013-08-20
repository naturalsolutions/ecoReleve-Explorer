package com.ecoReleve.controller
{
	import com.ecoReleve.model.MyAppConfigProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;


	public class LoadConfigCommand extends SimpleFabricationCommand
	{
		override public function execute(notification:INotification):void
		{
			//GET CONFIG FROM XML FILE
			var configProxy:MyAppConfigProxy = new MyAppConfigProxy();
			registerProxy(configProxy);	
			configProxy.getConfig();
		}
		
	}
}