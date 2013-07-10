package org.ns.OdataImportModule.controller
{
	import flash.filesystem.File;
	
	import org.ns.OdataImportModule.controller.NotificationConstants;
	import org.ns.OdataImportModule.model.VO.QueryOdataVO;
	import org.ns.OdataImportModule.model.proxy.ConnectorProxy;
	import org.ns.OdataImportModule.model.proxy.RemoteStationProxy;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.common.model.VO.QueryVO;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.VO.RemoteDatasourceVO;
	import org.ns.common.model.utils.QueryVOCast;
	import org.ns.common.model.utils.StationVOCast;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class QueryTestCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var pxyRemoteStation:RemoteStationProxy=retrieveProxy(RemoteStationProxy.NAME) as RemoteStationProxy;
			var pxyConnector:ConnectorProxy=retrieveProxy(ConnectorProxy.NAME) as ConnectorProxy;
			
			//get connector from proxy
			var connector:RemoteConnectorVO=pxyConnector.getConnector
			
			// create login:password string if it is required
			var strAuthentification:String
			if (connector.rd_authRequired==true){
				strAuthentification=connector.rd_login + ":" + connector.rd_password
			}else{
				strAuthentification=null
			}
			
			//Construit l'url avec le datamodel du wizard	
			var url:String=connector.rd_url;
			
			var datamodel:Object=note.getBody() as Object
			
			url+='/' + (datamodel.ENTITY as XML).attribute('Name')
			
			var o:Object;
			var expand:String='';
			for each(o in datamodel.ENTITY_LINKED){
				expand+=',' + (o as XML).attribute('Name')
			}				
			expand=expand.replace(',','');
			url+='/$count?$expand=' + expand
			
			var query:QueryOdataVO;
			var filter:String='';
			for each(query in datamodel.ENTITY_QUERY){
				var value:String=''
				switch (query.qry_type){
					case 'Edm.Int32':
						value=query.qry_value
						break
					case 'Edm.String':
						value="'" + query.qry_value+ "'"
						break
					case 'Edm.DateTime':
						value="datetime'" + query.qry_value+ "'"
						break
					case 'Edm.Double':
						value=query.qry_value
						break
					case 'Edm.Boolean':
						value=query.qry_value
						break			
				}
				filter+=' and ' + query.qry_field + ' ' + query.qry_operator + ' ' + value
			}	
			filter=filter.replace(' and','')
			url+='&$filter=' + filter
			
			pxyRemoteStation.countStation(url,strAuthentification)
		}
		
	}
}