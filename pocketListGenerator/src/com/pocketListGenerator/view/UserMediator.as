package com.pocketListGenerator.view
{
	import com.pocketListGenerator.controller.*;
	import com.pocketListGenerator.model.VO.UserVO;
	import com.pocketListGenerator.view.mycomponents.User;
	import com.pocketListGenerator.utils.Export;
	
	import flash.events.Event;
	import flash.net.dns.AAAARecord;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class UserMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "UserMediator";		
 				
 		//constructeur
        public function UserMediator(viewComponent:User)
        {
            super(NAME, viewComponent);         
			user.addEventListener(User.EXPORT_CSV,exportCSVHandler);                         	            
        }    

		/**
		 * Liste les notifications attendues
		 * @return 
		 */
		override public function listNotificationInterests( ) : Array 
		{
			return [ApplicationFacade.USERS_LOADED_NOTIFICATION];
		}
		
		/**
		 * Gère les notifications
		 * @param note
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case ApplicationFacade.USERS_LOADED_NOTIFICATION:
					user.users=note.getBody() as ArrayCollection		
					break;
			}
		}
		
		
		/**
		 * EXPORT SELECTED ITEM IN CSV
		 * @param event
		 */
		private function exportCSVHandler(event:Event) : void 
		{
			var strResult:String
			
			//add header
			strResult="id;nom\n";
			
			for each(var item:UserVO in user.users){
				strResult+=UserVO.toCSV(item,";") + "\n";	
			}
			
			Export.WriteData(strResult,"CSV");
			
		}
		
        protected function get user():User
        {
            return viewComponent as User;
        }
    }
}