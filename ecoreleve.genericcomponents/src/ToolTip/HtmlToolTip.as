package ToolTip
{
	import mx.controls.ToolTip;
     
    public class HtmlToolTip extends ToolTip
    {
        public function HtmlToolTip()
        {    super(); 
        }

        /***
         * commitProperties is called whenever the tooltip text is changed
         * Just copy the new text in the htmlText property of the IUITextField
         * embedded in ToolTip object and you're done!
         ***/
        override protected function commitProperties():void
        {
            super.commitProperties();
            textField.htmlText = text;
        }        
    }

}