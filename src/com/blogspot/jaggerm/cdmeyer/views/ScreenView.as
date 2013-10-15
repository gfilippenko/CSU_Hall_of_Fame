package com.blogspot.jaggerm.cdmeyer.views
{
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	
	import flash.desktop.NativeApplication;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.states.OverrideBase;
	
	import spark.components.Application;
	import spark.components.Group;
	import spark.components.WindowedApplication;
	

	public class ScreenView extends Group
	{
		protected var halfHeight  : Number;
		private var logoType : String = 'text';
		private var headText : String;
		private var headLogo : String;
		private var backgroundImage : Image;
		private var _settings : ScreenSettings;
		
		[Bindable]
		public function set settings(value : ScreenSettings) : void
		{
			_settings = value;
		}
		
		public function get settings() : ScreenSettings
		{
			return _settings;
		}
		
		public function ScreenView()
		{
//			width = 1920;
//			height = 2160;
			percentWidth = 100;
			percentHeight = 100;			
		}
		
		public function draw() : void
		{
			halfHeight = systemManager.stage.height/2;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			DrawBG();
			DrawTopLogo();
			draw();			
		}
		
		private function DrawBG(): void
		{
			backgroundImage = new Image();
			backgroundImage.percentWidth = 100;
			backgroundImage.percentHeight = 100;
			backgroundImage.x = 0;
			backgroundImage.y = 0;				
			backgroundImage.source = cdmeyer.APP_PATH + _settings.backgroundImage;
//			addChild(backgroundImage);
			addElement(backgroundImage);
		}
		
		private function DrawTopLogo() : void
		{
			var topLogo : Image = new Image();
			topLogo.source = cdmeyer.APP_PATH + _settings.top_logo;
			topLogo.percentWidth = 100;
			topLogo.percentHeight = 100;
			topLogo.x = (width - topLogo.width) / 2;
			topLogo.y = ((height/2) - topLogo.height) / 2;
//			addChild(topLogo);
			addElement(topLogo);
		}
	}
}