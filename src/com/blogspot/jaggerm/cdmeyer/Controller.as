package com.blogspot.jaggerm.cdmeyer
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.Decade;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenPair;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.screens.TopScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.athlete.AthleteScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.athlete.AthleteTop;
	import com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear.InductionDecade;
	import com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear.InductionYear;
	import com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear.YearScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.mainScreen.MainScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.namesScreen.NamesScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.sports.SportScreen;
	import com.blogspot.jaggerm.cdmeyer.views.screens.sports.SportsScreen;
	
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.ReturnKeyLabel;
	
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
		
		public function CreateScreen(id : String, screenLabel : String = null, decade : Decade = null) : void
		{	
			if(screens['main_menu'] != undefined)
			{
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.REMOVE_BOTTOM_SCREEN));
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.REMOVE_TOP_SCREEN));
			}
			
			if(screens[id] != undefined)
			{
				if(id == 'sport')
					SportScreen(screens[id].botScr).label = screenLabel;
				if(id == 'year')
					YearScreen(screens[id].botScr).label = screenLabel;
				if(id == 'years_of_decade')
					InductionYear(screens[id].botScr).decade = decade;
				
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
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_ATHLETE, ShowAthleteScreen);
					
				break;
				
				case 'sports':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='sports'));			
					
					bottomScreen = new SportsScreen(screenSettings, _screenWidth, _screenHeight);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_SPORT_SCREEN, ShowSportScreen);

					SportsScreen(bottomScreen).sports = sports;
					break;
				
				case 'decades':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='decades'));			
					
					bottomScreen = new InductionDecade(screenSettings, _screenWidth, _screenHeight);										
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen);	
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_YEARS_OF_DECADE, ShowYearsOfDecadeScreen);
					InductionDecade(bottomScreen).decades = decades;
					break;
				
				case 'sport':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='sport'));			
					
					bottomScreen = new SportScreen(screenSettings, _screenWidth, _screenHeight);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_SPORTS_SCREEN, ShowSportsScreen);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_ATHLETE, ShowAthleteScreen);
					SportScreen(bottomScreen).label = screenLabel;
					break;
				
				case 'years_of_decade':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='years'));			
					
					bottomScreen = new InductionYear(screenSettings, _screenWidth, _screenHeight);										
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen);	
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_YEARS_SCREEN, ShowYearsScreen);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_SPORT_YEAR, ShowYearScreen);
					InductionYear(bottomScreen).SetController(this);
					InductionYear(bottomScreen).decade = decade;
					break;
				
				case 'year':
					screenSettings = new ScreenSettings(_settings.screen.(@id=='year'));
					bottomScreen = new YearScreen(screenSettings, _screenWidth, _screenHeight);
					YearScreen(bottomScreen).label = screenLabel;
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_YEARS_OF_DECADE, ShowYearsOfDecadeScreen);
					bottomScreen.addEventListener(CDMeyerEvent.SHOW_ATHLETE, ShowAthleteScreen);
					break;
			}
			
			var topScr : TopScreen = new TopScreen(screenSettings, _screenWidth, _screenHeight);
			
			var scrPair : ScreenPair = new ScreenPair();
			scrPair.topScr = topScr;
			scrPair.botScr = bottomScreen;
			
			screens[id] = scrPair;
			
			AddPair(id, topScr, bottomScreen);
		}
		
		public function HasYear(year : String) : Boolean
		{
			for each(var item : Athlete in athletes)
			{
				if(item.year == year)
					return true;
			}
			
			return false;
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
			CreateScreen('decades');			
		}
		
		private function ShowSportScreen(event : CDMeyerEvent) : void
		{
			CreateScreen('sport', event.screenLabel);
		}
		
		private function ShowYearsOfDecadeScreen(event : CDMeyerEvent) : void
		{
			CreateScreen('years_of_decade', null, GetDecade(Number(event.decadeID)));
		}
		
		private function ShowYearScreen(event : CDMeyerEvent) : void
		{
			CreateScreen('year', String(event.year));
		}
		
		private function ShowAthleteScreen(event : CDMeyerEvent) : void
		{
			if(screens['main_menu'] != undefined)
			{
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.REMOVE_BOTTOM_SCREEN));
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.REMOVE_TOP_SCREEN));
			}
			
			if(screens['athlete'] != undefined)
			{
				AthleteScreen(screens['athlete'].botScr).athlete = GetAthlete(event.lastName, event.sport);
				AthleteTop(screens['athlete'].topScr).athlete = GetAthlete(event.lastName, event.sport);
				

				
				if(event.currentTarget is NamesScreen)
					AthleteScreen(screens['athlete'].botScr).backScreen = 'names';
				if(event.currentTarget is YearScreen)
					AthleteScreen(screens['athlete'].botScr).backScreen = 'year';
				if(event.currentTarget is SportScreen)
					AthleteScreen(screens['athlete'].botScr).backScreen = 'sport';
				
				AddPair('athlete', screens['athlete'].topScr, screens['athlete'].botScr); 
				return;
			}
			
			var screenSettings : ScreenSettings = new ScreenSettings(_settings.screen.(@id=='athlete'));
			
			var athleteScreen : AthleteScreen = new AthleteScreen(screenSettings, _screenWidth, _screenHeight);
			athleteScreen.addEventListener(CDMeyerEvent.SHOW_MAIN_SCREEN, ShowMainScreen, false, 0, true);
			athleteScreen.addEventListener(CDMeyerEvent.SHOW_NAMES_SCREEN, ShowNamesScreen, false, 0, true);
			athleteScreen.addEventListener(CDMeyerEvent.SHOW_SPORT_YEAR, ShowYearScreen, false, 0, true);
			athleteScreen.addEventListener(CDMeyerEvent.SHOW_SPORT_SCREEN, ShowSportScreen, false, 0, true);
				
			var athlete : Athlete = GetAthlete(event.lastName, event.sport); 
			athleteScreen.athlete = athlete;
			
			if(event.currentTarget is NamesScreen)
				athleteScreen.backScreen = 'names';
			if(event.currentTarget is YearScreen)
				athleteScreen.backScreen = 'year';
			if(event.currentTarget is SportScreen)
				athleteScreen.backScreen = 'sport';
			
			var athleteTop : AthleteTop = new AthleteTop(screenSettings, _screenWidth, _screenHeight);
			athleteTop.athlete = athlete;
						
			var scrPair : ScreenPair = new ScreenPair();
			scrPair.topScr = athleteTop;
			scrPair.botScr = athleteScreen;
			screens['athlete'] = scrPair;	
			
			
			AddPair('athlete', athleteTop, athleteScreen);
		}
		
		private function GetAthlete(lastName : String, sport : String) : Athlete
		{
			for each(var item : Athlete in athletes)
			{
				if(item.lastName.toUpperCase() == lastName.toUpperCase())
					return item;
			}
			
			return null
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
		
		public function GetDecade(id : uint) : Decade
		{
			for each(var d : Decade in decades)
			{
				if(d.id == id)
					return d;
			}
			
			return null;
		}
	}
}