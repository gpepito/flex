package components
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import spark.components.Button;
    import spark.components.Group;
    import spark.components.HGroup;
    import spark.components.Label;
    import spark.components.VGroup;

    [Event(name="fontSizeChanged", type="flash.events.Event")]

    public class StopWatchAS extends Group
    {
        private var _vgroup:VGroup;
        private var _hgroup:HGroup;
        private var _hgroupControls:HGroup;
        
        private var _lblMinutes:Label;
        private var _lblSeparator:Label;
        private var _lblSeconds:Label;
        private var _lblSeparator2:Label;
        private var _lblMilli:Label;
        
        private var _btnStart:Button;
        private var _btnStop:Button;
        private var _btnReset:Button;
        
        private var _swFontSize:int=50;
        
       [Bindable] private var _min:int=00;
       [Bindable] private var _sec:int=00;
       [Bindable] private var _millisec:int=00;
        
        private var _stopTime:Number=0;
        private var _startTime:Number=0;       
        private var _timer:Timer;
        private var _date:Date;
        
        
        public function StopWatchAS()
        {
            super();
        }        

        override protected function createChildren():void{
            super.createChildren();
            
            _timer=new Timer(10);
            _timer.addEventListener(TimerEvent.TIMER,processTimer);
            
            _vgroup=new VGroup();   
            _vgroup.percentWidth=100;
            _vgroup.percentHeight=100;
            
            _hgroup=new HGroup();      
            _hgroup.verticalAlign="middle";
            _hgroup.horizontalAlign="center";
            _hgroup.percentWidth=100;
            _hgroup.percentHeight=60;
            
            _hgroupControls=new HGroup();
            _hgroupControls.verticalAlign="middle";
            _hgroupControls.horizontalAlign="center";
            _hgroupControls.percentWidth=100;
            _hgroupControls.percentHeight=40;  
            
            _lblMinutes=new Label();
            _lblMinutes.text=zeroPad(_min);
            _lblMinutes.percentWidth=20;
            _lblMinutes.setStyle("textAlign","center");
            
            _lblSeparator=new Label();
            _lblSeparator.text=":";
            _lblSeparator.percentWidth=20;
            _lblSeparator.setStyle("textAlign","center");
            
            _lblSeconds=new Label();
            _lblSeconds.text=zeroPad(_sec);
            _lblSeconds.percentWidth=20;
            _lblSeconds.setStyle("textAlign","center");
            
            _lblSeparator2=new Label();
            _lblSeparator2.text=":";
            _lblSeparator2.percentWidth=20;
            _lblSeparator2.setStyle("textAlign","center");
            
            _lblMilli=new Label();
            _lblMilli.text=zeroPad(_millisec);
            _lblMilli.percentWidth=20;
            _lblMilli.setStyle("textAlign","center");
            
            _btnStart=new Button();
            _btnStart.label="Start";
            _btnStart.addEventListener(MouseEvent.CLICK,startTimer);
            _btnStart.percentWidth=20;
            _btnStart.percentHeight=30;
            
            _btnStop=new Button();
            _btnStop.label="Stop";
            _btnStop.addEventListener(MouseEvent.CLICK,stopTimer);
            _btnStop.percentWidth=20;
            _btnStop.percentHeight=30;
            
            _btnReset=new Button();
            _btnReset.label="Reset";
            _btnReset.addEventListener(MouseEvent.CLICK,reset);
            _btnReset.percentWidth=20;
            _btnReset.percentHeight=30;
            
            _hgroup.addElement(_lblMinutes);
            _hgroup.addElement(_lblSeparator);
            _hgroup.addElement(_lblSeconds);
            _hgroup.addElement(_lblSeparator2);
            _hgroup.addElement(_lblMilli);
            
            _vgroup.addElement(_hgroup);
            
            _hgroupControls.addElement(_btnStart);
            _hgroupControls.addElement(_btnStop);
            _hgroupControls.addElement(_btnReset);
            
            _vgroup.addElement(_hgroupControls);
            addElement(_vgroup);
            
        }
        
        override protected function commitProperties():void{
            super.commitProperties();
            
            if(isFontSet)
            {
                _lblMinutes.setStyle("fontSize",_swFontSize);
                _lblSeparator.setStyle("fontSize",_swFontSize);
                _lblSeconds.setStyle("fontSize",_swFontSize);     
                _lblSeparator2.setStyle("fontSize",_swFontSize);  
                _lblMilli.setStyle("fontSize",_swFontSize);
                isFontSet = false;
                dispatchEvent(new Event("fontSizeChanged"));
            }
            if(isTimeChanged){                
                _lblMinutes.text=zeroPad(_min);
                _lblSeconds.text=zeroPad(_sec);
                _lblMilli.text=zeroPad(_millisec);
                dispatchEvent(new Event("timerChanged"));
            }
            
            /*invalidateDisplayList();*/
          
        }
        
        private var isTimeChanged:Boolean;
        private function processTimer(event:TimerEvent):void{
            _date=new Date(getTimer()-_startTime+_stopTime);
            _min=_date.minutes;
            _sec=_date.seconds;
            _millisec=_date.milliseconds;
            isTimeChanged=true;
            invalidateProperties();
            
            
        }
        public function startTimer(event:MouseEvent):void{    
            _startTime=getTimer();
            _timer.start();
        }
        
        public function stopTimer(event:MouseEvent):void{
            _stopTime=_min * 60000 + _sec * 1000 + _millisec;                
            _timer.stop();
        }
        
        public function reset(event:MouseEvent):void{
            _timer.stop();
            
            _startTime=0;
            _stopTime=0;                  
            _min=0;
            _sec=0;
            _millisec=0;   
            invalidateProperties();
        }   
        
        public function zeroPad(number:int):String {
            var ret:String = ""+number;
            while( ret.length < 2 )
                ret="0" + ret;
            return ret;
        }
        
        [Bindable(event="fontSizeChanged")]
        public function get swFontSize():int
        {
            return _swFontSize;
        }
        
        private var isFontSet:Boolean;
        public function set swFontSize(value:int):void
        {
            _swFontSize = value;
            isFontSet = true;
            invalidateProperties();            
        }

        [Bindable(event="timerChanged")]
        public function get min():int
        {
            return _min;
        }
        [Bindable(event="timerChanged")]
        public function get sec():int
        {
            return _sec;
        }
        [Bindable(event="timerChanged")]
        public function get millisec():int
        {
            return _millisec;
        }

    }
}