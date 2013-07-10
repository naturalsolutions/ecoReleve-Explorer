package org.ns.dataconnecteur.shell.view
{

	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.Log;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	public class LogMediator extends FlexMediator
	{
		public static const NAME:String = 'LogMediator';
		private var strLog:String="";
		
		public function LogMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER
		public function respondToLog(note:INotification):void
		{
			log.strLog+="\n"
			log.strLog+=String(note.getBody()) + "\n"
			log.strLog+="-------------------------------"
		}
		
		//REACTIONS
		
		
		//GETTER		
		public function get log():Log
		{
			return this.viewComponent as Log;
		}
		
	}
}