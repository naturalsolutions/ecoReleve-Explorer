package org.ns.dataconnecteur.shell.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ArrayUtil;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.enhancer.AttributeEnhance;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.components.gridClasses.GridColumn;
	import spark.events.IndexChangeEvent;
	
	public class AttributeEnhanceMediator extends FlexMediator
	{
		public static const NAME:String = 'AttributeEnhanceMediator';
		
		private var PREFIX_URL:String="http://dbpedia.org/sparql"
		private var lstAttribute:Vector.<Object>;
		private var lstAttributeClone:Vector.<String>=new Vector.<String>
		private var dbpediaProp:HTTPService;
		private var serviceState:String='normal';	
		
		public function AttributeEnhanceMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER
		public function respondToStationEnhanced(note:INotification):void
		{
			PopUpManager.removePopUp(attributeenhance)
		}
		
       public function respondToAttributeDistinctAdded(note:INotification):void
	   {
		   var data:ArrayCollection=note.getBody() as ArrayCollection
		   var obj:Object
		   var str:String
		   lstAttribute=new Vector.<Object>;
		   for each (obj in data){ 
			   str=obj.sta_speciesName
			   //remove (blabla) if exist and add to array
			   if (str.indexOf('(')!=-1){
			   	str=str.slice(0,str.indexOf('(')-1)	   
			   }
			   //create hash map with database name as key and name modify as value
			   var hash:Object=new Object()
			   hash[obj.sta_speciesName]=str
			   lstAttribute.push(hash)
		   }
	   }
		
		
		//REACTIONS
		
	   public function reactToBtnUpdate$Click(event:MouseEvent):void
	   {
		   sendNotification(NotificationConstants.ENHANCE_STATION_NOTIFICATION,attributeenhance.dg.dataProvider,'EnhanceArray')
	   }
	   
	   public function reactToBtnCancel$Click(event:MouseEvent):void
	   {
		   //cancel service
		   serviceState='canceled'
		   dbpediaProp.cancel()
		   attributeenhance.dg.enabled=true
		   attributeenhance.btnCancel.enabled=false
		   attributeenhance.pgBar.visible=false
		   CursorManager.removeBusyCursor();
		   
	   }
	   
		public function reactToLstAttribute$Change(event:IndexChangeEvent):void
		{
			attributeenhance.lstProp.enabled=false
			attributeenhance.btnEnhance.enabled=false
			var url:String= "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "+
				"PREFIX dbOnto:<http://dbpedia.org/ontology/> " +
				"select DISTINCT ?prop " +
				" where {" +
				"?prop rdfs:domain dbOnto:" + attributeenhance.lstAttribute.selectedItem + "." +
				"}";
			
			trace(url)
			
			url=escape(url);
			url=PREFIX_URL + "?default-graph-uri=&should-sponge=&query=" + url + "&format=xml&debug=off&timeout="
				
			//create httpservice
			dbpediaProp=new HTTPService
			dbpediaProp.addEventListener(ResultEvent.RESULT,dbPediaPropResultHandler)	
			dbpediaProp.addEventListener(FaultEvent.FAULT,dbPediaPropFaultHandler)
			dbpediaProp.resultFormat="e4x"
			dbpediaProp.url=url;
			dbpediaProp.send();	
			
			//send notification for select attribute
			sendNotification(NotificationConstants.SELECT_ATTRIBUTE_NOTIFICATION,'sta_speciesName');
			
			CursorManager.setBusyCursor();
		}
		
		public function reactToBtnEnhance$Click(event:MouseEvent):void
		{
			//get value ofclone list Species
			var obj:Object
			for each(obj in lstAttribute){
				for (var p:String in obj) {
					lstAttributeClone.push(obj[p])
				}	
			}
	
			attributeenhance.nbSp.text=String(lstAttribute.length)
				
			//init datagrid dataprovider,busycursor and disenabled datagrid	
			CursorManager.setBusyCursor();	
			attributeenhance.dg.dataProvider=new ArrayCollection()
			attributeenhance.dg.columns=new ArrayCollection();
			attributeenhance.dg.enabled=false;
			
			//get endpoint data
			attributeenhance.btnCancel.enabled=true
			attributeenhance.pgBar.visible=true
			//set service state variable to normal (!= cancel)	
			serviceState='normal'	
			getEndPointData()
		}
		
		private function getEndPointData():void
		{
			if (serviceState!='canceled'){
				//create filter string
				var filter:String=""
				var sp:String=""
				for(var i:int = 0; i < 1; i++){
					sp=lstAttributeClone.shift()
					if (sp!=null){
						filter+=" || ?binomial = '" + sp + "'@en"
					}
				}
				
				//remove first || and completer Filter string
				filter="FILTER ("+ filter.replace('||','') + ")"
				
				//create sparql query with properties selected
				var obj:Object
				var strSelect:String="select ?binomial"
				var strWhere:String="?species dbProp:binomial ?binomial. "
				for each(obj in attributeenhance.lstProp.selectedItems){
					var strProp:String=(obj as XML).toString()
					strProp=strProp.slice(strProp.lastIndexOf('/')+1)
					strSelect+=',?' + strProp	
					strWhere+="OPTIONAL { ?species dbOwl:" + strProp + " ?" + strProp + "}. "
				}
				
				var url:String= "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> " +
					"PREFIX dbOwl: <http://dbpedia.org/ontology/> " +
					"PREFIX dbProp: <http://dbpedia.org/property/> " + strSelect + " where {" + strWhere + filter + "}";
	
				sendNotification(NotificationConstants.LOG_NOTIFICATION,url,'enhance')
				
				url=escape(url);
				url=PREFIX_URL + "?default-graph-uri=&should-sponge=&query=" + url + "&format=xml&debug=off&timeout="
				
				//trace url size
				trace('url length:' + url.length)
				
				//create httpservice	
				var dbpediaOccurences:HTTPService=new HTTPService
				dbpediaOccurences.addEventListener(ResultEvent.RESULT,dbpediaOccurencesResultHandler)	
				dbpediaOccurences.addEventListener(FaultEvent.FAULT,dbpediaOccurencesFaultHandler)
				dbpediaOccurences.resultFormat="e4x"
				dbpediaOccurences.url=url;
				dbpediaOccurences.send();
			}
		}
		
		private function dbPediaPropResultHandler(event:ResultEvent):void 
		{ 				
			CursorManager.removeBusyCursor();
			
			var xml:XML = removeDefaultNamespaceFromXML(new XML(event.result));
			attributeenhance.lstProp.dataProvider=new XMLListCollection(xml.results.result.binding.uri)
			attributeenhance.lstProp.enabled=true
			attributeenhance.btnEnhance.enabled=true
		} 
		
		private function dbPediaPropFaultHandler(event:FaultEvent):void 
		{ 
			CursorManager.removeBusyCursor();
			trace(event.fault.message)
		} 
		
		private function dbpediaOccurencesResultHandler(event:ResultEvent):void 
		{ 							
			if (serviceState!='canceled'){
				var xml:XML = removeDefaultNamespaceFromXML(new XML(event.result));
				trace(xml.toXMLString())
				
				//loop through header
				
				if (attributeenhance.dg.columns.length==0){
					for each ( var variable: XML in xml.head.variable ){
						trace(variable.attribute("name").toString())
						var column:GridColumn=new GridColumn('enh_' + variable.attribute("name").toString())
						attributeenhance.dg.columns.addItem(column)
					}
				}
				
				//loop through result
				var obj:Object;
				var attributeName:String=''
				var strValue:String='' 
				for each ( var result: XML in xml.results.result){
					obj=new Object;
					for each(var binding:XML in result.binding){
						//ad enh_ prefix
						attributeName=binding.attribute("name").toString()
						attributeName='enh_'+ attributeName
						//remove http://... if uri
						strValue=binding.children().toString()
						strValue=strValue.slice(strValue.lastIndexOf('/')+1)
						
						obj[attributeName]=strValue
					}
					attributeenhance.dg.dataProvider.addItem(obj);
				}
	
				attributeenhance.dg.enabled=true;
				if (lstAttributeClone.length>0){
					getEndPointData()
				}else{	
					attributeenhance.pgBar.visible=false;
					attributeenhance.btnCancel.enabled=false;
					CursorManager.removeBusyCursor();
				}
			}
		} 
		
		private function dbpediaOccurencesFaultHandler(event:FaultEvent):void 
		{ 
			CursorManager.removeBusyCursor();
			attributeenhance.dg.enabled=true;
			attributeenhance.btnCancel.enabled=false;
			attributeenhance.pgBar.visible=false;
			trace(event.fault.message)
		}
		
		private function removeDefaultNamespaceFromXML(xml:XML):XML
		{
			var rawXMLString:String = xml.toXMLString();
			
			/* Define the regex pattern to remove the default namespace from the 
			String representation of the XML result. */
			var xmlnsPattern:RegExp = new RegExp("xmlns=[^\"]*\"[^\"]*\"", "gi");
			
			/* Replace the default namespace from the String representation of the 
			result XML with an empty string. */
			var cleanXMLString:String = rawXMLString.replace(xmlnsPattern, "");
			
			// Create a new XML Object from the String just created
			return new XML(cleanXMLString);
		}
		
		//GETTER		
		public function get attributeenhance():AttributeEnhance
		{
			return this.viewComponent as AttributeEnhance;
		}
		
	}
}