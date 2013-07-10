package org.ns.genericComponents.geonames
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ProgressBar;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.Search.Search;
	import org.ns.genericComponents.geonames.VO.ToponymVO;
	import org.ns.genericComponents.geonames.event.GeonameEvent;
	import org.ns.genericComponents.geonames.event.ToponymEvent;
	import org.ns.genericComponents.geonames.model.Geoname;
	import org.ns.genericComponents.geonames.model.GeonameService;
	import org.ns.genericComponents.geonames.renderer.ToponymListRenderer;
	import org.ns.genericComponents.geonames.skin.GeonamesSearchSkin;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	
	[Event(name="complete", type="org.ns.genericComponents.geonames.event.ToponymEvent")]
	public class GeonamesSearch extends SkinnableContainer
	{	
		[SkinPart(required="true")] public var search:Search;
		[SkinPart(required="true")] public var info:Label;
		[SkinPart(required="true")] public var pgBar:ProgressBar;
		
		[Event(name="change", type="flash.events.Event")]
		
		[SkinState("normalAndSearching")]
		[SkinState("normalAndResulting")]
		[SkinState("normalAndError")]

		
		public static const SEARCHING:String 	= "searching";
		public static const RESULTING:String 	= "resulting";
		public static const ERROR:String 		= "error";	 
		
		private var value:String;
		
		public function GeonamesSearch()
		{
			super();
			setStyle("skinClass",GeonamesSearchSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			search.field='name'
			search.mode='auto'
			search.PopUpRenderer=new ClassFactory(ToponymListRenderer);
			search.addEventListener("onSelect",selectItemHandler)
			search.addEventListener("onSearch",searchHandler)
			search.addEventListener("onUnSelect",unSelectHandler)
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function createChildren():void 
		{
			super.createChildren();
		}
		
		
		override protected function measure():void 
		{
			super.measure();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override protected function getCurrentSkinState():String
		{
			var skinState:String = super.getCurrentSkinState();
				 
			switch(value)
			{
				case SEARCHING:
					skinState+="AndSearching";
					break;
				case RESULTING:
					skinState+="AndResulting";
					break;			
				case ERROR:
					skinState+="AndError";
					break;
			}
			 
			return skinState;
		}
		
		//HANDLERS----------------------------------------------------------------------------------------------------
		
		//search handler
		private function searchHandler(event:Event):void
		{
			var geoname:Geoname=GeonameService.search(search.txtSearch.text)
			geoname.addEventListener(GeonameEvent.COMPLETE,completeGeonameHandler)
			geoname.addEventListener(GeonameEvent.ERROR,errorGeonameHandler)
			geoname.call()
			
			search.enabled=false
			value=SEARCHING
			invalidateSkinState();
		}
		
		private function completeGeonameHandler(event:GeonameEvent):void
		{
			search.enabled=true;
			search.PopUpSource=new ArrayCollection(event.data as Array);
			value=RESULTING
			invalidateSkinState();
		}
		
		private function errorGeonameHandler(event:GeonameEvent):void
		{
			search.stopSearch()
			
			search.enabled=true
			value=ERROR
			invalidateSkinState();
		}
		
		private function unSelectHandler(event:Event):void
		{
			this.dispatchEvent(new ToponymEvent(ToponymEvent.CLEAR,null))
		}
		
		private function selectItemHandler(event:Event):void
		{			
			this.dispatchEvent(new ToponymEvent(ToponymEvent.COMPLETE,search.SelectedItem as ToponymVO))
		}

	}
}