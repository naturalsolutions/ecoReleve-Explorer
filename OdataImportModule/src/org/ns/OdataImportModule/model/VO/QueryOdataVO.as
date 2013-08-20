package org.ns.OdataImportModule.model.VO
{
	/**
	 * @author www.comtaste.com
	*/
	[Bindable]
	public class QueryOdataVO {
		
		public function QueryOdataVO() {
		}
		
		private var _qry_field : String;
		public function get qry_field() : String {
			return _qry_field;
		}
		
		public function set qry_field( value : String ) : void  {
			_qry_field = value;
		}
		
		private var _qry_operator : String;
		public function get qry_operator() : String {
			return _qry_operator;
		}
		
		public function set qry_operator( value : String ) : void  {
			_qry_operator = value;
		}
		
		private var _qry_value : String;
		public function get qry_value() : String {
			return _qry_value;
		}
		
		public function set qry_value( value : String ) : void  {
			_qry_value = value;
		}
		
		//types can be : Int32,String:,DateTime,Double,Boolean
		private var _qry_type : String;
		public function get qry_type() : String {
			return _qry_type;
		}
		
		public function set qry_type( value : String ) : void  {
			_qry_type = value;
		}
		
		//types can be: MIN_DATE,MAX_DATE,MIN_LAT,MAX_LAT,MIN_LON,MAX_LON,WHAT
		private var _qry_required_field : String;
		public function get qry_required_field() : String {
			return _qry_required_field;
		}
		
		public function set qry_required_field( value : String ) : void  {
			_qry_required_field = value;
		}
		
		
	}
}
