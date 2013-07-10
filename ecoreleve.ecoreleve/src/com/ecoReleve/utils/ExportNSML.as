/**
 * 
 */
package com.ecoReleve.utils
{
	import com.ecoReleve.model.VO.InventoryVO;
	import org.ns.common.model.VO.StationVO;
	
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	public class ExportNSML
	{
		
		/** Export to NSML
		 *
		 */
		public static function WriteNSML(data:ArrayCollection):String
		{
			var strXML:String="";

			
			//en-tête
			strXML=strXML+'<RELEVES>'
  			
			
			//data
			var station:StationVO;
			for each(station in data){
				strXML=strXML+'<RELEVE>'
				strXML=strXML + stationToNSML(station) + '\n';
				strXML=strXML+'</RELEVE>'
			}
			
			
			//fin de document
			strXML=strXML+'</RELEVES>'

			return strXML
		}

		
		/** Transforme un objet StationVO en NSML
        *
        **/
        private static function stationToNSML(obj:Object):String
        {
        	var strXML:String="";
        	
        	var myClass:Class=Class(getDefinitionByName(getQualifiedClassName(obj)));
			var xml:XML = describeType(myClass); 
			for each(var accessor:XML in xml..accessor) { 
			  var name:String = accessor.@name; 
			  var type:String = accessor.@type; 
			  if (type!="*"){
				  switch (name)
				  {
				  	case "NAME":
				  		strXML=strXML+"<NAME>" + String(obj[name]) + "</NAME>"
				  	break
			  		case "LATITUDE":
			  			strXML=strXML+"<LATITUDE>" + String(obj[name]) + "</LATITUDE>"
			  		break
			  		case "LONGITUDE":
			  			strXML=strXML+"<LONGITUDE>" + String(obj[name]) + "</LONGITUDE>"
			  		break
			  		case "DATE":
			  			var strDate:String="";
			  			var date:Date=obj[name] as Date;
			  			strXML=strXML+"<DATE>" + CastDateToString(date) + "</DATE>"		  			
			  		break
			  		case "ELEVATION":
			  			strXML=strXML+"<ELEVATION>" + String(obj[name]) + "</ELEVATION>"
			  		break
	        		case "PLACE":
	        			strXML=strXML+"<PLACE>" + String(obj[name]) + "</PLACE>"
	        		break
	        		case "REGION":
	        			strXML=strXML+"<REGION>" + String(obj[name]) + "</REGION>"
	        		break
	        		case "ACCURACY":
	        			strXML=strXML+"<ACCURACY>" + String(obj[name]) + "</ACCURACY>"
	        		break
	        		case "FIELDACTIVITY_NAME":
	        			strXML=strXML+"<FIELDACTIVITY_NAME>" + String(obj[name]) + "</FIELDACTIVITY_NAME>"
	        		break
			 		case "FIELDACTIVITY_ID":
			 			strXML=strXML+"<FIELDACTIVITY_ID>" + String(obj[name]) + "</FIELDACTIVITY_ID>"
			 		break
					case "COMMENTS":
						strXML=strXML+"<COMMENTS>" + String(obj[name]) + "</COMMENTS>"
					break
					case "DATA_ENTRY":
						strXML=strXML+"<DATA_ENTRY>" + String(obj[name]) + "</DATA_ENTRY>"
					break
			  		case "CHILDREN":
			  			var myArr:Array=new Array;
			  			myArr=obj[name] as Array;
			  			
			  			for each(var myobj:Object in myArr){
			  				var inventory:InventoryVO;
			  				strXML=strXML+"<WHATS>"
			  				for each(inventory in myobj){	
			  					strXML=strXML+"<WHAT>" + inventoryToNSML(inventory)	 + "</WHAT>" 				 
			  				}
			  				strXML=strXML+"</WHATS>"
			  			}
			  		break
				  } 
   				}
   			}       	
        	       	
        	return strXML
		}
	
		/** Transforme un objet StationVO en NSML
        *
        **/
        private static function inventoryToNSML(obj:Object):String
        {
        	var strXML:String="";
        	
        	var myClass:Class=Class(getDefinitionByName(getQualifiedClassName(obj)));
			var xml:XML = describeType(myClass); 
			for each(var accessor:XML in xml..accessor) { 
			  var name:String = accessor.@name; 
			  var type:String = accessor.@type; 
			  if (type!="*"){
			  	switch (name)
				  {
				  	case "ID":
				  		strXML=strXML+"<ID>" + String(obj[name]) + "</ID>"
				  	break
			        case "STATION_ID":
			        	strXML=strXML+"<STATION_ID>" + String(obj[name]) + "</STATION_ID>"
				  	break
			        case "DISTANCE":
			        	strXML=strXML+"<DISTANCE>" + String(obj[name]) + "</DISTANCE>"
				  	break
			        case "TAXON_ID":
			        	strXML=strXML+"<TAXON_ID>" + String(obj[name]) + "</TAXON_ID>"
				  	break
			        case "TAXON_NAME":
			        	strXML=strXML+"<TAXON_NAME>" + String(obj[name]) + "</TAXON_NAME>"
				  	break
			        case "NUMBER":
			        	strXML=strXML+"<NUMBER>" + String(obj[name]) + "</NUMBER>"
				  	break
			        case "ABUNDANCY":
			      		strXML=strXML+"<ABUNDANCY>" + String(obj[name]) + "</ABUNDANCY>"
				  	break
			        case "OCCUPE":
			      		strXML=strXML+"<OCCUPE>" + String(obj[name]) + "</OCCUPE>"
				  	break

			  	}
			  }
			}
			return strXML
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
}
}