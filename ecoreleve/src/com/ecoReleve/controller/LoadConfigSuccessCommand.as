package com.ecoReleve.controller
{
	import com.ecoReleve.model.VO.MyAppConfigVO;
	import com.ecoReleve.utils.Debug;
	import com.ecoReleve.view.ApplicationFacade;
	import com.ecoReleve.view.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;

	public class LoadConfigSuccessCommand extends SimpleFabricationCommand
	{
		override public function execute(notification:INotification):void
		{
			//stock l'objet configVO dans l'applicationMediator
			var AppMed:ApplicationMediator=retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var myConfigVar:MyAppConfigVO=notification.getBody() as MyAppConfigVO
			AppMed.currentConfig=myConfigVar;

			sendNotification( Application.LOAD_PROXIES_NOTIFICATION );
			
			Debug.doTrace(this,"success config")
			Debug.doTrace(this,myConfigVar.appName)
			Debug.doTrace(this,myConfigVar.serveurURL + "/" + myConfigVar.wsName)
			Debug.doTrace(this,myConfigVar.geoServerURL)
		}
		
	}
}