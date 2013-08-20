package org.ns.OdataImportModule.model.proxy
{	
	import org.ns.OdataImportModule.controller.NotificationConstants;
	import org.ns.OdataImportModule.view.ApplicationMediator;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class ModuleProxy extends FabricationProxy
	{
		public static const NAME:String = "moduleProxy";

		private var _container:Object;
		
		public function ModuleProxy()
		{
			super(NAME);
		}
		
		//getter/setter conatiner
		public function get container():Object
		{	
			return _container
		}
		
		public function set container(container:Object):void
		{	
			_container=container
        }

		
	}
}
