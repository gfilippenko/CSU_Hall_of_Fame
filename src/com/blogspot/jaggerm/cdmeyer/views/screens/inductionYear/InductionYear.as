package com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	
	import spark.components.Button;
	
	public class InductionYear extends ScreenView
	{
		public function InductionYear(value:ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{
			super(value, _scrWidth, _scrHeight);
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
		}
		
		private function BackClicked(e : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_MAIN_SCREEN));
		}
	}
}