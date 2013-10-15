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
	

	
	public class MainScreen extends ScreenView
	{
		public function MainScreen()
		{
			super();
//			addEventListener(Event.ADDED_TO_STAGE, draw1);
		}
		
		override public function draw() : void
		{
			super.draw();
			
			var btn1 : Button = new Button();
//			btn1.width = 100;
//			btn1.height = 100;
			btn1.label = 'press';
			btn1.setStyle('skinClass', Button1Skin);
			btn1.y = halfHeight + ((halfHeight - btn1.height)/2);
			btn1.addEventListener(MouseEvent.CLICK, btn1Clicked);
			addElement(btn1);
			
//			var btn2 : ImageButton = new ImageButton();
//			btn2.width = 100;
//			btn2.height = 100;
//			btn2.label = 'press';
//			btn2.source = 'main_scr_button1_up.png';
//			btn2.cornerRadius = 10;
//			addElement(btn2);
		}
		
		private function btn1Clicked(event : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_NAMES_SCREEN));
		}
	}
}