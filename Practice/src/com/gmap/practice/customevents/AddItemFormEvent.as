package com.gmap.practice.customevents
{
    import flash.events.Event;

    public class AddItemFormEvent extends Event
    {
        public static const EVENT_SAVE:String="save";
        public static const EVENT_DEFAULT:String="default";
        public function AddItemFormEvent(type:String=AddItemFormEvent.EVENT_DEFAULT,bubbles:Boolean=false,cancelable:Boolean=false)
        {
            super(type,bubbles,cancelable);
        }
        override public function clone():Event{
            trace("Dispatched::::AddItemFormEvent.EVENT_SAVE");
            return new AddItemFormEvent(type,bubbles,cancelable);
        }
    }
}