package com.blogspot.jaggerm.cdmeyer.views
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.screens.NextButtonSkin;
	
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	import flash.text.ReturnKeyLabel;
	import flash.ui.Mouse;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.graphics.BitmapFillMode;
	import mx.states.OverrideBase;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.WindowedApplication;
	import spark.primitives.BitmapImage;
	

	public class ScreenView extends Group
	{
		protected var instructionsText : Text;
		protected var listLimit : uint = 15;
		protected var listSource : Array;
		private var listPages : uint;
		protected var list : DataGrid;
		protected var currentPage : uint = 1;
		[Bindable]
		protected var currentProvider : ArrayCollection;
		
		protected var backBtn : Button;
		protected var nextBtn : Button;
		
		private var backgroundImage : Image;
		private var _settings : ScreenSettings;
		
		
		[Bindable]
		public function set settings(value : ScreenSettings) : void
		{
			_settings = value;
		}
		
		public function get settings() : ScreenSettings
		{
			return _settings;
		}
		
		public function set pages(value : uint) : void
		{
			listPages = value;
			if(listPages > 1)
				DrawNextButton();
		}
		
		public function get pages() : uint
		{
			return listPages;
		}
		
		public function ScreenView()
		{
			percentWidth = 100;
			percentHeight = 100;			
		}
		
		public function draw() : void
		{
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();						
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			DrawBG();
			DrawTopLogo();
			draw();
		}
		
		protected function DrawBG(): void
		{
			backgroundImage = new Image();
			backgroundImage.percentWidth = 100;
			backgroundImage.percentHeight = 100;
			backgroundImage.x = 0;
			backgroundImage.y = 0;		
			backgroundImage.scaleMode = BitmapFillMode.SCALE;
			backgroundImage.source = cdmeyer.APP_PATH + _settings.backgroundImage;
			addElement(backgroundImage);
		}
		
		protected function DrawNextButton() : void
		{
			nextBtn = new Button();
			nextBtn.addEventListener(MouseEvent.CLICK, NextBtnClicked);
			nextBtn.setStyle('skinClass',NextButtonSkin);
			addElement(nextBtn);			
		}
		
		/*
		 * overrided in top screen instance
		 * */
		protected function DrawTopLogo() : void
		{

		}
		
		override protected function measure() : void
		{
			super.measure();
			
			if(nextBtn != null)
			{
				nextBtn.x = width - nextBtn.width - 20;
				nextBtn.y = height - nextBtn.height - 20;
			}
			
			if(list != null)
			{
				list.height = 415;
			}
		}
		
		protected function DrawListPage(page : uint  = 1) : void
		{
			currentProvider.disableAutoUpdate();
			currentProvider.removeAll();
			
			var end : uint = page * listLimit;
			var start : uint = end - listLimit;
			
			if(end > listSource.length)
			{
				end = listSource.length - 1;
				nextBtn.visible = false;
			}
			else
				if(!nextBtn.visible)
					nextBtn.visible = true;
			
			
			
			for(var i:uint=start;i<end;i++)
			{
				Alert.show(listSource[i].firstName);
				currentProvider.addItem(listSource[i]);
			}
			
			currentProvider.enableAutoUpdate();
			currentProvider.refresh();
		}
		
		private function NextBtnClicked(e : MouseEvent) : void
		{
			if(currentPage == listPages)
				return;
			currentPage++;
			DrawListPage(currentPage);
		}
	}
}