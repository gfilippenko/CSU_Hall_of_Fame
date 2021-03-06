package com.blogspot.jaggerm.cdmeyer.views.screens.sports
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.utils.UString;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.circleButton.CircleButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.utils.StringUtil;
	
	import spark.components.Button;
	import spark.components.Label;
	
	public class SportsScreen extends ScreenView
	{
		private var _sports : Array;
		
		public function set sports(value : Array) : void
		{
			_sports = value;
			invalidateProperties();
		}
		
		public function SportsScreen(value:ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{
			super(value, _scrWidth, _scrHeight);
			showBackBtn = true;
			backBtnEventType = CDMeyerEvent.SHOW_MAIN_SCREEN;			
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		override protected function BGLoaded(e : Event) : void
		{
			//dispatchEvent(new CDMeyerEvent(CDMeyerEvent.BG_LOADED));
			draw1();
		}
		
		public function draw1() : void
		{
			//super.draw();
			
			if(settings.instructions != '')
			{
				DrawInstructions();
			}
			
			logo = new Label();
			logo.setStyle('fontFamily',"Swis721CnBT");
			logo.setStyle('fontWeight', "bold");
			logo.setStyle('fontSize', 104);
			logo.setStyle('color', 0xffffff);
			logo.x = ScreenView.screenlabelX;
			logo.y = ScreenView.screenlabelY;
			logo.text = 'SPORT';
			addElement(logo);
			
			DrawButtons();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		protected function DrawButtons():void
		{
			var buttons : Array = [];
			var startBtnIndex : uint = 0;
			var shiftX : Number = 55;
			var shiftY : Number = 47;
			
			var startX : Number = 583;
			var nextX : Number = startX;
			var nextY : Number = 90;
			var counter : uint = 1;
			for each(var item : String in _sports)
			{
				var btn : Button = new Button();
				btn.setStyle('skinClass', CircleButtonSkin);
				btn.width = ScreenView.sportButtonWidth;
				btn.height = ScreenView.sportButtonWidth;
				btn.label = item.toUpperCase();
				btn.x = nextX;
				btn.y = nextY;
				btn.addEventListener(MouseEvent.CLICK, SportButtonClicked);
				
				nextX = btn.x + btn.width + shiftX;
				if((counter%4) == 0)
				{
					nextX = startX;
					nextY = btn.y + btn.height + shiftY;
				}											
				buttons.push(btn);
				counter++;
			}
			
			for each(var b : Button in buttons)
			{
				addElement(b);
			}
		}
		
		private function SportButtonClicked(event : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));
			
			var e : CDMeyerEvent = new CDMeyerEvent(CDMeyerEvent.SHOW_SPORT_SCREEN);
			e.screenLabel = UString.trim(event.target.label);
			dispatchEvent(e);
		}
		
	}
}