package OlapADG
{
	import OlapADG.chart.olapChartVisu;
	import OlapADG.editors.olapQueryEditor;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.containers.HBox;
	import mx.containers.HDividedBox;
	import mx.containers.VBox;
	import mx.controls.OLAPDataGrid;
	import mx.events.ListEvent;
	import mx.messaging.messages.ErrorMessage;
	import mx.olap.IOLAPAxisPosition;
	import mx.olap.IOLAPCube;
	import mx.olap.IOLAPQuery;
	import mx.olap.IOLAPQueryAxis;
	import mx.olap.IOLAPSet;
	import mx.olap.OLAPAxisPosition;
	import mx.olap.OLAPCube;
	import mx.olap.OLAPDimension;
	import mx.olap.OLAPMember;
	import mx.olap.OLAPQuery;
	import mx.olap.OLAPResult;
	import mx.olap.OLAPSet;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;

	public class OlapADG extends VBox
	{
		private var myCube:OLAPCube;
		private var myOlapADG:OLAPDataGrid;
		private var myOlapQueryEditor:olapQueryEditor;
		private var myOlapChartVisu:olapChartVisu;
		
		[Inspectable(category="General", type="Array", defaultValue="[]")]
		private var _colToUse:Array;
		private var colToUseChanged : Boolean = false;
		
		[Inspectable(category="General", type="ArrayCollection", defaultValue="null")]
		private var _ADGSource:ArrayCollection;
		private var ADGSourceChanged : Boolean = false;
		
		[Bindable]
        [Embed(source="assets/icon-olap.png")]
        public var icoOlap:Class;
        
        [Bindable]
        [Embed(source="assets/icon-chart.png")]
        public var icoChart:Class;
		
		[Bindable]
		public function get ADGSource():ArrayCollection
		{
			return _ADGSource;
		}
		
		public function set ADGSource(arrCol:ArrayCollection) : void 
		{
			_ADGSource=arrCol
			ADGSourceChanged=true;
			this.invalidateProperties();
		}
		
		[Bindable]
		public function get colToUse():Array
		{
			return _colToUse;
		}
		
		public function set colToUse(arrCol:Array) : void 
		{
			_colToUse=arrCol
			colToUseChanged=true;
			this.invalidateProperties();
		}
		
		public function OlapADG()
		{
			super();
		}
		
		override protected function commitProperties():void
		{
		 	super.commitProperties();
		 	//modifie la source de l'ADG  dès que la source change
		 	if(ADGSourceChanged == true){		  		
	            MajADGDataSource()
		  		ADGSourceChanged = false;
		  	}
		  	if(colToUseChanged == true){		  		
		  		colToUseChanged = false;
		  	}
		}
		
		/** CONSTRUCTEUR
		 *  
		**/
		override protected function createChildren():void 
		{
			super.createChildren();
			
			var toolBar:HBox=new HBox;
			toolBar.setStyle('horizontalAlign','middle')
			toolBar.percentWidth=100
			
			var content:HDividedBox=new HDividedBox;
			content.setStyle('horizontalAlign','middle')
			content.percentWidth=100
			content.liveDragging=true;
			
			//EDITORS
			myOlapQueryEditor=new olapQueryEditor;
			myOlapQueryEditor.label='Set query'
			myOlapQueryEditor.setStyle('skin', null);
            myOlapQueryEditor.setStyle('upSkin', null);
            myOlapQueryEditor.setStyle('icon',icoOlap);
            myOlapQueryEditor.addEventListener("SetOlapQueryEvent",createCube)
             
			toolBar.addChild(myOlapQueryEditor)
			this.addChild(toolBar)
			
			//VISU
			myOlapChartVisu=new olapChartVisu;
			myOlapChartVisu.percentWidth=100;
			myOlapChartVisu.percentHeight=100;
			
			//construit le datagrid OLAP
			myOlapADG=new OLAPDataGrid;
			myOlapADG.percentHeight=100
			myOlapADG.percentWidth=100
			myOlapADG.selectionMode="multipleRows"
			myOlapADG.addEventListener(ListEvent.ITEM_CLICK,onClickItem)
			myOlapADG.styleFunction=myStyleFunc;
			
			content.addChild(myOlapADG)
			content.addChild(myOlapChartVisu)
			this.addChild(content)
			
		}
		
		
		private function onClickItem(event:ListEvent):void
		{
			var arrSelctedMembers:Array=new Array();
			for each(var axisPos:OLAPAxisPosition in myOlapADG.selectedItems){
	    		for each(var member:OLAPMember in axisPos.members){
	    			arrSelctedMembers.push(member.uniqueName)
	    		}
  			 }
			myOlapChartVisu.selectedMembers=arrSelctedMembers
		}
		
		/** MAJ du ADGSource
		 *
		 **/
		private function MajADGDataSource():void 
		{
			//initialise les valeur du queryeditor
			 myOlapQueryEditor.columns=_colToUse;
		}
		
		
		private function createCube(event:Event):void 
		{	
			
			myCube=new OLAPCube
			myCube.name="DataCube"
			myCube.addEventListener("complete",runQuery)
			
			var DimArray:ArrayCollection=new ArrayCollection()
			
			/*
			//creation d'une dimension pour chaque element selectionnée dans le olapQueryeditor
			for each (var column:String in myOlapQueryEditor.dimensions) 
                {               			
           			//CREATION DE LA DIMENSION POUR LA COLONNE
           			var dim:OLAPDimension = new OLAPDimension(column.toString() + "_Dim");
           			//ajoute un attribut à la dimension
				    var attr:OLAPAttribute = new OLAPAttribute(column.toString());
					attr.dataField = column.toString();
					//creation de la hierarchie
					var hier:OLAPHierarchy=new OLAPHierarchy(column.toString() + "_Hier");
					hier.hasAll=true
					//creation du level
					var level:OLAPLevel = new OLAPLevel();
 					level.attributeName = column.toString();

					//Ajoute le level à la hierarchie
  					hier.levels = new ArrayCollection([level]);
					//ajoute la hierarchie à la dimension
					dim.hierarchies = new ArrayCollection([hier]);
					//ajoute l'attribut à la dimension
					dim.attributes= new ArrayCollection([attr]);
					
					DimArray.addItem(dim)
                }
			*/
			
			//create measure 
			 var measures:ArrayCollection=new ArrayCollection
			 measures=myOlapQueryEditor.measures
		
			
			//add the dimensions and measures to the cube .
			 myCube.dataProvider=_ADGSource
			 myCube.dimensions=myOlapQueryEditor.dimensions			 
			 myCube.measures=measures;
			 
			 refreshCube()
			 		 
		}

		/** CREATION D'UNE REQUÊTE
		 * 
		 **/
        private function getQuery(cube:IOLAPCube):IOLAPQuery 
        {           
            // Creation d'une instance de requête
            var query:OLAPQuery = new OLAPQuery;
            
            var mylist:ArrayCollection;
            var nbMax:int;
            var i:int; 
            
            //création de l'objet sort sur le name
            var mysort:Sort=new Sort;
            var mysortField:SortField=new SortField("name")
            mysort.fields=[mysortField]
            
            // ROW AXIS
            var rowQueryAxis:IOLAPQueryAxis = query.getAxis(OLAPQuery.ROW_AXIS);
            var boRowSum:Boolean=myOlapQueryEditor.rowSum.selected
            nbMax=myOlapQueryEditor.rowDim.length;
             
            var rowSet:IOLAPSet
            for (i=0;i<nbMax;i++){
            	var rowdim:OLAPDimension=myOlapQueryEditor.rowDim[i] as OLAPDimension;
            	if (i==0){
            		rowSet=createOlapSet(cube,rowdim,boRowSum)
            	}else{
            		rowSet=rowSet.crossJoin(createOlapSet(cube,rowdim,boRowSum));
            	}
            }
			rowQueryAxis.addSet(rowSet);
            
            // COLUMN AXIS 
            var colQueryAxis:IOLAPQueryAxis =query.getAxis(OLAPQuery.COLUMN_AXIS);         
            var boColSum:Boolean=myOlapQueryEditor.colSum.selected
            nbMax=myOlapQueryEditor.colDim.length;
            
            var colSet:IOLAPSet
            for (i=0;i<nbMax;i++){
            	var coldim:OLAPDimension=myOlapQueryEditor.colDim[i] as OLAPDimension;
            	if (i==0){
            		colSet=createOlapSet(cube,coldim,boColSum)
            	}else{
            		colSet=colSet.crossJoin(createOlapSet(cube,coldim,boColSum));
            	}
            }
            colQueryAxis.addSet(colSet)

            //SLICER AXIS
		    var slicerQueryAxis:IOLAPQueryAxis = query.getAxis(OLAPQuery.SLICER_AXIS);         
		    // Create an OLAPSet instance to configure the axis.
		    var costSet:OLAPSet= new OLAPSet;
		    // Use OLAPDimension.findMember() to add the Cost measure.
		    costSet.addElement(cube.findDimension("Measures").findMember("mes"));
		    slicerQueryAxis.addSet(costSet);

            
            return query;       
        }

		//creation d'un OLAPSet à partir d'une dimension d'un cube
		private function createOlapSet(cube:IOLAPCube,myDimension:OLAPDimension,boSum:Boolean):OLAPSet
		{
			var myOLAPset:OLAPSet=new OLAPSet;
			var strDimName:String=myDimension.name
			var mysort:Sort=new Sort;
            var mysortField:SortField=new SortField("name")          
            mysort.fields=[mysortField]
			
			var mylist:ArrayCollection=new ArrayCollection();
			if (boSum==true){
            	mylist=cube.findDimension(strDimName).findAttribute("myAttribute").members as ArrayCollection; 
            } else {
            	mylist=cube.findDimension(strDimName).findAttribute("myAttribute").children as ArrayCollection; 
            } 
			
			mylist.sort=mysort
            mylist.refresh();
            
            myOLAPset.addElements(mylist);
			
			return myOLAPset
		}
		
		/** CONSTRUCTION du Cube ==>  propage l'evenement complete
		 * 
		 **/
        private function refreshCube():void
        {
        	//méthode refresh propage l'evenement complete
        	myCube.refresh()
        }
        
        /** LANCE UNE REQUETE
		 * 
		 **/
        private function runQuery(event:Event):void 
        {
        	// Recupère le cube
            var cube:IOLAPCube = IOLAPCube(event.currentTarget);
			
			cube=myCube
			// Creation d'une instance de requête
            var query:IOLAPQuery=getQuery(cube);
            // Execute la requête
            var token:AsyncToken = cube.execute(query);
            // Ajoute les handlers pour le resultat
            token.addResponder(new AsyncResponder(showResult, showFault));
        }
        
	   /** HANDLER ERREUR
		 * 
		 **/
        private function showFault(error:ErrorMessage, token:Object):void
        {
            trace(error.faultString);
        }

        /** HANDLER OK
		 * 
		 **/
        private function showResult(result:Object, token:Object):void 
        {
            if (!result) {
                trace("No results from query.");
                return;
            }
            this.myOlapADG.dataProvider= result as OLAPResult;  
            myOlapChartVisu.result=   result as OLAPResult;      
         }
         
        private function myStyleFunc(row:IOLAPAxisPosition, column:IOLAPAxisPosition,value:Number):Object 
        {
        	var rowMember:OLAPMember=row.members[0] as OLAPMember
        	var colMember:OLAPMember=column.members[0] as OLAPMember
        	
        	if (rowMember.name=='(All)')            
            return {color:0xff0000,fontWeight:"bold"}; 
            
            if (colMember.name=='(All)')            
            return {color:0xff0000,fontWeight:"bold"}; 
                
            return null;      
        }     
		
	}
}