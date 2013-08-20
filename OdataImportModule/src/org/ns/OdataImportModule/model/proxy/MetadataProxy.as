package org.ns.OdataImportModule.model.proxy
{	
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import org.ns.OdataImportModule.controller.NotificationConstants;
	import org.ns.OdataImportModule.model.delegate.LoadXMLDelegate;
	import org.ns.OdataImportModule.view.ApplicationMediator;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class MetadataProxy extends FabricationProxy implements IResponder
	{
		public static const NAME:String = "metadataProxy";

        private var metadata:XML
		
		private var edmx:Namespace=new Namespace("http://schemas.microsoft.com/ado/2007/06/edmx")
		private var m:Namespace=new Namespace("http://schemas.microsoft.com/ado/2007/08/dataservices/metadata")
		private var d:Namespace=new Namespace("http://schemas.microsoft.com/ado/2007/08/dataservices")
		private var root:Namespace=new Namespace("http://schemas.microsoft.com/ado/2008/09/edm")
		
		public function MetadataProxy()
		{
			super(NAME);
		}
		
		//get metadata
		public function GetMetadata(url:String,strAuthentification:String):void
		{	
            var delegate:LoadXMLDelegate = new LoadXMLDelegate(this,url,strAuthentification);
            delegate.send(); 
			CursorManager.setBusyCursor();
        }

		//get entity by name
		public function GetEntity(entityName:String):XML
		{
			var result:XML=new XML;
			var node:XML
			for each(node in metadata..root::EntityType){
				if (node.attribute('Name')==entityName){
					result=node
					return result
				}
			}		
			return result
		}
		
		//get entities linked
		public function GetEntityLinkedList(entity:XML):XMLList
		{
			var result:XMLList=new XMLList
			var node:XML
			for each(node in entity..root::NavigationProperty){
				result+=GetEntity(node.attribute('Name'))
			} 
	
			return result	
		}
			
		
		//get entity name list
		public function GetEntityNameList():XMLList
		{
			var result:XMLList=new XMLList
			
			result= metadata..root::EntityType
			
			return result
		}
		
		//get propertyList for an entity
		public function GetPropertyList(entity:XMLList,linkedEntities:XMLList,type:String=null):XMLList
		{
			var result:XMLList=new XMLList;
			var property:XML
			
			if (type!=null){type='Edm.'+type}
			
			for each(property in entity.root::Property){
				if (type==null){
					result+=property
				}
				if (property.attribute('Type')==type){
					result+=property
				}
			}
			
			//linked entity properties
			var item:XML
			for each(item in linkedEntities){
				for each(property in item.root::Property){
					var xml:XML=new XML(property)
					if (type==null){
						xml.@Name=item.@Name + '/' + xml.@Name
						result+=xml
					}
					if (property.attribute('Type')==type){
						xml.@Name=item.@Name + '/' + xml.@Name
						result+=xml
					}
				}
			}

			
			return result
		}
		
        public function result(data:Object) : void
        {   
			metadata=new XML
			metadata= XML(data)
			sendNotification(NotificationConstants.METADATA_GETTED_NOTIFICATIONS)
			CursorManager.removeBusyCursor();
        }
	
        public function fault(obj:Object):void 
        {
			
			var module:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator
            
			CursorManager.removeBusyCursor();
				
        	if (obj is HTTPStatusEvent){
        		
        	}else if (obj is FaultEvent){
        		var strInfo:String = new String((obj as FaultEvent).fault.faultString);
            	//sendNotification(ApplicationFacade.ERROR_IO_NOTIFICATION,strInfo,"ERROR");
        	}else if (obj is IOErrorEvent){
				sendNotification(NotificationConstants.METADATA_ERROR_NOTIFICATIONS,obj,"ioerror")
			}
	
        }
        
	}
}
