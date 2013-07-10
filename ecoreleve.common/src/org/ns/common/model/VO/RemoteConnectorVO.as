package org.ns.common.model.VO
{

	[Bindable]
	public class RemoteConnectorVO 
	{
		
		public function RemoteConnectorVO() 
		{
		}
		// Datasource VO-------------------------------------------------------------------------------------
		// PRIMARY KEY
		private var _rd_id : int;
		public function get rd_id() : int {
			return _rd_id;
		}
		
		public function set rd_id( value : int ) : void  {
			_rd_id = value;
		}
		
		private var _rd_name : String;
		public function get rd_name() : String {
			return _rd_name;
		}
		
		public function set rd_name( value : String ) : void  {
			_rd_name = value;
		}
		
		private var _rd_url : String;
		public function get rd_url() : String {
			return _rd_url;
		}
		
		public function set rd_url( value : String ) : void  {
			_rd_url = value;
		}
		
		private var _rd_authRequired : Boolean;
		public function get rd_authRequired() : Boolean {
			return _rd_authRequired;
		}
		
		public function set rd_authRequired( value : Boolean ) : void  {
			_rd_authRequired = value;
		}
		
		private var _rd_login : String;
		public function get rd_login() : String {
			return _rd_login;
		}
		
		public function set rd_login( value : String ) : void  {
			_rd_login = value;
		}
		
		private var _rd_password : String;
		public function get rd_password() : String {
			return _rd_password;
		}
		
		public function set rd_password( value : String ) : void  {
			_rd_password = value;
		}
		
		private var _rd_fkModule : Object;
		public function get rd_fkModule() : Object {
			return _rd_fkModule;
		}
		
		public function set rd_fkModule( value : Object ) : void  {
			_rd_fkModule = value;
		}
		
		private var _rd_logo : String;
		public function get rd_logo() : String {
			return _rd_logo;
		}
		
		public function set rd_logo( value : String ) : void  {
			_rd_logo = value;
		}
		
		private var _rd_type : String;
		public function get rd_type() : String {
			return _rd_type;
		}
		
		public function set rd_type( value : String ) : void  {
			_rd_type = value;
		}
		
		private var _rd_format : String;
		public function get rd_format() : String {
			return _rd_format;
		}
		
		public function set rd_format( value : String ) : void  {
			_rd_format = value;
		}
		
		// Module VO-------------------------------------------------------------------------------------
		// PRIMARY KEY
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
