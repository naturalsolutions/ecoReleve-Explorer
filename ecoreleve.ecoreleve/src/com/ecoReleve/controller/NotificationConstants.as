package com.ecoReleve.controller
{
	public class NotificationConstants
	{
		//LUNCH NOTIFICATIONS
		static public const LOAD_CFG_FILE_NOTIFICATION:String 				= "loadCfgFile";

		
		
		//Database notifications
		static public const INITIALIZE_SQLITE_NOTIFICATION:String 			= "initializeSqlite";
		static public const SQLITE_INITIALIZED_NOTIFICATION:String 			= "sqliteInitialized";
		static public const SQLITE_ERROR_NOTIFICATION:String 				= "sqliteError";
		
		static public const SQLITE_CLOSE_NOTIFICATION:String 				= "Closesqlite";
		static public const SQLITE_CLOSED_NOTIFICATION:String 				= "sqliteClosed";

		//Stations notifications
		static public const SELECT_STATIONS_NOTIFICATION:String 			= "selectStations";
		static public const STATIONS_SELECTED_LIST_NOTIFICATION:String 		= "stationsListSelected";
		static public const STATIONS_SELECTED_INFO_NOTIFICATION:String 		= "stationsInfoSelected";
		
		//TO CLEAN ************************************************
		public static const STARTUP_NOTIFICATION:String = "startup";
		public static const LOAD_PROXIES_NOTIFICATION:String = "loadproxies";
		
		// GESTION DES AFFICHAGES

		public static const SHOW_MDIWINDOW:String = "showMdiWindow";
		public static const MDIWINDOW_SHOWED:String = "MdiWindowShow";
		
		public static const DISPLAY_MODE:String = "displaymode";
		

		public static const DISPLAY_CTLPANEL:String= "displayctlbarre";
		

		public static const DISPLAY_EXPORT:String= "dsiplayexport";
		

		public static const DISPLAY_SPINNER:String= "dsiplayspinner";
		

		public static const DISPLAY_UPDATE_PANEL:String= "dsiplayUpdatePanel";
		
		
		//GESTION DE STATIONSDENSITY

		public static const LOADING_STATIONSDENSITY_COMPLETE_NOTIFICATION:String = "loadstationsdensitycomplete";
		

		public static const STATIONSDENSITY_GET_NOTIFICATION:String="stationsDensityget";
		
		//GESTION DE LA CONNEXION

		public static const DECONNEXION_NOTIFICATION:String = "deconnexion";
		public static const CONNEXION_TRY_NOTIFICATION:String = "connexiontry";
		public static const CONNEXION_UNAUTHORIZED_NOTIFICATION:String = "connexionunauthorized";
		public static const CONNEXION_FAILED_NOTIFICATION:String = "connexionfailed";
		public static const PUT_USER_NOTIFICATION:String = "putuser";
		
		public static const REGISTER_USER_NOTIFICATION:String = "registeruser";
		
		//GESTION DU MONITORING DES URL (Geoserver et NS Server)

		public static const SERVER_AVAILABLE_NOTIFICATION:String = "serveravailble";

		public static const GEOSERVER_AVAILABLE_NOTIFICATION:String = "geoserveravailble";
		
		//GESTION DU RIBBON

		public static const RIBBON_CHANGE_SIZE_NOTIFICATION:String = "ribbonchangesizenotification";
		
		//GESTION DES DONNEES

		public static const TRY_LOAD_NOTIFICATION:String = "load";
		public static const EXPORTED_DATA_NOTIFICATION:String = "exporteddata";

		public static const CONVERT_NSML_TO_XML_NOTIFICATION:String = "convertnsmltoxml";

		public static const STATIONS_INSERTED_NOTIFICATION:String="stationinserted";
		
		

		public static const DATA_SELECTED_NOTIFICATION:String="dataselected";
		public static const GET_WMS_FEATURE_INFO_NOTIFICATION:String="getwmsfeatureinfo";
		public static const FEATURE_SELECTED_NOTIFICATION:String="featureselected";
		public static const STATIONS_UNSELECTED_NOTIFICATION:String="stationunselected";
		public static const FILTER_DELETED_NOTIFICATION:String="filterdeleted";
		public static const FILTER_ALL_DELETED_NOTIFICATION:String="filteralldeleted";
		public static const FILTER_ADDED_NOTIFICATION:String="filteradded";
		public static const STATIONS_DELETED_NOTIFICATION:String="stationsdeleted";
		public static const STATIONS_ALL_DELETED_NOTIFICATION:String="stationsalldeleted";
		public static const STATIONS_ADDED_NOTIFICATION:String = "stationadded";
		public static const STATIONS_WS_ENHANCED_NOTIFICATION:String = "stationwsenhanced";
		public static const STATION_LAYER_ADDED_NOTIFICATION:String="stationlayeradded";
		public static const STATIONS_FILTERED_NOTIFICATION:String="stationfiltered"
		public static const STATIONS_EXPORT_NOTIFICATION:String="stationsexport";
		public static const STATIONS_EXPORTED_NOTIFICATION:String="stationsexported";
		
		public static const STATION_LAYER_MODE_NOTIFICATION:String="stationLayerMode";
		
		static public const SELECT_ATTRIBUTE_NOTIFICATION:String 	= "Selectattribute";
		static public const ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION:String 	= "attributeDistinctAdded";
		static public const ATTRIBUTE_MINMAX_ADDED_NOTIFICATION:String 		= "attributeMinMaxAdded";
		
		public static const LAYER_ADD_NOTIFICATION:String="layeradd";
		public static const LAYER_ADDED_NOTIFICATION:String="layeradded";
		public static const LAYER_REMOVED_NOTIFICATION:String="layerremoved";
		public static const REMOVE_STATION_LAYER_NOTIFICATION:String="removestationlayer";
		public static const REMOVE_FILTER_NOTIFICATION:String="removefilter";
		

		public static const DATA_GET_NOTIFICATION:String="stationget";
		public static const DATA_WS_GET_NOTIFICATION:String="stationwsget";
		public static const STATION_SUMMARY_LOADED_NOTIFICATION:String="stationsummaryloaded";
		
		public static const EXPORT_FILE_NOTIFICATION:String = "exportFile";
		
		//GESTION DES WIDGETS
		public static const WIDGET_ACTIVATE_NOTIFICATION:String = "widgetActivate";
		
		//GESTION DES COLUMNS (TABLE VIEW)
		public static const COLUMN_VISIBILITY_NOTIFICATION:String = "columnVisibility";
		public static const TABLE_CREATED_NOTIFICATION:String = "tableCreated";
		
		//GESTION DE LA SELECTION
		public static const SELECTION_CURRENT_ITEM_NOTIFICATION:String = "selectionCurrentItem";
		public static const SELECTION_NEW_NOTIFICATION:String = "selectionNew";
		public static const SELECTION_RESET_NOTIFICATION:String = "selectionReset";
		
		//GESTION DES ERREURS
	
		public static const SHOW_ERROR_NOTIFICATION:String = "showError";
		public static const NAV_ERROR_NOTIFICATION:String = "naverror";
		public static const MAP_ERROR_NOTIFICATION:String = "maperror";
		public static const ERROR_IO_NOTIFICATION:String = "ioerror";
		public static const ERROR_HTTP_NOTIFICATION:String = "httperror";
		public static const ERROR_MSG_NOTIFICATION:String = "msgerror";
		
		//GESTION DES FILTRES

		public static const FILTER_CRITERIA_NOTIFICATION:String="filtercriteria";
		public static const FILTER_INITIALIZE_NOTIFICATION:String="filterinitialize";
		public static const FILTER_CHANGED:String="filterchanged";
		public static const STATION_GET_SUMMARY_NOTIFICATION:String="stationgetsummary";
		public static const STATION_GET_EP_SUMMARY_NOTIFICATION:String="stationgetepsummary";
		public static const STATION_GET_DENSITY_NOTIFICATION:String="stationgetdensity";
		
		//GESTION DES OUTILS CARTO       

		public static const CHANGE_BASEMAP:String="changeBaseMap";
		public static const QUICK_INFO_NOTIFICATION:String="quickinfo";
		public static const LEGEND_NOTIFICATION:String="legend"; 
		public static const MAP_CREATED_NOTIFICATION:String="mapcreated";

		public static const DISPLAY_MAP_TOOL:String="displaymaptool";
		
		
		//GESTION DES STYLES
		public static const STATION_STYLE_CHANGED_NOTIFICATION:String="stationsstylechanged";
		public static const STATION_SIZE_CHANGED_NOTIFICATION:String="stationsizechanged";
		public static const STATION_OPACITY_CHANGED_NOTIFICATION:String="stationopacitychanged";
		public static const STATION_COLOR_CHANGED_NOTIFICATION:String="stationscolorchanged";

		public static const STATION_PROPORTIONALSIZE_CHANGED_NOTIFICATION:String="stationsproportionalsizechanged";
		public static const STATION_PROPORTIONALSIZE_UNSELECT_NOTIFICATION:String="stationsproportionalsizeUnselect";

		public static const STATION_CLASS_CHANGED_NOTIFICATION:String="stationclasschanged"
		public static const STATION_CLASS_UNSELECT_NOTIFICATION:String="stationclassUnselect"
		
		
	}
}