package com.pocketListGenerator.model.VO
{
	import mx.formatters.DateFormatter;
	
	[Bindable]
    public class ThesaurusVO    
    {
    	public var ID:Number = NaN;
        public var ID_FATHER:Number = NaN;
        public var HIERARCHIC_POSITION:Number = NaN;
        public var TOPIC_FR:String = null;
        public var TOPIC_EN:String = null;
        public var DEFINITION_FR:String = null;
        public var DEFINITION_EN:String = null;
        public var REFERENCES:String = null;
        public var CREATE_DATE:Date = new Date();
        public var UPDATE_DATE:Date = new Date();

        public function ThesaurusVO (id:Number=NaN,
	                                 id_father:Number=NaN,
	                                 hierarchic_position:Number=NaN,
	                                 topic_fr:String=null,
	                                 topic_en:String=null,
	                                 definition_fr:String=null,
	                                 definition_en:String=null,
	                                 references:String=null,
	                                 create_date:Date=null,
	                                 update_date:Date=null)
        {
        	if( !isNaN(id) ) this.ID=id;
	        if( !isNaN(id_father)) this.ID_FATHER=id_father;
	        if( !isNaN(hierarchic_position)) this.HIERARCHIC_POSITION=hierarchic_position;
	        if( topic_fr!= null ) this.TOPIC_FR=topic_fr;
	        if( topic_en!= null ) this.TOPIC_EN=topic_en;
	        if( definition_fr!= null ) this.DEFINITION_FR=definition_fr;
	        if( definition_en!= null ) this.DEFINITION_EN=definition_en;
	        if( references!= null ) this.REFERENCES=references;
	        if( create_date!= null ) this.CREATE_DATE=create_date;
	        if( update_date!= null ) this.UPDATE_DATE=update_date;

        }
        
        //Transforme un thesaurus XML en ThesaurusVO
        public static function fromXML(xml:XML):ThesaurusVO
        {
            var data:ThesaurusVO = new ThesaurusVO();
            
            data.ID=Number(xml.attribute("id"));
	        data.ID_FATHER= Number(xml.ID_FATHER.text());
	        data.HIERARCHIC_POSITION= Number(xml.HIERARCHIC_POSITION.text());
	        data.TOPIC_FR= xml.TOPIC_FR.text();
	        data.TOPIC_EN= xml.TOPIC_EN.text();
	        data.DEFINITION_FR= xml.DEFINITION_FR.text();
	        data.DEFINITION_EN= xml.DEFINITION_EN.text();
	        data.REFERENCES=xml.REFERENCES.text();
	        data.CREATE_DATE= CastStringToDate(xml.CREATE_DATE.text());
	        //data.UPDATE_DATE=CastStringToDate(xml.UPDATE_DATE.text());
			           
            return data;
        }

		//Fonction pour convertir une date en string au format YYYY-MM-DDTHH:NN:SS+HH:NN      
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

		//Fonction pour convertir le format de date suivant en YYYY-MM-DDTHH:NN:SS+HH:NN  date      
        private static function CastStringToDate(strDate:String):Date
        {
        	var date:Date;

        	if (strDate=="")
        	{
        		date=null;	
        	} else
        	{        	
	        	strDate=strDate.substring(0,strDate.indexOf("Z"));
	        	var arrStr:Array = strDate.split("T",2);
	        	var dateString:String =arrStr[0];
	        	var timeString:String =arrStr[1];
	        	
	        	var dateArray:Array =dateString.split("-");
	        	
	        	date=new Date();
	        	//ATTENTION:Les mois vont de 0-11
	        	date.setUTCFullYear(dateArray[0],dateArray[1]-1,dateArray[2]);
        	}
        	return date;
        }
        
    }
}