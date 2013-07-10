package org.ns.RemoteImportModule.controller
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Sprite;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.CursorManager;
	
	import org.ns.RemoteImportModule.controller.NotificationConstants;
	import org.ns.RemoteImportModule.model.proxy.ConnectorProxy;
	import org.ns.RemoteImportModule.view.ApplicationMediator;
	import org.ns.common.model.VO.QueryVO;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.utils.QueryVOCast;
	import org.ns.common.model.utils.StationVOCast;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class StationsResultProcessCommand extends SimpleFabricationCommand
	{		
		override public function execute( note:INotification ):void
		{
			var pxyConnector:ConnectorProxy=retrieveProxy(ConnectorProxy.NAME) as ConnectorProxy;
			var connector:RemoteConnectorVO=pxyConnector.getConnector;
			
			var params:Array=new Array;
			params=note.getBody() as Array;
			var data:Object=params[0] as Object
			var query:QueryVO=params[1] as QueryVO;
			
			var results:XML;
			var i:XML;
			var stations:ArrayCollection= new ArrayCollection();
			
			//create datasource name
			var strDatasourceName:String
			if (connector.rd_authRequired==true){
				strDatasourceName=connector.rd_name + "(" + connector.rd_login+ ")"
			} else {
				strDatasourceName=connector.rd_name
			}
			
			
			if (connector.rd_format=='nsml'){
				results=new XML(data);
				var strData:String=String(results.nsData.flatData.jsonResult.text());
				//Parse le json en array          
				var DataArray:Array=JSON.decode(strData) as Array; 
				
				//Convertit le résultat en tableau de StationVO
				var j:Array;
				for each (j in DataArray)
				{
					stations.addItem(StationVOCast.fromJSON(j,query.qry_id,strDatasourceName));
				}
			}else if (connector.rd_format=='sparql'){
				//nettoyage du xml ==> erreur de convertion xml
				// on ne garde que la balise results
				var settingsStart:String = "<results";
				var settingsEnd:String = "</results>";
				var settingsDirty:String = String(data);
				
				var settingsClean:String = 
					settingsDirty.substring(
						settingsDirty.indexOf(settingsStart)
						,(settingsDirty.lastIndexOf(settingsEnd)+settingsEnd.length)
					);
				
				results=new XML(settingsClean);
				for each (i in results.children())
				{
					stations.addItem(StationVOCast.fromDwcXML(i,query.qry_id,strDatasourceName));
				}
			}			
			
			CursorManager.removeBusyCursor();
			
			//if stations==0 then add alert
			if (stations.length==0){
				trace("CANCEL IMPORT")
				var module:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator						
				Alert.show("no station(s) returned","info",4,module.app,null,null,4 ,module.app.moduleFactory);
			} else {
				//notify shell with stations
				routeNotification("stationsImported",stations, "stations", "*")
				//notify module of the end of import
				sendNotification(NotificationConstants.IMPORT_FINISHED_NOTIFICATION);
			}
			
		}

	}
}