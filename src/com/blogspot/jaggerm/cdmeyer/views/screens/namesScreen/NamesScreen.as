package com.blogspot.jaggerm.cdmeyer.views.screens.namesScreen
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.list.AthletesList;
	import com.blogspot.jaggerm.cdmeyer.views.list.SortBar;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	
	public class NamesScreen extends ScreenView
	{
		
		
		public function NamesScreen(value : ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{
			super(value, _scrWidth, _scrHeight);
			showBackBtn = true;
			backBtnEventType = CDMeyerEvent.SHOW_MAIN_SCREEN;
//			addEventListener(FlexEvent.CREATION_COMPLETE, Added);
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
			logo.text = 'NAME';
			addElement(logo);
			
			sortButtons = new SortBar();
			sortButtons.x = 628;
			sortButtons.y = 920;
			sortButtons.addEventListener(CDMeyerEvent.CLICK_SORT_BUTTON, onClickSortButton);
			addElement(sortButtons);
						
			list = new AthletesList();			
			list.x = 631;
			list.y = 80;		
			list.list.dataProvider = new ArrayCollection();
			sortButtons.addSortListeners(list);
			var columnIndexes:Vector.<int> = Vector.<int>([ 0 ]);
			
			// set 2nd argument to true to show sorting triangle
			list.list.sortByColumns(columnIndexes, true);	
			addElement(list);
			DrawList();
		}
		
		private function Added(e : Event) : void
		{
			if(list != null)
				DrawList();
		}
		
		override protected function BackClicked(e : MouseEvent) : void
		{
			DrawList();
			super.BackClicked(e);
		}

		
	}
}