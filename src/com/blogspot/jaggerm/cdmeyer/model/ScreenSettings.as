package com.blogspot.jaggerm.cdmeyer.model
{
	import mx.controls.Alert;

	public class ScreenSettings
	{
		public var topBackgroundImage : String;
		public var botBackgroundImage : String;
		public var top_logo : String;
		public var instructions : String;
		
		public function ScreenSettings(settings : XMLList)
		{
			
			topBackgroundImage = settings.top_bg[0];
			botBackgroundImage = settings.bot_bg[0];
			top_logo = settings.top_logo[0];
			instructions = settings.instructions[0];

//			Alert.show(backgroundImage);
		}
	}
}