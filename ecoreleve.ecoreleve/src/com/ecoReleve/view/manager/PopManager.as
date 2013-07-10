package com.ecoReleve.view.manager
{
   	import flash.display.Sprite;
   	
   	import mx.core.Application;
   	import mx.core.FlexGlobals;
   	import mx.core.IFlexDisplayObject;
   	import mx.managers.PopUpManager;
   	
   	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	
	public class PopManager extends PopUpManager
	{
		public function PopManager()
		{
		}

		/** Fonction pour ouvrir un popup
		  * Appelle comme ceci ==> ApplicationFacade.openPopUpWindow( MyComponent, MyComponentMediator );
		 **/
		public static function openPopUpWindow(facade:FabricationFacade,ComponentClass:Class, MediatorClass:Class ):void
		{
			var window:IFlexDisplayObject = PopUpManager.createPopUp( Application.application as Sprite, ComponentClass, true );
			facade.registerMediator( new MediatorClass( window ) );
			PopUpManager.centerPopUp( window );
		}
		
		/** Fonction pour fermer un popup
		  * Appelle comme ceci ==> ApplicationFacade.closePopUpWindow( myComponentInstance, MyComponentMediator.NAME );		
		 **/
		public static function closePopUpWindow(facade:FabricationFacade, window:IFlexDisplayObject, mediatorName:String ):void
		{
			PopUpManager.removePopUp( window );
			facade.removeMediator( mediatorName );
		}

	}
}