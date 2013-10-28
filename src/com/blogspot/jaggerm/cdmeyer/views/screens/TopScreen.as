package com.blogspot.jaggerm.cdmeyer.views.screens
{
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	
	import mx.graphics.BitmapFillMode;
	
	import spark.components.Image;

	
	public class TopScreen extends ScreenView
	{
		private var topLogo : Image;
		public function TopScreen(value : ScreenSettings)
		{
			super(value);
		}
		
		override protected function DrawTopLogo() : void
		{
			topLogo = new Image();
			topLogo.width = 1123.6;
			topLogo.height = 159.8;
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
		
		override protected function measure():void
		{
			
			topLogo.x = (width - topLogo.width) / 2;
			topLogo.y = (height - topLogo.height) / 2;
		}
	}
}