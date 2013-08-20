package com.pocketListGenerator.model
{	
	import com.pocketListGenerator.model.VO.UserVO;
	import com.pocketListGenerator.model.delegate.LoadXMLDelegate;
	import com.pocketListGenerator.utils.Debug;
	import com.pocketListGenerator.view.ApplicationFacade;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class UserProxy extends Proxy implements IProxy,IResponder
	{
		public static const NAME:String = "userproxy";
		
		public var urlWebservice:String ="rest/pocketData/users"
		public var users:ArrayCollection=new ArrayCollection();
			
		public function UserProxy()
		{
			super(NAME);
		}
		        

		public function GetUsers(strUrlWs:String,strCriteria:String,strAuthentification:String):void
		{
			var url:String=strUrlWs + "/" + urlWebservice + strCriteria;			
			Debug.doTrace(this,url);
			var delegate:LoadXMLDelegate = new LoadXMLDelegate(this,url,strAuthentification,'site');
			delegate.send();           
		}
        
        public function result(data:Object) : void
        {            
        	//récupère le résultat sous forme XML            
			//Debug.doTrace(data) 
			var strData:String=String(data);	
			var vec:Vector.<String>=Vector.<String>(strData.split("\n"))
			var len:int=vec.length
				
			for (var i:int=1;i<len-1;i++){
				users.addItem(UserVO.fromCSV(vec[i],";"))
			}	
            
			sendNotification(ApplicationFacade.USERS_LOADED_NOTIFICATION,users,"user")
				
        }
        
        public function fault(obj:Object):void 
        {
        	if (obj is HTTPStatusEvent){
        	}else if (obj is FaultEvent){
        		var strInfo:String = new String((obj as FaultEvent).fault.faultString);
            	sendNotification(ApplicationFacade.ERROR_IO_NOTIFICATION,strInfo,"ERROR");
        	}else if (obj is IOErrorEvent){
        		
        	}	
        }
    
             
	}
}
