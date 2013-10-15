package com.blogspot.jaggerm.cdmeyer.events
{
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	
	import flash.events.Event;
	
	public class CDMeyerEvent extends Event
	{
		public static const ADD_SCREEN : String = 'addScreen';
		public static const SHOW_MAIN_SCREEN : String = 'showMainScreen';
		public static const SHOW_NAMES_SCREEN : String = 'showNamesScreen';
		
		public var screen : ScreenView;
		
		public function CDMeyerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}