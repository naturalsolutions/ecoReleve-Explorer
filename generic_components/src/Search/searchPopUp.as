package Search
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.*;
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	
	[Event(name="onSearch", type="flash.events.Event")]
	[Event(name="onSelect", type="flash.events.Event")]
	[Event(name="onUnSelect", type="flash.events.Event")]
	public class searchPopUp extends TextInput
	{
		private var myText:TextInput;
		private var dg:DataGrid;
		private var lblBackText:Label;
		private var myIcon:Image;
		private var myLkButton:LinkButton;
		private var boIsfirstRow:Boolean=false;

		private var objTextInput:DisplayObject;
		private var defaultStyleName:String="styleGrdSearchPopUp";
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var _LogoSource : String = '';
		
		[Inspectable(category="General", type="ArrayCollection", defaultValue="null")]
		private var _PopUpSource:ArrayCollection;
		private var PopUpSourceChanged : Boolean = false;
		
		[Inspectable(category="General", type="String", defaultValue="")]
		private var  _strBackLabelText:String;
		private var strBackLabelTextChanged: Boolean = false;
		
		[Inspectable(category="General", type="String", defaultValue="auto")]
		private var  _strMode:String="auto";
		
		[Inspectable(category="General", type="Object", defaultValue="null")]
		public var _SelectedItem:Object;
		
		[Inspectable(category="General", type="Array", defaultValue="null")]
		private var _ColToDisplay:Array;
		private var ColToDisplayChanged : Boolean = false;
		
		[Inspectable(category="General", type="Number", defaultValue="5")]
		private var _NbRowCount:Number=5;
		
		[Inspectable(category="General", type="Number", defaultValue="3")]
		private var _NbCaracSearch:Number=3;
 
		[Bindable]
		public function get LogoSource() : String 
		{
			return _LogoSource;
		}
		
		public function set LogoSource(str : String) : void 
		{
			_LogoSource=str
		}
		
		[Bindable]
		public function get PopUpSource() : ArrayCollection 
		{
			return _PopUpSource;
		}
		
		public function set PopUpSource(arrCol:ArrayCollection) : void 
		{
			_PopUpSource=arrCol
			PopUpSourceChanged=true;
			this.invalidateProperties();
		}
		
		[Bindable("selectedItemChanged")]
		public function get SelectedItem() : Object 
		{
			return _SelectedItem;
		}
		
		public function set SelectedItem(obj:Object) : void 
		{
			_SelectedItem=obj
			dispatchEvent(new Event("selectedItemChanged"));
		}
		
		[Bindable]
		public function get ColToDisplay() : Array 
		{
			return _ColToDisplay;
		}
		
		public function set ColToDisplay(arr:Array) : void 
		{
			_ColToDisplay=arr
			ColToDisplayChanged=true;
			this.invalidateProperties();
		}
		
		[Bindable]
		public function get NbRowCount() : Number 
		{
			return _NbRowCount;
		}
		
		public function set NbRowCount(value:Number) : void 
		{
			_NbRowCount=value
		}
		
		[Bindable]
		public function get NbCaracSearch() : Number 
		{
			return _NbCaracSearch;
		}
		
		public function set NbCaracSearch(value:Number) : void 
		{
			_NbCaracSearch=value
		}
		
		[Bindable]
		public function get defaultText():String 
		{
			return _strBackLabelText;
		}
		
		public function set defaultText(value:String) : void 
		{
			_strBackLabelText=value
			strBackLabelTextChanged=true;
			this.invalidateProperties();
		}
		
		[Bindable]
		public function get mode():String 
		{
			return _strMode;
		}
		
		public function set mode(value:String) : void 
		{
			_strMode=value
		}
		
		public function searchPopUp()
		{
			super();
			//selectionne le mode fonctionnement: auto( num caractère) ou manuel(touche enter)	
		}
		
		/** 
		 *  CONSTRUCTEUR
		**/
		override protected function createChildren():void 
		{
			super.createChildren();
			
    		//Background
    		//this.setStyle("backgroundColor","0xFF0000");
    		this.setStyle('backgroundAlpha', 0.0);
    		
    		//create label background msg
    		if (!lblBackText){
    			lblBackText=new Label()
	    		lblBackText.setStyle("fontColor","gray");
	    		lblBackText.setStyle("fontWeight","normal");
	    		lblBackText.setStyle("fontStyle ","italic");
				lblBackText.setStyle("fontSize",this.getStyle("fontSize"));
	    		this.addChild(lblBackText);
    		}
    	
    		//création de l'icon
    		if (!myIcon){
    			myIcon = new Image();
       		 	myIcon.source = _LogoSource;
        		this.addChild(DisplayObject(myIcon));
    		}
    		
    		//création du linkButton pour effacer le text
    		if (!myLkButton){
	    		myLkButton=new LinkButton();
	    		myLkButton.toolTip="Clear the text"
	    		myLkButton.label="x"
	    		myLkButton.visible=false
	    		myLkButton.useHandCursor=true
	    		myLkButton.addEventListener(MouseEvent.CLICK, onClickClearButton);
	    		this.addChild(myLkButton);    		
    		}
    		
    		//CREATE DATAGRID POUR LE POPUP
    		dg=new DataGrid;   		
    		dg.rowCount=_NbRowCount;
	    	            
 			dg.width=400;
 		  	
  			dg.sortableColumns=false;
  			dg.draggableColumns=false;
  			dg.resizableColumns=false;
  			dg.styleName=defaultStyleName;
  			dg.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,onMoveOutsidePopUp);
  			

  			//detecte la selection d'un element dans le datagrid
  			dg.addEventListener("click", handleDgClickEvent);
  			//detecte les touche clavier sur le datagrid
  			dg.addEventListener(KeyboardEvent.KEY_DOWN, dgKeyboardHandler);
  			
  			//detecte les changement dans le text de recherche
			this.addEventListener("change", handleChangeEvent);
			//detecte la touche enter du textbox
  			this.addEventListener(KeyboardEvent.KEY_DOWN, textKeyboardHandler);
  				
		}    				
		
		override protected function commitProperties():void
		{
		 	super.commitProperties();
		 	//modifie le text du label background dès que la source change
		 	if(strBackLabelTextChanged == true){
		  		lblBackText.text=_strBackLabelText
		  		strBackLabelTextChanged = false;
		  	}		 	
		 	//modifie la source du datagrid du popup dès que la source change
		 	if(PopUpSourceChanged == true){
		  		dg.dataProvider=_PopUpSource;
		  		PopUpSourceChanged = false;
		  	}
		  	//création des colonnes définit par l'utilisateur dès que la définition des colonnes à afficher change
		  	if(ColToDisplayChanged==true){
	    		var arrCols:Array = new Array();
		  		for each ( var strCol:String in _ColToDisplay )
	 			{
	 				var dgCol:DataGridColumn = new DataGridColumn();
	            	dgCol.dataField = strCol;
	            	dgCol.headerText=strCol;
		    		arrCols.push( dgCol );
	 			}
				dg.columns = arrCols;
		  		ColToDisplayChanged=false;
		  	}
		}
		
		//Overrides focusInHandler to colorize background on focusIn events
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler( event );
 
			this.setStyle('backgroundAlpha', 1.0);
		}
 
		//Overrides focusOutHandler to reset background on focusOut events
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler( event );
 
			this.setStyle('backgroundAlpha', (this.text=='')?0.0:1.0);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	    {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	
			var nbLarg:Number=Number(unscaledHeight-4);
			
			//passe le label au dernier plan(sous le textinput) et change sa taille (=textinput)
			this.setChildIndex(lblBackText,0)
			lblBackText.setActualSize(unscaledWidth -(nbLarg-4),unscaledHeight)
			lblBackText.move(nbLarg + 4,2)

			//place l'icon et ajuste sa taille
			myIcon.setActualSize(nbLarg,nbLarg)
			myIcon.move(2,2)
			
			//place le linkbutton(clear text) et ajuste sa taille	
			myLkButton.setActualSize(nbLarg + 4,nbLarg)
			myLkButton.move(unscaledWidth-(nbLarg + 6),2)
				
			//change la position et la taille du contenu textuelle du textinput
			this.textField.move(nbLarg + 2,2)
			this.textField.width=unscaledWidth-(2*nbLarg)-4
	    }
		
		private function onClickClearButton(event:Event):void
		{
			this.text=''
			myLkButton.visible=false
			this.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
			this.dispatchEvent(new Event("onUnSelect",true));
		}
		
		/** NAVIGATION AU CLAVIER DANS LE TEXTBOX DE RECHERCHE
		**/
		private function textKeyboardHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				this.dispatchEvent(new Event("onSearch",true));
				AddPopUp()				
			}
			if (event.keyCode == Keyboard.DOWN)
			{
				dg.setFocus()
				boIsfirstRow=true
				dg.selectedIndex=0
				dg.scrollToIndex(0)
			}
		}
		
		/** NAVIGATION AU CLAVIER DANS LE DATAGRID
		**/	
		private function dgKeyboardHandler(event:KeyboardEvent):void
		{	
			if (boIsfirstRow==true && event.keyCode==Keyboard.UP){
				if (_strMode=="manuel"){
					ClosePopUp()
				}
				this.setFocus()
				this.setSelection(this.length+1,this.length+1)
			}
			
			if (event.keyCode == Keyboard.UP)
			{
				if (dg.selectedIndex==0){
					boIsfirstRow=true
				} else {
					boIsfirstRow=false
				}
			}
			
			if (event.keyCode == Keyboard.DOWN)
			{
				if (dg.selectedIndex==0){
					boIsfirstRow=true
				} else {
					boIsfirstRow=false
				}
			}
	
			if (event.keyCode == Keyboard.SPACE)
			{
				dg.dispatchEvent(new MouseEvent("click",true))
			}
		}
		
		/** CAPTURE LES CHANGEMENTS DANS LE TEXTBOX
		 **/
		private function handleChangeEvent(event:Event):void
		{
			objTextInput = event.target as DisplayObject;
			
			//si le text est vide alors on masque le linkbutton sinon on l'affiche
			myLkButton.visible=((this.text=='')?false:true)
			
			if (_strMode=="auto"){			
				if (this.length==0){
					this.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
					this.dispatchEvent(new Event("onUnSelect",true));
				}else if (this.length==1){
					this.setStyle('backgroundAlpha', 1.0);
	        		this.text=this.text.charAt(0).toUpperCase();
	        	} else if (this.length>=_NbCaracSearch){
					//dispatch l'evenement de recherche
					this.dispatchEvent(new Event("onSearch",true));
					AddPopUp()
	            } else {
	            	ClosePopUp();
	            	this.dispatchEvent(new Event("onUnSelect",true));
	            } 
  			 }
		}
		
		/** CAPTURE LE CLICK DANS LE DATAGRID
		 **/
		private function handleDgClickEvent(event:MouseEvent):void
		{
			//complete le textInput avec le text selectionné de la première colonne
			this.text=dg.selectedItem[dg.columns[0].dataField];
			_SelectedItem=dg.selectedItem as Object;
			ClosePopUp()
			this.dispatchEvent(new Event("onSelect",true));
		}
		
		private function AddPopUp():void
		{
			PopUpManager.addPopUp(dg,this,false); 
			
			var pt:Point = new Point(this.x, this.y);
			var pt_global:Point = this.parent.localToGlobal(pt);
		
			dg.move(pt_global.x,pt_global.y + this.height)
						
		}
		
		private function ClosePopUp():void
		{
			if (dg){
				PopUpManager.removePopUp(dg);
				dg.dataProvider=null	
			}			
		}
		
		private function onMoveOutsidePopUp(event:Event):void
		{
			ClosePopUp()
		}
	}
}