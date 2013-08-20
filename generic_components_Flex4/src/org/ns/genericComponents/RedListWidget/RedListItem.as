package org.ns.genericComponents.RedListWidget
{
	public class RedListItem
	{
		private var _category_code:String=""; 
		private var _category_title:String="";
		private var _category_version:String="";
		private var _modified_year:String="";
		private var _red_list_criteria:String="";
		
		public function get category_code() : String 
		{
			return _category_code;
		}
		
		public function set category_code(value : String) : void 
		{
			_category_code = value;
		}

		public function get category_title() : String 
		{
			return _category_title;
		}
		
		public function set category_title(value : String) : void 
		{
			_category_title = value;
		}
		
		public function get category_version() : String 
		{
			return _category_version;
		}
		
		public function set category_version(value : String) : void 
		{
			_category_version = value;
		}
		
		public function get modified_year() : String 
		{
			return _modified_year;
		}
		
		public function set modified_year(value : String) : void 
		{
			_modified_year = value;
		}
		
		public function get red_list_criteria() : String 
		{
			return _red_list_criteria;
		}
		
		public function set red_list_criteria(value : String) : void 
		{
			_red_list_criteria = value;
		}
		
		
		
		
	}
}