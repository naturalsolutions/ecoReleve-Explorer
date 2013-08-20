package com.ecoReleve.model
{
	import com.ecoReleve.model.VO.MyAppConfigVO;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;


	public class MyAppConfigProxy extends FabricationProxy
	{
		public static const NAME:String = "myappconfigproxy";
		private static const FILE:String ="com/ecoReleve/ressources/myapp-config.xml"
			
		public function MyAppConfigProxy()
		{
			super()
		}
		
		public function getConfig():void
		{
			
		}
	}
}