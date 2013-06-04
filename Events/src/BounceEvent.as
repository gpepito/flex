package
{
    import flash.events.Event;
    
    public class BounceEvent extends Event
    {
        public static const BOUNCE:String = "bounce";
        
        private var _side:String = "none";
        
        public function get side():String {
            return _side;
        }
        
        public function BounceEvent(type:String, side:String){
            super(type, true);
            _side = side;
        }
        
        public override function clone():Event {
            return new BounceEvent(type, _side);
        }
    }
}