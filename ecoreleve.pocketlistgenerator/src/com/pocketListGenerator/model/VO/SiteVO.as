package com.pocketListGenerator.model.VO
{
	
	[Bindable]
    public class SiteVO    
    {
    	public var ID:String = null;
        public var NAME:String = null;
		public var LATITUDE:Number = NaN;
		public var LONGITUDE:Number = NaN;
		public var ELEVATION:Number = NaN;

        /**
         * 
         * @param id
         * @param name
         */
        public function SiteVO ( id:String=null,
								 name:String=null,
								 latitude:Number=NaN,
								 longitude:Number=NaN,
								 elevation:Number=NaN)
        {
        	if( id != null ) this.ID = id;
            if( name != null ) this.NAME = name;
			if( isNaN(latitude)) this.LATITUDE = latitude;
			if( isNaN(longitude)) this.LONGITUDE = longitude;
			if( isNaN(elevation)) this.ELEVATION = elevation;
        }
        

        /**
         * IMPORT FROM CSV
         * @param strLine
         * @param delim
         * @return 
         */
        public static function fromCSV(strLine:String,delim:String):SiteVO
        {
            var data:SiteVO = new SiteVO();
			
			var arr:Array=strLine.split(delim)
			
			data.ID = String(arr[0])
			data.NAME = String(arr[1])
			data.LATITUDE = Number(arr[2])
			data.LONGITUDE = Number(arr[3])
			data.ELEVATION = Number(arr[4])
            
            return data;
        }
		
		/** 
		 * EXPORT TO CSV
		 * @param site
		 * @param delim
		 * @return 
		 */
		public static function toCSV(site:SiteVO,delim:String):String
		{
			var str:String;
			
			str=site.ID + delim + site.NAME + delim + site.LATITUDE + delim + site.LONGITUDE + delim + site.ELEVATION
			
			return str
		}
    }
}