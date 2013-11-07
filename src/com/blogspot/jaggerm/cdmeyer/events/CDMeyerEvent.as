package com.blogspot.jaggerm.cdmeyer.events
{
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	
	import flash.events.Event;
	
	public class CDMeyerEvent extends Event
	{
		public static const ADD_TOP_SCREEN : String = 'addTopScreen';
		public static const ADD_BOTTOM_SCREEN : String = 'addBottomScreen';
		public static const REMOVE_TOP_SCREEN : String = 'removeTopScreen';
		public static const REMOVE_BOTTOM_SCREEN : String = 'removeBottomScreen';
		
		public static const SHOW_MAIN_SCREEN : String = 'showMainScreen';
		public static const SHOW_NAMES_SCREEN : String = 'showNamesScreen';
		public static const SHOW_SPORTS_SCREEN : String = 'showSportsScreen';
		public static const SHOW_YEARS_SCREEN : String = 'showYearsScreen';
		public static const SHOW_YEARS_OF_DECADE : String = 'showYearsOfDecade';
		
		public static const SHOW_SPORT_SCREEN : String = 'showSportScreen';
		public static const SHOW_SPORT_YEAR : String = 'showYearScreen';
		
		public static const SORT_LIST : String = 'sortAthletesList';
		
		public static const SHOW_ATHLETE : String = 'showAthelete';
		public static const SHOW_ATHLETE_VIDEO : String = 'showAtheleteVideo';
		
		public var screen : ScreenView;
		public var sortParam : String;
		public var screenLabel : String;
		public var decadeID : uint;
		public var year : uint;
		public var sport : String;
		public var lastName : String;
				
		public function CDMeyerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}