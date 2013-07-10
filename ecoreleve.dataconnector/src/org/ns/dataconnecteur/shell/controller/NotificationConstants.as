package org.ns.dataconnecteur.shell.controller
{
	public class NotificationConstants
	{
		//Database notifications
		static public const INITIALIZE_SQLITE_NOTIFICATION:String 			= "initializeSqlite";
		static public const SQLITE_INITIALIZED_NOTIFICATION:String 			= "sqliteInitialized";
		static public const SQLITE_ERROR_NOTIFICATION:String 				= "sqliteError";
		
		static public const SQLITE_COMPACT_NOTIFICATION:String 				= "sqliteCompact";
		static public const SQLITE_COMPACTED_NOTIFICATION:String 			= "sqliteCompacted";
		
		static public const SQLITE_CHECK_RELEASE_NOTIFICATION:String 		= "sqliteCheckRelease";
		static public const SQLITE_RELEASE_CHECKED_NOTIFICATION:String 		= "sqliteReleaseChecked";
		
		static public const SQLITE_RECREATE_NOTIFICATION:String 			= "sqliteReCreate";
		static public const SQLITE_RECREATED_NOTIFICATION:String 			= "sqliteReCreated";
		
		static public const SQLITE_CLOSE_NOTIFICATION:String 				= "Closesqlite";
		static public const SQLITE_CLOSED_NOTIFICATION:String 				= "sqliteClosed";
		
		static public const SQLITE_DB_IS_READY_NOTIFICATION:String 			= "sqliteDbIsReady";
		
		//module(swf) notifications
		static public const LOAD_MODULE_NOTIFICATION:String 				= "loadModule";
		static public const MODULE_LOADED_NOTIFICATION:String 				= "moduleLoaded";

		static public const FILE_DROPED_NOTIFICATION:String 				= "fileDroped";
		
		//Stations notifications
		static public const ADD_STATIONS_NOTIFICATION:String 				= "addStations";
		static public const STATIONS_ADDED_NOTIFICATION:String 				= "stationsAdded";
		static public const STATIONS_COUNTED_NOTIFICATION:String 			= "stationCounted";
		static public const DELETE_ALL_STATIONS_NOTIFICATION:String 		= "deleteAllStations";
		static public const STATIONS_DELETED_NOTIFICATION:String 			= "stationsDeleted";
		static public const STATIONS_SELECTED_NOTIFICATION:String 			= "stationsSelected";
		
		//ATTRIBUTE NOTIFICATION
		static public const SELECT_ATTRIBUTE_NOTIFICATION:String 			= "Selectattribute";
		static public const ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION:String 	= "attributeDistinctAdded";
		
		//Query notifications
		static public const QUERY_ADDED_NOTIFICATION:String 				= "queryAdded";
		static public const QUERY_SELECTED_NOTIFICATION	:String 			= "querySelected";
		static public const DELETE_QUERY_NOTIFICATION:String 				= "deleteQuery";
		static public const QUERY_DELETED_NOTIFICATION:String 				= "queryDeleted";
		static public const UPDATE_QUERY_NOTIFICATION:String 				= "updateQuery";
		static public const QUERY_UPDATED_NOTIFICATION:String 				= "queryUpdated";
		static public const QUERY_COUNTED_NOTIFICATION:String 				= "queryCounted";
		static public const QUERY_USED_NOTIFICATION:String 					= "queryUsed";
		static public const QUERY_UNPERSISTENT_DELETED_NOTIFICATION:String	= "queryUnpersistentDeleted";
		
		//modules(sqlite) notifications
		static public const MODULES_SELECTED_NOTIFICATION:String 			= "modulesSelected";
		
		//connectors notifications
		static public const CONNECTORS_LOCAL_SELECTED_NOTIFICATION:String 	= "connectorsLocalSelected";
		static public const CONNECTORS_REMOTE_SELECTED_NOTIFICATION:String 	= "connectorsRemoteSelected";
		
		//datasources notifications
		static public const UPDATE_DATASOURCE:String 						= "updateDatasource";
		static public const DATASOURCE_UPDATED_NOTIFICATION:String 			= "datasourceUpdated";
		static public const INSERT_DATASOURCE_NOTIFICATION:String 			= "insertDatasource";
		static public const DATASOURCE_INSERTED_NOTIFICATION:String 		= "datasourceInserted";
		static public const DATASOURCE_SELECTED_NOTIFICATION:String 		= "datasourceSelected";
		static public const DELETE_DATASOURCE_NOTIFICATION:String			= "deleteDatasource";
		static public const DATASOURCE_DELETED_NOTIFICATION:String			= "datasourceDeleted";
		
		//SQL Notifications
		static public const STATION_JOIN_QUERY_SELECTED_NOTIFICATION:String = "stationJoinQuerySelected";
		static public const STATION_RESUME_DATASOURCE_NOTIFICATION:String 	= "stationResumeDatasource";
		
		//Enhance notifciation
		static public const ENHANCE_STATION_NOTIFICATION:String 			= "enhanceStation";
		static public const STATIONS_ENHANCED_NOTIFICATION:String 			= "stationEnhanced";
		
		//log notifications
		static public const LOG_NOTIFICATION:String 						= "log";
	}
}