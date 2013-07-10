package com.pocketListGenerator.controller
{
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import com.pocketListGenerator.controller.*;
	
	public class LoadUserAndSiteCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand() : void    
		{
			addSubCommand( LoadUserCommand );
			addSubCommand( LoadSiteCommand );
		}
	}
}