/**
 * 
 */
package com.ecoReleve.utils
{
	import com.ecoReleve.model.VO.InventoryVO;
	
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	import org.ns.common.model.VO.StationVO;
	
	public class ExportKML
	{
		
		/** Export to KML
		 *
		 */
		public static function WriteKML(data:ArrayCollection):String
		{
			var strXML:String="";

			
			//en-tête
			strXML=strXML+'<kml xmlns="http://www.opengis.net/kml/2.2">'
  			strXML=strXML+'<Document>'
			
			//data
			var station:StationVO;
			for each(station in data){
				strXML=strXML + toKML(station) + '\n';
			}
			
			
			//fin de document
			strXML=strXML+'</Document>'
			strXML=strXML+'</kml>'

			return strXML
		}

		
		/** Transforme un objet StationVO en kml
        *
        **/
        private static function toKML(obj:Object):String
        {
        	var strXML:String="";
        	var strDescription:String="";
        	var strDescriptionStation:String="";
        	var strDescriptionInventory:String="";
        	
        	var myClass:Class=Class(getDefinitionByName(getQualifiedClassName(obj)));
			var xml:XML = describeType(myClass); 
			for each(var accessor:XML in xml..accessor) { 
			  var name:String = accessor.@name; 
			  var type:String = accessor.@type; 
			  if (type!="*" && name!="DATE_Y" && name!="DATE_YM" && name!="DATE_YMD" && name!="uid" && name!="FIELDACTIVITY_ID" && name!="DATASET"){
				  switch (name)
				  {
				  	case "NAME":
				  		var strNAME:String=obj[name]
				  	break
			  		case "LATITUDE":
			  			var strLAT:String=String(obj[name])
			  		break
			  		case "LONGITUDE":
			  			var strLON:String=String(obj[name])
			  		break
			  		case "DATE":
			  			var strDate:String="";
			  			var date:Date=obj[name] as Date;
			  			var formater:DateFormatter=new DateFormatter;
			  			formater.formatString="YYYY-MM-DD";
			  			strDate=strDate + formater.format(date) + "T";
			  			formater.formatString="HH:MM:SS";
			  			strDate=strDate + formater.format(date) + "Z";		  			
			  		break
			  		case "CHILDREN":
			  			var myArr:Array=new Array;
			  			myArr=obj[name] as Array;
			  			
			  			for each(var myobj:Object in myArr){
			  				var inventory:InventoryVO;
			  				for each(inventory in myobj){		  				
								var xml2:XML = describeType(InventoryVO); 
								for each(var accessor2:XML in xml2..accessor) { 
									var name2:String = accessor2.@name; 
								  	var type2:String = accessor2.@type; 
								  	if (type2!="*"){
								  		if (inventory[name2]!=null){
								  			strDescriptionInventory=strDescriptionInventory + "<![CDATA[<br/>]]>" + name2 + ":" + inventory[name2].toString()
								  		}
								  	}
								}
			  				}
			  			}
			  		break
			  		default:
			  			if (obj[name]!=null){
			  				strDescriptionStation=strDescriptionStation + "<![CDATA[<br/>]]>" + name + ":" + obj[name].toString()
			  			}else{
			  				strDescriptionStation=strDescriptionStation + "<![CDATA[<br/>]]>" + name + ": NULL"
			  			}
			  		break
				  } 
   				}
   			}
   			
   			strDescription="<![CDATA[<B>STATION</B><br/>]]>" + strDescriptionStation + "<![CDATA[<HR><B>INVENTORY</B><br/>]]>" + strDescriptionInventory + "<![CDATA[<br/>]]>"
   			
        	strXML=strXML+"<Placemark>"
				strXML=strXML+"<name>"+ strNAME +"</name>"
				strXML=strXML+"<TimeStamp>"+ strDate +"</TimeStamp>"
				strXML=strXML+"<description>"+ strDescription +"</description>"
				strXML=strXML+"<Point>"
					strXML=strXML+"<coordinates>"+ strLON + "," + strLAT + ",0</coordinates>"
				strXML=strXML+"</Point>"
			strXML=strXML+"</Placemark>"
        	
        	       	
        	return strXML

		}
	}
}