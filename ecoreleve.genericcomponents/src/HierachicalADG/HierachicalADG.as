package HierachicalADG
{
	import HierachicalADG.controls.AutoResizableADG;
	import HierachicalADG.editors.GroupingEditor;
	import HierachicalADG.editors.ShowHideColumnsEditor;
	import HierachicalADG.event.FilterEvent;
	import HierachicalADG.renderer.HierarchicalColumnHeaderRenderer;
	import HierachicalADG.renderer.HierarchicalSortItemRenderer;
	import HierachicalADG.utils.DataGridUtil;
	
	import com.fnicollet.datafilter.filter.DataFilterParameters;
	import com.fnicollet.datafilter.filter.DataFilterSet;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.*;
	import mx.collections.ArrayCollection;
	import mx.collections.Grouping;
	import mx.collections.GroupingCollection;
	import mx.collections.GroupingField;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridRendererProvider;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.mx_internal;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.CollectionEvent;
	import mx.events.ListEvent;
	
	public class HierachicalADG extends VBox
	{
		private var groupingCollection:GroupingCollection
		private var columnsArray:Array
        private var grouping:Grouping
        private var adg:AdvancedDataGrid
        private var _GrpRenderer:IFactory;
        private var _arrFilters:Array=new Array();
        
        [Bindable]
        [Embed(source="assets/icon-grouping.png")]
        private var ico_grouping:Class;
		[Bindable]
		[Embed(source="assets/icon-column.png")]
        private var ico_column:Class;
        [Bindable]
		[Embed(source="assets/icon-reset-filter.png")]
        private var ico_filter:Class;
		[Bindable]
        [Embed(source="assets/icon-expandAll.png")]
        private var ico_expand:Class;
        [Bindable]
        [Embed(source="assets/icon-collapseAll.png")]
        private var ico_collapse:Class;
		[Bindable]
		[Embed(source="assets/icon-copy.png")]
		private var ico_copy:Class;
        
        //CONTROLS
        private var btnCollapse:Button=new Button;
		private var btnExpand:Button=new Button;
		private var btnResetFilter:Button=new Button;
		private var btnClip:Button=new Button;
        //EDITORS
        private var columnEditor:ShowHideColumnsEditor=new ShowHideColumnsEditor;
        private var groupingEditor:GroupingEditor=new GroupingEditor;
        //COMPTEUR DE DONNEES
        private var totLabel:Label=new Label;
        
        [Inspectable(category="General", type="Array", defaultValue="[]")]
		private var _colToUse:Array;
		private var colToUseChanged : Boolean = false;
        
        [Inspectable(category="General", type="ArrayCollection", defaultValue="null")]
		private var _ADGSource:ArrayCollection;
		private var ADGSourceChanged : Boolean = false;
		
		
		public function get arrFilters():Array
		{
			return _arrFilters;
		}
		
        [Bindable]
		public function get GrpRenderer() :IFactory
		{
			return _GrpRenderer;
		}
		
		public function set GrpRenderer(value:IFactory) : void 
		{
			_GrpRenderer=value
			this.invalidateProperties();
		} 
        
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
		
		[Bindable]
		public function get ADG():AdvancedDataGrid
		{
			return adg;
		}
		
		public function set ADG(value:AdvancedDataGrid) : void 
		{
			adg=value
			this.invalidateProperties();
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
		       		
		public function HierachicalADG()
		{
			super();
		}

		/** CONSTRUCTEUR
		 *  
		**/
		override protected function createChildren():void 
		{
			super.createChildren();
			
			
			var hb:HBox=new HBox;
			hb.setStyle('horizontalAlign','middle')
			hb.percentWidth=100
			
			//AJOUTE LES BOUTONS COLLAPSE et EXPAND
			btnCollapse.toolTip='collapse all'
			btnCollapse.setStyle('icon',ico_collapse)
			btnCollapse.setStyle('skin',null)
			btnCollapse.visible=false
			btnCollapse.useHandCursor=true
			btnCollapse.buttonMode=true
			btnCollapse.mouseChildren=false
			btnCollapse.addEventListener(MouseEvent.CLICK,CollapseADG)
			
			
			btnExpand.toolTip='expand all'
			btnExpand.setStyle('icon',ico_expand)
			btnExpand.setStyle('skin',null)
			btnExpand.visible=false
			btnExpand.useHandCursor=true
			btnExpand.buttonMode=true
			btnExpand.mouseChildren=false
			btnExpand.addEventListener(MouseEvent.CLICK,ExpandADG)
			
			//AJOUTE LE BOUTON RESET ALL FILTERS
			btnResetFilter.toolTip='reset all filter'
			btnResetFilter.setStyle('icon',ico_filter)
			btnResetFilter.setStyle('skin',null)
			btnResetFilter.visible=true
			btnResetFilter.useHandCursor=true
			btnResetFilter.buttonMode=true
			btnResetFilter.mouseChildren=false
			btnResetFilter.addEventListener(MouseEvent.CLICK,ResetAllFilters)
			
			//AJOUTE LES EDITORS (SHOW/HIDE et GROUPING)			
			groupingEditor.addEventListener('SetGroupingEvent',processGrouping);
			groupingEditor.label='Set grouping'
			groupingEditor.setStyle('skin', null);
            groupingEditor.setStyle('upSkin', null);
            groupingEditor.setStyle('icon',ico_grouping);
            
            columnEditor.addEventListener('SetChangeVisibilityEvent',changeVisibility);
			columnEditor.setStyle('skin', null);
			columnEditor.setStyle('icon', ico_column);
			
			//COMPETEUR DE DONNEES
			totLabel.setStyle('textAlign','right');
			totLabel.setStyle('fontWeight','bold');
			totLabel.setStyle('fontSize',14);
		
			//copy to clipboard
			btnClip.enabled=false;
			btnClip.toolTip="copy selection to clipboard";
			btnClip.setStyle('icon',ico_copy)
			btnClip.setStyle('skin',null)
			btnClip.useHandCursor=true
			btnClip.buttonMode=true
			btnClip.mouseChildren=false
			btnClip.addEventListener(MouseEvent.CLICK,copyToClipboardClickHandler)
			
			hb.addChild(totLabel)
			hb.addChild(btnClip)
			hb.addChild(columnEditor)
			hb.addChild(btnResetFilter)
			hb.addChild(groupingEditor)	
			hb.addChild(btnCollapse)			
			hb.addChild(btnExpand)	
			

			this.addChild(hb)			
			
			
			//AJOUTE LE DATAGRID
			adg=new AutoResizableADG;
			adg.styleName="HierarchicalADG"
			adg.selectionMode="multipleRows"
			adg.addEventListener(KeyboardEvent.KEY_DOWN,KeyShortcutHandler);
				
			//adg.addEventListener('SetDataFilterParameters',processFiltering)
			adg.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChangeEvent);
			adg.sortItemRenderer=new ClassFactory(HierarchicalSortItemRenderer);
			adg.addEventListener(ListEvent.CHANGE,adgChangeHandler);
			adg.addEventListener(AdvancedDataGridEvent.HEADER_RELEASE,ClickColHeaderHandler)
				
            var datagridColumn:AdvancedDataGridColumn=new AdvancedDataGridColumn()
	
			adg.percentHeight=100
			adg.width=this.parentApplication.width
			//adg.percentWidth=100			
			
			this.addChild(adg)
		
		}
		
		private function adgChangeHandler(event:ListEvent):void
		{
			if (adg.selectedItem!=-1){
				btnClip.enabled=false;
			}else {
				btnClip.enabled=true;
			}
		}
		
		private function KeyShortcutHandler(event:KeyboardEvent):void
		{
			if(event.ctrlKey && event.keyCode == 65){				//CTL A
				//select all item
				var arrIdx:Array=new Array
				for (var i:uint=0;i<_ADGSource.length;i++){
					arrIdx.push(i)
				}
				adg.selectedIndices=arrIdx;
				
			}else if(event.ctrlKey && event.keyCode == 67){			//CTL C
				//copy selected item to clipboard
				DataGridUtil.exportADGToClipboard(adg,false,true)
			}				
		}
		
		private function copyToClipboardClickHandler(event:MouseEvent):void
		{
			if (adg.selectedItems.length>0){
				DataGridUtil.exportADGToClipboard(adg,false,true)
			}
		}
		
		private function ClickColHeaderHandler(event:AdvancedDataGridEvent):void
		{
			
			if (event.columnIndex==0){
				//select all item
				var arrIdx:Array=new Array
				for (var i:uint=0;i<_ADGSource.length;i++){
					arrIdx.push(i)
				}
				adg.selectedIndices=arrIdx;
				event.stopImmediatePropagation();
			}
		}
		
		private function changeVisibility(evt:ListEvent=null):void 
		{
			//créer un tableau avec les colonnes visibles
            var arrVisibleColumns:Array=new Array()
            for each(var dg:AdvancedDataGridColumn in columnsArray){
            	if (dg.visible==true){
            		arrVisibleColumns.push(dg)
            	}
            }
                             
            groupingEditor.columns=new ArrayCollection(arrVisibleColumns)
		}
		
		public function refreshADG():void
		{
			//refresh groupingCollection si il n'est pas nulle
			if (groupingCollection!=null){
				groupingCollection.refresh()
			}
			
			//refresh le compteur
			if (_ADGSource!=null){
				totLabel.text=String(_ADGSource.length) + " station(s)";
			}
		}
		
		private function processFiltering(event:FilterEvent):void 
		{	
			//this.dispatchEvent(new FilterEvent('SetDataFilterParameters',true,true,event.data as DataFilterParameters))
			/*var _dataFilter:DataFilterSet=new DataFilterSet;
			
			//si le FilterEvent est nulle ==> reset all filters
			if (event.data==null){
				//passe tous les filtres actif à "All"
				for(var i:int;i< _arrFilters.length;i++){
		   			_arrFilters[i].filterValues="All"
		   		}
			}else {
					
				var filterParam:DataFilterParameters=event.data as DataFilterParameters
	
				//supprime le filtre si il existe dejà pour cette colonne
				for(var j:int;j< _arrFilters.length;j++){
		   				if (_arrFilters[j].filterKeys[0]==filterParam.filterKeys[0]){
		   					_arrFilters.splice(j,1);
		   				}
		   			}
				
				_arrFilters.push(filterParam)
	
			}
			
			_dataFilter.data=_ADGSource;
			_dataFilter.dataFilterParameters=_arrFilters;
			
			
			//refresh groupingCollection si il n'est pas nulle
			if (groupingCollection!=null){
            	groupingCollection.refresh()
   			}
			
			//refresh le compteur
   			if (_ADGSource!=null){
		  		totLabel.text=String(_ADGSource.length) + " station(s)";
		  	}
			
			//envoit un event pour dir qu'un filtre à eu lieu
			this.dispatchEvent(new Event('dataFiltered',true))
			*/
		}
		
		private function processGrouping(evt:Event=null):void 
		{            
            //si il y a un grouping alors on applique les renderer sinon on enlève les renderer
            if (groupingEditor.grouping.fields.length>0){
            	
            	groupingCollection=new GroupingCollection()
				groupingCollection.source=_ADGSource    
	            groupingCollection.grouping=groupingEditor.grouping
	        	
				//deplace la premiere colonne du grouping en position 1					
				var i:uint;
				var len:uint=adg.columns.length
				var oldIndex:uint;
				var firstGroupingFieldName:String=(groupingCollection.grouping.fields[0] as GroupingField).name
				for (i;i<len;i++){
					var strHeader:String=(adg.columns[i] as AdvancedDataGridColumn).headerText
					if (firstGroupingFieldName==strHeader){
						oldIndex=i;
					}
				}
				
				adg.mx_internal::shiftColumns(oldIndex,0)
					
	        	//applique le grouping             
	            adg.dataProvider=groupingCollection
	            
	            //refresh grouping
	            groupingCollection.refresh()
            	           	
            	btnExpand.visible=true
            	btnCollapse.visible=true
            	
            	//var nbMax:int=groupingCollection.grouping.fields.length + 1
            	//applique le renderer à chaque colonne groupée
	           	//for(var i:int = 1; i < nbMax; i++){
	            //	AddRenderer(i)
	            //}
            }else{
            	btnExpand.visible=false
            	btnCollapse.visible=false
            	//adg.rendererProviders=new Array;
            	adg.dataProvider=_ADGSource
            }

            //refresh grouping
            groupingCollection.refresh()
            
            //modify le label of groupingEditor
            var _columnsGrouped:Array =new Array()
            _columnsGrouped=groupingEditor.selectedLabels;
            if(_columnsGrouped.length > 0 ){                
                groupingEditor.label = 'Grouped By: '+_columnsGrouped.join(',');
            } else {
            	groupingEditor.label ='Set grouping'
            }
            
		}		

		/** MAJ du ADGSource
		 *
		 **/
		private function MajADGDataSource():void 
		{
			columnsArray=new Array()
			
			adg.dataProvider=_ADGSource;	  		
			adg.sortExpertMode=true;
			
			
			var datagridColumn:AdvancedDataGridColumn;
				
			//ajoute une colonne avec row number
			datagridColumn=new AdvancedDataGridColumn();
			datagridColumn.headerText=" ";
			datagridColumn.styleFunction=styleCallback ;
			datagridColumn.width=30;	
			datagridColumn.labelFunction=fctRowNumber;
			columnsArray.push(datagridColumn);
			
	  		//création des colonnes (ne prends pas en compte la colonne mx_internal_uid)
            for (var col:String in _colToUse) 
            {
            	if (_colToUse[col]!= "mx_internal_uid") {
          		
					datagridColumn=new AdvancedDataGridColumn();
                	datagridColumn.dataField=_colToUse[col];
                	datagridColumn.showDataTips=false;
                	datagridColumn.styleFunction=styleCallback ;
                	datagridColumn.headerRenderer=new ClassFactory(HierarchicalColumnHeaderRenderer);
                	columnsArray.push(datagridColumn);                 	
             	}	
            }
                 
            adg.columns=columnsArray       
            columnEditor.columns=columnsArray
            groupingEditor.columns=new ArrayCollection(columnsArray)
				
		}

		private function handleChangeEvent(event:CollectionEvent):void
		{
			//refresh le compteur
   			if (_ADGSource!=null){
		  		totLabel.text=String(_ADGSource.length) + " station(s)";
		  	}
		}

		private function fctRowNumber(oItem:Object,iCol:int):String
		{
			var iIndex:int = _ADGSource.getItemIndex(oItem) + 1;
			return String(iIndex);
		}

		
		//le style d'une colonne utilise un callback ==> pas encore trouvé comment récupérer le CSS à ce niveau
        private function styleCallback(data:Object, col:AdvancedDataGridColumn):Object
	    {
            return {fontSize: 12,fontFamily: "Arial",fontColor:"Black"};     	    
	    }

		
		private function AddRenderer(nbDepth:Number):void
        {
        	 var rp : AdvancedDataGridRendererProvider = new AdvancedDataGridRendererProvider();
             rp.renderer = GrpRenderer;
             rp.columnIndex = 0;
           
             rp.columnSpan= adg.columns.length;
             rp.depth = nbDepth;
             
	         adg.rendererProviders.push(rp);
	         
             adg.validateNow();
        }
		
        private function ResetAllFilters(e:MouseEvent):void
		{
			adg.dispatchEvent(new FilterEvent('SetDataFilterParameters',true,false,null))
		}  
		private function CollapseADG(e:MouseEvent):void
		{
			adg.collapseAll()
		}
		
		private function ExpandADG(e:MouseEvent):void
		{
			adg.expandAll()
		}
		
	}
}