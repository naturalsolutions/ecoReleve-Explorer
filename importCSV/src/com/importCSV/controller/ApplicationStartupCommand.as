package com.importCSV.controller
{
	import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
	import com.importCSV.controller.*;

    public class ApplicationStartupCommand extends MacroCommand implements ICommand
    {
        override protected function initializeMacroCommand() : void    
        {
        	addSubCommand( ModelPrepCommand );
			addSubCommand( ViewPrepCommand );
        }
    }
}