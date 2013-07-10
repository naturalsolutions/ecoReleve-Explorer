package com.ecoReleve.view.renderer
{
	import com.ecoReleve.view.events.ColorToClassEvent;
	
	import flash.geom.ColorTransform;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.ColorPicker;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridGroupItemRenderer;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.events.ColorPickerEvent;

	public class MyCustomGroupRenderer extends AdvancedDataGridGroupItemRenderer 
	{
	    private var _listData:AdvancedDataGridListData;
		private var _listDataChanged:Boolean;
		
	
	    public function MyCustomGroupRenderer()
	    {
	        super();
	    }
		
		// OVERRIDE ******************************************************
		
        override protected function createChildren():void 
        {
        	super.createChildren();
         }
		
	    override public function set listData(value:BaseListData):void 
	    {
	        super.listData = value;
	        if (value) {
	            _listData = value as AdvancedDataGridListData;            
				
				_listDataChanged=true
	            
	            invalidateProperties();
	     	}
	    }
		
		override protected function commitProperties():void 
		{
  			super.commitProperties();
  			
  			//si il s'agit d'un niveau de regroupement
			if (_listData.hasChildren==true && _listDataChanged==true){
	            
	            //ajoute le nombre de stations au label 
				_listData.label=_listData.label + " (" + String(_listData.item.children.length) + ")"
			
				//la taille décroit avec la profondeur de la hierarchie
				var strSize:String=String(18 - (_listData.depth*2))
			
				setStyle('fontWeight', 'bold');
				setStyle('color', 'blue');
            	setStyle('fontSize', strSize);
            	
            	_listDataChanged=false;		            	
			}        		
  		}		
   
	    override public function get listData() : BaseListData
	    {	
			return _listData;
		}	
		    
	}
}