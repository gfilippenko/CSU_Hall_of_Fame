package com.blogspot.jaggerm.cdmeyer.views.screens.sports
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.circleButton.CircleButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	
	import spark.components.Button;
	
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
		
		override public function draw() : void
		{
			super.draw();
			
			if(settings.instructions != '')
			{
				DrawInstructions();
			}
			
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
			var shiftX : Number = 20;
			var shiftY : Number = 20;
			
			var startX : Number = 20;
			var nextX : Number = 20;
			var nextY : Number = 150;
			
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
				if(nextX > (stage.width - btn.width))
				{
					nextX = startX;
					nextY = btn.y + btn.height + shiftY;
				}
											
				buttons.push(btn);
			}
			
			for each(var b : Button in buttons)
			{
				addElement(b);
			}
		}
		
		private function SportButtonClicked(event : MouseEvent) : void
		{
			var e : CDMeyerEvent = new CDMeyerEvent(CDMeyerEvent.SHOW_SPORT_SCREEN);
			e.screenLabel = event.target.label;
			dispatchEvent(e);
		}

	}
}