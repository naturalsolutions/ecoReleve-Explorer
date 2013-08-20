package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.view.ApplicationMediator;
	import com.pocketListGenerator.view.ApplicationFacade;
	import com.pocketListGenerator.utils.Debug;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class LoadConfigFailedCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			//Envoit une notification d'erreur
			sendNotification( ApplicationFacade.ERROR_MSG_NOTIFICATION,"Loading config file failed")
			Debug.doTrace(this,notification.getBody())
		}
		
	}
}