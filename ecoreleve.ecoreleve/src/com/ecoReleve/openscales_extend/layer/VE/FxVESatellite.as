package com.ecoReleve.openscales_extend.layer.VE
{
	import com.ecoReleve.openscales_extend.layer.VE.VESatellite
	import org.openscales.fx.layer.FxLayer;	
	 
	public class FxVESatellite extends FxLayer {
		public function FxVESatellite(name:String = "") 
		{
			this._layer=new VESatellite(name);
			super();
		}

	}
}