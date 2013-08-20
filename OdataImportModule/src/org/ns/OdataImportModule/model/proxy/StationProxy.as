package org.ns.OdataImportModule.model.proxy
{
	
	import mx.collections.ArrayCollection;
	
	import org.ns.OdataImportModule.controller.*;
	import org.ns.common.model.VO.StationVO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class StationProxy extends FabricationProxy
	{
		public static const NAME:String = "StationProxy";	
		
		private var _stations:ArrayCollection= new ArrayCollection();
		
		public function StationProxy()
		{
			super(NAME);
		}
		
		public function get stations():ArrayCollection
		{
			return _stations
		}
		
		public function addItem(station:StationVO):void
		{
			_stations.addItem(station)
		}
		
		public function removeAll():void
		{
			_stations.removeAll();
			_stations.refresh();	
		}
	}
}

