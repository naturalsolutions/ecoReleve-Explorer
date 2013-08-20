package com.ecoReleve.view.myFilter 
{
	import org.openscales.core.feature.Feature;
	import org.openscales.core.filter.IFilter;

	public class AttributeEqualityFilter implements IFilter 
	{

		private var _field:String;
		private var _value:String;

		public function AttributeEqualityFilter(field:String,value:String) 
		{
			this._field = field;
			this._value = value 
		}

		public function matches(feature:Feature):Boolean 
		{
			return (feature.attributes[_field]==_value);
		}
		
		public function clone():IFilter
		{
			var AttributeEqualityFilter:AttributeEqualityFilter = new AttributeEqualityFilter(this._field,this._value);
			return AttributeEqualityFilter;
		}
	}
}

