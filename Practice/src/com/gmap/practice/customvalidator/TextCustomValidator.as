package com.gmap.practice.customvalidator
{
    import mx.validators.Validator;
    
    public class TextCustomValidator extends Validator
    {
        private var results:Array;
        public function TextCustomValidator()
        {
            super();
        }
        override protected function doValidation(value:Object):Array{
            var val:String=String(value);
            results=[];
            results=super.doValidation(val);
            
            if(results.length>0){
                return results;
            }            
            return results;
        }        
    }
}