package com.blogspot.jaggerm.cdmeyer
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenPair;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.screens.TopScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.mainScreen.MainScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.namesScreen.NamesScreen;
	
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;

	public class Controller implements IEventDispatcher
	{
		static private var _instance : Controller;
		private var screens : Array = [];
		private var _settings : XML;
		public var athletes : Array = [];
		
		private var _ed:EventDispatcher;
		
		public function Controller()
		{
//			if(_instance != null)
//				throw new Error('trying to create instance of Controller. Use Controller.getInstance()');
				
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
			CreateScreen(0);
		}
		
		public function Atheles(rawData : XML) : void
		{
			for each(var item : XML in rawData[0].item)
			{
				athletes.push(new Athlete(item));
			}
		}
		
		public function CreateScreen(id : uint) : void
		{	
			if(screens.length != 0)
			{
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.REMOVE_BOTTOM_SCREEN));
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.REMOVE_TOP_SCREEN));
			}
			
			if(id < screens.length)
			{
				AddPair(id, screens[id].topScr, screens[id].botScr); 
				return;
			}
			
			var screenSettings : ScreenSettings;
			var e : CDMeyerEvent;
			var bottomScreen : ScreenView;

			switch(id)
			{
				case 0:
					screenSettings = new ScreenSettings(_settings.screen.(@id=='main_menu'));			
					
					bottomScreen = new MainScreen();
					bottomScreen.settings = screenSettings;
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_NAMES_SCREEN, ShowNamesScreen);
					
				break;
			
				case 1:
					screenSettings = new ScreenSettings(_settings.screen.(@id=='names'));			
					
					bottomScreen = new NamesScreen();
					bottomScreen.settings = screenSettings;
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen);										
					
				break;
			}
			
			var topScr : TopScreen = new TopScreen();
			topScr.settings = screenSettings;
			
			var scrPair : ScreenPair = new ScreenPair();
			scrPair.topScr = topScr;
			scrPair.botScr = bottomScreen;
			
			screens.push(scrPair);
			
			AddPair(id, topScr, bottomScreen);
		}
		
		private function ShowMainScreen(e : CDMeyerEvent) : void
		{
			CreateScreen(0);
		}
		
		private function AddPair(id : uint, topScr : ScreenView, botScr : ScreenView) : void
		{
			var e : CDMeyerEvent = new CDMeyerEvent(CDMeyerEvent.ADD_TOP_SCREEN);
			e.screen = topScr;
			dispatchEvent(e);
			
			e = new CDMeyerEvent(CDMeyerEvent.ADD_BOTTOM_SCREEN);
			e.screen = botScr;
			dispatchEvent(e);			
		}
		
		private function ShowNamesScreen(event : CDMeyerEvent) : void
		{
			CreateScreen(1);
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