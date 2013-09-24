package org.ns.common.model.utils
{
	import flash.utils.*;
	
	import mx.controls.DateField;
	import mx.formatters.DateFormatter;

	import org.ns.common.model.VO.StationVO;
	import org.ns.common.utils.DateUtils;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.basetypes.Location;
	import org.openscales.proj4as.ProjProjection;

	public class StationVOCast
	{
		
		// FUNCTIONS SOMETHING TO STATIONS
		
		public static function fromJSON(arr:Array,queryId:Number,datasourceName:String):StationVO
		{
			var data:StationVO = new StationVO();
			
			//data.ID=Number(arr[0])  //["tsta_pk_id","integer"]
			//arr[1]  //["tsta_nbfieldworker","integer"]
			//arr[2]  //["tsta_fieldactivity_id","integer"]
			//data.FIELDACTIVITY_NAME=String(arr[3])  //["tsta_fieldactivity_name","character varying(255)"]
			data.sta_name=String(arr[4])  //["tsta_name","character varying(255)"]
			//data.REGION=String(arr[5])  //["tsta_region","character varying(255)"]
			//data.PLACE=String(arr[6])  //["tsta_place","character varying(50)"]
			
			var date:Date=new Date;
			var dateFormat:DateFormatter = new DateFormatter();
			date=DateUtils.CastStringToDate(String(arr[7])," ","YYYY-MM-DD","HH:NN:SS")  //["tsta_date","DateTime"]
			data.sta_date=date;
			dateFormat.formatString = "YYYY";
			data.sta_dateY= dateFormat.format(date);
			dateFormat.formatString = "YYYY-MM";
			data.sta_dateYM= dateFormat.format(date);
			dateFormat.formatString = "YYYY-MM-DD";
			data.sta_dateYMD= dateFormat.format(date);
			
			data.sta_latitude=Number(arr[8])  //["tsta_lat","numeric(9,5)"]
			data.sta_longitude=Number(arr[9])  //["tsta_lon","numeric(9,5)"]
			//data.ACCURACY= Number(arr[10])  //["tsta_precision_h","integer"]
			data.sta_elevation=Number(arr[11])  //["tsta_ele","integer"]
			//arr[12]  //["tsta_operateur_saisie_id","integer"]
			//arr[13]  //["tsta_operateur_saisie","character varying(255)"]
			//arr[14]  //["tsta_date_saisie","DateTime"]
			data.sta_comments=String(arr[15])  //["tsta_comments","character varying(255)"]
			//arr[16]  //["PK_Fw1","integer"]
			//data.FW1=String(arr[17])  //["FW1","character varying(255)"]
			//arr[18]  //["PK_Fw2","integer"]
			//data.FW2=String(arr[19])  //["FW2","character varying(255)"]
			//arr[20]  //["pk","integer"]
			//arr[21]  //["tpi_id_taxon","integer"]
			data.sta_speciesName=arr[22]  //["tpi_name_taxon","character varying(255)"]
			//data.ABUNDANCY=arr[23]  //["tpi_name_abundance","character varying(255)"]
			data.sta_nbIndividual=arr[24]  //["tpi_nb_individual","integer"]
			//arr[25]  //["tpi_distance","numeric"]
			//arr[26]  //["tpi_occupe","boolean"]
			//arr[27]  //["tpi_comments","character varying(255)"]
			//arr[28]  //["tgeo_pk_id","integer"]
			//data.SITE_NAME=String(arr[29])  //["nom_complet","character varying(50)"]
			//arr[30]  //["PKcreateur","integer"]
			//arr[31]  //["createur","character varying(255)"]
			//arr[32]  //["actif","boolean"]
			//data.SITE_TYPE=String(arr[33])  //["name_type","character varying(200)"]
			//arr[34]  //["id_type","integer"]
			//arr[35]  //["tgeopos_lat","numeric(9,5)"]
			//arr[36]  //["tgeopos_lon","numeric(9,5)"]
			//arr[37]  //["tgeopos_ele","numeric"]
			//arr[38]  //["tgeopos_date","DateTime"]
			//arr[39]  //["tgeopos_precision_h","integer"]
			//arr[40]  //["tgeopos_comments","character varying(500)"]
			
			data.sta_fkQuery=queryId;
				
			data.sta_source=datasourceName;
				
			return data;	
		}
		
		
		
		public static function fromDwcXML(xml:XML,queryId:Number,datasourceName:String):StationVO
		{
			var data:StationVO = new StationVO();
			var i:XML;
			
			
			data.sta_latitude=Number(xml.binding.(@name=="lat").literal.text())
			data.sta_longitude=Number(xml.binding.(@name=="long").literal.text())
			
			
			var date:Date=new Date;
			var dateFormat:DateFormatter = new DateFormatter();
			date=DateUtils.CastStringToDate(xml.binding.(@name=="date").literal.text(),"T","YYYY-MM-DD","HH:NN:SS");
			if (date==null){
				date=new Date(Number(xml.binding.(@name=="date").literal.text())*1000);
			}
			data.sta_date=date;
			dateFormat.formatString = "YYYY";
			data.sta_dateY= dateFormat.format(date);
			dateFormat.formatString = "YYYY-MM";
			data.sta_dateYM= dateFormat.format(date);
			dateFormat.formatString = "YYYY-MM-DD";
			data.sta_dateYMD= dateFormat.format(date);
			
			data.sta_id=xml.binding.(@name=="occurrence").uri.text();
			data.sta_name=xml.binding.(@name=="occurrence").uri.text();
			
			data.sta_nbIndividual=1;
			data.sta_speciesName=xml.binding.(@name=="scientificName").literal.text();

			
			data.sta_fkQuery=queryId;
			data.sta_source=datasourceName;
			
			return data;
		}
		
		public static function fromNSML(when:XML,where:XML,who:XML,what:XML,datasourceName:String):StationVO
		{
			var station:StationVO = new StationVO();
			trace("StationCreationFromNSML");
			station.sta_latitude=where.LATITUDE.text()
			station.sta_longitude=where.LONGITUDE.text()
			station.sta_elevation=where.ELEVATION.text()
			station.sta_id=NaN
			station.sta_name=where.NAME.text
				
			station.sta_date=DateUtils.CastStringToDate(when.DATE.text()," ","YYYY-MM-DD","HH:NN:SS")
			if(station.sta_date!=null){
				station.sta_dateY=String(station.sta_date.getFullYear())
				station.sta_dateYM=station.sta_dateY + "-" + String(station.sta_date.getMonth()+1)
				station.sta_dateYMD=station.sta_dateYM + "-" + String(station.sta_date.getDate())
			}
			
			station.sta_speciesName=what.TAXON.TAXON_NAME.text()
			
			var observation:XML
			for each (observation in what.OBSERVATIONS.children()){
				if (observation.NAME.text()=='Effectif' || observation.NAME.text()=='Nombre' ){
					station.sta_nbIndividual=Number(observation.VALUE.text())
				}
			}
	
			station.sta_source=datasourceName;
			
			if (isNaN(station.sta_latitude) || isNaN(station.sta_longitude)){
				return null
			}
			
			return station;	
		}
		
		public static function fromFauneML(xml:XML,datasourceName:String):StationVO
		{
			var station:StationVO = new StationVO();
			
			station.sta_latitude=Number(xml.observers.observer.coord_lat.text())
			station.sta_longitude=Number(xml.observers.observer.coord_lon.text())
			station.sta_elevation=Number(xml.observers.observer.altitude.text())
			
			station.sta_date=new Date(xml.date.year.text(),xml.sighting.date.month.text(),xml.sighting.date.day.text())
			station.sta_dateY= xml.date.year.text()
			station.sta_dateYM= station.sta_dateY + "-" + xml.date.month.text()
			station.sta_dateYMD= station.sta_dateYM + "-" + xml.date.day.text()
			
			station.sta_id=xml.observers.observer.id_sighting.text();
			station.sta_name="FauneML_" + station.sta_id
			
			station.sta_nbIndividual=Number(xml.observers.observer.count.text());
			station.sta_speciesName=xml.species.latin_name.text();
			
			station.sta_comments=xml.observers.observer.comment.text();
			
			station.sta_source=datasourceName;
			
			if (isNaN(station.sta_latitude) || isNaN(station.sta_longitude)){
				return null
			}
			
			return station;
		}
		
		public static function fromODataXML(xml:XML,datasourceName:String):StationVO
		{
			var station:StationVO = new StationVO();
			var m:Namespace=new Namespace("http://schemas.microsoft.com/ado/2007/08/dataservices/metadata")
			var d:Namespace=new Namespace("http://schemas.microsoft.com/ado/2007/08/dataservices")
			var atom:Namespace=new Namespace("http://www.w3.org/2005/Atom")
			
			station.sta_latitude=Number(xml..d::LAT.text())
			station.sta_longitude=Number(xml..d::LON.text())
			station.sta_elevation=Number(xml..d::ELE.text())
			
			station.sta_date=DateUtils.CastStringToDate(xml..d::DATE.text(),"T","YYYY-MM-DD","HH:NN:SS")
			station.sta_dateY=String(station.sta_date.fullYear)
			station.sta_dateYM= station.sta_dateY + "-" + String(station.sta_date.month + 1)
			station.sta_dateYMD= station.sta_dateYM + "-" + String(station.sta_date.date)
			
			station.sta_id=Number(xml..d::TSta_PK_ID.text())
			station.sta_name="TSta_id_" + station.sta_id
			
			station.sta_nbIndividual=1;
			
			if (xml..d::TCaracThes_Species_Precision.text()!=""){
				station.sta_speciesName=xml..d::TCaracThes_Species_Precision.text();				
				station.sta_comments='Individual id: ' + String(xml..d::Individual_Obj_pk.text())
			}

			station.sta_source=datasourceName;
			
			return station;
		}
		
		
		// FUNCTIONS STATIONS TO SOMETHING
		
		public static function toPointFeature(station:StationVO):PointFeature
		{      	
			var LAT:String=station.sta_latitude.toString();
			var LON:String=station.sta_longitude.toString();
			
			if (LAT!="" && LON!="")	{
				//create latlon object
				var lonlat:Location = new Location(Number(LON),Number(LAT), ProjProjection.getProjProjection("EPSG:4326"));
				
				//create point object
				var p:Point=new Point(lonlat.lon,lonlat.lat);				
					
				//create attributes
				var classInfo:XML = describeType(station);
				var v:XML;
				var obj:Object=new Object;
				
				//add VO definition property
				for each (v in classInfo..accessor) {
					obj[v.@name]=station[v.@name]
				}
				
				//add dynamic property
				for (var prop:String in station){
					obj[prop]=station[prop]
				}
				

				//create attributes for pointfeature
				var pointFeature:PointFeature = new PointFeature(p);
				pointFeature.attributes=obj
				
			}
			return pointFeature;	
		}
		
		public static function toNSML(station:StationVO):String
		{
			var strXML:String="";
			
			strXML+='<RELEVE>'
			
			var myClass:Class=Class(getDefinitionByName(getQualifiedClassName(station)));
			var xml:XML = describeType(myClass); 
			for each(var accessor:XML in xml..accessor) { 
				var name:String = accessor.@name; 
				var type:String = accessor.@type; 
				if (type!="*"){
					switch (name)
					{
						case "sta_name":
							strXML=strXML+"<NAME>" + String(station[name]) + "</NAME>"
							break
						case "sta_latitude":
							strXML=strXML+"<LATITUDE>" + String(station[name]) + "</LATITUDE>"
							break
						case "sta_longitude":
							strXML=strXML+"<LONGITUDE>" + String(station[name]) + "</LONGITUDE>"
							break
						case "sta_date":
							var strDate:String="";
							var date:Date=station[name] as Date;
							strXML=strXML+"<DATE>" + DateUtils.CastDateToString(date,"DD/MM/YYYY HH:NN:SS") + "</DATE>"		  			
							break
						case "sta_elevation":
							strXML=strXML+"<ELEVATION>" + String(station[name]) + "</ELEVATION>"
							break
						case "sta_comments":
							strXML=strXML+"<COMMENTS>" + String(station[name]) + "</COMMENTS>"
							break
						case "sta_speciesName":
							strXML=strXML+"<SPECIES_NAME>" + String(station[name]) + "</SPECIES_NAME>"
							break
						case "sta_nbIndividual":
							strXML=strXML+"<NB_INDIVIDUAL>" + String(station[name]) + "</NB_INDIVIDUAL>"
							break
						case "sta_fkQuery":
							strXML=strXML+"<FK_QUERY>" + String(station[name]) + "</FK_QUERY>"
							break
						case "sta_source":
							strXML=strXML+"<SOURCE>" + String(station[name]) + "</SOURCE>"
							break
					} 
				}	
			} 
			strXML+='</RELEVE>'
				
			return strXML
		}
		
		//GET CLASS INFO
		
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
				resultArray.push("sta_nbIndividual")
			} else if (fieldType=="class"){	            
				resultArray.push("sta_speciesName")
				resultArray.push("sta_dateY")
				resultArray.push("sta_dateYM")
				resultArray.push("sta_dateYMD")
				resultArray.push("sta_source")
				resultArray.push("sta_fkQuery")
				resultArray.push("enh_conservationStatus")
			}
			
			return resultArray;
		}
		
	}
}