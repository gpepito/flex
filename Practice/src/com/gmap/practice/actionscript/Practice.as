import com.gmap.practice.customevents.AddItemFormEvent;
import com.gmap.practice.mxml.AddItemForm;
import com.gmap.practice.skin.CustomProgressBarSkin;
import com.gmap.practice.utils.XmlUtil;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileReference;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.ProgressBar;
import mx.controls.ProgressBarMode;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.XMLUtil;

import org.osmf.events.TimeEvent;

import spark.components.TitleWindow;

[Bindable] public var arrType:ArrayCollection=new ArrayCollection(["kids","adults"]);
[Bindable] public var arrGenre:ArrayCollection=new ArrayCollection(["romance","scifi","horror","fantasy"]);
[Bindable]private var _bookXML:XML=new XML();
[Bindable]private var _xmlCollection:XMLListCollection=new XMLListCollection();

private var _titleWindow:TitleWindow=new TitleWindow();
private var _itemForm:AddItemForm=new AddItemForm();
private var _progressBar:CustomProgressBarSkin=new CustomProgressBarSkin();

private var _xmlutil:XmlUtil=new XmlUtil();
private var _timer:Timer;



/*[Embed("/../../commons/images/spinner_blue.gif")]
[Bindable]public var SpinnerImage:Class;*/

private function addItem(e:Event):void{
    
    PopUpManager.addPopUp(_titleWindow, this, true);
    PopUpManager.centerPopUp(_titleWindow);
}

protected function initial(event:FlexEvent):void
{       
    _bookXML=_xmlutil.getXML(File.applicationStorageDirectory.resolvePath("xml/Books.xml"));
    
    _itemForm.addEventListener(AddItemFormEvent.EVENT_SAVE,function():void{
        PopUpManager.removePopUp(_titleWindow);
        var xmlObj:Object=_itemForm.xmlItem;
        booksCollection.addItemAt(xmlObj,0);
    });
    _titleWindow.addElement(_itemForm);
    _titleWindow.addEventListener(CloseEvent.CLOSE,
        function():void{        
            _itemForm.clearForm();
            PopUpManager.removePopUp(_titleWindow);        
        });
    
    //initialize progressBar
    _progressBar.width=200;
    _progressBar.height=200;
    
    
}
private function startTimer():void{
    _timer=new Timer(500);
    _timer.addEventListener(TimerEvent.TIMER,updateTimer);
    _timer.start();
}
private function stopTimer():void{
    _timer.stop();
}
private function updateTimer(event:TimerEvent):void{
    switch(_timer.currentCount)
    {
        case 1:
        {
            showProgressDialog();
            break;
        }
            
        case 5:
        {
            stopTimer();
            PopUpManager.removePopUp(_progressBar);
            break;
        }
    }    
    if(_timer.currentCount>5){
        stopTimer();
    }
}

private function deleteItem():void{
    var arr:Array=new Array();
    booksCollection.refresh();
    arr=adg.selectedIndices;
    var arrSize:int=arr.length;
    for(var i:int=0;i<=arrSize-1;i++){
        trace(booksCollection.getItemAt(arr[i]).@name+"-----item");        
        booksCollection.removeItemAt(arr[i]);
    }
}
private function disableEdit():void{
    adg.editable="false";
}
private function editItem():void{
    adg.editable="true";
}
private function saveItems():void{
    startTimer();
    
    var file:File=File.applicationStorageDirectory.resolvePath("xml/Books.xml");
    var fileStream:FileStream=new FileStream();
    var xml:XML=new XML('<?xml version="1.0" encoding="utf-8"?>\n<books/>');
    
    xml.appendChild(new XML('<list>'+booksCollection.toXMLString()+'</list>'));
    _xmlutil.saveXML(file,xml);
    
}
private function showProgressDialog():void{
    PopUpManager.addPopUp(_progressBar,this,true);
    PopUpManager.centerPopUp(_progressBar);
}

protected function myservice_resultHandler(event:ResultEvent):void
{
    var xml:XML=new XML(event.result);
    _xmlCollection=new XMLListCollection(xml.list.book);
    
}

