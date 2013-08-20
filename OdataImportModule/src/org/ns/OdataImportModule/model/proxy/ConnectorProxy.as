package org.ns.OdataImportModule.model.proxy
{
	
	import mx.collections.ArrayCollection;
	
	import org.ns.OdataImportModule.controller.*;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class ConnectorProxy extends FabricationProxy
	{
		public static const NAME:String = "ConnectorProxy";	
		
		private var connector:RemoteConnectorVO=new RemoteConnectorVO;
		
		public function ConnectorProxy()
		{
			super(NAME);	
		}
		
		public function get getConnector():RemoteConnectorVO
		{
			return connector
		}
		
		public function setConnector(data:RemoteConnectorVO):void
		{
			connector=data
		}
	}
}



