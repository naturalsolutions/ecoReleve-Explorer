package com.ecoReleve.model
{
	import com.ecoReleve.controller.*;
	
	import mx.binding.utils.*;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import org.ns.common.model.VO.StationVO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class SelectionProxy extends FabricationProxy
	{
		public static const NAME:String = "SelectionProxy";	
		
		
		
		private var _currentIndex:Number;
		public function set currentIndex(data:Number):void
		{
			_currentIndex=data;
		}
		
		private var _selection:ArrayCollection=new ArrayCollection();
		public function set selection(data:ArrayCollection):void
		{
			_selection=data;	
			_currentIndex=0;
			this.sendNotification(NotificationConstants.SELECTION_NEW_NOTIFICATION,_selection,"new")
		}
		
		public function get selection():ArrayCollection
		{
			return 	_selection;
		}

		//CONSTRUCTOR
		public function SelectionProxy()
		{
			super(NAME);	
		}				
		
		//PUBLIC FUNCTION
		public function nextItem():Object
		{
			if (_currentIndex<_selection.length + 1){
				_currentIndex+=1;
				this.sendNotification(NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION,_selection.getItemAt(_currentIndex),"changed")
			}
			return _selection.getItemAt(_currentIndex)
		}
		
		public function previousItem():Object
		{
			if (_currentIndex>0){
				_currentIndex-=1;
				this.sendNotification(NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION,_selection.getItemAt(_currentIndex),"changed")
			}
			return _selection.getItemAt(_currentIndex)
		}
		
		public function changeCurrentItem(index:Number):Object
		{
			if (index>=0 && index < _selection.length){
				_currentIndex=index;
				this.sendNotification(NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION,_selection.getItemAt(_currentIndex),"changed")
				return _selection.getItemAt(_currentIndex)
			}
			return null;
		}
		
		public function setCurrentItem(item:Object):void
		{
			if (item is StationVO){
				_currentIndex=_selection.getItemIndex(item)
				this.sendNotification(NotificationConstants.SELECTION_CURRENT_ITEM_NOTIFICATION,_selection.getItemAt(_currentIndex),"changed")
			}
		}
		
		public function getCurrentItem():Object
		{
			return _selection.getItemAt(_currentIndex)
		}
		
		public function removeAll():void
		{
			_selection.removeAll()
			_selection.refresh()
			this.sendNotification(NotificationConstants.SELECTION_RESET_NOTIFICATION,null,"reset")
		}
	
		
		//HANDLERS
		
	
	}
}