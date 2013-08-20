package org.ns.genericComponents.RedListWidget
{
	import org.ns.genericComponents.RedListWidget.event.RedListEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	
	public class RedListSearch extends EventDispatcher
	{
		
		private static const RED_LIST_URL:String="http://api.iucnredlist.org/go/";
		
		
		public function search(searchString:String):void
		{
			var loader:URLLoader=new URLLoader();
			
			searchString=searchString.replace(" ","-");
			
			var request:URLRequest=new URLRequest(RED_LIST_URL + searchString);
			
			
			loader.addEventListener(Event.COMPLETE, onResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
			loader.dataFormat=URLLoaderDataFormat.TEXT;
			loader.load(request);
		}
		
		private function onResponse(event:Event) : void 
		{
			
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			
			var strResult:String=String(event.currentTarget.data);
			
			//clean XHTML==> xhtlm not well formed
			// use regexp to get only class x_assessment_information before justification part
			
			var pattern:RegExp=new RegExp;
			
			pattern=/<div class='x_section' id='x_assessment_information'>.*<div id='justification'>/gs
			strResult=strResult.match(pattern)[0];
			strResult=strResult + "</div></div>";
			
			//trace(strResult);

			
			try {
				var html:XML=XML(strResult);
				
				var redListItem:RedListItem=new RedListItem();
				
				redListItem.category_code = html..div.(hasOwnProperty("@id") && @id == "red_list_category_code").text();
				redListItem.category_title = html..div.(hasOwnProperty("@id") && @id == "red_list_category_title").text();
				redListItem.category_version = html..div.(hasOwnProperty("@id") && @id == "category_version").text();
				redListItem.modified_year = html..div.(hasOwnProperty("@id") && @id == "modified_year").text();
				redListItem.red_list_criteria = html..div.(hasOwnProperty("@id") && @id == "red_list_criteria").text();
				
				dispatchEvent(new RedListEvent(RedListEvent.REDLIST_SEARCH_RESULT,redListItem))
			}catch (err:Error){
				dispatchEvent(new RedListEvent(RedListEvent.PARSE_ERROR,"ERROR: " + err.message))
			}	
			
		}
		
		private function onIOError(event:IOErrorEvent) : void 
		{  
			dispatchEvent(new RedListEvent(RedListEvent.IO_ERROR,"IOERROR: " + event.text))
		} 

	}
}