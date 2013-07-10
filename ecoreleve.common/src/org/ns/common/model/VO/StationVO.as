package org.ns.common.model.VO
{
	/**
	 * @author www.comtaste.com
	*/
	[Bindable]
	public dynamic class StationVO {
		
		public function StationVO() {
		}
		
		// PRIMARY KEY
		private var _sta_id : int;
		public function get sta_id() : int {
			return _sta_id;
		}
		
		public function set sta_id( value : int ) : void  {
			_sta_id = value;
		}
		
		private var _sta_name : String;
		public function get sta_name() : String {
			return _sta_name;
		}
		
		public function set sta_name( value : String ) : void  {
			_sta_name = value;
		}
		
		private var _sta_latitude : Number;
		public function get sta_latitude() : Number {
			return _sta_latitude;
		}
		
		public function set sta_latitude( value : Number ) : void  {
			_sta_latitude = value;
		}
		
		private var _sta_longitude : Number;
		public function get sta_longitude() : Number {
			return _sta_longitude;
		}
		
		public function set sta_longitude( value : Number ) : void  {
			_sta_longitude = value;
		}
		
		private var _sta_elevation : Number;
		public function get sta_elevation() : Number {
			return _sta_elevation;
		}
		
		public function set sta_elevation( value : Number ) : void  {
			_sta_elevation = value;
		}
		
		private var _sta_date : Date;
		public function get sta_date() : Date {
			return _sta_date;
		}
		
		public function set sta_date( value : Date ) : void  {
			_sta_date = value;
		}
		
		private var _sta_nbIndividual : int;
		public function get sta_nbIndividual() : int {
			return _sta_nbIndividual;
		}
		
		public function set sta_nbIndividual( value : int ) : void  {
			_sta_nbIndividual = value;
		}
		
		private var _sta_speciesName : String;
		public function get sta_speciesName() : String {
			return _sta_speciesName;
		}
		
		public function set sta_speciesName( value : String ) : void  {
			_sta_speciesName = value;
		}
		
		private var _sta_comments : String;
		public function get sta_comments() : String {
			return _sta_comments;
		}
		
		public function set sta_comments( value : String ) : void  {
			_sta_comments = value;
		}
		
		private var _sta_dateY : String;
		public function get sta_dateY() : String {
			return _sta_dateY;
		}
		
		public function set sta_dateY( value : String ) : void  {
			_sta_dateY = value;
		}
		
		private var _sta_dateYM : String;
		public function get sta_dateYM() : String {
			return _sta_dateYM;
		}
		
		public function set sta_dateYM( value : String ) : void  {
			_sta_dateYM = value;
		}
		
		private var _sta_dateYMD : String;
		public function get sta_dateYMD() : String {
			return _sta_dateYMD;
		}
		
		public function set sta_dateYMD( value : String ) : void  {
			_sta_dateYMD = value;
		}
		
		private var _sta_fkQuery : Object;
		public function get sta_fkQuery() : Object {
			return _sta_fkQuery;
		}
		
		public function set sta_fkQuery( value : Object ) : void  {
			_sta_fkQuery = value;
		}
		
		private var _sta_source : String;
		public function get sta_source() : String {
			return _sta_source;
		}
		
		public function set sta_source( value : String ) : void  {
			_sta_source = value;
		}
		
	}
}
