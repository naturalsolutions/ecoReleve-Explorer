package com.ecoReleve.view.expression 
{
	import org.openscales.core.feature.Feature;
	import org.openscales.core.filter.expression.IExpression;

	public class CircleSizeExpression implements IExpression 
	{
		public var _attribute:String;
		public var _minSize:Number;
		public var _maxSize:Number;
		private var _sizeDelta:Number;
		public var _minValue:Number;
		public var _maxValue:Number;
		private var _delta:Number;

		public function CircleSizeExpression(attribute:String,minSize:Number, maxSize:Number, minValue:Number, maxValue:Number) 
		{
			this._attribute = attribute;
			this._minSize = minSize;
			this._maxSize = maxSize;
			this._sizeDelta = maxSize - minSize;
			this._minValue = minValue;
			this._maxValue = maxValue;
			this._delta = maxValue - minValue;
		}

		public function evaluate(feature:Feature):Object 
		{
			if (feature!=null){
				var pop:Number = parseFloat(feature.attributes[_attribute]);
				var epsilon:Number = pop - this._minValue;
				return this._minSize + this._sizeDelta * epsilon / this._delta;
			}
			return 1
		}
	}
}

