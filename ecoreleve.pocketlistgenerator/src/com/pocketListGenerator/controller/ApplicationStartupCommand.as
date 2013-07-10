package com.pocketListGenerator.controller
{
	import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
	import com.pocketListGenerator.controller.*;

    public class ApplicationStartupCommand extends MacroCommand implements ICommand
    {
        override protected function initializeMacroCommand() : void    
        {
        	addSubCommand( ModelPrepCommand );
			addSubCommand( ViewPrepCommand );
        }
    }
}