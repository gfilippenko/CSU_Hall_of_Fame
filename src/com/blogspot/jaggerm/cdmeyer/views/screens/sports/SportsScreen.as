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
		
		public function SportsScreen(value:ScreenSettings)
		{
			super(value);
		}
		
		override public function draw() : void
		{
			super.draw();
			
			if(settings.instructions != '')
			{
				DrawInstructions();
			}
			
			backBtn = new Button();
			backBtn.addEventListener(MouseEvent.CLICK, BackClicked);
			backBtn.setStyle('skinClass',BackButtonSkin);
			backBtn.useHandCursor = true;
			addElement(backBtn);	
			
			DrawButtons();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		protected function DrawButtons():void
		{
			var shiftX : Number = 20;
			var shiftY : Number = 20;
			
			var startX : Number = 20;
			var nextX : Number = 20;
			var nextY : Number = 150;
			
			for each(var item : String in _sports)
			{
				var btn : Button = new Button();
				btn.setStyle('skinClass', CircleButtonSkin);
				btn.width = 200;
				btn.height = 200;
				btn.label = item.toUpperCase();
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
		
		private function BackClicked(e : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_MAIN_SCREEN));
		}
	}
}