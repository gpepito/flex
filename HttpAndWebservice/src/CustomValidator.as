package
{
    
    import mx.events.ValidationResultEvent;
    import mx.validators.NumberValidator;
    import mx.validators.Validator;
    
    import spark.components.TextInput;

    public class CustomValidator
    {
        private var _field:TextInput,_enabled:Boolean=false;
        private var _numValidator:NumberValidator;
        private var _validator:Validator;
        
        public function get validator():Validator
        {
            return _validator;
        }

        [Bindable]
        public function get enabled():Boolean
        {
            return _enabled;
        }

        public function set enabled(value:Boolean):void
        {
            _validator.enabled=value;
            _enabled = value;
        }

        [Bindable(event="change")]
        public function set field(txtInput:TextInput):void
        {
            _field=txtInput;
            switch(txtInput.id.toString())
            {
                case ValidatorName.LOGIN_USERNAME:
                {
                    _validator=new Validator();
                    _validator.enabled=false;
                    _validator.required=true;
                    _validator.requiredFieldError="required Field";
                    _validator.source=txtInput;
                    _validator.property="text";
                    _validator.validate();
                    break;
                }
                case ValidatorName.LOGIN_PASSWORD:
                {
                    _validator=new Validator();
                    _validator.enabled=false;
                    _validator.required=true;
                    _validator.requiredFieldError="required Field";
                    _validator.source=txtInput;
                    _validator.property="text";
                    _validator.validate();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
    /*    public function validate():void{
            switch(_field.id.toString())
            {
                case ValidatorName.LOGIN_USERNAME:
                {
                    _validator.validate();
                    break;
                }
                    
                default:
                {
                    break;
                }
            }
        }*/

    }
}