package Timeline.controls
{
	import com.fnicollet.datafilter.filter.DataFilterBase;
	import com.fnicollet.datafilter.filter.DataFilterParameters;
	
	public class CustomDateFilter extends DataFilterBase
	{
		public function CustomDateFilter(parameters:DataFilterParameters)
		{
			super(parameters);
		}
		
		/**
		 * The filter applied cast the item as a CustomSimpleObject. Properties are then strongly typed.
		 */
		override public function apply(item:Object):Boolean {
			
			var fieldName:String=String(_parameters.filterKeys[0])
			var result:Boolean;
			
			if (_parameters.filterValues[0]=="All"){
				result=true
			}else {
				var dateToFilter:Date = item[fieldName];
				var d1:Date=_parameters.filterValues[0] as Date;
				var d2:Date=_parameters.filterValues[1] as Date;
				
				if (dateToFilter > d1 && dateToFilter < d2){
					result=true
				}else{
					result=false
				}
			}
			return applyConstraints(result);
		}

	}
}