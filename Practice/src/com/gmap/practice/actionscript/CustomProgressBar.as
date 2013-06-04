package com.gmap.practice.actionscript
{
    import com.gmap.practice.skin.CustomProgressBarSkin;
    
    import mx.controls.ProgressBar;
    
    public class CustomProgressBar extends ProgressBar
    {
        public function CustomProgressBar()
        {
            super();
            this.setStyle("barSkin",CustomProgressBarSkin);
            this.width=100;
            this.height=100;
        }
    }
}