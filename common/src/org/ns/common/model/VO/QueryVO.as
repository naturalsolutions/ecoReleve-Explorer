package org.ns.common.model.VO
{
	/**
	 * @author www.comtaste.com
	*/
	[Bindable]
	public class QueryVO {
		
		public function QueryVO() {
		}
		
		// PRIMARY KEY
		private var _qry_id : int;
		public function get qry_id() : int {
			return _qry_id;
		}
		
		public function set qry_id( value : int ) : void  {
			_qry_id = value;
		}
		
		private var _qry_minDate : Date;
		public function get qry_minDate() : Date {
			return _qry_minDate;
		}
		
		public function set qry_minDate( value : Date ) : void  {
			_qry_minDate = value;
		}
		
		private var _qry_maxDate : Date;
		public function get qry_maxDate() : Date {
			return _qry_maxDate;
		}
		
		public function set qry_maxDate( value : Date ) : void  {
			_qry_maxDate = value;
		}
		
		private var _qry_format : String;
		public function get qry_format() : String {
			return _qry_format;
		}
		
		public function set qry_format( value : String ) : void  {
			_qry_format = value;
		}
		
		private var _qry_idTaxon : int;
		public function get qry_idTaxon() : int {
			return _qry_idTaxon;
		}
		
		public function set qry_idTaxon( value : int ) : void  {
			_qry_idTaxon = value;
		}
		
		private var _qry_topicFr : String;
		public function get qry_topicFr() : String {
			return _qry_topicFr;
		}
		
		public function set qry_topicFr( value : String ) : void  {
			_qry_topicFr = value;
		}
		
		private var _qry_isTaxonFather : Boolean;
		public function get qry_isTaxonFather() : Boolean {
			return _qry_isTaxonFather;
		}
		
		public function set qry_isTaxonFather( value : Boolean ) : void  {
			_qry_isTaxonFather = value;
		}
		
		private var _qry_minLat : Number;
		public function get qry_minLat() : Number {
			return _qry_minLat;
		}
		
		public function set qry_minLat( value : Number ) : void  {
			_qry_minLat = value;
		}
		
		private var _qry_maxLat : Number;
		public function get qry_maxLat() : Number {
			return _qry_maxLat;
		}
		
		public function set qry_maxLat( value : Number ) : void  {
			_qry_maxLat = value;
		}
		
		private var _qry_minLon : Number;
		public function get qry_minLon() : Number {
			return _qry_minLon;
		}
		
		public function set qry_minLon( value : Number ) : void  {
			_qry_minLon = value;
		}
		
		private var _qry_maxLon : Number;
		public function get qry_maxLon() : Number {
			return _qry_maxLon;
		}
		
		public function set qry_maxLon( value : Number ) : void  {
			_qry_maxLon = value;
		}
		
		private var _qry_dataOwner : String;
		public function get qry_dataOwner() : String {
			return _qry_dataOwner;
		}
		
		public function set qry_dataOwner( value : String ) : void  {
			_qry_dataOwner = value;
		}
		
		private var _qry_maxResult : Number;
		public function get qry_maxResult() : Number {
			return _qry_maxResult;
		}
		
		public function set qry_maxResult( value : Number ) : void  {
			_qry_maxResult = value;
		}
		
		private var _qry_name : String;
		public function get qry_name() : String {
			return _qry_name;
		}
		
		public function set qry_name( value : String ) : void  {
			_qry_name = value;
		}
		
		private var _qry_persist : Boolean;
		public function get qry_persist() : Boolean {
			return _qry_persist;
		}
		
		public function set qry_persist( value : Boolean ) : void  {
			_qry_persist = value;
		}
		
		private var _qry_region : String;
		public function get qry_region() : String {
			return _qry_region;
		}
		
		public function set qry_region( value : String ) : void  {
			_qry_region = value;
		}
		
		private var _qry_place : String;
		public function get qry_place() : String {
			return _qry_place;
		}
		
		public function set qry_place( value : String ) : void  {
			_qry_place = value;
		}
		
		private var _qry_FieldActivity : String;
		public function get qry_FieldActivity() : String {
			return _qry_FieldActivity;
		}
		
		public function set qry_FieldActivity( value : String ) : void  {
			_qry_FieldActivity = value;
		}
		
		private var _qry_ViewName : String;
		public function get qry_ViewName() : String {
			return _qry_ViewName;
		}
		
		public function set qry_ViewName( value : String ) : void  {
			_qry_ViewName = value;
		}
		
		private var _qry_Count : Boolean;
		public function get qry_Count() : Boolean {
			trace("QUERYVO GET COUNT");
			return _qry_Count;
		}
		
		public function set qry_Count( value : Boolean ) : void  {
			trace("QUERYVO SET COUNT");
			_qry_Count = value;
		}
	}
}
