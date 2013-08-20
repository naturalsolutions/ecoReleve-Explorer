package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.DataProxy;
	import com.ecoReleve.model.StationEnhanceProxy;
	import com.ecoReleve.view.events.ClassEvent;
	import com.ecoReleve.view.mycomponents.ribbon.MapPanel.ProportionalSizePanel;
	
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.utils.StationVOCast;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	public class ProportionalSizePanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "ProportionalSizePanelMediator";	

		private var _dataProxy:StationEnhanceProxy;
		private var _MinValue:Number = new Number;
		private var _MaxValue:Number = new Number;
		
		public function ProportionalSizePanelMediator(viewComponent:ProportionalSizePanel)
		{
			super(NAME, viewComponent);
		} 
		 
		override public function onRegister():void
		{
			super.onRegister();
			
			proportionalsizepanel.addEventListener(ProportionalSizePanel.SIZE_CHANGED,onchangeSize)
			proportionalsizepanel.addEventListener(ProportionalSizePanel.ATTRIBUTE_SELECTED,onSelectAttribute)
			
			//récupération du proxy
			_dataProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy;
		
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATIONS_ADDED_NOTIFICATION,
					NotificationConstants.DECONNEXION_NOTIFICATION,
					NotificationConstants.STATION_LAYER_MODE_NOTIFICATION,
					NotificationConstants.ATTRIBUTE_MINMAX_ADDED_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION:	
					if ((note.getBody() as ArrayCollection).length==0){
						proportionalsizepanel.boEnabled=false;
					}else{
						populateAttributeCombobox();		
						proportionalsizepanel.boEnabled=true;
					}
					break;
				case NotificationConstants.DECONNEXION_NOTIFICATION:	
					proportionalsizepanel.boEnabled=false;			
					break;
				case NotificationConstants.ATTRIBUTE_MINMAX_ADDED_NOTIFICATION:	
					createMinMax(note.getBody() as ArrayCollection);			
					break;
				case NotificationConstants.STATION_LAYER_MODE_NOTIFICATION:
					if (note.getBody()==DisplayMapMediator.MODE_CLUSTER){
						proportionalsizepanel.boEnabled=false;
					}else{
						proportionalsizepanel.boEnabled=true;
					}
					break;
			}
		}	
			
		/** 
		 * Remplit le combobox avec la liste d'attribut
		 * 
		 **/
		private function populateAttributeCombobox():void
		{
			var fieldNumArray:Array=_dataProxy.getListField("ordonable")
			proportionalsizepanel.fieldArrCol=new ArrayCollection(fieldNumArray);
		}

		/** 
		 * Calcul le Min et Max de l'attribut selectionné
		 * 
		 **/
		private function onSelectAttribute(event:Event):void
		{
			//récupère le nom de l'attribut selectionné
			var strSelAttribute:String=proportionalsizepanel.cmbField.selectedItem.toString();
			var arr:Array
			
			if (strSelAttribute=="NONE"){
				//désactive le slider
				proportionalsizepanel.mySlide.enabled=false
				sendNotification(NotificationConstants.STATION_PROPORTIONALSIZE_UNSELECT_NOTIFICATION,"proportionalSize")
			}else {		
				sendNotification(NotificationConstants.SELECT_ATTRIBUTE_NOTIFICATION,strSelAttribute,'minMax')
					
			}
		}
		
		private function createMinMax(data:ArrayCollection):void
		{
			//récupère le nom de l'attribut selectionné
			var strSelAttribute:String=proportionalsizepanel.cmbField.selectedItem.toString();
			
			//active le slider
			proportionalsizepanel.mySlide.enabled=true
			proportionalsizepanel.mySlide.value=20;    //deafault size
			
			var arr:Array=new Array
			
			_MinValue=data[0].min
			_MaxValue=data[0].max
			arr.push(_MinValue)
			arr.push(_MaxValue)
			arr.push(strSelAttribute);    					//Attribute
			arr.push(proportionalsizepanel.mySlide.value);	//maxsize
			
			sendNotification(NotificationConstants.STATION_PROPORTIONALSIZE_CHANGED_NOTIFICATION,arr,"proportionalSize")
		}
		
		/** 
		 * Change la taille des points
		 * 
		 **/
		private function onchangeSize(event:Event):void
		{
			var strSelAttribute:String=proportionalsizepanel.cmbField.selectedItem.toString();
			var arr:Array=new Array();
			arr.push(_MinValue)
			arr.push(_MaxValue)
			arr.push(strSelAttribute);
			arr.push(proportionalsizepanel.mySlide.value)
			
			sendNotification(NotificationConstants.STATION_PROPORTIONALSIZE_CHANGED_NOTIFICATION,arr,"proportionalSize")
		}
  
        protected function get proportionalsizepanel():ProportionalSizePanel
        {
            return viewComponent as ProportionalSizePanel;
        }
		

		
	}
}