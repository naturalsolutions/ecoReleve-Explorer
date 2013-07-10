package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.model.VO.MyAppConfigVO;
	import com.pocketListGenerator.view.ApplicationMediator;
	import com.pocketListGenerator.view.ApplicationFacade;
	import com.pocketListGenerator.utils.Debug;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class LoadConfigSuccessCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			//stock l'objet configVO dans l'applicationMediator
			var AppMed:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var myConfigVar:MyAppConfigVO=notification.getBody() as MyAppConfigVO
			AppMed.currentConfig=myConfigVar;

			sendNotification( ApplicationFacade.LOAD_PROXIES_NOTIFICATION );
			
			Debug.doTrace(this,"success config")
			Debug.doTrace(this,myConfigVar.appName)
			Debug.doTrace(this,myConfigVar.serveurURL + "/" + myConfigVar.wsName)
		}
		
	}
}