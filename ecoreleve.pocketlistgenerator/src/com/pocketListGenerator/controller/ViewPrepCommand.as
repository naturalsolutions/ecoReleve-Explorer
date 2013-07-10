package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.view.*;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ViewPrepCommand extends SimpleCommand implements ICommand
	{
		// Crée et enregistre le médiateur principal de l'application
		override public function execute(notification:INotification):void
		{
			var app:pocketListGenerator=notification.getBody() as pocketListGenerator;
			
			facade.registerMediator(new ApplicationMediator(app));	
		}
		
	}
}