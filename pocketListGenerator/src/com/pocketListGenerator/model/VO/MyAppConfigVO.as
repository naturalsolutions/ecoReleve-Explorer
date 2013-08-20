package com.pocketListGenerator.model.VO
{
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.utilities.flex.config.model.ConfigVO;
	
	public class MyAppConfigVO extends ConfigVO
	{
		
		/**
		 * Check that config is valid.
		 */		
		override public function isValid():Boolean
		{
			// make sure deployment namespace is populated
			if ( !super.isValid() ) return false;

			// make sure all fields are populated
			return ( appName 			!= null &&
					 serveurURL 		!= null &&
					 wsName 			!= null &&
					 updateURL		 	!= null
					);
		}

		/**
		 * Get the App Name for the selected deployment environment.
		 */
		public function get appName():String
		{
			return config.nsDeploy::appName;
		}

		/**
		 * Get the serveur url for the selected deployment environment.
		 */
		public function get serveurURL():String
		{
			return config.nsDeploy::serveurURL;
		}
		
		/**
		 * Get the update file url
		 */
		public function get updateURL():String
		{
			return config.nsDeploy::updateURL;
		}

		/**
		 * Get the webservice name for the selected deployment environment.
		 */
		public function get wsName():String
		{
			return config.nsDeploy::wsName;
		}	
		
	}
}