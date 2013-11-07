package com.blogspot.jaggerm.cdmeyer.views.screens
{
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	
	import mx.graphics.BitmapFillMode;
	
	import spark.components.Image;

	
	public class TopScreen extends ScreenView
	{
		private var topLogo : Image;
		
		public function TopScreen(value : ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{
			super(value, _scrWidth, _scrHeight);
		}
		
		override protected function DrawTopLogo() : void
		{
			topLogo = new Image();
			topLogo.width = 1123.6;
			topLogo.height = 462;
			topLogo.x = (_screenWidth - 1123.6) / 2;
			topLogo.y = (_screenHeight - 462) / 2;
			topLogo.source = cdmeyer.APP_PATH + settings.top_logo;			
			addElement(topLogo);
		}
		
		override protected function DrawBG(): void
		{
			backgroundImage = new Image();
			backgroundImage.percentWidth = 100;
			backgroundImage.percentHeight = 100;
			backgroundImage.x = 0;
			backgroundImage.y = 0;		
			backgroundImage.scaleMode = BitmapFillMode.SCALE;
			backgroundImage.source = cdmeyer.APP_PATH + settings.topBackgroundImage;
			addElement(backgroundImage);
		}
		
	}
}