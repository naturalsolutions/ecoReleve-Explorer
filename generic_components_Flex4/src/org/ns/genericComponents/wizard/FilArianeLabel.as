package org.ns.genericComponents.wizard
{
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.wizard.skin.WizardFilArianeLabelSkin;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	

	public class FilArianeLabel extends SkinnableContainer
	{
		[SkinPart(required="true")] public var lblData:Label;		
		[SkinState("selected")]
		
		
		public static const SELECTED:String 	= "selected";
		public static const NORMAL:String 		= "normal";
		private var _state:String=NORMAL;
		
		private var _text:String;
		private var bTextChanged:Boolean = false;
		
		private var _selected:Boolean;
		private var bSelectedChanged:Boolean = false;
		
		//text property
		[Inspectable(category="General", type="String", defaultValue="null")]
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(data:String) : void 
		{
			if (data!=_text){
				_text=data
				bTextChanged=true;
				invalidateProperties();
			}
		}

		// selected property
		[Inspectable(category="General", type="Boolean", defaultValue="null")]
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(data:Boolean) : void 
		{
			if (data!=_selected){
				_selected=data
				if (_selected==true){
					_state= SELECTED
				}else{
					_state = NORMAL
				}
				invalidateSkinState();
			}
		}
		
		
		public function FilArianeLabel()
		{
			super();
			setStyle("skinClass",WizardFilArianeLabelSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			if (_selected==true){
				_state= SELECTED
			}else{
				_state = NORMAL
			}
			invalidateSkinState();
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function getCurrentSkinState():String
		{ 			
			if (_state == SELECTED){ 
				return "selected" 
			} 
			if (_state == NORMAL){ 
				return "normal" 
			}
			return "normal"; 
		}
		
		override protected function commitProperties():void { 
			super.commitProperties(); 
			
			if (bTextChanged){ 
				lblData.text=_text;
				// Reset flag. 
				bTextChanged = false; 
			} 
		}
	}
}