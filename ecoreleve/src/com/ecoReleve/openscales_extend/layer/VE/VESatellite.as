package com.ecoReleve.openscales_extend.layer.VE
{

	 /**
	 * Virtual earth Satellite layer 
	 * 
	 * 
	 * 
	 **/	
	 
	public class VESatellite extends VIRTUALEARTH
	{

		public static const HYBRID:String = 'hybrid';
		public static const ROUTING:String = 'routing';
		public static const ROUTING_WITH_RELIEF:String = 'routingWithRelief';
		public static const AERIAL:String = 'aerial';
		
		
		public function VESatellite(name:String,type:String=HYBRID)
		{
			var url:String 
			var params:String;
			switch (type){
				case HYBRID:
					url= "http://tiles.virtualearth.net/tiles/h";     //hybrid view
					params=''
					break;
				case ROUTING:
					url = "http://tiles.virtualearth.net/tiles/r";        //road view
					params=''
					break;
				case ROUTING_WITH_RELIEF:
					url = "http://tiles.virtualearth.net/tiles/r";        //road view with shaded relief
					params='&shading=hill'
					break;
				case AERIAL:
					url = "http://tiles.virtualearth.net/tiles/a";     //aerial view
					params='';
					break;
			}

			//var alturls:Array = ["http://b.tah.openstreetmap.org/Tiles/tile/",
			//					 "http://c.tah.openstreetmap.org/Tiles/tile/"]; 
			
			super(name, url,params);		
			
			//this.altUrls = alturls;
			
			this.generateResolutions(18, VIRTUALEARTH.DEFAULT_MAX_RESOLUTION);
						
		}

	}
}

