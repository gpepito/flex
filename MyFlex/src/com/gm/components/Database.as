package com.gm.components
{
    import flash.data.SQLConnection;
    import flash.data.SQLMode;
    import flash.data.SQLResult;
    import flash.data.SQLStatement;
    import flash.filesystem.File;
    
    import mx.core.FlexGlobals;

    public class Database
    {
        private var _conn:SQLConnection;
        private const dbFile:File=File.applicationDirectory.resolvePath("MyFlex.db");
        private var _sqlStatement:SQLStatement=new SQLStatement();
        private static const SQL_UPDATE:String="UPDATE";
        private static const SQL_READ:String="READ";
        private static const SQL_CREATE:String="CREATE";
        public function Database()
        {
            
        }
        public function createConn():void{
            _conn=new SQLConnection();        
            _sqlStatement.sqlConnection=_conn;
        }
        public function openMode(mode:String):void{
            switch(mode)
            {
                case SQL_UPDATE:
                {
                    _conn.open(dbFile,SQLMode.UPDATE);
                    break;
                }
                    
                case SQL_READ:
                {
                    _conn.open(dbFile,SQLMode.READ);
                    break;
                }
                case SQL_CREATE:{
                    _conn.open(dbFile,SQLMode.CREATE);
                    break;
                }
            }
        }
        public function setStatement(statement:String):void{
            _sqlStatement.text=statement;
        }
        public function setParams(paramName:String,paramValue:String):void{
            _sqlStatement.parameters[":"+paramName]=paramValue;
        }
        public function execute():void{
            _sqlStatement.execute();
        }
        public function result():SQLResult{
            return _sqlStatement.getResult();
        }
    }
}