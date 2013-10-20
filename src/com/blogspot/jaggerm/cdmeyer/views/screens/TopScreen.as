package com.blogspot.jaggerm.cdmeyer.views.screens
{
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	
	import spark.components.Image;

	
	public class TopScreen extends ScreenView
	{
		private var topLogo : Image;
		public function TopScreen()
		{
			super();
		}
		
		override protected function DrawTopLogo() : void
		{
			topLogo = new Image();
			topLogo.source = cdmeyer.APP_PATH + settings.top_logo;			
			addElement(topLogo);
		}
		
		override protected function measure():void
		{
			topLogo.x = (width - topLogo.width) / 2;
			topLogo.y = (height - topLogo.height) / 2;
		}
	}
}