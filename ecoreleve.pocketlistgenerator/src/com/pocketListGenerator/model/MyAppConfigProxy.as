package com.pocketListGenerator.model
{
	import com.pocketListGenerator.model.VO.MyAppConfigVO;
	
	import flash.events.Event;
	
	import org.puremvc.as3.utilities.flex.config.interfaces.IConfigVO;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;

	public class MyAppConfigProxy extends ConfigProxy
	{
		public static const NAME:String = "myappconfigproxy";
		
		public function MyAppConfigProxy()
		{
			super("com/pocketListGenerator/ressources/myapp-config.xml")
		}

		override protected function constructVO():IConfigVO
		{
			return new MyAppConfigVO();
		}

	}
}