package com.blogspot.jaggerm.cdmeyer.views
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.list.AthletesList;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.HomeButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.NextButtonSkin;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
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
	import spark.components.Label;
	import spark.components.WindowedApplication;
	import spark.primitives.BitmapImage;
	

	public class ScreenView extends Group
	{
		protected var backgroundPhoto : Image;
		
		public static const mainButtonWidth : Number = 428;
		public static const mainButtonHeight : Number = 428;
		public static const backBtnHeight : Number = 241;
		public static const listWidth : Number = 1322;
		public static const listHeight : Number = 900;//600;//900; 
		public static const sportButtonWidth : Number = 265;
		
		public static const instructionsWidth : Number = 430;
		public static const instructionsHeight : Number = 580;
		
		public static const instructionsX : Number = 111;
		public static const instructionsY : Number = 177;
				
		public var showHomeBtn : Boolean = false;
		public var showBackBtn : Boolean = false;
		public var backBtnEventType : String;
		
		public var _screenWidth : Number;
		public var _screenHeight : Number;
		
		protected var instructionsText : Text;
		protected var listLimit : uint = 15;
		protected var listSource : Array;
		private var listPages : uint;
		protected var list : AthletesList;
		protected var currentPage : uint = 1;
		[Bindable]
		protected var currentProvider : ArrayCollection;
		
		protected var backBtn : Button;
		protected var nextBtn : Button;
		protected var homeBtn : Button; 
		
		protected var backgroundImage : Image;
		private var _settings : ScreenSettings;
		
		protected var logo : Label;
		public static const screenlabelX : Number = 111;
		public static const screenlabelY : Number = 30;
		
		
//		private var _athlete : Athlete;
//		protected var _athleteChanged : Boolean = false;
//		protected var backgroundPhoto : Image;
//		
//		public function get athletePath() : String
//		{
//			return cdmeyer.APP_PATH + 'info/' + _athlete.lastName + '_' 
//				+ _athlete.firstName  + '/';
//		}
//		
//		
//		public function set athlete(value : Athlete) : void
//		{
//			if(_athlete != value)
//			{
//				_athleteChanged = true;
//				_athlete = value;
//				invalidateProperties();
//			}			
//		}
//		
//		public function get athlete() : Athlete
//		{
//			return _athlete;
//		}
		
		
		public function get settings() : ScreenSettings
		{
			return _settings;
		}
		
		public function set pages(value : uint) : void
		{
			listPages = value;
		}
		
		public function get pages() : uint
		{
			return listPages;
		}
		
		public function ScreenView(value : ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{
			_settings = value;
			
			_screenWidth = _scrWidth;
			_screenHeight = _scrHeight;
			
			measuredWidth = _scrWidth;
			measuredHeight = _scrHeight;
			width = _scrWidth;
			height = _scrHeight;
		}
		
		public function draw() : void
		{
			if(showBackBtn)
			{
				backBtn = new Button();
				backBtn.addEventListener(MouseEvent.CLICK, BackClicked);
				backBtn.setStyle('skinClass',BackButtonSkin);
				backBtn.useHandCursor = true;
				backBtn.x = 83;
				backBtn.y = _screenHeight - ScreenView.backBtnHeight - 75;
				addElement(backBtn);
			}
			
			if(showHomeBtn)
			{
				homeBtn = new Button();
				homeBtn.addEventListener(MouseEvent.CLICK, HomeClicked);
				homeBtn.setStyle('skinClass',HomeButtonSkin);
				homeBtn.useHandCursor = true;
				homeBtn.x = 144 + 120;
				homeBtn.y = _screenHeight - ScreenView.backBtnHeight - 75;
				addElement(homeBtn);
			}
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
			backgroundImage.percentWidth = measuredWidth;
			backgroundImage.percentHeight = measuredHeight;
			backgroundImage.x = 0;
			backgroundImage.y = 0;		
			backgroundImage.scaleMode = BitmapFillMode.SCALE;
			backgroundImage.source = cdmeyer.APP_PATH + _settings.botBackgroundImage;
			addElement(backgroundImage);
		}
		
		
//		protected function DrawBGPhoto(): void
//		{
//			if(backgroundPhoto == null)
//			{
//				backgroundPhoto = new Image();
//				backgroundPhoto.addEventListener(Event.COMPLETE, BackgroundLoaded);
//				backgroundPhoto.x = 0;
//				backgroundPhoto.y = 0;		
////				backgroundPhoto.scaleMde = BitmapFillMode.CLIP;
//				backgroundPhoto.source = athletePath + athlete.backGroundImage;
//				
//				
//				//				var mask : Image = new Image();
//				//				mask.width = 1920;
//				//				mask.height = 1080;
//				//				mask.alpha = 0.5;
//				////				backgroundImage.source = cdmeyer.APP_PATH + '';
//				//				addElement(mask);
//			}
//			else 
//			{
////				removeElement(backgroundImage);
//				backgroundPhoto.source = athletePath + athlete.backGroundImage;
//			}
//		}	
//		
//		protected function BackgroundLoaded(event : Event) : void
//		{
//			backgroundPhoto.width = 100;//backgroundPhoto.bitmapData.width;
//			backgroundPhoto.height = 100;//backgroundPhoto.bitmapData.height;
////			backgroundPhoto.x = (_screenWidth - backgroundPhoto.bitmapData.width) / 2;
////			backgroundPhoto.y = 0;
//			addElement(backgroundPhoto);
//		}
		
		protected function DrawList() : void
		{
			list.list.dataProvider = new ArrayCollection(listSource);
		}
		
		/*
		* drows limited number of items
		*/
		protected function DrawListPage(page : uint  = 1) : void
		{
			currentProvider.disableAutoUpdate();
			currentProvider.removeAll();
			
			var end : uint = page * listLimit;
			var start : uint = end - listLimit;
			
			if(end > listSource.length)
			{
				end = listSource.length - 1;
				if(nextBtn != null)
					nextBtn.visible = false;
			}
			else
				if(nextBtn == null)
				{
					DrawNextButton();
				}
			
				if(!nextBtn.visible)
					nextBtn.visible = true;
			
			for(var i:uint=start;i<end;i++)
			{				
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
		
		protected function DrawInstructions() : void
		{
			instructionsText = new Text();
			instructionsText.text = settings.instructions;
			instructionsText.setStyle('fontFamily',"Swis721CnBTnonCFF");
			instructionsText.setStyle('fontSize', 36);
			instructionsText.setStyle('color', 0xffffff);
			instructionsText.x = ScreenView.instructionsX;
			instructionsText.y = ScreenView.instructionsY;
			instructionsText.width = ScreenView.instructionsWidth;
			instructionsText.height = ScreenView.instructionsHeight;
			addElement(instructionsText);
		}
		
		
		/*
		* overrided in top screen instance
		* */
		protected function DrawTopLogo() : void
		{
			
		}
		
		protected function DrawNextButton() : void
		{
			nextBtn = new Button();			
			nextBtn.addEventListener(MouseEvent.CLICK, NextBtnClicked);
			nextBtn.setStyle('skinClass',NextButtonSkin);
			addElement(nextBtn);			
			if(nextBtn != null)
			{
				nextBtn.x = width - nextBtn.width - 20;
				nextBtn.y = height - nextBtn.height - 20;
			}
		}
		
		protected function BackClicked(e : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(backBtnEventType));
		}
		
		private function HomeClicked(event : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_MAIN_SCREEN));
		}
	}
}