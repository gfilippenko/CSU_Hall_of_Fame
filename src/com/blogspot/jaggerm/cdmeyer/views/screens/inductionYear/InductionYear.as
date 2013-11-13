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
	import spark.components.Label;
	
	public class InductionYear extends ScreenView
	{
		private var _decade : Decade;
		private var _decadeChanged : Boolean = false;
		private var buttons : Array = [];
		
		[Bindable]
		public function set decade(value : Decade) : void
		{
			if(_decade != value)
			{
				_decade = value;
				_decadeChanged = true;
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
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(_decade != null)
			{
				if(_decadeChanged)			
				{
					DrawButtons();	
					logo.text = 'YEAR: ' + decade.id + "'s";
					_decadeChanged = false;
				}
			}			
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
		}
		
		protected function DrawButtons():void
		{
			for each(var b : Button in buttons)
			{
				removeElement(b);
			}
			buttons.splice(0, buttons.length);
			
			var shiftX : Number = 42;
			var shiftY : Number = 48;
			
			var startX : Number = 349;
			var nextX : Number = startX;
			var nextY : Number = 256;
			var counter : uint = 1;
			for each(var item : uint in _decade.years)
			{
				var btn : Button = new Button();
				btn.id = String(item);
				btn.addEventListener(MouseEvent.CLICK, YearBtnClicked, false, 0, true);
				btn.setStyle('skinClass', CircleButtonSkin);
				btn.width = ScreenView.sportButtonWidth;
				btn.height = ScreenView.sportButtonWidth;
				btn.label = String(item);
				btn.x = nextX;
				btn.y = nextY;
				
				nextX = btn.x + btn.width + shiftX;
				if((counter%5) == 0)
				{
					nextX = startX;
					nextY = btn.y + btn.height + shiftY;
				}
				
				buttons.push(btn);
				addElement(btn);
				counter++;
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