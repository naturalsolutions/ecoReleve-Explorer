package org.ns.common.model.VO
{
	/**
	 * @author www.comtaste.com
	*/
	[Bindable]
	public class ModuleVO {
		
		public function ModuleVO() {
		}
		
		// PRIMARY KEY
		private var _mod_id : int;
		public function get mod_id() : int {
			return _mod_id;
		}
		
		public function set mod_id( value : int ) : void  {
			_mod_id = value;
		}
		
		private var _mod_name : String;
		public function get mod_name() : String {
			return _mod_name;
		}
		
		public function set mod_name( value : String ) : void  {
			_mod_name = value;
		}
		
		private var _mod_url : String;
		public function get mod_url() : String {
			return _mod_url;
		}
		
		public function set mod_url( value : String ) : void  {
			_mod_url = value;
		}
		
		private var _mod_type : String;
		public function get mod_type() : String {
			return _mod_type;
		}
		
		public function set mod_type( value : String ) : void  {
			_mod_type = value;
		}
		
	}
}
