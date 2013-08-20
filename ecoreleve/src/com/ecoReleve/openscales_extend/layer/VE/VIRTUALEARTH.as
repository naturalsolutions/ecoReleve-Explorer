package com.ecoReleve.openscales_extend.layer.VE
{
	import org.openscales.core.layer.TMS;
	import org.openscales.geometry.basetypes.Bounds;
	import org.openscales.proj4as.ProjProjection;

	 /**
	 * BASE CLASS FOR VIRTUAL ERATH LAYER
	 * 
	 * 
	 **/	
	public class VIRTUALEARTH extends TMS
	{
		public static const MISSING_TILE_URL:String="http://www.openstreetmap.org/openlayers/img/404.png";		
		public static const DEFAULT_MAX_RESOLUTION:Number = 156543.0339;
		
		private var _params:String='';
		
		public function VIRTUALEARTH(name:String,url:String,params:String) 
		{
			super(name, url);
			_params=params;
			this.projection = new ProjProjection("EPSG:900913");
			// Use the projection to access to the unit
			/* this.units = Unit.METER; */
			this.maxExtent = new Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34);

		}

		override public function getURL(bounds:Bounds):String
		{
			var res:Number = this.map.resolution;
			var x:Number = Math.round((bounds.left - this.maxExtent.left) / (res * this.tileWidth));
			var y:Number = Math.round((this.maxExtent.top - bounds.top) / (res * this.tileHeight));
			var z:Number = this.map.zoom;
			var limit:Number = Math.pow(2, z);


			if (y < 0 || y >= limit ||x < 0 || x >= limit) {
				return VIRTUALEARTH.MISSING_TILE_URL;
			} else {
				x = ((x % limit) + limit) % limit;
				y = ((y % limit) + limit) % limit;
				
				var url:String = this.url;
				
				//Get Quadkey from TileX et TileY
				var quadkey:String=this.TileXYToQuadKey(x,y,z)
								
				var urlMiddle:String = quadkey  
				var urlEnd:String = "?g=117";

				var path:String = urlMiddle + urlEnd;


				if (this.altUrls != null) 
				{
					url = this.selectUrl(this.url + path, this.getUrls());
				} 
				
				trace(url + path + _params)
				
				return url + path + _params;				
			}
		}
		
		/** 
        * Converts tile XY coordinates into a QuadKey at a specified level of detail.
        * 
        * tileX:Tile X coordinate.
        * tileY:Tile Y coordinate.
        * levelOfDetail:Level of detail, from 1 (lowest detail) to 23 (highest detail).
        * ==> A string containing the QuadKey.
        **/
        private function TileXYToQuadKey(tileX:int, tileY:int,levelOfDetail:int):String
        {
            var quadKey:Array = new Array();
            for (var i:int = levelOfDetail; i > 0; i--)
            {
                var digit:Number = 0;
                var mask:int = 1 << (i - 1);
                if ((tileX & mask) != 0)
                {
                    digit++;
                }
                if ((tileY & mask) != 0)
                {
                    digit++;
                    digit++;
                }
                quadKey.push(digit);
            }
            
            var strquadKey:String=""
            for(var j:Number = 0; j < quadKey.length; j++){
            	strquadKey +=quadKey[j]
            }
            
            return strquadKey
        }

	}
}
