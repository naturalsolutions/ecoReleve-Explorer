package com.pocketListGenerator.model.VO
{
	
	[Bindable]
    public class TaxaVO    
    {
    	public var ID:String = null;
        public var DISPLAYNAME:String = null;
		public var STORAGENAME:String = null;
		
        /**
         * 
         * @param id
         * @param name
         */
        public function TaxaVO ( id:String=null,
								 displayname:String=null,
								 storagename:String=null)
        {
        	if( id != null ) this.ID = id;
            if( displayname != null ) this.DISPLAYNAME = displayname;
			if( storagename != null ) this.STORAGENAME = storagename;
        }
        
      
        /**
         * 
         * @param strLine
         * @param delim
         * @return 
         */
        public static function fromCSV(strLine:String,delim:String):TaxaVO
        {
            var data:TaxaVO = new TaxaVO();
            
			var arr:Array=strLine.split(delim)
			
            data.ID = String(arr[0])
            data.DISPLAYNAME = String(arr[1])
			data.STORAGENAME = String(arr[2])
            
            return data;
        }

		/** 
		 * EXPORT TO CSV
		 * @param taxa
		 * @param delim
		 * @return 
		 */
		public static function toCSV(taxa:TaxaVO,delim:String):String
		{
			var str:String;
			
			str=taxa.ID + delim + taxa.DISPLAYNAME + delim + taxa.STORAGENAME
			
			return str
		}
		
    }
}