package com.importCSV.model.VO
{
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.core.IUID;
	import mx.formatters.DateFormatter;
	import mx.utils.UIDUtil;

	
	[Bindable]
    public class StationVO implements IUID    
    {
    	private var _uid:String;
    	public var ID:String=null;
        public var LATITUDE:Number = NaN;
        public var LONGITUDE:Number = NaN;
        public var ELEVATION:Number = NaN;
        public var PLACE:String = null;
        public var REGION:String = null;
        public var ACCURACY:Number = NaN;
        public var DATE:Date = new Date();
        public var DATE_Y:String = null;
        public var DATE_YM:String = null;
        public var DATE_YMD:String = null;
        public var NAME:String = null;
        public var FIELDACTIVITY_NAME:String = null;
 		public var FIELDACTIVITY_ID:Number = NaN;
		public var COMMENTS:String = null;
		public var DATA_ENTRY:Number = NaN;
		public var SOURCE:String = null;
		public var NB_INDIVIDUAL:Number = NaN;
		public var ABUNDANCY:String = null;
		public var SPECIES_NAME:String = null;
		public var FW1:String = null;
		public var FW2:String = null;
		public var SITE_NAME:String = null;
		public var SITE_TYPE:String = null;
		public var DATASET:Number=NaN;
		
		public var NB_SPECIES:Number = NaN;
		public var CHILDREN:Array=[];
		
		/** Constructeur
		 *
		 **/
        public function StationVO (  id:String=null,
	                                 latitude:Number=NaN,
	                                 longitude:Number=NaN,
	                                 elevation:Number=NaN,
	                                 place:String=null,
	                                 region:String=null,
	                                 accuracy:Number=NaN,
	                                 date:Date=null,
	                                 name:String=null,
	                                 fldactivityname:String=null,
	                                 fldactivityid:Number=NaN,
	                                 comments:String=null,
	                                 dataentry:Number=NaN,
	                                 source:String=null,
	                                 nb_individual:Number = NaN,
									 abundancy:String=null,
	                                 site_name:String=null,
	                                 site_type:String=null,
	                                 fw1:String=null,
	                                 fw2:String=null,
	                                 species_name:String=null,
	                                 children:Array=null,
	                                 nb_species:Number = NaN)
        {
        	 _uid = UIDUtil.createUID();
        	if( id!=null ) this.ID=id;
	        if( !isNaN(latitude)) this.LATITUDE=latitude;
	        if( !isNaN(longitude)) this.LONGITUDE=longitude;
	        if( !isNaN(elevation)) this.ELEVATION=elevation;
	        if( place!= null ) this.PLACE=place;
	        if( region!= null ) this.REGION=region;
	        if( !isNaN(accuracy)) this.ACCURACY=accuracy;
	        if( date!= null ){
	        	this.DATE=date;
	        	this.DATE_Y=String(this.DATE.fullYear);
	        	this.DATE_YM=this.DATE_Y + "-" + String(this.DATE.month);
	        	this.DATE_YMD=this.DATE_YM + "-" + String(this.DATE.day);
	        } 
	        if( name!= null ) this.NAME=name;
	        if( fldactivityname!= null ) this.FIELDACTIVITY_NAME=fldactivityname;
	        if( !isNaN(fldactivityid)) this.FIELDACTIVITY_ID=fldactivityid;
	        if( comments!= null ) this.COMMENTS=comments;
	        if( !isNaN(dataentry)) this.DATA_ENTRY=dataentry;
	        if( source!= null ) this.SOURCE=name;
	        if( species_name!=null) this.SPECIES_NAME=species_name;
	        if( site_name!=null) this.SITE_NAME=site_name;
	        if( site_type!=null) this.SITE_TYPE=site_type;
	        if( fw1!=null) this.FW1=fw1;
	        if( fw2!=null) this.FW2=fw2;
	        if( !isNaN(nb_individual)) this.NB_INDIVIDUAL=nb_individual;
			if( abundancy!=null) this.ABUNDANCY=abundancy;
	        
	        if( !isNaN(nb_species)) this.NB_SPECIES=nb_species;
	        if( children!= null ) this.CHILDREN=children;
        }
        
        public function get uid():String 
        {
            return _uid;
        }

        public function set uid(value:String):void 
        {
            // Do nothing, the constructor created the uid.
        }


		// TRANSFORMATION FROM STATIONVO //
		// ----------------------------------------------------------------------------------------------------- //
		/** Transforme une station csv en StationVO
		 *
		 **/
		public static function fromCSV(csvline:String,separator:String,arrFieldMapping:ArrayCollection):StationVO
		{
			var data:StationVO = new StationVO();

			var arr:Array=csvline.split(separator);
			
			for each(var csvMapping:CsvMappingVO in arrFieldMapping) {
				if (csvMapping.CSV_INDEX!=-1){	                      //-1 ==> NONE
					if (csvMapping.STA_FIELD=="DATE"){
						var d:Date = DateField.stringToDate(arr[csvMapping.CSV_INDEX],csvMapping.FORMAT);	
						data["DATE"]=d
						data["DATE_Y"]=String(d.fullYear);
						data["DATE_YM"]=data["DATE_Y"] + "-" + String(d.month);
						data["DATE_YMD"]=data["DATE_YM"] + "-" + String(d.day);
					}else {
						data[csvMapping.STA_FIELD]=arr[csvMapping.CSV_INDEX]
					}
				}
			}
			
			return data;
		}
		
		

		// FONCTIONS //
		// ----------------------------------------------------------------------------------------------------- //


		/** Recupère la liste des variables de type numéric
 		 *  
 		 **/
 		public static function getListField(fieldType:String):Array
        {
        	var resultArray:Array=new Array;
        	/**var strFieldName:String;
        	
        	var classInfo:XML = describeType(stationVO);
        	for each (var v:XML in classInfo..accessor) {
                if (v.@type=="Number"){
                	strFieldName=String(v.@name)
                	resultArray.push(strFieldName)
                }
            }**/
            resultArray.push("NONE")
            
            if (fieldType=="ordonable"){	            
	            resultArray.push("NB_INDIVIDUAL")
            } else if (fieldType=="class"){	            
				resultArray.push("SPECIES_NAME")
				resultArray.push("FW1")
				resultArray.push("FW2")
				resultArray.push("ABUNDANCY")
				resultArray.push("SITE_NAME")
				resultArray.push("DATE_Y")
				resultArray.push("DATE_YM")
				resultArray.push("DATE_YMD")
				resultArray.push("SOURCE")
				resultArray.push("DATASET")
            }
            
			return resultArray;
        }

		/** Fonction pour convertir une date en string au format YYYY-MM-DDTHH:NN:SS+HH:NN
        *
        **/
        private static function CastDateToString(date:Date):String
        {
        	var strDate:String;
        	var df:DateFormatter;
        	var tzf:DateFormatter;
        	
        	df = new DateFormatter();
        	df.formatString="YYYY-MM-DDTJJ:NN:SS";
        	
        	var min:Number;
        	var hours:Number;
        	var signe:String;
        	
        	if (date.getTimezoneOffset()>0)
        	{
        		signe="-";
        	} else
        	{
        		signe="+";
        	}
        	
        	hours=Math.floor(Math.abs(date.getTimezoneOffset())/60)
        	min=Math.abs(date.getTimezoneOffset())-(hours*60);

        	var timeZone:Date;
        	timeZone=new Date();
        	timeZone.setHours(hours,min);
        	
        	tzf = new DateFormatter();
        	tzf.formatString="JJ:NN";        	
        	
        	strDate=df.format(date) + signe + tzf.format(timeZone);
        	return strDate;
        }

		/** Fonction pour convertir une date sous forme text en date
        *
        * @param strDate Date in string format
        * @param sepDateTime Date-time separator
        * @param sepDate Date separator
        **/
        private static function CastStringToDate(strDate:String,sepDateTime:String,sepDate:String):Date
        {
        	var date:Date;
        	var strDateSansTime:String;
			var dateArray:Array=new Array;
			
        	if (strDate=="" || strDate==null)
        	{
        		date=null;	
        	} else
        	{    
        		//SPLIT DATE et TIME
        		var arrStr:Array = strDate.split(sepDateTime,2);
        		var dateString:String =arrStr[0];
		        var timeString:String =arrStr[1];
        		
        		//SPLIT DATE
        		var arrDateStr:Array = dateString.split(sepDate,3);
        		var Year:Number =Number(arrDateStr[0]);
        		var Month:Number =Number(arrDateStr[1] -1);	//month are between 0 - 11
        		var Day:Number =Number(arrDateStr[2]);
        		
        		//SPLIT TIME
				if (timeString!=null && timeString!=""){							//NO TIME
	        		var arrTimeStr:Array = timeString.split(":",3);
	        		var Hour:Number =Number(arrTimeStr[0]);
	        		var Minute:Number =Number(arrTimeStr[1]);
	        		var Second:Number =Number(arrTimeStr[2]);
					
					date=new Date(Year,Month,Day,Hour,Minute,Second);
				} else{																//DATE AND TIME
        			date=new Date(Year,Month,Day);
        		}
        	}	
        	return date;
        }
    }
}