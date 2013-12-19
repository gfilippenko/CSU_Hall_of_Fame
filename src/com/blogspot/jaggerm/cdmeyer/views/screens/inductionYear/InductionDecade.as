package com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Decade;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.circleButton.CircleButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	
	public class InductionDecade extends ScreenView
	{
		private var _decades : Array;
		
		public function set decades(value : Array) : void
		{
			_decades = value;	
		}
		
		public function InductionDecade(value:ScreenSettings, _scrWidth : Number, _scrHeight : Number)
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
			
			logo = new Label();
			logo.setStyle('fontFamily',"Swis721CnBT");
			logo.setStyle('fontWeight', "bold");
			logo.setStyle('fontSize', 104);
			logo.setStyle('color', 0xffffff);
			logo.x = ScreenView.screenlabelX;
			logo.y = ScreenView.screenlabelY;
			logo.text = 'YEAR';
			addElement(logo);
			
			DrawButtons();
		}
		
		protected function DrawButtons():void
		{
			var shiftX : Number = 42;
			var shiftY : Number = 48;
			
			var startX : Number =  348;
			var nextX : Number = startX;
			var nextY : Number = 294;
			var counter : uint = 1;
			for each(var item : Decade in _decades)
			{
				var btn : Button = new Button();
				btn.id = String(item.id);
				btn.addEventListener(MouseEvent.CLICK, DecadeBtnClicked);
				btn.setStyle('skinClass', CircleButtonSkin);
				btn.width = ScreenView.sportButtonWidth;
				btn.height = ScreenView.sportButtonWidth;
				btn.label = item.id.toString() + "'s";
				if(item.years.length == 0)
					btn.enabled = false;
				btn.x = nextX;
				btn.y = nextY;
				
				nextX = btn.x + btn.width + shiftX;
				if((counter%5) == 0)
				{
					nextX = startX;
					nextY = btn.y + btn.height + shiftY;
				}
				
				addElement(btn);
				counter++;
			}
		}
		
		private function DecadeBtnClicked(e : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));
			
			var event : CDMeyerEvent = new CDMeyerEvent(CDMeyerEvent.SHOW_YEARS_OF_DECADE);
			event.decadeID = Number(e.target.id);
			dispatchEvent(event);
		}
	}
}