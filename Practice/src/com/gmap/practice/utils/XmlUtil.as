package com.gmap.practice.utils
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import mx.collections.XMLListCollection;
    
    public class XmlUtil
    {
        private var _fs:FileStream=new FileStream();
        public function XmlUtil()
        {
        }
        public function saveXML(path:File,xml:XML):void{
            _fs.open(path,FileMode.WRITE);   
            _fs.writeUTFBytes(xml.toString());
            _fs.close();
        }
        
        public function getXML(path:File):XML{
            _fs.open(path,FileMode.READ);
            var xmlList:XML=new XML(_fs.readUTFBytes(_fs.bytesAvailable));
            return xmlList;
        }
    }
}