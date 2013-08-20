package HierachicalADG.renderer
{
	import HierachicalADG.HierachicalADG;
	import HierachicalADG.controls.IconComboBox;
	import HierachicalADG.event.FilterEvent;
	
	import com.fnicollet.datafilter.filter.DataFilterParameters;
	import com.fnicollet.datafilter.filter.DataFilterSingleValueOperator;
	import com.fnicollet.datafilter.filter.DataFilterType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.ComboBox;
	import mx.controls.List;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
	import mx.controls.listClasses.BaseListData;
	import mx.events.DropdownEvent;
	import mx.events.ListEvent;
	import mx.events.ResizeEvent;
	
	public class HierarchicalColumnHeaderRenderer extends AdvancedDataGridHeaderRenderer
	{
		
		protected var comboBox:IconComboBox;
		private var adg:AdvancedDataGrid;
		private var adgCol:AdvancedDataGridColumn;
		
		[Embed(source="../assets/icon_filter.png")]
		private var ico_filter:Class;
		
		public function HierarchicalColumnHeaderRenderer()
		{
			super();        
            setStyle("verticalAlign","bottom");
            setStyle("horizontalAlign","center");  
		}

		override protected function createChildren():void
		{        
            super.createChildren();
            doubleClickEnabled = false;

            if(!comboBox){
                comboBox = new IconComboBox()  // ComboBox()
				comboBox.iconFunction = myIconFunction;
                comboBox.addEventListener(MouseEvent.MOUSE_DOWN, stopPropagationHandler);
                comboBox.addEventListener(DropdownEvent.OPEN,onOpenDropDown)
                comboBox.addEventListener(DropdownEvent.CLOSE,onCloseDropDown)
				comboBox.addEventListener(ResizeEvent.RESIZE, updateListWidth);
                comboBox.doubleClickEnabled = false;
                //comboBox.iconFunction = myIconFunction;
                comboBox.setStyle("cornerRadius", 0);           
                comboBox.addEventListener(ListEvent.CHANGE,comboBoxChangeHandler);
                addChild(comboBox);
            }
                    
        }
        
		private function myIconFunction(item:Object):Class 
		{                
			if(comboBox.selectedItem == item){                 
				return ico_filter;                
			}
			return null;
		}

		
        private function onCloseDropDown(event:DropdownEvent):void 
        {
         	comboBox.dropdown.removeEventListener(MouseEvent.ROLL_OUT,closeDropDownList);
        }
        
        private function onOpenDropDown(event:DropdownEvent):void 
        {
         	comboBox.dropdown.addEventListener(MouseEvent.ROLL_OUT,closeDropDownList);
        }
        
         private function closeDropDownList(event:MouseEvent):void 
         {	
         	comboBox.close()
         }
        
         private function comboBoxChangeHandler(event:ListEvent):void 
         {  
         	//construct DataFilterParameters and dispatchevent      
            var _filtParam:DataFilterParameters=new DataFilterParameters;
	        _filtParam.filterType=DataFilterType.SINGLE_VALUE;
	        _filtParam.filterKeys=adgCol.headerText;
	        _filtParam.filterOperator=DataFilterSingleValueOperator.EQUALS_TO;
	        _filtParam.filterValues=comboBox.selectedItem
	        _filtParam.filterJokers="All";
	        _filtParam.invert=false;
			
	        this.dispatchEvent(new FilterEvent('SetDataFilterParameters',true,true,_filtParam))
        }
		
		 private function updateListWidth(event:ResizeEvent):void 
		 {
			 if (comboBox.dropdown!=null){
				var ddWidth:int = comboBox.dropdown.measureWidthOfItems(-1,comboBox.dataProvider.length);
				ddWidth +=16   //add for scrollbar width (16 pixel is standard)
				comboBox.dropdown.width =Math.max(ddWidth,comboBox.width);
			 }
		 }

        
        //stop propagation du mouse_down sinon entraine un sort,un refresh du datagrid et donc un close du dropdown.
        protected function stopPropagationHandler(event:Event):void
        {
       		event.stopPropagation();
        }
		
        override public function set listData(value:BaseListData):void 
        {            
            super.listData = value;            
            adg = value.owner as AdvancedDataGrid;
        }
     
     
         override public function set data(value:Object):void 
         {            
            super.data = value;
			var str:String
			var mySource:ArrayCollection=(adg.parent as HierachicalADG).ADGSource;
			var myfilters:Array=(adg.parent as HierachicalADG).arrFilters as Array;
            adgCol=data as AdvancedDataGridColumn
				
			if (mySource!=null && adgCol!=null){
				if (comboBox.selectedItem==null){
					str="All"
				}else{
					str=String(comboBox.selectedItem)
				}			
            	comboBox.dataProvider=getUniqueValues(mySource.source,adgCol)
				comboBox.selectedItem=str;
            	/*for each(var filterParam:DataFilterParameters in myfilters){
	   				if (filterParam.filterKeys[0]==adgCol.headerText){
	   					comboBox.selectedItem=filterParam.filterValues
	   				}
	   			} */          	
   			}
	
		}
		
		
		
		 /**
         * @protected
         */
        override protected function measure():void {        
            super.measure(); 
            if(comboBox.visible){
                measuredHeight = measuredHeight + comboBox.getExplicitOrMeasuredHeight();
            }   
                             
        }
        
        /**
         * @protected
         */
        override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void{        
            super.updateDisplayList(unscaledWidth, unscaledHeight);         
            comboBox.setActualSize(unscaledWidth,comboBox.getExplicitOrMeasuredHeight()); 
        }

		
		
		private function getUniqueValues(dataSource:Array,adgColumn:AdvancedDataGridColumn):Array
		{
			var dic:Dictionary = new Dictionary();
		 	var value : Object;
		 
		 	for each(var obj:Object in dataSource){
		 			value =obj[adgColumn.headerText]
		 			if (value is Date){
		 				dic[value.toString()] = value.toString()
		 			} else {
		 				dic[value] = value;	
		 			}
		 	}
		 
		    var unique:Array = new Array();
		    for(var prop :String in dic){
		    	unique.push(dic[prop]);
		    }
		    
		    //SORT
			unique.sort();
			//Add the joker value 'All'
		    unique.unshift('All');
		    
		    return unique;
		}
	}
}
