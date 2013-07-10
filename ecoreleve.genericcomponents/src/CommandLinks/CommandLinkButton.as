package CommandLinks
{
	import flash.text.TextLineMetrics;
	
	import mx.controls.LinkButton;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;
	use namespace mx_internal;
 
	public class CommandLinkButton extends LinkButton 
	{	
		public var myLineMetric:TextLineMetrics;
		private var myIcon:IFlexDisplayObject;
		private var lblDescription:MultilineLabel;
		
		private var _descriptionFontSize:Number; 
		private var _descriptionFontWeight:String;
		
		[Inspectable(defaultValue=true)]
		private var _strDescription:String;
		
		[Bindable]
		public function get description():String
		{
			return _strDescription;
		}
		
		public function set description(value:String) : void 
		{
			_strDescription=value
		}
		
		public function CommandLinkButton()
	    {
		   super();
	    }
			
		override protected function createChildren():void 
		{
			if (_strDescription){
				lblDescription=new MultilineLabel()
				lblDescription.text=_strDescription;
				lblDescription.setStyle("textAlign","left");	
				this.addChild(lblDescription);
			}
			super.createChildren();
		}
 
		override protected function measure():void
		{			
			if (!isNaN(explicitWidth))
			{
				myIcon = getCurrentIcon();
				var w:Number = explicitWidth;
				if (myIcon)
					w -= myIcon.width + getStyle("horizontalGap") + getStyle("paddingLeft") + getStyle("paddingRight");
				textField.width = w;
				lblDescription.width=w;
			}
			
			super.measure();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
        {
        	super.updateDisplayList(unscaledWidth, unscaledHeight);
        	
        	//gestion de la disposition des childs
        	myIcon.x=getStyle("paddingLeft")
			myIcon.y=getStyle("paddingTop")
			textField.x=myIcon.width + getStyle("horizontalGap") + getStyle("paddingLeft")
			textField.y=getStyle("paddingTop")
			
			lblDescription.y=textField.height;
			lblDescription.x=textField.x;
			
			//Mise en forme
			if (this.getStyle("descriptionFontSize")!== false) {_descriptionFontSize = this.getStyle('descriptionFontSize');}
			if (this.getStyle("descriptionFontWeight")!== false) {_descriptionFontWeight = this.getStyle('descriptionFontWeight');}
			
			lblDescription.setStyle("fontSize",_descriptionFontSize)
			lblDescription.setStyle("fontWeight",_descriptionFontWeight)
        }
	}
}