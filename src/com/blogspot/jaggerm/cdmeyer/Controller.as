package com.blogspot.jaggerm.cdmeyer
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.Decade;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenPair;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.screens.TopScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear.InductionDecade;
	import com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear.InductionYear;
	import com.blogspot.jaggerm.cdmeyer.views.screens.mainScreen.MainScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.namesScreen.NamesScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.sports.SportsScreen;
	
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;

	public class Controller implements IEventDispatcher
	{
		private var _screenWidth : Number;
		private var _screenHeight : Number;
				
		private var screens : Object = {};
		
		private var _settings : XML;
		
		public var athletes : Array = [];
		public var sports : Array = [];
		public var decades : Array = [];
		
		
		private var _ed:EventDispatcher;
		static private var _instance : Controller;
		
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
		
		public function Start(settings : XML, screenWidth : Number, screenHeight : Number) : void
		{
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			_settings = settings;
			CreateScreen('main_menu');
		}
		
		public function Atheles(rawData : XML) : void
		{
			for each(var item : XML in rawData[0].item)
			{
				athletes.push(new Athlete(item));
			}
		}
		
		public function Sports(rawData : XML) : void
		{
			for each(var item : XML in rawData[0].item)
			{
				sports.push(item);
			}
		}
		
		public function Years(rawData : XML) : void
		{
			for each(var item : XML in rawData[0].decade)
			{
				var d : Decade = new Decade();
				d.id = Number(item.@id);
				for each(var year : XML in item[0].year)
				{
					d.years.push(Number(year));
				}
				decades.push(d);
			}
		}
		
		public function CreateScreen(id : String) : void
		{	
			if(screens['main_menu'] != undefined)
			{
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.REMOVE_BOTTOM_SCREEN));
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.REMOVE_TOP_SCREEN));
			}
			
			if(screens[id] != undefined)
			{
				AddPair(id, screens[id].topScr, screens[id].botScr); 
				return;
			}
			
			var screenSettings : ScreenSettings;
			var e : CDMeyerEvent;
			var bottomScreen : ScreenView;

			switch(id)
			{
				case 'main_menu':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='main_menu'));			
					
					bottomScreen = new MainScreen(screenSettings, _screenWidth, _screenHeight);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_NAMES_SCREEN, ShowNamesScreen);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_SPORTS_SCREEN, ShowSportsScreen);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_YEARS_SCREEN, ShowYearsScreen);
					
				break;
			
				case 'names':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='names'));			
					
					bottomScreen = new NamesScreen(screenSettings, _screenWidth, _screenHeight);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen);										
					
				break;
				
				case 'sports':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='sports'));			
					
					bottomScreen = new SportsScreen(screenSettings, _screenWidth, _screenHeight);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen);										
					SportsScreen(bottomScreen).sports = sports;
					break;
				
				case 'years':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='years'));			
					
					bottomScreen = new InductionDecade(screenSettings, _screenWidth, _screenHeight);										
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen);										
					InductionDecade(bottomScreen).decades = decades;
					break;
			}
			
			var topScr : TopScreen = new TopScreen(screenSettings, _screenWidth, _screenHeight);
			
			var scrPair : ScreenPair = new ScreenPair();
			scrPair.topScr = topScr;
			scrPair.botScr = bottomScreen;
			
			screens[id] = scrPair;
			
			AddPair(id, topScr, bottomScreen);
		}
		
		private function ShowMainScreen(e : CDMeyerEvent) : void
		{
			CreateScreen('main_menu');
		}
		
		private function AddPair(id : String, topScr : ScreenView, botScr : ScreenView) : void
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
			CreateScreen('names');
		}
		
		private function ShowSportsScreen(event : CDMeyerEvent) : void
		{
			CreateScreen('sports');			
		}
		
		private function ShowYearsScreen(event : CDMeyerEvent) : void
		{
			CreateScreen('years');			
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