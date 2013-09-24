package org.ns.dataconnecteur.shell.controller
{
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.EnhanceProxy;
	import org.ns.dataconnecteur.shell.model.proxy.ReleaseProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class SqliteReleaseDBCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
    	{    		         	
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			var pxyRelease:ReleaseProxy=retrieveProxy(ReleaseProxy.NAME) as ReleaseProxy;

			pxyRelease.getReleaseNumber(pxyDatabase.getSqlConnexion);
		}
    }

}