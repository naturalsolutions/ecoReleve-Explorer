package com.pocketListGenerator.model.VO
{
	import mx.formatters.DateFormatter;
	
	[Bindable]
    public class ThesaurusFiltreVO    
    {
    	public var ID_TYPE:Number=NaN;
        public var ID_FATHER:Number=NaN;
        public var TOPIC_FR_LIKE:String = null;
        public var DEFINITION_FR_LIKE:String = null;
		public var START_INDEX:Number=NaN;
		public var MAX_RESULTS:Number=NaN;
		
        public function ThesaurusFiltreVO (  id_type:Number=NaN,
	                                 		 id_father:Number=NaN,
	                                 		 topic_fr_like:String=null,
	                                 		 definition_fr_like:String=null,
	                                 		 start_index:Number=NaN,
	                                 		 max_results:Number=NaN)
        {
	        if( !isNaN(id_type) ) this.ID_TYPE=id_type;
	        if( !isNaN(id_father) ) this.ID_FATHER=id_father;
	        if( topic_fr_like!= null ) this.TOPIC_FR_LIKE=topic_fr_like;
	        if( definition_fr_like!= null ) this.DEFINITION_FR_LIKE=definition_fr_like;
	        if( !isNaN(start_index)) this.START_INDEX=start_index;
	        if( !isNaN(max_results)) this.MAX_RESULTS=max_results;
        }
        
        //Transforme un StationFiltreVO en critère pour webservice
        public static function toNsHttpStr(myFilter:ThesaurusFiltreVO):String
        {
            var strCritere:String="";
            var numIdType:Number=myFilter.ID_TYPE;
            var numIdFather:Number=myFilter.ID_FATHER;
            var strTopicFrLike:String=myFilter.TOPIC_FR_LIKE;
            var strDefinitionFrLike:String=myFilter.DEFINITION_FR_LIKE;
            var numStartIndex:Number=myFilter.START_INDEX;
            var numMaxResults:Number=myFilter.MAX_RESULTS;
                       
			if (!isNaN(numIdType)){
				strCritere=strCritere + "&id_type=" + numIdType.toString();
			}
			if (!isNaN(numIdFather)){
				strCritere=strCritere + "&id_father=" + numIdFather.toString();
			}
			if (strTopicFrLike!=null){
				strCritere=strCritere + "&topicFr-like=" + strTopicFrLike;
			}
			if (strDefinitionFrLike!=null){
				strCritere=strCritere + "&definitionFr-like=" + strDefinitionFrLike;
			}
			if (!isNaN(numStartIndex)){
				strCritere=strCritere + "&startindex" + numStartIndex.toString();
			}
			if (!isNaN(numMaxResults)){
				strCritere=strCritere + "&maxresults=" + numMaxResults.toString();
			}

			//remplace le premier & par ? si strCritere n'est pas vide
			if (strCritere!=""){
				strCritere= "?" + strCritere.substring(1);
			}						           
            return strCritere;
        }

		//Fonction pour convertir une date en string au format MM/DD/YYYY      
        private static function CastDateToString(date:Date):String
        {
        	var strDate:String;
        	var df:DateFormatter;
        	
        	df = new DateFormatter();
        	df.formatString="YYYY-MM-DD";
        	
        	strDate=df.format(date);
        	 
        	return strDate;
        }
        
    }
}