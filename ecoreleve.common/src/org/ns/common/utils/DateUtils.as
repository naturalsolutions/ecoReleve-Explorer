package org.ns.common.utils
{
	import mx.formatters.DateFormatter;
	import mx.controls.DateField;

	public class DateUtils
	{
		public static function UTCToJulianDay(newDate:Date):Number
		{
			var nb:Number;
			nb=((newDate.time - (newDate.getTimezoneOffset()*60000))  / 86400000) + 2440587.5;
			return nb;
		}
		
		public static function JulianDayToString(nbJulianDay:Number):String
		{
			var str:String=""
			return str
		}
		
		public static function CastStringToDate(strDate:String,sepDateTime:String,formatDate:String,formatTime:String):Date
		{
			var date:Date;
			
			if (strDate=="" || strDate==null){
				return null;	
			} else {   
				//SPLIT DATE et TIME
				var arrStr:Array = strDate.split(sepDateTime,2);
				var dateString:String =arrStr[0];
				var timeString:String =arrStr[1];
				
				//CREATE DATE PART
				date=DateField.stringToDate(dateString,formatDate);
				
				//CREATE TIME PART if exist
				if (timeString!=null && timeString!=''){

					var arrTimeStr:Array
					var Hour:Number 
					var Minute:Number
					var Second:Number
					
					//ADD TIME VALUE
					switch (formatTime)
					{
						case "HH:NN:SS":
							arrTimeStr= timeString.split(":",3);
							Hour=Number(arrTimeStr[0]);
							Minute=Number(arrTimeStr[1]);
							Second=Number(arrTimeStr[2]);
							break
					}
					
					date.setHours(Hour,Minute,Second)
				}
				
				
			}
			return date;
		}

		     
		public static function CastDateToString(date:Date,format:String):String
		{
			var strDate:String;
			var df:DateFormatter;
			
			df = new DateFormatter();
			df.formatString=format;
			
			strDate=df.format(date);
			
			return strDate;
		}
		
		public static function dateAdd(datepart:String = "", number:Number = 0, date:Date = null):Date
		{
			if (date == null) {
				date = new Date();
			}
			
			var returnDate:Date = new Date(date.time);;
			
			switch (datepart.toLowerCase()) {
				case "fullyear":
				case "month":
				case "date":
				case "hours":
				case "minutes":
				case "seconds":
				case "milliseconds":
					returnDate[datepart] += number;
					break;
				default:
					/* Unknown date part, do nothing. */
					break;
			}
			return returnDate;
		}
	}
}