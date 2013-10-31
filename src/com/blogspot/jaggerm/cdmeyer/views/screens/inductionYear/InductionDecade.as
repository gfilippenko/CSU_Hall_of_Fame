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
			
			DrawButtons();
		}
		
		protected function DrawButtons():void
		{
			var shiftX : Number = 20;
			var shiftY : Number = 20;
			
			var startX : Number =  (_screenWidth - ((_decades.length * 200) + ((_decades.length - 1) * 20))) / 2;
			var nextX : Number = startX;
			var nextY : Number = 150;
			
			for each(var item : Decade in _decades)
			{
				var btn : Button = new Button();
				btn.id = String(item.id);
				btn.addEventListener(MouseEvent.CLICK, DecadeBtnClicked);
				btn.setStyle('skinClass', CircleButtonSkin);
				btn.width = ScreenView.sportButtonWidth;
				btn.height = ScreenView.sportButtonWidth;
				btn.label = item.id.toString() + "`s";
				btn.x = nextX;
				btn.y = nextY;
				
				nextX = btn.x + btn.width + shiftX;
				if(nextX > (stage.width - btn.width))
				{
					nextX = startX;
					nextY = btn.y + btn.height + shiftY;
				}
				
				addElement(btn);
			}
		}
		
		private function DecadeBtnClicked(e : MouseEvent) : void
		{
			var event : CDMeyerEvent = new CDMeyerEvent(CDMeyerEvent.SHOW_YEARS_OF_DECADE);
			event.decadeID = Number(e.target.id);
			dispatchEvent(event);
		}
	}
}