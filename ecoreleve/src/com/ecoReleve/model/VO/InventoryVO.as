package com.ecoReleve.model.VO
{
	import mx.formatters.DateFormatter;
	
	[Bindable]
    public class InventoryVO    
    {
    	public var ID:Number = NaN;
        public var STATION_ID:Number = NaN;
        public var DISTANCE:Number = NaN;
        public var TAXON_ID:Number = NaN;
        public var TAXON_NAME:String = null;
        public var NUMBER:Number = NaN;
        public var ABUNDANCY:String = null;
        public var OCCUPE:String = null;

        public function InventoryVO (  id:Number=NaN,
		                               stationid:Number=NaN,
		                               distance:Number=NaN,
		                               taxonid:Number=NaN,
		                               taxonname:String=null,
		                               number:Number=NaN,
		                               abundancy:String=null,
		                               occupe:String = null)
        {
        	if( !isNaN(id) ) this.ID=id;
	        if( !isNaN(stationid)) this.STATION_ID=stationid;
	        if( !isNaN(distance)) this.DISTANCE=distance;
	        if( !isNaN(taxonid)) this.TAXON_ID=taxonid;
	        if( taxonname!= null ) this.TAXON_NAME=taxonname;
	        if( !isNaN(number)) this.NUMBER=number;
	        if( abundancy!=null) this.ABUNDANCY=abundancy;
	        if( occupe!=null) this.OCCUPE=occupe;
        }
        //Transforme un inventory XML en InventoryVO
        public static function fromDwcXML(str:String):InventoryVO
        {
        	var data:InventoryVO = new InventoryVO();
        	
        	data.TAXON_NAME=str
        	data.NUMBER=1;
        	
        	return data;
        }
        
        //Transforme un inventory XML en InventoryVO
        public static function fromXML(xml:XML):InventoryVO
        {
            var data:InventoryVO = new InventoryVO();
            
            data.ID=Number(xml.attribute("id"));
	        data.STATION_ID = Number(xml.STATION_ID.text());
	        if (xml.DISTANCE.children().length()!=0){
	        	data.DISTANCE= Number(xml.DISTANCE.text());
	        }
	        data.TAXON_ID= Number(xml.TAXON_ID.text());
	        data.TAXON_NAME= xml.TAXON_NAME.text();
	        data.NUMBER= Number(xml.NUMBER.text());
	        data.ABUNDANCY= xml.ABUNDANCY.text();
	        data.OCCUPE= xml.OCCUPE.text();
			           
            return data;
        }
        
    }
}