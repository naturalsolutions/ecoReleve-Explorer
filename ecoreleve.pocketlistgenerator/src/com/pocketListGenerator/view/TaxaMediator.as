package com.pocketListGenerator.view
{
	import com.pocketListGenerator.controller.*;
	import com.pocketListGenerator.model.VO.TaxaVO;
	import com.pocketListGenerator.model.VO.ThesaurusFiltreVO;
	import com.pocketListGenerator.model.VO.ThesaurusVO;
	import com.pocketListGenerator.view.mycomponents.Taxa;
	import com.pocketListGenerator.utils.Export;
	
	import flash.events.Event;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class TaxaMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "TaxaMediator";		
 				
 		//constructeur
        public function TaxaMediator(viewComponent:Taxa)
        {
            super(NAME, viewComponent); 
			taxa.addEventListener(Taxa.SELECT,selectHandler);
			taxa.addEventListener(Taxa.UNSELECT,unselectHandler);
			taxa.addEventListener(Taxa.CREATE_LIST,loadThesaurusHandler);
			taxa.addEventListener(Taxa.EXPORT_CSV,exportCSVHandler);
        }    

		/**
		 * Liste les notifications attendues
		 * @return 
		 */
		override public function listNotificationInterests( ) : Array 
		{
			return [ApplicationFacade.TAXA_LOADED_NOTIFICATION,
					ApplicationFacade.LOADING_THESAURUS_COMPLETE_NOTIFICATION];
		}
		
		/**
		 * Gère les notifications
		 * @param note
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case ApplicationFacade.TAXA_LOADED_NOTIFICATION:
					taxa.taxa=note.getBody() as ArrayCollection		
					break;
				case ApplicationFacade.LOADING_THESAURUS_COMPLETE_NOTIFICATION:	
					taxa.thesaurus=(note.getBody()) as ArrayCollection;
					break;
			}
		}
		
		/**
		 * SELECT A TAXA IN THESAURUS LIST
		 * @param event
		 */
		private function selectHandler(event:Event) : void 
		{
			//récupération de l'objet Thésaurus selectionné
			var selThesaurus:ThesaurusVO=taxa.myCriteria._SelectedItem as ThesaurusVO;
			sendNotification(ApplicationFacade.TAXA_GET_NOTIFICATION,selThesaurus,"taxon");
		}
		
		/**
		 * UNSELECT IN THESAURUS LIST
		 * @param event
		 */
		private function unselectHandler(event:Event) : void 
		{
			//sendNotification(ApplicationFacade.UNSELECT);
		}
		
		/**
		 * CREATE THESAURUS LIST
		 * @param event
		 */
		private function loadThesaurusHandler(event:Event) : void 
		{
			//création du filtre
			var thesaurusFilter:ThesaurusFiltreVO=new ThesaurusFiltreVO;
			var strCriteria:String="";
			strCriteria=taxa.myCriteria.text
			
			//ajoute %25 (équivalent de % en urlencoding)  en fin de critere et en remplacement des caratères espaces
			var original:Array=strCriteria.split(" ");
			strCriteria=original.join("%25");
			
			if (strCriteria.substr(strCriteria.length-3,3)!='%25'){
				strCriteria=strCriteria + "%25";
			}
			
			//Test le mode de recherche du critère:scientific ou vernacular
			if (taxa.mode=='vernacular'){
				thesaurusFilter.DEFINITION_FR_LIKE=strCriteria
			} else {
				thesaurusFilter.TOPIC_FR_LIKE=strCriteria;	
			}
			
			//envoi la notification pour charger les thesaurus
			sendNotification(ApplicationFacade.THESAURUS_GET_NOTIFICATION,thesaurusFilter);
		}
		
		/**
		 * EXPORT SELECTED ITEM IN CSV
		 * @param event
		 */
		private function exportCSVHandler(event:Event) : void 
		{
			var strResult:String
			
			//add header
			strResult="pk;displayname;storagename\n";
			
			for each(var item:TaxaVO in taxa.taxa){
				strResult+=TaxaVO.toCSV(item,";") + "\n";	
			}
			
			Export.WriteData(strResult,"CSV");
		}
		
        protected function get taxa():Taxa
        {
            return viewComponent as Taxa;
        }
    }
}