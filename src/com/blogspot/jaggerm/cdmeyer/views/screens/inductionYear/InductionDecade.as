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
		
		public function InductionDecade(value:ScreenSettings)
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
		
		protected function DrawButtons():void
		{
			var shiftX : Number = 20;
			var shiftY : Number = 20;
			
			var startX : Number =  (1366 - ((_decades.length * 200) + ((_decades.length - 1) * 20))) / 2;
			var nextX : Number = startX;
			var nextY : Number = 150;
			
			for each(var item : Decade in _decades)
			{
				var btn : Button = new Button();
				btn.setStyle('skinClass', CircleButtonSkin);
				btn.width = 200;
				btn.height = 200;
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
		
		private function BackClicked(e : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_MAIN_SCREEN));
		}
	}
}