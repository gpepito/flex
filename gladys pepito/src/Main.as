// ActionScript fileimport mx.controls.Alert;

import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.charts.CategoryAxis;
import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.validators.Validator;

import spark.components.Button;
import spark.components.Label;
import spark.components.TextInput;
import spark.components.TitleWindow;
import spark.validators.NumberValidator;


private const arrItemType:ArrayList=new ArrayList(["Feet Only","Inches Only","Feet and Inches"]);
private const arrQuantity:ArrayList=new ArrayList(["PCS", "LBS","FT"]);

private var _titleWindow:TitleWindow=new TitleWindow();
private var _label:Label = new Label();
private var _btnYes:Button=new Button();
private var _btnNo:Button=new Button();
private var _qty:Number=new Number();
private var _feet:Number=0;
private var _inches:Number=0;
private var _arrValidators:Array=new Array();
private var _check:Boolean=false;
private var _validQty:Boolean=false;
private var _validFeet:Boolean=false;
private var _validInches:Boolean=false;
private var validYesNo:Boolean=false;

[Bindable]private var strResult:String="pending...";



private function initialFocus():void{
    txtYesNo.setFocus();
    _arrValidators.push(txtFeet_validator,txtInches_validator,txtQty_validator);
}
protected function keypress(event:KeyboardEvent):void
{
    if(event.keyCode==Keyboard.F2)
        popUpYesNo();    
}
private function highlightText(txtField:TextInput):void{
    txtField.selectAll();
}
private function txtYesNoFocusOut(event:FocusEvent):void{
    var str:String="";    
    try{        
        str=event.relatedObject.toString();
        var strArray:Array=str.split(".");
        if(strArray[13]!="btnYesNo" && strArray[2]!="OK"){
            txtYesNo_validator.enabled=true;
            txtYesNo_validator.validate(txtYesNo.text);
        }else{
            txtYesNo_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
            txtYesNo_validator.enabled=false;
        }
    }catch(error:Error){
        trace("Focused outside Form");  //catch when event.relatedObject is null or empty. 
    }
    trace("txtYesNofocusout",str);
}
/**will check if the next focus is not in txtFeet and txtInches, 
 if true, will validate those fields*/
protected function nextFocus(event:FocusEvent):void
{
    var str:String="";
    var strArray:Array=new Array();
    var validators:Array=new Array();
    _check=true;
    
    try{
        //store the InteractiveObject instance that has gained focus.
        str=event.relatedObject.toString();
        trace("str nextfocus",str);
        
        strArray=str.split(".");
        validators.push((txtFeet.enabled==true?txtFeet_validator:null),(txtInches.enabled==true?txtInches_validator:null));
        
        //the index 13 contains the id of the field that has gained focus.
        if(strArray[13]!="txtInches" && strArray[13]!="txtFeet"){
            txtFeet_validator.enabled=true;
            txtInches_validator.enabled=true;
            Validator.validateAll(validators);
            if((_validFeet && txtFeet.enabled==true)|| (_validInches && txtInches.enabled==true)){
                if((_validFeet && txtInches.text.length==0)||( _validInches && txtFeet.text.length==0) ||
                   (_validFeet && _validInches)){
                    _validFeet=true;
                    _validInches=true;
                txtFeet_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
                txtInches_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
                txtFeet_validator.enabled=false;
                txtInches_validator.enabled=false;
                }
            }else{
                txtFeet_validator.enabled=(txtFeet.enabled==false?false:true);
                txtInches_validator.enabled=(txtInches.enabled==false?false:true);
            }
        }else if (strArray[13]=="txtInches" || strArray[13]=="txtFeet"){
            _validFeet=true;
            _validInches=true;
            txtFeet_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
            txtInches_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
            txtFeet_validator.enabled=false;
            txtInches_validator.enabled=false;
        }
        
        if(_validInches && strArray[13]!="txtInches"){
            txtInches.text=(txtInches.text!="" && int(txtInches.text)>0?formatInches.format(txtInches.text):txtInches.text);
        }
        
    }catch(error:Error){
        trace("focused is outside form");  //catch when event.relatedObject is null or empty. 
    }
}

/**
 * display title window containing Yes No buttons
 * */
private function popUpYesNo():void{
    _label.text = "The Yes No ellipse has been activated.";
    _label.x=10;
    _label.y=10;        
    
    _btnYes.label="Yes";
    _btnYes.id="btnYes";
    _btnYes.x=20;
    _btnYes.y=70;
    _btnYes.addEventListener(MouseEvent.CLICK,function():void{yesClick();});
    
    _btnNo.label="No";
    _btnNo.id="btnYes";
    _btnNo.x=150;
    _btnNo.y=70;
    _btnNo.addEventListener(MouseEvent.CLICK,function():void{noClick();});
    
    _titleWindow.width = 240;
    _titleWindow.height = 180;
    _titleWindow.addEventListener(CloseEvent.CLOSE,function():void{titleWindow_close()});
    _titleWindow.addElement(_label);
    _titleWindow.addElement(_btnYes);
    _titleWindow.addElement(_btnNo);
    _titleWindow.id="titleWindow";
    PopUpManager.addPopUp(_titleWindow, this, true);
    PopUpManager.centerPopUp(_titleWindow);
    
}
private function titleWindow_close():void{
    PopUpManager.removePopUp(_titleWindow);
}
private function noClick():void{
    txtYesNo_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
    txtYesNo.text="";
    titleWindow_close();
    txtYesNo.setFocus();
}
private function yesClick():void{
    txtYesNo.text="YES";
    titleWindow_close();
    cboItemType.setFocus();
}
private function selectedItemType():void{
    switch(cboItemType.selectedIndex)
    {
        case 0:
        {            
            lblInches.enabled=false;
            txtInches.enabled=false;
            lblFeet.enabled=true;
            txtFeet.enabled=true;
            txtInches.text="";
            _validInches=true;
            _arrValidators=new Array(txtFeet_validator,txtQty_validator);
            break;
        }
            
        case 1:
        {
            lblInches.enabled=true;
            txtInches.enabled=true;            
            lblFeet.enabled=false;
            txtFeet.enabled=false;
            _validFeet=true;
            txtFeet.text="";            
            _arrValidators=new Array(txtInches_validator,txtQty_validator);
            break;
        }
        case 2:{
            lblInches.enabled=true;
            txtInches.enabled=true;
            lblFeet.enabled=true;            
            txtFeet.enabled=true;
            _arrValidators=new Array(txtFeet_validator,txtInches_validator,txtQty_validator);
            break;
        }
    }
    txtInches_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
    txtFeet_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));   
}

/**
 * set the result of the validators
 * */
private function setResult(val:Number,bol:Boolean):void{
    switch(val)
    {
        case 0:
        {
            _validQty=bol;
            break;
        }
        case 1:
        {
            _validFeet=bol;
            break;
        }
        default:
        {   _validInches=bol;
            break;
        }
    }
    
    computeResult();
    
} 

private function computeResult():void{    
    var total:Number=0;
    _qty=_validQty?new Number(txtQuantity.text):0;
    _feet=int(txtFeet.text)>0 && _validFeet?int(txtFeet.text):0;
    _inches=int(txtInches.text)>0 && _validInches?new Number(txtInches.text):0;
    switch(cboQuantity.selectedIndex)
    {
        case 0:
        {
            total=_qty*15.2587;
            break;
        }
        case 1:
        {
            total=((_feet+(_inches*12))*.08)*15.2587;
            break;
        } 
        default:
        {   total=(_feet+(_inches*12))*15.2587;
            break;
        }
    }
    if(total>0 && _validFeet && _validInches && _validQty){
         strResult=String(formatResult.format(total));
    }else{
        strResult="pending...";
    }
    trace("computeResult",strResult);
}
private function checkQtyOpt():void{
    trace("selected qtyopt",cboQuantity.selectedIndex);
    switch(cboQuantity.selectedIndex)
    {
        case 0:
        {
            txtQty_validator.domain="int";
            txtQty_validator.maxValue=99999;
            _validFeet=true;
            _validInches=true;
            break;
        }
            
        case 1:
        {
            txtQty_validator.domain="real";
            txtQty_validator.fractionalDigits=3;
            txtQty_validator.maxValue=9999.999;
            _validQty=true;
            break;
        }
    }
    computeResult();
}
private function format():void{
    if(cboQuantity.selectedIndex>0 && txtQuantity.text!="" && _validQty){
        txtQuantity.text=formatQuantity.format(txtQuantity.text);
    }
}
private function submitForm():void{
    if(validateForm()){       
        resetForm();
        Alert.show("Form Finished!");
    }
}
private function validateForm():Boolean{
    
    if(txtFeet.enabled==true && !_check){txtFeet_validator.enabled=true;}
    if(txtInches.enabled==true && !_check){txtInches_validator.enabled=true;}
    
    var validatorErrors:Array=Validator.validateAll(_arrValidators);
    txtYesNo_validator.validate();
    if(!validYesNo){
        txtYesNo.setFocus();
    }else if(!_validFeet){
        txtFeet.setFocus();
    }else if(!_validInches){
        txtInches.setFocus();
    }else if(!_validQty){
        txtQuantity.setFocus();
    }
    if(validatorErrors.length==0 && validYesNo)return true;
    return false;
    
}
private function resetForm():void{
    _check=false;
    _validQty=false;
    _validFeet=false;
    _validInches=false;
    validYesNo=false;
    lblFeet.enabled=true;
    txtFeet.enabled=true;
    lblInches.enabled=true;
    txtInches.enabled=true;
    txtYesNo.text="";
    txtFeet.text="";
    txtInches.text="";
    txtQuantity.text="";
    strResult="pending...";
    txtFeet.enabled=true;
    txtInches.enabled=true;
    lblExtendedValue.text=strResult;
    cboItemType.selectedIndex=2;
    cboQuantity.selectedIndex=0;
    resetValidationWarnings();  
    initialFocus();
    
}
private function resetValidationWarnings():void{
    for each(var validator:NumberValidator in _arrValidators){
        validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
    }
    txtYesNo_validator.dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
    txtYesNo_validator.enabled=false;
}