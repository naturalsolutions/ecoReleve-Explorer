package org.ns.dataconnecteur.shell.model.proxy
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.model.DAO.ReleaseDAO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class ReleaseProxy extends FabricationProxy
	{
		public static const NAME:String = "ReleaseProxy";	
		
		
		public function ReleaseProxy()
		{
			super(NAME);	
		}
		
		public function getReleaseNumber(conn:SQLConnection):void
		{
			var dao:ReleaseDAO=ReleaseDAO.getInstance()
			dao.setConnection(conn)
			dao.select(getReleaseNumberHandler,getReleaseNumberErrorHandler);
		}	
		
		public function setReleaseNumber(conn:SQLConnection,RelNumber:String):void
		{
			var dao:ReleaseDAO=ReleaseDAO.getInstance()
			dao.setConnection(conn)
			dao.updateReleaseNumber(RelNumber,setReleaseNumberHandler,setReleaseNumberErrorHandler);
		}
		
		//HANDLERS
		// get Release Number
		private function getReleaseNumberHandler(result:Object):void
		{
			trace(result.rel_number)
			sendNotification(NotificationConstants.SQLITE_RELEASE_CHECKED_NOTIFICATION,result.rel_number)
		}
		
		private function getReleaseNumberErrorHandler(event:SQLErrorEvent):void
		{
			trace("get release number error: " + event.error.details)
		}
		
		//set release Number
		private function setReleaseNumberHandler(dbRelease:String):void
		{
			trace(dbRelease)
			sendNotification(NotificationConstants.SQLITE_RELEASE_CHECKED_NOTIFICATION,dbRelease)
		}
		
		private function setReleaseNumberErrorHandler(event:SQLErrorEvent):void
		{
			trace("set release number error: " + event.error.details)
		}
	}
}

