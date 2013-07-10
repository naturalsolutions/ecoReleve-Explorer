package org.ns.genericComponents.geonames.model
{
	import flash.events.Event;
	
	public class GeonameService
	{
		private static var _url:String = "http://ws.geonames.org";
		
		
		public function GeonameService()
		{
		}
		
		public static function findNearby(lat:Number,lng:Number,featureClass:String = null, featureCode:String = null, radius:Number = 0, maxRows:int = 0, style:String = null):Geoname
		{
			var params:Object = new Object();
			params.lat = lat;
			params.lng = lng;
			if(featureClass) { params.featureClass = featureClass }
			if(featureCode) { params.featureCode = featureCode }
			if(radius) { params.radius = radius }
			if(maxRows) { params.maxRows = maxRows }
			if(style) { params.style = style }
			
			var operation:Geoname = new Geoname(_url + '/findNearby',params);

			return operation;
		}
		
		public static function search(q:String=null,name:String=null,maxRows:int = 0,lang:String='fr',country:String=null,featureClass:String = null,featureCode:String = null):Geoname
		{
			var params:Object = new Object();
			if(q ) { params.q  = q }
			if(name) { params.name = name }
			if(maxRows) { params.maxRows = maxRows }
			if(lang) { params.lang = lang }
			if(country) { params.country = country }
			if(featureClass) { params.featureClass = featureClass }
			if(featureCode) { params.featureCode = featureCode }			
			
			var operation:Geoname = new Geoname(_url + '/search',params);

			return operation;
		}
		
	}
}