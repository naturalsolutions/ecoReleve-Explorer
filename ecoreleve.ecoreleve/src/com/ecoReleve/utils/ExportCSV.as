/**
 * 
 */
package com.ecoReleve.utils
{
	import com.ecoReleve.model.VO.InventoryVO;
	
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.StationVO;
	
	public class ExportCSV
	{
		
		/** Export to CSV
		 *
		 */
		public static function WriteCSV(data:ArrayCollection, csvSeparator:String=";", lineSeparator:String="\n"):String
		{
			var result:String
			
			var station:StationVO
			
			//en-tête
			result= getHeader(StationVO) + csvSeparator + getHeader(InventoryVO)
			
			result=result+lineSeparator;
			
			//data
			for each(station in data){
				result=result + toCSV(station);
			}
			
			return result
		}

		/** Crétaion de l'en-tête CSV à partir d'une class
        *
        **/
        private static function getHeader(myClass:Class,csvSeparator:String=";",lineSeparator:String="\n"):String
		{
			var result:String="";

			var xml:XML = describeType(myClass); 
			for each(var accessor:XML in xml..accessor) { 
			  var name:String = accessor.@name; 
			  var type:String = accessor.@type;
			  if (type!="*" && type!="Array"){
			  		result=result + csvSeparator + name
			  	}
			}
			
			//enlève le premier scvSeparator
        	result=result.substr(1,result.length)
			
			return result
		}
		
		/** Transforme un objet StationVO en csv
        *
        **/
        private static function toCSV(obj:Object,csvSeparator:String=";",lineSeparator:String="\n"):String
        {
        	var result:String="";
 			var arrCSVChild:Array=new Array();
 			var CSVObj:String="";
 			
 			var myClass:Class=Class(getDefinitionByName(getQualifiedClassName(obj)));
			var xml:XML = describeType(myClass); 
			for each(var accessor:XML in xml..accessor) { 
			  var name:String = accessor.@name; 
			  var type:String = accessor.@type; 
			  switch (type)
			  {
		  		case "Number":
		  			if (!isNaN(obj[name])){
		  				CSVObj=CSVObj + csvSeparator + obj[name] 
		  			}else{
		  				CSVObj=CSVObj + csvSeparator
		  			}
		  		break
		  		case "String":
		  			if (obj[name]!="" && obj[name]!=null){
		  				CSVObj=CSVObj + csvSeparator + '"' + obj[name] + '"'
		  			} else {
		  				CSVObj=CSVObj + csvSeparator
		  			}
		  		break
		  		case "Date":
		  			var date:Date=obj[name] as Date
		  			CSVObj=CSVObj + csvSeparator + date.toString()
		  		break
		  		case "Array":
		  			var myArr:Array=new Array;
		  			myArr=obj[name] as Array;
		  			
		  			for each(var myobj:Object in myArr){
		  				var inventory:InventoryVO;
		  				for each(inventory in myobj){		  				
							var str:String=toCSV(inventory);
							arrCSVChild.push(str);
		  				}
		  			}
		  		break
			  } 
			}        	       	
        	
        	//enlève le premier scvSeparator
        	CSVObj=CSVObj.substr(1,CSVObj.length)
        	
        	//ajoute les inventory au stations (applati)
        	if (arrCSVChild.length>0){
	        	for each(var item:String in arrCSVChild){
	        		//enlève le premier lineSeparator
        			item=item.substr(1,item.length)
	        		
	        		result= result + lineSeparator +  CSVObj + csvSeparator + item	        		 
	        	}
        	} else {
        		result= result + lineSeparator + CSVObj 
        	}
        	
        	
        	       	
        	return result;
        }

	}
}