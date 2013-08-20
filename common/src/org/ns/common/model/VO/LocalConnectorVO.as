package org.ns.common.model.VO
{

	[Bindable]
	public class LocalConnectorVO 
	{
		
		public function LocalConnectorVO() 
		{
		}
		//LOCAL DATASOURCEVO
		// PRIMARY KEY
		private var _ld_id : int;
		public function get ld_id() : int {
			return _ld_id;
		}
		
		public function set ld_id( value : int ) : void  {
			_ld_id = value;
		}
		
		private var _ld_name : String;
		public function get ld_name() : String {
			return _ld_name;
		}
		
		public function set ld_name( value : String ) : void  {
			_ld_name = value;
		}
		
		private var _ld_fkModule : Object;
		public function get ld_fkModule() : Object {
			return _ld_fkModule;
		}
		
		public function set ld_fkModule( value : Object ) : void  {
			_ld_fkModule = value;
		}
		
		private var _ld_extension : String;
		public function get ld_extension() : String {
			return _ld_extension;
		}
		
		public function set ld_extension( value : String ) : void  {
			_ld_extension = value;
		}
		
		private var _ld_logo : String;
		public function get ld_logo() : String {
			return _ld_logo;
		}
		
		public function set ld_logo( value : String ) : void  {
			_ld_logo = value;
		}
		
		//module VO
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
