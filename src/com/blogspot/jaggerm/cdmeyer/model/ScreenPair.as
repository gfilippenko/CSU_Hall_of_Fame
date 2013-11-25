package com.blogspot.jaggerm.cdmeyer.model
{
	import com.blogspot.jaggerm.cdmeyer.Controller;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	
	import mx.events.FlexEvent;
	
	public class ScreenPair
	{
		private var controller : Controller;
		public var topScr  : ScreenView;
		public var botScr : ScreenView;
		public var uid : String;
		
		public function ScreenPair(ctr : Controller, id : String = null, top : ScreenView = null, bot : ScreenView = null)
		{
			controller = ctr;	
			if(id != null)
				this.uid = id;
			if(top != null)
				topScr = top;
			if(bot != null)
			{
				botScr = bot;
				botScr.addEventListener(FlexEvent.INITIALIZE, BootmScreenCreationComplete); 
			}
		}
		
		private function BootmScreenCreationComplete(e : FlexEvent) : void
		{
			controller.AddPair(this.uid, this.topScr, this.botScr);
		}
	}
}