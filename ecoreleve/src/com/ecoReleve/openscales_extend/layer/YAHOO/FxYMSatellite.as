package com.ecoReleve.openscales_extend.layer.YAHOO
{
	import org.openscales.fx.layer.FxLayer;
	import com.ecoReleve.openscales_extend.layer.YAHOO.YMSatellite;

	 /**
	 * Class edited so we can add non WMS/WFS basemaps 
	 * 
	 * @author Matt Sheehan - flexmappers.com
	 * 
	 **/	
	 
	public class FxYMSatellite extends FxLayer {
		public function FxYMSatellite(name:String = "") 
		{
			this._layer=new YMSatellite(name);
			super();
		}

	}
}