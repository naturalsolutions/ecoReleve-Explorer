package org.ns.dataconnecteur.shell.controller
{

	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.QueryVO;
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.QueryProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class QueryRecordCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			var pxyQuery:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy;
			
			
			pxyQuery.addQuery(pxyDatabase.getSqlConnexion,note.getBody() as QueryVO);
			
		}
    }

}