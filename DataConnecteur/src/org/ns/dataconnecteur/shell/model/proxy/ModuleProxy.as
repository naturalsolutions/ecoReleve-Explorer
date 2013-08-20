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
	
	import org.ns.common.model.VO.ModuleVO;
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.model.DAO.ModuleDAO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class ModuleProxy extends FabricationProxy
	{
		public static const NAME:String = "ModuleProxy";	
		
		private var modules:ArrayCollection=new ArrayCollection();
		
		public function ModuleProxy()
		{
			super(NAME);	
		}

		public function get getModules():ArrayCollection
		{
			return modules
		}
		
		public function getModuleByName(moduleName:String):ModuleVO
		{
			var module:ModuleVO;
			
			for each(module in modules){
				if (module.mod_name==moduleName){
					return module
				}
			}
			
			return null
		}
		
		public function selectModules(conn:SQLConnection):void
		{
			var dao:ModuleDAO=ModuleDAO.getInstance()
			dao.setConnection(conn)
			dao.selectAll(selectAllResultHandler,selectAllErrorHandler)
		}
		
		
		
		//HANDLERS
		//SELECT
		private function selectAllResultHandler(collModules:ArrayCollection):void
		{
			trace(collModules)
			modules.removeAll()
			modules=collModules
			sendNotification(NotificationConstants.MODULES_SELECTED_NOTIFICATION,modules);
		}
		
		private function selectAllErrorHandler(event:SQLErrorEvent):void
		{
			trace(event.errorID)
		}
	}
}

