package com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Decade;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.circleButton.CircleButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.messaging.ConsumerMessageDispatcher;
	
	import spark.components.Button;
	
	public class InductionYear extends ScreenView
	{
		private var _decade : Decade;
		
		[Bindable]
		public function set decade(value : Decade) : void
		{
			if(_decade != value)
			{
				_decade = value;
				invalidateProperties();
			}
		}
		
		public function get decade() : Decade
		{
			return _decade;
		}
		
		public function InductionYear(value:ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{		
			super(value, _scrWidth, _scrHeight);
			showBackBtn = true;
			backBtnEventType = CDMeyerEvent.SHOW_YEARS_SCREEN;
			showHomeBtn = true;
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
			
			var startX : Number =  (_screenWidth - ((_decade.years.length * 200) + ((_decade.years.length - 1) * 20))) / 2;
			var nextX : Number = startX;
			var nextY : Number = 150;
			
			for each(var item : uint in _decade.years)
			{
				var btn : Button = new Button();
				btn.id = String(item);
				btn.addEventListener(MouseEvent.CLICK, YearBtnClicked);
				btn.setStyle('skinClass', CircleButtonSkin);
				btn.width = ScreenView.sportButtonWidth;
				btn.height = ScreenView.sportButtonWidth;
				btn.label = String(item);
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
		
		private function YearBtnClicked(e : MouseEvent) : void
		{
			var event : CDMeyerEvent = new CDMeyerEvent(CDMeyerEvent.SHOW_SPORT_YEAR);
			event.year = Number(e.target.id);
			dispatchEvent(event);
		}
	}
}