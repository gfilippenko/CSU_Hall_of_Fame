package com.blogspot.jaggerm.cdmeyer.views.screens.namesScreen
{
	import com.blogspot.jaggerm.cdmeyer.Controller;
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
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
		
		
		public function NamesScreen()
		{
			super();
		}
		
		override public function draw() : void
		{
			super.draw();
			
			backBtn = new Button();
			backBtn.addEventListener(MouseEvent.CLICK, BackClicked);
			backBtn.setStyle('skinClass',BackButtonSkin);
			backBtn.useHandCursor = true;
			addElement(backBtn);
			
			if(settings.instructions != '')
			{
				instructionsText = new Text();
				instructionsText.text = settings.instructions;
				addElement(instructionsText);
			}

			logo = new Image();
			logo.source = logoClass;
			addElement(logo);
			
			listSource = Controller.getInstance().athletes;
			
			pages = Math.ceil(listSource.length / listLimit);
			
			list = new DataGrid();
			
			currentProvider = new ArrayCollection();
			list.dataProvider = currentProvider;
			list.columns = new ArrayList();
			
			var col1 : GridColumn = new GridColumn();
			col1.dataField = 'lastName';
			var col2 : GridColumn = new GridColumn();
			col2.dataField = 'firstName';
			var col3 : GridColumn = new GridColumn();
			col3.dataField = 'sport';
			
			list.columns.addItem(col1);
			list.columns.addItem(col2);
			list.columns.addItem(col3);
			
			addElement(list);
			DrawListPage();
		}
		
		override protected function measure() : void
		{
			super.measure();
			
			backBtn.x = 20;
			backBtn.y = height - backBtn.height - 20; 
			
			instructionsText.x = 20;
			instructionsText.y = 20;
			instructionsText.width = 350;
			instructionsText.height = 160;
			
			logo.x = 50;
			logo.y = instructionsText.y + instructionsText.height + 20;
			
			list.width = 800;
			list.height = 415;
			list.x = instructionsText.x + instructionsText.width + 50;
			list.y = 20;
		}
		
		private function BackClicked(e : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_MAIN_SCREEN));
		}		
	}
}