package com.importCSV.controller
{
	import com.importCSV.view.*;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ViewPrepCommand extends SimpleCommand implements ICommand
	{
		// Crée et enregistre le médiateur principal de l'application
		override public function execute(notification:INotification):void
		{
			var app:importCSV=notification.getBody() as importCSV;
			
			facade.registerMediator(new ApplicationMediator(app));	
		}
		
	}
}