package com.pocketListGenerator.model.VO
{
	
	[Bindable]
    public class UserVO    
    {
    	public var ID:String = null;
        public var NAME:String = null;
		public var FIRSTNAME:String = null;
		public var SURNAME:String = null;
		public var LOGIN:String = null;
		public var PASSWORD:String = null;
		public var GROUP:Number = NaN;
		public var GROUP_NAME:String = null;
        /**
         * 
         * @param id
         * @param name
         */
        public function UserVO ( id:String=null,
								 name:String=null,
								 fname:String=null,
								 sname:String=null,
								 login:String=null,
								 password:String=null,
								 group:Number=NaN,
								 groupname:String=null)
        {
        	if( id != null ) this.ID = id;
            if( name != null ) this.NAME = name;
			if( fname != null ) this.FIRSTNAME = fname;
			if( sname != null ) this.SURNAME = sname;
			if( login != null ) this.LOGIN = login;
			if( password != null ) this.PASSWORD = password;
			if( !isNaN(group)) this.GROUP = group;
			if( groupname != null ) this.GROUP_NAME = groupname;
        }
        
      
        /**
         * 
         * @param strLine
         * @param delim
         * @return 
         */
        public static function fromCSV(strLine:String,delim:String):UserVO
        {
            var data:UserVO = new UserVO();
            
			var arr:Array=strLine.split(delim)
			
            data.ID = String(arr[0])
            data.NAME = String(arr[1])
            
            return data;
        }
		
		/** 
		 * EXPORT TO CSV
		 * @param user
		 * @param delim
		 * @return 
		 */
		public static function toCSV(user:UserVO,delim:String):String
		{
			var str:String;
			
			str=user.ID + delim + user.NAME
			
			return str
		}
		
		/**
		 * Transforme un UserVO en paramètre d'authentification string ==> "login:password"
		 * @param user
		 * @return 
		 */
		public static function toAuth(user:UserVO):String
		{
			return user.LOGIN + ":" + user.PASSWORD
		}
		
    }
}