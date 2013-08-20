package com.sqlLite.utils
{
	public class Debug
	{
		public static function doTrace(... arg):void
        {
               CONFIG::debugMode{
                    var message:String = "";
                    for each(var data:* in arg)
                       message+=data;
 
                    trace(message);
              }
         }
	}
}