package org.ns.dataconnecteur.shell.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.PopUpManager;
	
	import org.ns.common.model.VO.QueryVO;
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.TimeLine;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class TimeLineMediator extends FlexMediator
	{
		public static const NAME:String = 'TimeLineMediator';
		
		public function TimeLineMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER
		public function respondToQueryUsed(note:INotification):void
		{
			//get array of queries
			var arr:ArrayCollection=new ArrayCollection();
			arr=note.getBody() as ArrayCollection;
			
			var newArrQueries:Array=new Array()
			var min:Number=0
			var max:Number=0
				
			var query:QueryVO;
			for each(query in arr){
				var obj:Object=new Object;
				obj.name=query.qry_name;
				obj.dateMax=query.qry_minDate.getTime();
				obj.dateMin=query.qry_maxDate.getTime();
				
				if (max==0 || obj.dateMax>max){max=query.qry_maxDate.getTime()}
				if (min==0 || obj.dateMin<min){min=query.qry_minDate.getTime()}

				newArrQueries.push(obj);
			}
			
			//apply on chart	
			var delta:Number=(max-min)/2 //delta is half the time between min and max
			timeline.hAxis.minimum=min - delta 
			timeline.hAxis.maximum=max + delta 
			
			timeline.queries=new Array();
			timeline.queries=newArrQueries;		
		}
		
		//REACTIONS

		
		//GETTER		
		public function get timeline():TimeLine
		{
			return this.viewComponent as TimeLine;
		}
		
	}
}