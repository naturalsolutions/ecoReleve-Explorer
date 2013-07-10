package com.ecoReleve.view.myFilter

{
	import org.openscales.core.feature.Feature;
	import org.openscales.core.filter.IFilter;
	
	public class ClusterLengthFilter implements IFilter
	{
		private var min:Number = 0;
		private var max:Number = 0;
		
		public function ClusterLengthFilter(min:Number, max:Number) 
		{
			this.min = min;
			this.max = max;
		}
		
		public function matches(feature:Feature):Boolean 
		{
			var length:Number = parseFloat(feature.attributes["length"]);
			return (length > min && length <= max);
		}
		
		public function clone():IFilter
		{
			var ClusterLengthFilter:ClusterLengthFilter = new ClusterLengthFilter(this.min,this.max);
			return ClusterLengthFilter;
		}
		
	}
}