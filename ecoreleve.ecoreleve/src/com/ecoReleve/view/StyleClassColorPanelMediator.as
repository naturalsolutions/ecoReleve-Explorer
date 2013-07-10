package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.DataProxy;
	import com.ecoReleve.model.StationEnhanceProxy;
	import com.ecoReleve.model.VO.ClassColorVO;
	import com.ecoReleve.view.events.ClassEvent;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.StyleClassColorPanel;
	
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.IndexChangedEvent;
	import mx.events.PropertyChangeEvent;
	
	import org.ns.common.model.utils.StationVOCast;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	public class StyleClassColorPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "StyleClassColorPanelMediator";	
		private var _dataProxy:StationEnhanceProxy;
		private var boAmIAsk:Boolean=false;
		
		public function StyleClassColorPanelMediator(viewComponent:StyleClassColorPanel)
		{
			super(NAME, viewComponent);
		} 
		 
		override public function onRegister():void
		{
			super.onRegister();
			classcolorpanel.addEventListener(StyleClassColorPanel.ATTRIBUTE_SELECTED,onSelectAttribute)
			classcolorpanel.addEventListener('createList',createListHandler)
			
			//récupération du proxy
			_dataProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy;
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.DECONNEXION_NOTIFICATION,
					NotificationConstants.STATION_COLOR_CHANGED_NOTIFICATION,
					NotificationConstants.STATION_LAYER_MODE_NOTIFICATION,
					NotificationConstants.ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION,
					NotificationConstants.STATIONS_ADDED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.DECONNEXION_NOTIFICATION:
					 classcolorpanel.boEnabled=false;
					 break;
				case NotificationConstants.STATION_COLOR_CHANGED_NOTIFICATION:
					 if (classcolorpanel.cmbField!=null){
					 	classcolorpanel.cmbField.selectedItem="NONE"
					 }
					 if (classcolorpanel.classes!=null){
					 	classcolorpanel.classes.removeAll();
						classcolorpanel.classes.refresh();
					 }
					 break;
				case NotificationConstants.ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION:
					if (boAmIAsk==true){
						createClassColor(note.getBody() as ArrayCollection)
					}
					break;
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:	
					if ((note.getBody() as ArrayCollection).length==0){
						classcolorpanel.boEnabled=false;
					}else{
						populateAttributeCombobox();			
						classcolorpanel.boEnabled=true;
					}
					break;
				case NotificationConstants.STATION_LAYER_MODE_NOTIFICATION:
					if (note.getBody()==DisplayMapMediator.MODE_CLUSTER){
						classcolorpanel.boEnabled=false;
					}else{
						classcolorpanel.boEnabled=true;
					}
					break;
			}
		}	
		
		private function attributeChangeHandler(event:CollectionEvent):void
		{
			switch (event.kind) 
			{		
				case CollectionEventKind.UPDATE:
					for (var i:uint = 0; i < event.items.length; i++) {
						if (event.items[i] is PropertyChangeEvent) {
							if (PropertyChangeEvent(event.items[i]) != null) {
								sendNotification(NotificationConstants.STATION_CLASS_CHANGED_NOTIFICATION,event.items[i].source as ClassColorVO,"class")
							}
						}
					}
					break;
			}
		}
		
		
		/** Remplit le combobox avec la liste d'attribut
		 * 
		 **/
		private function populateAttributeCombobox():void
		{
			var fieldClassArray:Array=_dataProxy.getListField("class");
			//fix bug combobox dataprovider update on flex sdk 3.5
			classcolorpanel.fieldArrCol.removeAll();
			classcolorpanel.fieldArrCol.addAll(new ArrayCollection(fieldClassArray));
		}
	  
	  	private function onSelectAttribute(event:Event):void
	  	{
	  		//récupère le nom de l'attribut selectionné
			var strSelAttribute:String=classcolorpanel.cmbField.selectedItem.toString();
			
	  		if (strSelAttribute!="NONE"){
				boAmIAsk=true
				sendNotification(NotificationConstants.SELECT_ATTRIBUTE_NOTIFICATION,strSelAttribute,'uniqueValue')
	  			
	  		} else {
				boAmIAsk=false
	  			classcolorpanel.classes.removeAll();
	  			classcolorpanel.lstClass.enabled=false;
	  			//send notification
	  			sendNotification(NotificationConstants.STATION_CLASS_UNSELECT_NOTIFICATION,"classes")
	  		}
	  		
	  	}
	  
		private function createClassColor(data:ArrayCollection):void
		{
			boAmIAsk=false
			
			//récupère le nom de l'attribut selectionné
			var strSelAttribute:String=classcolorpanel.cmbField.selectedItem.toString();
			
			classcolorpanel.lstClass.enabled=true 
			classcolorpanel.classes.removeAll();
			
			var length:Number=data.length
			var i:uint=0;	  			
			for(i;i<length;i++){
				var classColor:ClassColorVO=new ClassColorVO;
				classColor.field=classcolorpanel.cmbField.selectedItem.toString();
				classColor.value=(data[i] as Object)[strSelAttribute]
				classColor.color=RandomColor(i+1,length)
				classcolorpanel.classes.addItem(classColor)	
		}		
			
			//send notification
			sendNotification(NotificationConstants.STATION_CLASS_CHANGED_NOTIFICATION,classcolorpanel.classes,"classes")	
		}
		
		private function createListHandler(event:Event):void
		{
			classcolorpanel.lstClass.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,attributeChangeHandler)	
		}
		
		private function RandomColor(nbClass:Number,nbTotClass:Number):uint 
		{
			var h:Number=(360/nbTotClass*nbClass)
			
			var obj:Object = hsbtorgb(h, 100, 100);
			
			var ct:ColorTransform = new ColorTransform(1,1,1,1,obj.red,obj.green,obj.blue);
			
			return ct.color;
		}
		
		/**
		 * CONVERT COLOR FORM HSV to RGB
		 * @ Param h hue (Hue) number that indicates (to 360-0)
		 * @ Param s the saturation (Saturation) shows the number (0 to 100)
		 * @ Param v lightness (Value) indicates the number (0 to 100)
		 * @ Return RGB values into an array of [R, G, B]
		 **/
		public static function hsbtorgb(hue:Number,saturation:Number,brightness:Number):Object
		{
			var red:Number
			var green:Number
			var blue:Number
			hue%=360;
			if(brightness==0)
			{
				return {red:0, green:0, blue:0}
			}
			saturation/=100;
			brightness/=100;
			hue/=60;
			var i:Number = Math.floor(hue);
			var f:Number = hue-i;
			var p:Number = brightness*(1-saturation);
			var q:Number = brightness*(1-(saturation*f));
			var t:Number = brightness*(1-(saturation*(1-f)));
			switch(i)
			{
				case 0:			
					red=brightness; green=t; blue=p;
					break;			
				case 1:			
					red=q; green=brightness; blue=p;
					break;				
				case 2:		
					red=p; green=brightness; blue=t;
					break;			
				case 3:		
					red=p; green=q; blue=brightness;
					break;				
				case 4:			
					red=t; green=p; blue=brightness;
					break;				
				case 5:			
					red=brightness; green=p; blue=q;
					break;
			}
			red=Math.round(red*255)
			green=Math.round(green*255)
			blue=Math.round(blue*255)
			return {red:red, green:green, blue:blue}
		}
 
        protected function get classcolorpanel():StyleClassColorPanel
        {
            return viewComponent as StyleClassColorPanel;
        }
		

		
	}
}