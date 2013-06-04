// ActionScript file
import com.gm.components.Database;

import flash.errors.SQLError;

import mx.controls.Alert;

private var dbase:Database=new Database();
protected function registerForm():void
{
 //create first database
/*    try{
    dbase.createConn();
    dbase.openMode("CREATE");
    dbase.setStatement("CREATE TABLE if not exists m_account ( accountId  INTEGER PRIMARY KEY AUTOINCREMENT, fname TEXT NOT NULL , lname TEXT NOT NULL, email TEXT NOT NULL, username TEXT NOT NULL, password TEXT NOT NULL)");
    dbase.execute();
    }catch(error:SQLError){
        trace("Error Message:",error.message);
        trace("Error Details:",error.details);
    }*/
}

protected function logIn(user:String,pass:String):void{
    try{
        dbase.createConn();
        dbase.openMode("READ");
        dbase.setStatement("SELECT * FROM m_account WHERE username=:username AND password=:password ");
        dbase.setParams("username",user);
        dbase.setParams("password",pass);
        dbase.execute();
    }catch(error:SQLError){
        trace("Error Message:",error.message);
        trace("Error Details:",error.details);
    }
       if( dbase.result().data.length>0){
          Alert.show("Successfull logged In");}
       else{
          Alert.show("Invalid log in");}
    }