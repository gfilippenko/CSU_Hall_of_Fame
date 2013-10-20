package com.blogspot.jaggerm.cdmeyer.views.screens.mainScreen
{
	import com.blogspot.jaggerm.cdmeyer.controls.imageButton.ImageButton;
	import com.blogspot.jaggerm.cdmeyer.controls.imageButton.RoundButton;
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	
	import spark.components.Button;
	import spark.components.Image;
	

	
	public class MainScreen extends ScreenView
	{
		[Embed(source="../../../../../../../resources/sport_by.png")]
		private var sortByClass : Class;
		private var sortBy : Image;
		
		public function MainScreen()
		{
			super();
		}
		
		override public function draw() : void
		{
			super.draw();
			
			var btn1 : Button = new Button();
			btn1.setStyle('skinClass', Button1Skin);
			btn1.width = 300;
			btn1.x = 100;
			btn1.y = 300;
			btn1.addEventListener(MouseEvent.CLICK, btn1Clicked);
			addElement(btn1);
			
			var btn2 : Button = new Button();
			btn2.setStyle('skinClass', Button2Skin);
			btn2.width = 300;
			btn2.x = btn1.x + btn1.width + 100;
			btn2.y = 300;
			btn2.addEventListener(MouseEvent.CLICK, btn2Clicked);
			addElement(btn2);
			
			var btn3 : Button = new Button();
			btn3.setStyle('skinClass', Button3Skin);
			btn3.width = 300;
			btn3.x = btn2.x + btn2.width + 100;
			btn3.y = 300;
			btn3.addEventListener(MouseEvent.CLICK, btn3Clicked);
			addElement(btn3);
			
			sortBy = new Image();
			sortBy.source = sortByClass;			
			addElement(sortBy);
						
		}
		
		override protected function measure() : void
		{
			super.measure();
			sortBy.x = 300;
			sortBy.y = 600;
		}
		
		private function btn1Clicked(event : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_NAMES_SCREEN));
		}
		
		private function btn2Clicked(event : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_SPORTS_SCREEN));
		}
		
		private function btn3Clicked(event : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_YEARS_SCREEN));
		}
	}
}