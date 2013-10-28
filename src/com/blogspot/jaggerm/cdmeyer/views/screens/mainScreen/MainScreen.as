package com.blogspot.jaggerm.cdmeyer.views.screens.mainScreen
{
	import com.blogspot.jaggerm.cdmeyer.controls.imageButton.ImageButton;
	import com.blogspot.jaggerm.cdmeyer.controls.imageButton.RoundButton;
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
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
		
		private var btn1 : Button;
		private var btn2 : Button;
		private var btn3 : Button;
		
		public function MainScreen(value : ScreenSettings)
		{
			super(value);
		}
		
		override public function draw() : void
		{
			super.draw();
			
			btn1 = new Button();
			btn1.setStyle('skinClass', Button1Skin);			
			btn1.addEventListener(MouseEvent.CLICK, btn1Clicked);
			addElement(btn1);
			
			btn2= new Button();
			btn2.setStyle('skinClass', Button2Skin);
			btn2.addEventListener(MouseEvent.CLICK, btn2Clicked);
			addElement(btn2);
			
			btn3 = new Button();
			btn3.setStyle('skinClass', Button3Skin);
			btn3.addEventListener(MouseEvent.CLICK, btn3Clicked);
			addElement(btn3);
			
			sortBy = new Image();
			sortBy.source = sortByClass;			
			addElement(sortBy);
						
		}
		
		override protected function measure() : void
		{
			super.measure();
			sortBy.width = 221.5;
			sortBy.height = 44;
			sortBy.x = 400;
			sortBy.y = 700;
			
//			btn1.width = 300;
			btn1.x = 100;
			btn1.y = 300;
			
//			btn2.width = 300;
			btn2.x = btn1.x + btn1.width + 100;
			btn2.y = 300;
			
//			btn3.width = 300;
			btn3.x = btn2.x + btn2.width + 100;
			btn3.y = 300;

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