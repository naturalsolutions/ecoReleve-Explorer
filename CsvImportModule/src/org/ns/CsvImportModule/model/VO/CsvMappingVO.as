package org.ns.CsvImportModule.model.VO
{

	
	[Bindable]
    public class CsvMappingVO   
    {
    	
    	public var STA_FIELD:String=null;
        public var CSV_FIELD:String = null;
		public var CSV_INDEX:Number = NaN;
        public var FORMAT:String = null;
		
		/** Constructeur
		 *
		 **/
        public function CsvMappingVO (  sta_field:String=null,
	                                 	csv_field:String=null,
										csv_index:Number=NaN,
	                                 	format:String=null)
        {
        	if( sta_field!=null ) this.STA_FIELD=sta_field;
	        if( csv_field!=null ) this.CSV_FIELD=csv_field;
			if( !isNaN(csv_index)) this.CSV_INDEX=csv_index;
	        if( format!=null ) this.FORMAT=format;
        }
		
	}
}