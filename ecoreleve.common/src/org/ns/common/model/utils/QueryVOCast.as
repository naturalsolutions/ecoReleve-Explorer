package org.ns.common.model.utils
{
	import org.ns.common.model.VO.QueryVO;
	import org.ns.common.utils.DateUtils;

	public class QueryVOCast
	{
		//Transforme un StationFiltreVO en critère pour requete sur le service NS
		public static function toNsHttpStr(query:QueryVO):String
		{
			var strCritere:String="";
			var strFormat:String=query.qry_format;
			var dMinDate:Date=query.qry_minDate;
			var dMaxDate:Date=query.qry_maxDate;
			var numIdTaxon:Number=query.qry_idTaxon;
			var boIsTaxonFather:Boolean=query.qry_isTaxonFather;
			var numMinLat:Number=query.qry_minLat;
			var numMaxLat:Number=query.qry_maxLat;
			var numMinLon:Number=query.qry_minLon;
			var numMaxLon:Number=query.qry_maxLon;
			//var numStartIndex:Number=query.START_INDEX;
			//var numMaxResults:Number=query.MAX_RESULTS;
			var strDataOwner:String=query.qry_dataOwner;
			
			if (strFormat!=""){
				strCritere=strCritere + "&format=" + strFormat;
			}
			if (dMinDate!=null){
				strCritere=strCritere + "&min-date=" + DateUtils.CastDateToString(dMinDate,"YYYY-MM-DD");
			}
			if (dMaxDate!=null){
				strCritere=strCritere + "&max-date=" + DateUtils.CastDateToString(dMaxDate,"YYYY-MM-DD");
			}
			if (!isNaN(numIdTaxon)){
				strCritere=strCritere + "&id-taxon=" + numIdTaxon.toString();
			}
			if (boIsTaxonFather!=false){
				strCritere=strCritere + "&is-taxonFather=" + boIsTaxonFather.toString();
			}	
			if (!isNaN(numMinLat)){
				strCritere=strCritere + "&min-lat=" + numMinLat.toString();
			}		
			if (!isNaN(numMaxLat)){
				strCritere=strCritere + "&max-lat=" + numMaxLat.toString();
			}			
			if (!isNaN(numMinLon)){
				strCritere=strCritere + "&min-lon=" + numMinLon.toString();
			}	
			if (!isNaN(numMaxLon)){
				strCritere=strCritere + "&max-lon=" + numMaxLon.toString();
			}	
			/*if (!isNaN(numStartIndex)){
				strCritere=strCritere + "&startrndex" + numStartIndex.toString();
			}
			if (!isNaN(numMaxResults)){
				strCritere=strCritere + "&maxresults=" + numMaxResults.toString();
			}*/		
			if (strDataOwner!=""){
				strCritere=strCritere + "&dataOwner="+ strDataOwner;
			}
			
			//remplace le premier & par ? si strCritere n'est pas vide
			if (strCritere!=""){
				strCritere= "?" + strCritere.substring(1);
			}
			
			return strCritere;
		}
		
		//Transforme un StationFiltreVO en critère pour requete sur le service GBIF
		public static function toGbifHttpStr(query:QueryVO):String
		{
			var strCritere:String="";
			var dMinDate:Date=query.qry_minDate;
			var dMaxDate:Date=query.qry_maxDate;
			var numMinLat:Number=query.qry_minLat;
			var numMaxLat:Number=query.qry_maxLat;
			var numMinLon:Number=query.qry_minLon;
			var numMaxLon:Number=query.qry_maxLon;
			
			if (dMinDate!=null){
				strCritere=strCritere + "&startdate=" + DateUtils.CastDateToString(dMinDate,"YYYY-MM-DD");
			}
			if (dMaxDate!=null){
				strCritere=strCritere + "&enddate=" + DateUtils.CastDateToString(dMaxDate,"YYYY-MM-DD");
			}
			if (!isNaN(numMinLat)){
				strCritere=strCritere + "&minlatitude=" + numMinLat.toString();
			}		
			if (!isNaN(numMaxLat)){
				strCritere=strCritere + "&maxlatitude=" + numMaxLat.toString();
			}			
			if (!isNaN(numMinLon)){
				strCritere=strCritere + "&minlongitude=" + numMinLon.toString();
			}	
			if (!isNaN(numMaxLon)){
				strCritere=strCritere + "&maxlongitude=" + numMaxLon.toString();
			}	

			//remplace le premier & par ? si strCritere n'est pas vide
			if (strCritere!=""){
				strCritere= "?" + strCritere.substring(1);
			}
			
			return strCritere;
		}
		
		//Transforme un StationFiltreVO en critère pour requete sparql via HTTP
		public static function toSparql(query:QueryVO,mode:String):String
		{
			var strSparqlQry:String="";
			
			var strSpeciesName:String=query.qry_topicFr;
			var numIdTaxon:Number=query.qry_idTaxon;
			var numMinLat:Number=query.qry_minLat;
			var numMaxLat:Number=query.qry_maxLat;
			var numMinLon:Number=query.qry_minLon;
			var numMaxLon:Number=query.qry_maxLon;
			var dMinDate:Date=query.qry_minDate;
			var dMaxDate:Date=query.qry_maxDate;
			
			strSparqlQry=strSparqlQry +="PREFIX dwc: <http://rs.tdwg.org/dwc/terms/#> "
			strSparqlQry=strSparqlQry +="PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
			strSparqlQry=strSparqlQry +="PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
			strSparqlQry=strSparqlQry +="PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> "
			strSparqlQry=strSparqlQry +="PREFIX dsw: <http://purl.org/dsw/> "
			
			switch (mode){
				case 'count':
					strSparqlQry=strSparqlQry +="SELECT count(*) as ?count "
					break
				case 'data':
					strSparqlQry=strSparqlQry +="SELECT distinct ?occurrence ?scientificName ?lat ?long ?date "
					break	
			}
			
			
			strSparqlQry=strSparqlQry +="WHERE { " 
				
				
			strSparqlQry=strSparqlQry +="?occurrence a dwc:Occurrence. "
			strSparqlQry=strSparqlQry +="?occurrence dsw:atEvent ?event. "
			strSparqlQry=strSparqlQry +="?event dwc:eventDate ?date. "
			//if (dMinDate!=null && dMaxDate!=null){
			//	strSparqlQry=strSparqlQry +="FILTER (xsd:dateTime(?date) > '" + DateUtils.CastDateToString(dMinDate,"YYYY-MM-DD") + "'^^xsd:dateTime). "
			//	strSparqlQry=strSparqlQry +="FILTER (xsd:dateTime(?date) < '" + DateUtils.CastDateToString(dMaxDate,"YYYY-MM-DD") + "'^^xsd:dateTime). "
			//} 
			strSparqlQry=strSparqlQry +="?event dsw:locatedAt ?location. "
			strSparqlQry=strSparqlQry +="?location geo:lat ?lat. "
			if (!isNaN(numMinLat) && !isNaN(numMaxLat)){
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?lat) > " + String(numMinLat) + "). "
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?lat) < " + String(numMaxLat) + "). "
			}
			strSparqlQry=strSparqlQry +="?location geo:long ?long. "
			if (!isNaN(numMinLon) && !isNaN(numMaxLon)){
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?long) > " + String(numMinLon) + "). "
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?long) < " + String(numMaxLon) + "). "
			}
			strSparqlQry=strSparqlQry +="?occurrence dsw:occurrenceOf ?indiv. "
			strSparqlQry=strSparqlQry +="?indiv dsw:hasIdentification ?ident. "
			strSparqlQry=strSparqlQry +="?ident dsw:toTaxon ?taxon. "
			strSparqlQry=strSparqlQry +="?taxon rdfs:label ?scientificName . "
			if (strSpeciesName!=null && strSpeciesName!=""){
				strSparqlQry=strSparqlQry +="?taxon rdfs:label '" + strSpeciesName + "'."
			}	
				
				
			/*strSparqlQry=strSparqlQry +="?occurrence rdf:type dwc:Occurrence. "
			strSparqlQry=strSparqlQry +="?occurrence dwc:scientificName ?lbl. "
			strSparqlQry=strSparqlQry +="?lbl rdfs:label ?scientificName. "
			if (strSpeciesName!=null && strSpeciesName!=""){
				strSparqlQry=strSparqlQry +="?lbl rdfs:label '" + strSpeciesName + "'."
			}
			strSparqlQry=strSparqlQry +="?occurrence geo:location ?location. "
			strSparqlQry=strSparqlQry +="?location geo:lat ?lat. "	       
			if (!isNaN(numMinLat) && !isNaN(numMaxLat)){
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?lat) > " + String(numMinLat) + "). "
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?lat) < " + String(numMaxLat) + "). "
			}
			strSparqlQry=strSparqlQry +="?location geo:long ?long. "
			if (!isNaN(numMinLon) && !isNaN(numMaxLon)){
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?long) > " + String(numMinLon) + "). "
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?long) < " + String(numMaxLon) + "). "
			}
			strSparqlQry=strSparqlQry +="?occurrence dcterms:date ?date "
			if (dMinDate!=null && dMaxDate!=null){
				strSparqlQry=strSparqlQry +="FILTER (xsd:dateTime(?date) > '" + DateUtils.CastDateToString(dMinDate,"YYYY-MM-DD") + "'^^xsd:dateTime). "
				strSparqlQry=strSparqlQry +="FILTER (xsd:dateTime(?date) < '" + DateUtils.CastDateToString(dMaxDate,"YYYY-MM-DD") + "'^^xsd:dateTime). "
			} 
			*/
			strSparqlQry=strSparqlQry +="} "	
			
			return strSparqlQry;
			
		}
		
		//Transforme un StationFiltreVO en critère pour requete sparql via HTTP
		/*public static function toSparql(query:QueryVO,mode:String):String
		{
			var strSparqlQry:String="";
			
			var strSpeciesName:String=query.qry_topicFr;
			var numIdTaxon:Number=query.qry_idTaxon;
			var numMinLat:Number=query.qry_minLat;
			var numMaxLat:Number=query.qry_maxLat;
			var numMinLon:Number=query.qry_minLon;
			var numMaxLon:Number=query.qry_maxLon;
			var dMinDate:Date=query.qry_minDate;
			var dMaxDate:Date=query.qry_maxDate;
			
			//strCritere=strCritere +="?default-graph-uri=&should-sponge=&query="
			
			strSparqlQry=strSparqlQry +="PREFIX dwc: <http://rs.tdwg.org/dwc/terms/#>"
			strSparqlQry=strSparqlQry +="PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>"
			strSparqlQry=strSparqlQry +="PREFIX  geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>"
			strSparqlQry=strSparqlQry +="PREFIX  dcterms: <http://purl.org/dc/terms/>"
			
			switch (mode){
				case 'count':
					strSparqlQry=strSparqlQry +="SELECT count(*) as ?count "
					break
				case 'data':
					strSparqlQry=strSparqlQry +="SELECT distinct ?occurrence ?scientificName ?lat ?long ?date ?recorder "
					break	
			}

			
			strSparqlQry=strSparqlQry +="FROM " + "<urn:rdf.Occurences_AKN_dwc>" + " "
			strSparqlQry=strSparqlQry +="WHERE { " 
			strSparqlQry=strSparqlQry +="?occurrence rdf:type dwc:Occurrence."
			strSparqlQry=strSparqlQry +="?occurrence dwc:recordedBy ?recorder."
			strSparqlQry=strSparqlQry +="?occurrence dwc:Identification ?id."
			strSparqlQry=strSparqlQry +="?id dwc:scientificName ?scientificName."
			if (strSpeciesName!=null && strSpeciesName!=""){
				strSparqlQry=strSparqlQry +="?id dwc:scientificName '" + strSpeciesName + "'."
			}
			strSparqlQry=strSparqlQry +="?occurrence geo:lat ?lat. "	       
			if (!isNaN(numMinLat) && !isNaN(numMaxLat)){
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?lat) > " + String(numMinLat) + "). "
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?lat) < " + String(numMaxLat) + "). "
			}
			strSparqlQry=strSparqlQry +="?occurrence geo:long ?long. "
			if (!isNaN(numMinLon) && !isNaN(numMaxLon)){
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?long) > " + String(numMinLon) + "). "
				strSparqlQry=strSparqlQry +="FILTER (xsd:float(?long) < " + String(numMaxLon) + "). "
			}
			strSparqlQry=strSparqlQry +="?occurrence dcterms:date ?date "
			if (dMinDate!=null && dMaxDate!=null){
				strSparqlQry=strSparqlQry +="FILTER (xsd:dateTime(?date) > '" + DateUtils.CastDateToString(dMinDate,"YYYY-MM-DD") + "'^^xsd:dateTime). "
				strSparqlQry=strSparqlQry +="FILTER (xsd:dateTime(?date) < '" + DateUtils.CastDateToString(dMaxDate,"YYYY-MM-DD") + "'^^xsd:dateTime). "
			} 
			strSparqlQry=strSparqlQry +="} "	
			
			return strSparqlQry;
			
		}*/
		
		//Transforme un StationFiltreVO en critère pour requete odata via http
		public static function toOdataHttpStr(query:QueryVO):String
		{
			var strCritere:String="";
			var strFormat:String=query.qry_format;
			var strIndividual:String=query.qry_topicFr;
			var dMinDate:Date=query.qry_minDate;
			var dMaxDate:Date=query.qry_maxDate;
			var numMinLat:Number=query.qry_minLat;
			var numMaxLat:Number=query.qry_maxLat;
			var numMinLon:Number=query.qry_minLon;
			var numMaxLon:Number=query.qry_maxLon;
			
			if (dMinDate!=null){
				strCritere+= " and TStations/DATE ge datetime'" + DateUtils.CastDateToString(dMinDate,"YYYY-MM-DD") + "T00:00:00'";
			}
			if (dMaxDate!=null){
				strCritere+= " and TStations/DATE le datetime'" + DateUtils.CastDateToString(dMaxDate,"YYYY-MM-DD") + "T00:00:00'";
			}
			
			if (!isNaN(numMinLat)){
				strCritere+= " and TStations/LAT ge " + numMinLat.toString();
			}		
			if (!isNaN(numMaxLat)){
				strCritere+= " and TStations/LAT le " + numMaxLat.toString();
			}			
			if (!isNaN(numMinLon)){
				strCritere+= " and TStations/LON ge " + numMinLon.toString();
			}	
			if (!isNaN(numMaxLon)){
				strCritere+= " and TStations/LON le " + numMaxLon.toString();
			}	
			
			if (strIndividual!=""){
				strCritere+= " and TObj_Individual_Obj/Individual_Obj_pk eq "+ strIndividual;
			}

			//remplace le premier and par &$filter = si strCritere n'est pas vide
			if (strCritere!=""){
				strCritere=strCritere.replace(" and","&$filter=")
			}
			
			return strCritere;
		}
		
		public static function toText(query:QueryVO):String
		{
			var strText:String="";
			var dMinDate:Date=query.qry_minDate;
			var dMaxDate:Date=query.qry_maxDate;
			var numIdTaxon:Number=query.qry_idTaxon;
			var strTopicFr:String=query.qry_topicFr;
			var boIsTaxonFather:Boolean=query.qry_isTaxonFather;
			var numMinLat:Number=query.qry_minLat;
			var numMaxLat:Number=query.qry_maxLat;
			var numMinLon:Number=query.qry_minLon;
			var numMaxLon:Number=query.qry_maxLon;
			var strDataOwner:String=query.qry_dataOwner;
			
			if (strDataOwner!=""){strText+=strDataOwner + " observation(s)";} 
			if (strTopicFr!=""){strText+=" of " + strTopicFr;}
			//if (!isNaN(numIdTaxon) && numIdTaxon!=0){strText+=" of " + strTopicFr ;	}
			
			//saut de ligne
			strText+="<br>"
			
			if (dMinDate!=null){strText+= " from " + DateUtils.CastDateToString(dMinDate,"DD-MM-YYYY");}
			if (dMaxDate!=null){strText+=" to " + DateUtils.CastDateToString(dMaxDate,"DD-MM-YYYY");}
			//saut de ligne
			strText=strText + "<br>"
			
			if (!isNaN(numMinLat) && !isNaN(numMaxLat) && !isNaN(numMinLon) && !isNaN(numMaxLon)){
				strText+=" in (" 
				strText+=String(Math.round(numMinLon*100000)/100000) + "," 
				strText+=String(Math.round(numMaxLat*100000)/100000) + ","
				strText+=String(Math.round(numMaxLon*100000)/100000) + ","
				strText+=String(Math.round(numMinLat*100000)/100000)
				strText+=")";
			}		
			
			return strText;
		}
	}
}