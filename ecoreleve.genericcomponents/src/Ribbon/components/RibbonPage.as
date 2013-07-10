package Ribbon.components
{
	import mx.containers.Canvas;
	import mx.core.UIComponent;
    
	public class RibbonPage extends Canvas
	{
		private var defaultStyleName:String="styleRibbonPage";
		
		public function RibbonPage()
		{
			super();
			//skin
			this.styleName=defaultStyleName
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            //REDIMENSIONNE TOUS LES CHILDS
            // adapte la taille du panel au contenu
            // ajoute un espace avnt,aprés et entre chaque panel
            // redimensionne les panel si il dépasse du ribbon
            
            var RibbonWidth:Number;
            var obj:UIComponent;
            var objHeight:Number;  
            var objX:Number=0;
			var gap:Number=5;
            
            RibbonWidth=unscaledWidth -gap
            objHeight=unscaledHeight-(gap*2)
            objX=gap;
                
            for (var i:int = 0; i < numChildren; i++)
            {
                obj = UIComponent(getChildAt(i));
                
                obj.setActualSize(obj.width,objHeight);
                
                //test si la largeur qui rest est bien superieur à celle du panel
                /**if (RibbonWidth < obj.width){
                	obj.setActualSize(obj.width/2,objHeight);
                } else {
	                obj.setActualSize(obj.width,objHeight);	
                }**/
                // déplace le panel comme il faut
                obj.move(objX,gap);
                
                //recalcul la position en x du prochain panel
                objX=obj.width + gap + objX
                
                //recalcul la largeur restante
                RibbonWidth=RibbonWidth - objX
            }

			
		}
		
	}
}