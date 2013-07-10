package Timeline.controls
{
	import flash.display.Graphics;
	
	import mx.charts.DateTimeAxis;
	import mx.formatters.DateFormatter;

	public class FormattedDateTimeAxis extends DateTimeAxis
	{
		public var formatStringYears:String = "YYYY";
	    public var formatStringMonths:String = "MMMM(YY)";
	    public var formatStringDays:String = "DD MMM(YY)";
	    public var formatStringHours:String = "HH";
	    
	    protected var formatter:DateFormatter = new DateFormatter();
   
		public function FormattedDateTimeAxis()
		{
			super();
		}
		
		protected override function formatDays(d:Date, previousValue:Date, axis:DateTimeAxis):String
	  	{
	   		return formatDate(d, formatStringDays);
	  	}
	  	
	  	protected override function formatMonths(d:Date, previousValue:Date, axis:DateTimeAxis):String
	  	{
	   		return formatDate(d, formatStringMonths);
	  	}
	  	
	  	protected override function formatYears(d:Date, previousValue:Date, axis:DateTimeAxis):String
	  	{
	   		return formatDate(d, formatStringYears);
	  	}
	  	
	  	protected function formatHours(d:Date, previousValue:Date, axis:DateTimeAxis):String
	  	{
	   		return formatDate(d, formatStringHours);
	  	}
	   
	  	protected function formatDate(d:Date, formatString:String):String
	  	{
	   		formatter.formatString = formatString;
	   		return formatter.format(d);
	  	} 
	}
}