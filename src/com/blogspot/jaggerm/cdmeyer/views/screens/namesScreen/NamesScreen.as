package com.blogspot.jaggerm.cdmeyer.views.screens.namesScreen
{
	import com.blogspot.jaggerm.cdmeyer.Controller;
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.list.AthletesList;
	import com.blogspot.jaggerm.cdmeyer.views.list.SortBar;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.NextButtonSkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.states.OverrideBase;
	
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.gridClasses.GridColumn;
	
	public class NamesScreen extends ScreenView
	{
		
		
		public function NamesScreen(value : ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{
			super(value, _scrWidth, _scrHeight);
			showBackBtn = true;
			backBtnEventType = CDMeyerEvent.SHOW_MAIN_SCREEN;
			addEventListener(Event.ADDED_TO_STAGE, Added);
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
			
			listSource = Controller.getInstance().athletes;
			
			list = new AthletesList();			
			list.x = 631;
			list.y = 4;			
			//currentProvider = new ArrayCollection();
			addElement(list);
			DrawList();
			
			sortButtons = new SortBar();
			sortButtons.x = 634;
			sortButtons.y = 846;
			sortButtons.addSortListeners(list);
			addElement(sortButtons);
			
			
		}
		
		private function Added(e : Event) : void
		{
			if(list != null)
				DrawList();
		}
		
	}
}