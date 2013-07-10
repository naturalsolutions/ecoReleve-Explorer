package com.ecoReleve.ressources.skin.timelineSkin
{
    import mx.skins.Border;
 
    public class TrackHighLightSkin extends Border
    {
        public function TrackHighLightSkin()
        {
            super();
        } 
 
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth,unscaledHeight); 
 			var nbLarg:Number;
 			
			 with (graphics)
	         {
	            clear();
	            nbLarg=this.parent.parent.width - unscaledWidth + 100;
	            
	            lineStyle( 2, 0x0033FF,.5 );
	            beginFill( 0x999999, .7 );
	            //rectangleé de gauche
	            drawRect( -nbLarg,0,nbLarg,unscaledHeight-23);
	            //rectangleé de droite
	            drawRect( unscaledWidth,0,nbLarg,unscaledHeight-23 );
	            
	            //rectangle sous la selection
	          	lineStyle(2, 0x0033FF,.5 );
	            beginFill( 0x0033FF, .5 );  
	            drawRect( 0,unscaledHeight-32,unscaledWidth,9);
	          }
        } 
 
      override public function get measuredWidth():Number
      {
         return 100;
       }
      override public function get measuredHeight():Number
      {
         return 100;
       }

 
    }
}
