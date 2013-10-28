package com.blogspot.jaggerm.cdmeyer.views.screens.namesScreen
{
	import com.blogspot.jaggerm.cdmeyer.Controller;
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.list.AthletesList;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.NextButtonSkin;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.states.OverrideBase;
	
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.Image;
	import spark.components.gridClasses.GridColumn;
	
	public class NamesScreen extends ScreenView
	{
		
		private var logo : Image;
		[Embed(source="../../../../../../../resources/sort_creen_lbl.png")]
		private var logoClass : Class;
		
		
		public function NamesScreen(value : ScreenSettings, _scrWidth : Number, _scrHeight : Number)
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
			

			logo = new Image();
			logo.width = 400;
			logo.height = 400;
			logo.source = logoClass;
			logo.x = 50;
			logo.y = instructionsText.y + ScreenView.backBtnHeight + 20;
			addElement(logo);
			
			listSource = Controller.getInstance().athletes;
			
			list = new AthletesList();
			list.x = _screenWidth - ScreenView.listWidth - 20;
			list.y = _screenHeight - ScreenView.listHeight - 20;			

			currentProvider = new ArrayCollection();
//			list.list.dataProvider = currentProvider;
//			list.columns = new ArrayList();
//			
//			var col1 : GridColumn = new GridColumn();
//			col1.dataField = 'lastName';
//			var col2 : GridColumn = new GridColumn();
//			col2.dataField = 'firstName';
//			var col3 : GridColumn = new GridColumn();
//			col3.dataField = 'sport';
			
//			list.columns.addItem(col1);
//			list.columns.addItem(col2);
//			list.columns.addItem(col3);
			
			addElement(list);
			//pages = Math.ceil(listSource.length / listLimit);
			//DrawListPage();
			DrawList();
		}
		
//		override protected function measure() : void
//		{
//			super.measure();
//			
//			
//			if(logo != null)
//			{
//				logo.x = 50;
//				logo.y = instructionsText.y + instructionsText.height + 20;
//			}
//		}
		
				
	}
}