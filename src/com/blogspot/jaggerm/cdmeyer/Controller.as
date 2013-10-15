package com.blogspot.jaggerm.cdmeyer
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.screens.mainScreen.MainScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.namesScreen.NamesScreen;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;

	public class Controller implements IEventDispatcher
	{
		static private var _instance : Controller;
		private var screens : Array = [];
		private var _settings : XML;
		
		private var _ed:EventDispatcher;
		
		public function Controller()
		{
			if(_instance != null)
				throw new Error('trying to create instance of Controller. Use Controller.getInstance()');
				
			_ed = new EventDispatcher();
			
			
//			settings = new XML();
//			settings.source = 'screens.xml';
//			
//			Notify(settings.toString());
		}
		
		static public function getInstance() : Controller
		{
			if(_instance == null)
			{
				_instance = new Controller();
			}
			
			return _instance;
		}
		
		public function Start(settings : XML) : void
		{
			_settings = settings;
			CreateScreen(1);
		}
		
		public function CreateScreen(id : uint) : void
		{	
			var screenSettings : ScreenSettings;
			var e : CDMeyerEvent;
			//Alert.show(_settings.screen.(@id=='main_menu'));
			switch(id)
			{
				case 1:
					screenSettings = new ScreenSettings(_settings.screen.(@id=='main_menu'));			
					var main_screen : MainScreen = new MainScreen();
					main_screen.settings = screenSettings;
					main_screen.addEventListener(CDMeyerEvent.SHOW_NAMES_SCREEN, ShowNamesScreen);
					
					e = new CDMeyerEvent(CDMeyerEvent.ADD_SCREEN);
					e.screen = main_screen;
					dispatchEvent(e);
				break;
			
				case 2:
					screenSettings = new ScreenSettings(_settings.screen.(@id=='names'));			
					var names_screen : NamesScreen = new NamesScreen();
					names_screen.settings = screenSettings;
					
					e = new CDMeyerEvent(CDMeyerEvent.ADD_SCREEN);
					e.screen = names_screen;
					dispatchEvent(e);
				break;
			}
		}
		
		private function ShowNamesScreen(event : CDMeyerEvent) : void
		{
			CreateScreen(2);
		}
		
		public function addEventListener(type:String, listener:Function,
								  useCapture:Boolean=false, priority:int=0,
								  useWeakReference:Boolean=false):void
		{
			_ed.addEventListener(type,
				listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function,
								useCapture:Boolean=false):void
		{
			_ed.removeEventListener(type, listener,
				useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _ed.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return 	_ed.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _ed.willTrigger(type);
		}
		
		public function Notify(value : String) : void
		{
			Alert.show(value);
		}
	}
}