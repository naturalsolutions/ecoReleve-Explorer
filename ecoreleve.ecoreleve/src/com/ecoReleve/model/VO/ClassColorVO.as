package com.ecoReleve.model.VO
{
	[Bindable]
	public class ClassColorVO {
		
		public function ClassColorVO() {
		}
		
		private var _field:String;
		public function get field() : String {
			return _field;
		}
		
		public function set field( value : String ) : void  {
			_field = value;
		}
		
		private var _value:String;
		public function get value() : String {
			return _value;
		}
		
		public function set value( value : String ) : void  {
			_value = value;
		}
		
		private var _color : uint;
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint ) : void  {
			_color = value;
		}
	}
}
