package
{
    public class ServiceApplication
    {
        private static var _instance:ServiceApplication;
        private var _empId:int;

        public function get empId():int
        {
            return _empId;
        }

        public function set empId(value:int):void
        {
            _empId = value;
        }

        public static function get instance():ServiceApplication
        {
            if(_instance==null){
                _instance=new ServiceApplication();
            }
            return _instance;
        }


    }
}