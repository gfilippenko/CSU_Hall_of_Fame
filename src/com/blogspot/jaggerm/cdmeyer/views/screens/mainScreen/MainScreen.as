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
		
		public function MainScreen(value : ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{
			super(value, _scrWidth, _scrHeight);
		}
		
		override public function draw() : void
		{
			super.draw();
			
			var startX : Number = 208;
			var startY : Number = 290;
			var shiftY : Number = 100;
			
			btn1 = new Button();
			btn1.label = 'NAME';
			btn1.x = startX;
			btn1.y = startY;
			btn1.setStyle('skinClass', Button1Skin);			
			btn1.addEventListener(MouseEvent.CLICK, btn1Clicked);
			addElement(btn1);
			
			btn2 = new Button();
			btn2.label = 'SPORT';
			btn2.setStyle('skinClass', Button1Skin);
			btn2.addEventListener(MouseEvent.CLICK, btn2Clicked);
			var btn2X : Number = startX + ScreenView.mainButtonWidth + shiftY; 
			btn2.x = btn2X; 
			btn2.y = startY;
			addElement(btn2);
			
			
			btn3 = new Button();
			btn3.label = 'YEAR';
			btn3.setStyle('skinClass', Button1Skin);
			btn3.addEventListener(MouseEvent.CLICK, btn3Clicked);
			btn3.x = btn2X + ScreenView.mainButtonWidth + shiftY;
			btn3.y = startY;
			addElement(btn3);
			
			sortBy = new Image();
			sortBy.source = sortByClass;				
			sortBy.width = 129;
			sortBy.height = 25;
			sortBy.x = 300;
			sortBy.y = 750;
			addElement(sortBy);						
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