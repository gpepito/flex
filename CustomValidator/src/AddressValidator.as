package
{
    import mx.validators.ValidationResult;
    import mx.validators.Validator;

    public class AddressValidator extends Validator
    {
        private var _results:Array;
        
        public function AddressValidator()
        {
            super();
        }
        override protected function doValidation(value:Object):Array{
            _results=[];
            _results=super.doValidation(value);
            
            if(value!=null){
                var pattern:RegExp = new RegExp("\\d+\\x20[A-Za-z]+", "");
                if(value.search(pattern) == -1){
                    _results.push(new ValidationResult (true, null, "notAddress", "This is not a valid US address"));
                }
            }               
            return _results;
        }
    }
}