package com.ecoReleve.openscales_extend.layer.YAHOO
{
	import org.openscales.core.Util;

	 /**
	 * Virtual earth Satellite layer 
	 * 
	 * @author Matt Sheehan - flexmappers.com
	 * 
	 **/	
	 
	public class YMSatellite extends YAHOOMAP
	{

		public function YMSatellite(name:String)
		{
			//url = "http://us.maps1.yimg.com/us.tile.yimg.com/tl?v=4.1&";        		//map view
			var url:String= "http://us.maps3.yimg.com/aerial.maps.yimg.com/ximg?v=1.7&t=a";     //satellite view

			//var alturls:Array = ["http://b.tah.openstreetmap.org/Tiles/tile/",
			//					 "http://c.tah.openstreetmap.org/Tiles/tile/"]; 
			
			super(name, url);	
			
			//this.altUrls = alturls;
			
			this.generateResolutions(18, YAHOOMAP.DEFAULT_MAX_RESOLUTION);
						
		}

	}
}

