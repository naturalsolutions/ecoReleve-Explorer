package com.pocketListGenerator.model
{	
	import com.pocketListGenerator.model.VO.ThesaurusVO;
	import com.pocketListGenerator.model.delegate.LoadXMLDelegate;
	import com.pocketListGenerator.view.ApplicationFacade;
	import com.pocketListGenerator.view.ApplicationMediator;
	import com.pocketListGenerator.utils.Debug;
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ThesaurusProxy extends Proxy implements IProxy,IResponder
	{
		public static const NAME:String = "thesaurusproxy";
		public var DataXml:XML;
		public var items:ArrayCollection;
		
		public var urlThesaurusWebservice:String ="rest/thesaurus"
		
		public function ThesaurusProxy()
		{
			super(NAME);
		}
		
		//Récupère (GET) le thésaurus selon un critère. Si celle ci est vide alors récupère toutes les stations
		public function GetThesaurus(strUrlWs:String,strCriteria:String,strAuthentification:String):void
		{
			var url:String=strUrlWs + "/" + urlThesaurusWebservice + strCriteria;			
			Debug.doTrace(this,url);
            var delegate:LoadXMLDelegate = new LoadXMLDelegate(this,url,strAuthentification,'thesaurus');
            delegate.send();           
        }
         
        public function result(data:Object) : void
        {            
        	//récupère le résultat sous forme XML         
            var DataXml:XML=new XML(data);      
            
			//Convertit le résultat en tableau de ThesaurusVO
			items = new ArrayCollection();
			var i:XML;
			for each (i in DataXml.nsData.tthesauruss.children())
			{
				items.addItem(ThesaurusVO.fromXML(i));
			}
			
			sendNotification(ApplicationFacade.LOADING_THESAURUS_COMPLETE_NOTIFICATION,items);
        }
        
        public function fault(info:Object):void 
        {
			if (info is HTTPStatusEvent){
				
			}else if (info is FaultEvent){
				var strInfo:String = new String((info as FaultEvent).fault.faultString);
				sendNotification(ApplicationFacade.ERROR_IO_NOTIFICATION,strInfo,"ERROR");
			}else if (info is IOErrorEvent){
				
			}
        	
        }
        
	}
}
